--!strict

-- Modules
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")

-- Types
return {
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	FontData = Types.FontData.new(Font.fromEnum(Enum.Font.BuilderSans), 14, 1, nil),
	Scale = 1,
	IsAnimated = true,
	SurfaceColor3 = Color3.new(1, 1, 1),
	OnSurfaceColor3 = Color3.new(0, 0, 0),
	SelectionSurfaceColor3 = Color3.new(0, 1, 1),
	SelectionOnSurfaceColor3 = Color3.new(0, 0, 0),
	DropShadowColor3 = Color3.new(0, 0, 0),
	DisabledSurfaceColor3 = Color3.new(0.7, 0.7, 0.7),
	DisabledOnSurfaceColor3 = Color3.new(0.2, 0.2, 0.2),
	DropShadowTransparency = 0.1,
	SoundVolume = 1,
}
