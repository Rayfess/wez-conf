local wezterm = require('wezterm')
local custom = require('colors.custom')

---@alias Theme.Mode 'system' | 'custom'

-- Theme mode:
--   'system' — follow the OS appearance (Dark/Light) and switch live when it changes
--   'custom' — always use the `colors.custom.lua` palette, ignoring the OS appearance
---@type Theme.Mode
local mode = 'system'

-- Built-in scheme used when the OS is in Dark mode:
local scheme_dark = 'Midnight In Mojave'
-- Built-in scheme used when the OS is in Light mode:
local scheme_light = 'Modus-Operandi'

-- Alternatives — swap by commenting/uncommenting:
-- local scheme_dark = 'Modus-Vivendi'
-- local scheme_light = 'Midnight In Mojave'

---Resolve the active color scheme
---ref: https://wezterm.org/config/lua/wezterm.gui/get_appearance.html
---@return string
local function resolve_scheme()
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

return {
   color_scheme = resolve_scheme(),
   -- Custom scheme names defined here take precedence over built-in schemes
   -- ref: https://wezterm.org/config/appearance.html#defining-a-color-scheme-in-your-weztermlua
   color_schemes = { Custom = custom },
}
