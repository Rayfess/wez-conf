---Per-scheme styling profiles for the custom components.
---
---Each profile styles the components that do not read their colors from the
---active `color_scheme` itself: the tab pills, the status bars, the new-tab
---button labels, the command palette, the window titlebar and the backdrop
---solid layer.
---
---INFO:
---  When `colors/theme.lua`'s `scheme_dark` / `scheme_light` are changed, add
---  or update the matching profiles here. Schemes without a profile fall
---  back to `Custom`.

---@alias Profile.Colors {bg?: string, fg?: string}

---@class Theme.Profile
---@field tab table<string, Profile.Colors> keys consumed by `events/tab-title.lua`
---@field left_status { default: Profile.Colors, scircle: Profile.Colors }
---@field right_status { date: Profile.Colors, battery: Profile.Colors, separator: Profile.Colors }
---@field new_tab { label_text: Profile.Colors, icon_default: Profile.Colors, icon_wsl: Profile.Colors, icon_ssh: Profile.Colors, icon_unix: Profile.Colors }
---@field command_palette { fg: string, bg: string }
---@field window_frame { active_titlebar_bg: string }
---@field scheme_overrides? { bright_black?: string } optional ANSI overrides applied onto the registered scheme

-- stylua: ignore
---@type table<string, Theme.Profile>
local profiles = {
   Custom = {
      tab = {
         text_default          = { bg = '#45475A', fg = '#1C1B19' },
         text_hover            = { bg = '#7188b0', fg = '#1C1B19' },
         text_active           = { bg = '#89b4fa', fg = '#11111B' },

         unseen_output_default = { bg = '#45475A', fg = '#FFA066' },
         unseen_output_hover   = { bg = '#7188b0', fg = '#FFA066' },
         unseen_output_active  = { bg = '#89b4fa', fg = '#FFA066' },

         scircle_default       = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#45475A' },
         scircle_hover         = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#7188b0' },
         scircle_active        = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#89b4fa' },

         progress_percentage_default    = { bg = '#45475A', fg = '#9df296' },
         progress_percentage_hover      = { bg = '#7188b0', fg = '#9df296' },
         progress_percentage_active     = { bg = '#89b4fa', fg = '#9df296' },

         progress_error_default         = { bg = '#45475A', fg = '#fa3970' },
         progress_error_hover           = { bg = '#7188b0', fg = '#fa3970' },
         progress_error_active          = { bg = '#89b4fa', fg = '#fa3970' },

         progress_indeterminate_default = { bg = '#45475A', fg = '#f5e0dc' },
         progress_indeterminate_hover   = { bg = '#7188b0', fg = '#f5e0dc' },
         progress_indeterminate_active  = { bg = '#89b4fa', fg = '#f5e0dc' },
      },
      left_status = {
         default = { bg = '#fab387', fg = '#1c1b19' },
         scircle = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#fab387' },
      },
      right_status = {
         date      = { fg = '#fab387', bg = 'rgba(0, 0, 0, 0.4)' },
         battery   = { fg = '#f9e2af', bg = 'rgba(0, 0, 0, 0.4)' },
         separator = { fg = '#74c7ec', bg = 'rgba(0, 0, 0, 0.4)' },
      },
      new_tab = {
         label_text   = { fg = '#CDD6F4' },
         icon_default = { fg = '#89B4FA' },
         icon_wsl     = { fg = '#FAB387' },
         icon_ssh     = { fg = '#F38BA8' },
         icon_unix    = { fg = '#CBA6F7' },
      },
      command_palette = { fg = '#b4befe', bg = '#11111b' },
      window_frame    = { active_titlebar_bg = '#090909' },
      scheme_overrides = { bright_black = '#9399b2' },
      tab_bar         = {
         background   = 'rgba(0, 0, 0, 0.4)',
         new_tab      = { bg_color = '#1f1f28', fg_color = '#cdd6f4' },
         new_tab_hover = { bg_color = '#181825', fg_color = '#cdd6f4', italic = true },
      },
   },

   ['midnight-in-mojave'] = {
      tab = {
         text_default          = { bg = '#3a3a3c', fg = '#ffffff' },
         text_hover            = { bg = '#515151', fg = '#ffffff' },
         text_active           = { bg = '#0a84ff', fg = '#ffffff' },

         unseen_output_default = { bg = '#3a3a3c', fg = '#ff9f0a' },
         unseen_output_hover   = { bg = '#515151', fg = '#ff9f0a' },
         unseen_output_active  = { bg = '#0a84ff', fg = '#ff9f0a' },

         scircle_default       = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#3a3a3c' },
         scircle_hover         = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#515151' },
         scircle_active        = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#0a84ff' },

         progress_percentage_default    = { bg = '#3a3a3c', fg = '#32d74b' },
         progress_percentage_hover      = { bg = '#515151', fg = '#32d74b' },
         progress_percentage_active     = { bg = '#0a84ff', fg = '#32d74b' },

         progress_error_default         = { bg = '#3a3a3c', fg = '#ff453a' },
         progress_error_hover           = { bg = '#515151', fg = '#ff453a' },
         progress_error_active          = { bg = '#0a84ff', fg = '#ff453a' },

         progress_indeterminate_default = { bg = '#3a3a3c', fg = '#5ac8fa' },
         progress_indeterminate_hover   = { bg = '#515151', fg = '#5ac8fa' },
         progress_indeterminate_active  = { bg = '#0a84ff', fg = '#5ac8fa' },
      },
      left_status = {
         default = { bg = '#0a84ff', fg = '#ffffff' },
         scircle = { bg = 'rgba(0, 0, 0, 0.4)', fg = '#0a84ff' },
      },
      right_status = {
         date      = { fg = '#ff9f0a', bg = 'rgba(0, 0, 0, 0.4)' },
         battery   = { fg = '#ffd60a', bg = 'rgba(0, 0, 0, 0.4)' },
         separator = { fg = '#5ac8fa', bg = 'rgba(0, 0, 0, 0.4)' },
      },
      new_tab = {
         label_text   = { fg = '#ffffff' },
         icon_default = { fg = '#0a84ff' },
         icon_wsl     = { fg = '#ffd60a' },
         icon_ssh     = { fg = '#ff453a' },
         icon_unix    = { fg = '#bf5af2' },
      },
      command_palette = { fg = '#ffffff', bg = '#2c2c2e' },
      window_frame    = { active_titlebar_bg = '#1e1e1e' },
      scheme_overrides = { bright_black = '#98989d' },
      tab_bar         = {
         background   = 'rgba(0, 0, 0, 0.4)',
         new_tab      = { bg_color = '#3a3a3c', fg_color = '#ffffff' },
         new_tab_hover = { bg_color = '#515151', fg_color = '#ffffff', italic = true },
      },
   },

   ['modus-operandi'] = {
      tab = {
         text_default          = { bg = '#a6a6a6', fg = '#000000' },
         text_hover            = { bg = '#6e6e6e', fg = '#ffffff' },
         text_active           = { bg = '#0031a9', fg = '#ffffff' },

         unseen_output_default = { bg = '#a6a6a6', fg = '#a60000' },
         unseen_output_hover   = { bg = '#6e6e6e', fg = '#a60000' },
         unseen_output_active  = { bg = '#0031a9', fg = '#ffffff' },

         scircle_default       = { bg = 'rgba(0, 0, 0, 0.1)', fg = '#a6a6a6' },
         scircle_hover         = { bg = 'rgba(0, 0, 0, 0.1)', fg = '#6e6e6e' },
         scircle_active        = { bg = 'rgba(0, 0, 0, 0.1)', fg = '#0031a9' },

         progress_percentage_default    = { bg = '#a6a6a6', fg = '#006800' },
         progress_percentage_hover      = { bg = '#6e6e6e', fg = '#006800' },
         progress_percentage_active     = { bg = '#0031a9', fg = '#ffffff' },

         progress_error_default         = { bg = '#a6a6a6', fg = '#a60000' },
         progress_error_hover           = { bg = '#6e6e6e', fg = '#a60000' },
         progress_error_active          = { bg = '#0031a9', fg = '#ffffff' },

         progress_indeterminate_default = { bg = '#a6a6a6', fg = '#005e8b' },
         progress_indeterminate_hover   = { bg = '#6e6e6e', fg = '#005e8b' },
         progress_indeterminate_active  = { bg = '#0031a9', fg = '#ffffff' },
      },
      left_status = {
         default = { bg = '#0031a9', fg = '#ffffff' },
         scircle = { bg = 'rgba(0, 0, 0, 0.1)', fg = '#0031a9' },
      },
      right_status = {
         date      = { fg = '#6f5500', bg = 'rgba(0, 0, 0, 0.06)' },
         battery   = { fg = '#006800', bg = 'rgba(0, 0, 0, 0.06)' },
         separator = { fg = '#005e8b', bg = 'rgba(0, 0, 0, 0.06)' },
      },
      new_tab = {
         label_text   = { fg = '#000000' },
         icon_default = { fg = '#0031a9' },
         icon_wsl     = { fg = '#884900' },
         icon_ssh     = { fg = '#a60000' },
         icon_unix    = { fg = '#721045' },
      },
      command_palette = { fg = '#000000', bg = '#f2f2f2' },
      window_frame    = { active_titlebar_bg = '#ffffff' },
      scheme_overrides = nil,
      tab_bar         = {
         background   = 'rgba(255, 255, 255, 0.6)',
         new_tab      = { bg_color = '#a6a6a6', fg_color = '#000000' },
         new_tab_hover = { bg_color = '#6e6e6e', fg_color = '#ffffff', italic = true },
      },
   },
}

local REQUIRED_SECTIONS = {
   tab            = {
      'text_default', 'text_hover', 'text_active',
      'unseen_output_default', 'unseen_output_hover', 'unseen_output_active',
      'scircle_default', 'scircle_hover', 'scircle_active',
      'progress_percentage_default', 'progress_percentage_hover', 'progress_percentage_active',
      'progress_error_default', 'progress_error_hover', 'progress_error_active',
      'progress_indeterminate_default', 'progress_indeterminate_hover', 'progress_indeterminate_active',
   },
   left_status    = { 'default', 'scircle' },
   right_status   = { 'date', 'battery', 'separator' },
   new_tab        = { 'label_text', 'icon_default', 'icon_wsl', 'icon_ssh', 'icon_unix' },
   command_palette = { 'fg', 'bg' },
   window_frame   = { 'active_titlebar_bg' },
   tab_bar        = { 'background', 'new_tab', 'new_tab_hover' },
}

for profile_name, profile in pairs(profiles) do
   for section, keys in pairs(REQUIRED_SECTIONS) do
      assert(profile[section], 'Profile "' .. profile_name .. '" is missing section "' .. section .. '"')

      for _, key in ipairs(keys) do
         assert(
            profile[section][key],
            'Profile "' .. profile_name .. '" is missing "' .. section .. '.' .. key .. '"'
         )
      end
   end
end

---Get the styling profile for a scheme, falls back to `Custom` when missing
---@param scheme string|nil active color scheme name
---@return Theme.Profile
function profiles.get_profile(scheme)
   return profiles[scheme] or profiles.Custom
end

return profiles
