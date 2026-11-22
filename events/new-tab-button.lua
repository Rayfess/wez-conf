local wezterm = require('wezterm')
local launch_menu = require('config.launch').launch_menu
local domains = require('config.domains')
local Cells = require('utils.cells')
local profiles = require('colors.profiles')

local nf = wezterm.nerdfonts
local act = wezterm.action
local attr = Cells.attr

local M = {}

local cells = Cells:new()
   :add_segment('icon_default', ' ' .. nf.oct_terminal .. ' ')
   :add_segment('icon_wsl', ' ' .. nf.cod_terminal_linux .. ' ')
   :add_segment('icon_ssh', ' ' .. nf.md_ssh .. ' ')
   :add_segment('icon_unix', ' ' .. nf.dev_gnu .. ' ')
   :add_segment('label_text', '', nil, attr(attr.intensity('Bold')))

---@param colors Theme.Profile.new_tab
local function build_choices(colors)
   cells
      :update_segment_colors('icon_default', colors.icon_default)
      :update_segment_colors('icon_wsl', colors.icon_wsl)
      :update_segment_colors('icon_ssh', colors.icon_ssh)
      :update_segment_colors('icon_unix', colors.icon_unix)
      :update_segment_colors('label_text', colors.label_text)

   local choices = {}
   local choices_data = {}
   local idx = 1

   -- Add launch menu items (DefaultDomain)
   for _, v in ipairs(launch_menu) do
      cells:update_segment_text('label_text', v.label)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_default', 'label_text' })),
      })
      table.insert(choices_data, {
         args = v.args,
         domain = 'DefaultDomain',
      })
      idx = idx + 1
   end

   -- Add WSL domains
   for _, v in ipairs(domains.wsl_domains) do
      cells:update_segment_text('label_text', v.name)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_wsl', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- Add SSH domains
   for _, v in ipairs(domains.ssh_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_ssh', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- Add Unix domains
   for _, v in ipairs(domains.unix_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_unix', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   return choices, choices_data
end

M.setup = function()
   wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
      if default_action and button == 'Left' then
         window:perform_action(default_action, pane)
      end

      if button == 'Right' then
         local profile = profiles.get_profile(window:effective_config().color_scheme)
         local choices, choices_data = build_choices(profile.new_tab)

         window:perform_action(
            act.InputSelector({
               title = 'InputSelector: Launch Menu',
               choices = choices,
               fuzzy = true,
               fuzzy_description = nf.md_rocket .. ' Select a launch item: ',
               action = wezterm.action_callback(function(_window, _pane, id, label)
                  if not id and not label then
                     return
                  end
                  window:perform_action(act.SpawnCommandInNewTab(choices_data[tonumber(id)]), pane)
               end),
            }),
            pane
         )
      end

      return false
   end)
end

return M
