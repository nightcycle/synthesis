--!strict
-- Services
-- Packages
-- Modules
local Enums = require("@proj/Enums")

-- Types
return {
	Value = false,
	OnChange = function(isSelected: boolean) end,
	IsEnabled = true,
	IsAnimated = true,
	OutlineColor3 = Color3.new(),
	FillColor3 = Color3.new(),
	IconColor3 = Color3.new(),
	DisabledColor3 = Color3.new(),
	OnDisabledColor3 = Color3.new(),
	SoundVolume = 0.5,
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	Scale = 1,
}
