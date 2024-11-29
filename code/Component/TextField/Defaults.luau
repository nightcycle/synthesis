--!strict

-- Modules
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")

-- Types
return {
	IsEnabled = true,
	IsError = false,
	IsFilled = true,
	IsMultiLine = false,
	IsClearButtonEnabled = true,
	Label = "Label",
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderHightlightColor3 = Color3.new(1, 1, 1),
	ErrorColor3 = Color3.new(1, 1, 0),
	BorderColor3 = Color3.new(),
	TextColor3 = Color3.new(),
	LabelColor3 = Color3.new(),
	SupportingTextColor3 = Color3.new(),
	Elevation = 0,
	SoundVolume = 0.5,
	SchemeType = Enums.SchemeType.Light,
	BodyFontData = Types.FontData.new(Font.fromEnum(Enum.Font.BuilderSans), 14, 1, nil),
	SupportFontData = Types.FontData.new(
		Font.fromEnum(Enum.Font.BuilderSans),
		10,
		1,
		nil
	),
	ClearTextOnFocus = true,
	Scale = 1,
}
