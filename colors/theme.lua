local wezterm = require('wezterm')
local custom = require('colors.custom')

---@alias Theme.Mode 'system' | 'custom'

-- Theme mode:
--   'system' — follow the OS appearance (Dark/Light) and switch live when it changes
--   'custom' — always use the `colors.custom.lua` palette, ignoring the OS appearance
---@type Theme.Mode
local mode = 'system'

-- Themes listed in the runtime picker (<SUPER>+g).
-- A name must either be `Custom` or a built-in WezTerm color scheme.
---@type string[]
local themes = {
   'Custom',
   'Midnight In Mojave',
   'Modus-Operandi',
}

-- Built-in scheme used when the OS is in Dark mode:
local scheme_dark = 'Midnight In Mojave'
-- Built-in scheme used when the OS is in Light mode:
local scheme_light = 'Modus-Operandi'

-- Alternatives — swap by commenting/uncommenting:
-- local scheme_dark = 'Modus-Vivendi'
-- local scheme_light = 'Midnight In Mojave'

-- Persisted theme choice. Takes precedence over `mode` until it is cleared by
-- picking `Follow System` in the runtime picker.
local STATE_FILE = wezterm.config_dir .. '/.theme-state'

---Read the persisted theme choice
---@return string|nil
local function load_state()
   local file = io.open(STATE_FILE, 'r')
   if not file then
      return nil
   end

   local scheme = file:read('*l')
   file:close()

   if not scheme or scheme == '' then
      return nil
   end
   return scheme
end

---Persist the theme choice, `nil` clears it
---@param scheme string|nil
local function save_state(scheme)
   local file = io.open(STATE_FILE, 'w')
   if not file then
      wezterm.log_error('Theme: unable to write state file: ' .. STATE_FILE)
      return
   end

   file:write(scheme or '')
   file:close()
end

---Check if a scheme name is `Custom` or a built-in WezTerm color scheme
---@param scheme string
---@return boolean
local function is_known_scheme(scheme)
   if scheme == 'Custom' then
      return true
   end

   return wezterm.get_builtin_color_schemes()[scheme] ~= nil
end

---@type string|nil currently selected theme, `nil` follows `mode`
local selected = load_state()
if selected and not is_known_scheme(selected) then
   wezterm.log_warn('Theme: unknown persisted scheme "' .. selected .. '", ignoring it')
   selected = nil
end

---Resolve the active color scheme
---ref: https://wezterm.org/config/lua/wezterm.gui/get_appearance.html
---@return string
local function resolve_scheme()
   if selected then
      return selected
   end

   if mode == 'custom' then
      return 'Custom'
   end

   -- `wezterm.gui` is not available to the mux server, so take care to do
   -- something reasonable when this config is evaluated by the mux.
   local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
   if appearance:find('Dark') then
      return scheme_dark
   end
   return scheme_light
end

---Build the theme picker choices, computed when the picker opens
---@param window Window WezTerm `Window` see: https://wezterm.org/config/lua/window/index.html
---@return {id: string, label: string}[]
local function choices(window)
   local active = window:effective_config().color_scheme

   ---@type {id: string, label: string}[]
   local res = {
      { id = '0', label = 'Follow System' .. (selected and '' or '  (active)') },
   }

   for i, scheme in ipairs(themes) do
      local is_active = selected == scheme or (selected == nil and scheme == active)
      table.insert(res, { id = tostring(i), label = scheme .. (is_active and '  (active)' or '') })
   end

   return res
end

---Resolve a picker id into a theme name, `nil` = Follow System
---@param id string
---@return string|nil
local function choice_by_id(id)
   local idx = tonumber(id)
   if not idx or idx == 0 then
      return nil
   end

   return themes[idx]
end

---Apply and persist the chosen theme, `nil` = Follow System
---@param window Window WezTerm `Window` see: https://wezterm.org/config/lua/window/index.html
---@param scheme string|nil
local function set_theme(window, scheme)
   selected = scheme
   save_state(scheme)

   -- keep other overrides (`background` from backdrops, `enable_tab_bar`, ...)
   local overrides = window:get_config_overrides() or {}
   overrides.color_scheme = scheme -- `nil` removes the override, falling back to the config
   window:set_config_overrides(overrides)
end

return {
   color_scheme = resolve_scheme(),
   -- Custom scheme names defined here take precedence over built-in schemes
   -- ref: https://wezterm.org/config/appearance.html#defining-a-color-scheme-in-your-weztermlua
   color_schemes = { Custom = custom },
   choices = choices,
   choice_by_id = choice_by_id,
   set_theme = set_theme,
}
