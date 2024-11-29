--!strict

-- Modules
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")

-- Types
return {
	IsEnabled = true,
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	FillColor3 = Color3.new(1, 1, 1),
	TextColor3 = Color3.new(),
	FillDisabledColor3 = Color3.new(0.5, 0.5, 0.5),
	TextDisabledColor3 = Color3.new(0.5, 0.5, 0.5),
	FontData = Types.FontData.new(Font.fromEnum(Enum.Font.BuilderSans), 14, 1, nil),
	IsAnimated = true,
	Scale = 1,
	SoundVolume = 0.5,
}
