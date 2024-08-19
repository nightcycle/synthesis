--!strict

-- Modules
local Enums = require("@proj/Enums")

-- Types
return {
	IsEnabled = true,
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	FillColor3 = Color3.new(1, 1, 1),
	IconColor3 = Color3.new(),
	FillDisabledColor3 = Color3.new(0.5, 0.5, 0.5),
	IconDisabledColor3 = Color3.new(0.5, 0.5, 0.5),
	IsAnimated = true,
	Scale = 1,
	ClickVolume = 0.5,
}
