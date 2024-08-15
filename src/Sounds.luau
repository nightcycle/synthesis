--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
-- Modules
local Enums = require(_Package:WaitForChild("Enums"))
-- Types
-- Constants
local LIBRARY: { [Enums.SoundType]: string } = table.freeze({
	hero_simple_celebration_02 = "rbxassetid://15530172366",
	navigation_cancel = "rbxassetid://15530082510",
	ui_tap_variant_03 = "rbxassetid://15530107510",
	alert_error_03 = "rbxassetid://15530081806",
	notification_ambient = "rbxassetid://15530133360",
	state_change_confirm_up = "rbxassetid://15530106459",
	ringtone_minimal = "rbxassetid://15530133688",
	hero_decorative_celebration_01 = "rbxassetid://15530172572",
	navigation_transition_right = "rbxassetid://15530082646",
	hero_decorative_celebration_02 = "rbxassetid://15530172198",
	alert_simple = "rbxassetid://15530134380",
	ui_loading = "rbxassetid://15530081925",
	notification_decorative_01 = "rbxassetid://15530134178",
	notification_high_intensity = "rbxassetid://15530133039",
	navigation_backward_selection_minimal = "rbxassetid://15530108245",
	navigation_unavailable_selection = "rbxassetid://15530082211",
	ui_unlock = "rbxassetid://15530107328",
	notification_decorative_02 = "rbxassetid://15530133501",
	navigation_hover_tap = "rbxassetid://15530107661",
	ui_tap_variant_01 = "rbxassetid://15530106592",
	ui_tap_variant_04 = "rbxassetid://15530106152",
	ui_tap_variant_02 = "rbxassetid://15530106800",
	alert_error_02 = "rbxassetid://15530082354",
	alarm_gentle = "rbxassetid://15530134666",
	ui_refresh_feed = "rbxassetid://15530081643",
	hero_simple_celebration_01 = "rbxassetid://15530172024",
	hero_decorative_celebration_03 = "rbxassetid://15530172766",
	hero_simple_celebration_03 = "rbxassetid://15530172475",
	alert_high_intensity = "rbxassetid://15530134780",
	state_change_confirm_down = "rbxassetid://15530107943",
	navigation_transition_left = "rbxassetid://15530082066",
	notification_simple_01 = "rbxassetid://15530133936",
	navigation_forward_selection = "rbxassetid://15530108068",
	navigation_selection_complete_celebration = "rbxassetid://15530107202",
	ui_camera_shutter = "rbxassetid://15530106289",
	navigation_forward_selection_minimal = "rbxassetid://15530107049",
	notification_simple_02 = "rbxassetid://15530133223",
	navigation_backward_selection = "rbxassetid://15530108417",
	ui_lock = "rbxassetid://15530107845",
	alert_error_01 = "rbxassetid://15530082764",
})
-- Variables
-- References
-- Private Functions
-- Class

return {
	play = function(soundType: Enums.SoundType, volume: number?)
		volume = volume or 0.5
		assert(volume)
		local sound = Instance.new("Sound")
		sound.SoundId = LIBRARY[soundType]
		sound.Volume = volume
		SoundService:PlayLocalSound(sound)
		sound:Destroy()
	end,
	Library = LIBRARY,
}
