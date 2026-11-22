local wezterm = require('wezterm')
local Cells = require('utils.cells')
local profiles = require('colors.profiles')

local nf = wezterm.nerdfonts
local attr = Cells.attr

local M = {}

local GLYPH_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[  ]]
local GLYPH_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[  ]]
local GLYPH_KEY_TABLE = nf.md_table_key --[[ 󱏅 ]]
local GLYPH_KEY = nf.md_key --[[ 󰌆 ]]

local cells = Cells:new()

---Apply the active profile colors to the status segments
---@param profile Theme.Profile
local function apply_profile_colors(profile)
   cells
      :update_segment_colors(1, profile.left_status.scircle)
      :update_segment_colors(2, profile.left_status.default)
      :update_segment_colors(3, profile.left_status.default)
      :update_segment_colors(4, profile.left_status.scircle)
end

cells
   :add_segment(1, GLYPH_SEMI_CIRCLE_LEFT, nil, attr(attr.intensity('Bold')))
   :add_segment(2, ' ')
   :add_segment(3, ' ')
   :add_segment(4, GLYPH_SEMI_CIRCLE_RIGHT, nil, attr(attr.intensity('Bold')))

M.setup = function()
   wezterm.on('update-status', function(window, _pane)
      local profile = profiles.get_profile(window:effective_config().color_scheme)
      local name = window:active_key_table()
      local res = {}

      if name then
         cells
            :update_segment_text(2, GLYPH_KEY_TABLE)
            :update_segment_text(3, ' ' .. string.upper(name))
         apply_profile_colors(profile)
         res = cells:render_all()
      elseif window:leader_is_active() then
         cells:update_segment_text(2, GLYPH_KEY):update_segment_text(3, ' ')
         apply_profile_colors(profile)
         res = cells:render_all()
      end
      window:set_left_status(wezterm.format(res))
   end)
end

return M
