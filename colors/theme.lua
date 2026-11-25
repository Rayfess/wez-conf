local wezterm = require('wezterm')
local custom = require('colors.custom')
local profiles = require('colors.profiles')

-- Built-in scheme used when the OS is in Dark mode:
local scheme_dark = 'midnight-in-mojave'
-- Built-in scheme used when the OS is in Light mode:
local scheme_light = 'Modus-Operandi'

-- Alternatives — swap by commenting/uncommenting:
-- local scheme_dark = 'Modus-Vivendi'
-- local scheme_light = 'midnight-in-mojave'

---Theme kinds selectable in the runtime picker:
---  'custom' — always use the `colors.custom.lua` palette
---  'dark'   — always use `scheme_dark`, ignoring the OS appearance
---  'light'  — always use `scheme_light`, ignoring the OS appearance
---An empty/missing persisted state means following the OS appearance.
---@alias Theme.Kind 'custom' | 'dark' | 'light'

local STATE_FILE = wezterm.config_dir .. '/.theme-state'

---@type Theme.Kind[]
local KINDS = { 'custom', 'dark', 'light' }

---Read the persisted theme kind
---@return Theme.Kind|nil
local function load_state()
   local file = io.open(STATE_FILE, 'r')
   if not file then
      return nil
   end

   local kind = file:read('*l')
   file:close()

   if not kind or kind == '' then
      return nil
   end
   return kind
end

---Persist the theme kind, `nil` clears it (back to following the OS)
---@param kind Theme.Kind|nil
local function save_state(kind)
   local file = io.open(STATE_FILE, 'w')
   if not file then
      wezterm.log_error('Theme: unable to write state file: ' .. STATE_FILE)
      return
   end

   file:write(kind or '')
   file:close()
end

---Check if a theme kind is selectable
---@param kind string
---@return boolean
local function is_known_kind(kind)
   return kind == 'custom' or kind == 'dark' or kind == 'light'
end

---@type Theme.Kind|nil currently selected kind, `nil` = follow the OS
local selected = load_state()
if selected and not is_known_kind(selected) then
   wezterm.log_warn('Theme: unknown persisted kind "' .. selected .. '", ignoring it')
   selected = nil
end

---Resolve the active color scheme
---ref: https://wezterm.org/config/lua/wezterm.gui/get_appearance.html
---@return string
local function resolve_scheme()
   if selected == 'custom' then
      return 'Custom'
   elseif selected == 'dark' then
      return scheme_dark
   elseif selected == 'light' then
      return scheme_light
   end

   -- `selected` is `nil` (nothing picked yet) — follow the OS appearance.
   -- `wezterm.gui` is not available to the mux server, so take care to do
   -- something reasonable when this config is evaluated by the mux.
   local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
   if appearance:find('Dark') then
      return scheme_dark
   end
   return scheme_light
end

---Build a copy of a built-in scheme extended with the profile's tab bar
---colors (strip background + the `+` new-tab button). Defining a scheme
---with the same name takes precedence over the built-in one.
---ref: https://wezterm.org/config/appearance.html#defining-a-color-scheme-in-your-weztermlua
---
---INFO:
---  Non-fatal: when the scheme name is missing from the registry, this logs
---  the closest candidates and returns `nil` — the tab bar then falls back
---  to WezTerm's default colors instead of breaking the whole config.
---@type table<string, table> all built-in color schemes, name keyed
local builtin_schemes = wezterm.get_builtin_color_schemes()

---@param scheme_name string
---@param profile Theme.Profile
---@return table|nil
local function themed_scheme(scheme_name, profile)
   local scheme = builtin_schemes[scheme_name]

   if not scheme then
      local candidates = {}
      local keyword = scheme_name:match('[%a]+') or scheme_name
      for key in pairs(builtin_schemes) do
         if key:lower():find(keyword:lower(), 1, true) then
            table.insert(candidates, '"' .. key .. '"')
         end
      end

      wezterm.log_error(
         'Theme: built-in scheme "'
            .. scheme_name
            .. '" not found, its tab bar keeps the default colors. Candidates: '
            .. (next(candidates) and table.concat(candidates, ', ') or 'none')
      )
      return nil
   end

   local themed = {}
   for key, value in pairs(scheme) do
      themed[key] = value
   end

   themed.tab_bar = {
      background = profile.tab_bar.background,
      new_tab = profile.tab_bar.new_tab,
      new_tab_hover = profile.tab_bar.new_tab_hover,
   }
   return themed
end

---Apply the profile's optional ANSI overrides onto the scheme table
---@param scheme table
---@param profile Theme.Profile
local function apply_scheme_overrides(scheme, profile)
   local overrides = profile.scheme_overrides
   if overrides and overrides.bright_black then
      -- brights[1] is "bright black" — the gray most shells use for
      -- parameters/flags; replace it with a copy to keep sources untouched
      local brights = {}
      for i, color in ipairs(scheme.brights or {}) do
         brights[i] = color
      end
      brights[1] = overrides.bright_black
      scheme.brights = brights
   end
end

---Build the `color_schemes` map, skipping schemes missing from the registry
---@return table<string, table>
local function build_color_schemes()
   local schemes = { Custom = custom }
   apply_scheme_overrides(schemes.Custom, profiles.get_profile('Custom'))

   for _, scheme_name in ipairs({ scheme_dark, scheme_light }) do
      local themed = themed_scheme(scheme_name, profiles.get_profile(scheme_name))
      if themed then
         apply_scheme_overrides(themed, profiles.get_profile(scheme_name))
         schemes[scheme_name] = themed
      end
   end

   return schemes
end

local active_scheme = resolve_scheme()

---Build the theme picker choices, computed when the picker opens
---@return {id: string, label: string}[]
local function choices()
   local active_kind = selected

   ---@type {id: string, label: string}[]
   local res = {}

   for _, kind in ipairs(KINDS) do
      local label = kind:sub(1, 1):upper() .. kind:sub(2)
      table.insert(res, { id = kind, label = label .. (kind == active_kind and '  (active)' or '') })
   end

   return res
end

---Apply and persist the chosen theme kind
---@param window Window WezTerm `Window` see: https://wezterm.org/config/lua/window/index.html
---@param kind Theme.Kind
local function set_theme(window, kind)
   if not is_known_kind(kind) then
      return
   end

   selected = kind
   save_state(selected)

   local scheme_name = resolve_scheme()
   local profile = profiles.get_profile(scheme_name)

   -- keep the other overrides and recolor every component in one pass
   local overrides = window:get_config_overrides() or {}
   overrides.color_scheme = scheme_name
   overrides.command_palette_fg_color = profile.command_palette.fg
   overrides.command_palette_bg_color = profile.command_palette.bg
   overrides.window_frame = { active_titlebar_bg = profile.window_frame.active_titlebar_bg }
   window:set_config_overrides(overrides)
end

return {
   color_scheme = active_scheme,
   -- Custom scheme names defined here take precedence over built-in schemes
   -- ref: https://wezterm.org/config/appearance.html#defining-a-color-scheme-in-your-weztermlua
   color_schemes = build_color_schemes(),
   choices = choices,
   set_theme = set_theme,
}
