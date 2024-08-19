--!strict

-- Modules
local Enums = require("@proj/Enums")

-- Types
return {
	Value = false,
	OnChanged = function(newValue: boolean) end,
	IsEnabled = true,
	IsAnimated = true,
	IncludeIconOnSelected = true,
	IncludeIconOnDeselected = true,
	BackgroundColor3 = Color3.new(),
	OnBackgroundColor3 = Color3.new(),
	FillColor3 = Color3.new(),
	ButtonColor3 = Color3.new(),
	OnButtonColor3 = Color3.new(),
	DisabledColor3 = Color3.new(),
	OnDisabledColor3 = Color3.new(),
	Elevation = 0,
	ClickVolume = 0.5,
	SchemeType = Enums.SchemeType.Light,
	Scale = 1,
}
