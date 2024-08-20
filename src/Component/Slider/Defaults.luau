--!strict

-- Modules
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")

-- Types
return {
	SnapCount = nil,
	IsLabelEnabled = true,
	IsEnabled = true,
	IsAnimated = true,
	Elevation = 0,
	Scale = 1,
	SoundVolume = 0.5,
	SchemeType = Enums.SchemeType.Light,
	FillColor3 = Color3.new(),
	ContainerColor3 = Color3.new(),
	OnFillColor3 = Color3.new(1, 1, 1),
	OnContainerColor3 = Color3.new(1, 1, 1),
	DisabledFillColor3 = Color3.new(),
	DisabledContainerColor3 = Color3.new(),
	DisabledOnFillColor3 = Color3.new(1, 1, 1),
	DisabledOnContainerColor3 = Color3.new(1, 1, 1),
	LabelColor3 = Color3.new(),
	OnLabelColor3 = Color3.new(1, 1, 1),
	LabelFontData = Types.FontData.new(Font.fromEnum(Enum.Font.BuilderSans), 14, 1, nil),
}
