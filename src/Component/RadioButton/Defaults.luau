--!strict
-- Services
-- Packages
-- Modules
local Enums = require("@proj/Enums")

-- Types
return {
	Value = false,
	OnChanged = function(isSelected: boolean) end,
	IsEnabled = true,
	IsAnimated = true,
	OutlineColor3 = Color3.new(),
	FillColor3 = Color3.new(),
	IconColor3 = Color3.new(),
	DisabledColor3 = Color3.new(),
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	ClickVolume = 0.5,
	Scale = 1,
}
