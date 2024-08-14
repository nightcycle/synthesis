--!strict
-- Services
-- Packages
local HashUtil = require("@wally/HashUtil")
-- Modules
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")

-- Types
export type FontData = Types.FontData
type TextInstance = TextLabel | TextButton | TextBox
export type Typography = {
	__index: Typography,
	_Fonts: { [Enums.FontType]: FontData },
	getTextSize: (fontSize: number, scale: number) -> number,
	getGuiLineHeight: (lineHeight: number, fontSize: number) -> number,
	apply: (inst: TextInstance, fontData: FontData, scale: number?) -> (),
	Apply: (self: Typography, inst: TextInstance, fontType: Enums.FontType, scale: number?) -> (),
	Get: (self: Typography, fontType: Enums.FontType) -> FontData,
	Hash: (self: Typography) -> string,
	new: (fonts: { [Enums.FontType]: FontData }) -> Typography,
	fromFont: (font: Enum.Font) -> Typography,
}
-- Constants
local WEIGHT = {
	[100] = Enum.FontWeight.Thin,
	[200] = Enum.FontWeight.ExtraLight,
	[300] = Enum.FontWeight.Light,
	[400] = Enum.FontWeight.Regular,
	[500] = Enum.FontWeight.Medium,
	[600] = Enum.FontWeight.SemiBold,
	[700] = Enum.FontWeight.Bold,
	[800] = Enum.FontWeight.ExtraBold,
	[900] = Enum.FontWeight.Heavy,
}
-- Variables
local FontCache: { [Enum.Font]: Typography } = {}

-- References
-- Private Functions
local function newFontFamily(font: Enum.Font, weight: Enum.FontWeight, style: Enum.FontStyle): Font
	local fontFamily = Font.fromEnum(font)
	fontFamily.Weight = weight
	fontFamily.Style = style
	return fontFamily
end

-- Class
local Typography = {} :: Typography
Typography.__index = Typography

function Typography.getTextSize(fontSize: number, scale: number): number
	return fontSize * scale
end

function Typography.getGuiLineHeight(lineHeight: number, fontSize: number): number
	return lineHeight / fontSize
end

function Typography.apply(inst: TextInstance, fontData: FontData, scale: number?)
	scale = scale or 1
	assert(scale)
	local textSize = Typography.getTextSize(fontData.Size, scale)
	local lineHeightRatio = Typography.getGuiLineHeight(fontData.LineHeight, fontData.Size)
	if inst:IsA("TextLabel") then
		inst.TextSize = textSize
		inst.LineHeight = lineHeightRatio
		inst.FontFace = fontData.Font
	elseif inst:IsA("TextButton") then
		inst.TextSize = textSize
		inst.LineHeight = lineHeightRatio
		inst.FontFace = fontData.Font
	elseif inst:IsA("TextBox") then
		inst.TextSize = textSize
		inst.LineHeight = lineHeightRatio
		inst.FontFace = fontData.Font
	else
		error(`Unsupported TextInstance type: {inst.ClassName}`)
	end
end

function Typography:Apply(inst: TextInstance, fontType: Enums.FontType, scale: number?)
	Typography.apply(inst, self:Get(fontType), scale)
end

function Typography:Get(style: Enums.FontType): FontData
	return self._Fonts[style]
end

function Typography:Hash(): string
	local fullMessage = ""
	for fontType, fontData in pairs(self._Fonts) do
		fullMessage ..= `[{fontType}-{fontData.Font}-{fontData.Size}-{fontData.Tracking}-{fontData.LineHeight}],`
	end
	return HashUtil.md5(fullMessage)
end

function Typography.new(fonts: { [Enums.FontType]: FontData }): Typography
	local self: Typography = setmetatable({}, Typography) :: any
	self._Fonts = table.freeze(table.clone(fonts))

	table.freeze(self)
	return self
end

function Typography.fromFont(font: Enum.Font): Typography
	if FontCache[font] then
		return FontCache[font]
	end

	local self = Typography.new({
		[Enums.FontType.DisplayLarge] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 57,
			Tracking = -0.25,
			LineHeight = 64,
		}),
		[Enums.FontType.DisplayMedium] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 45,
			Tracking = 0,
			LineHeight = 52,
		}),
		[Enums.FontType.DisplaySmall] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 36,
			Tracking = 0,
			LineHeight = 44,
		}),
		[Enums.FontType.HeadlineLarge] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 32,
			Tracking = 0,
			LineHeight = 40,
		}),
		[Enums.FontType.HeadlineMedium] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 28,
			Tracking = 0,
			LineHeight = 36,
		}),
		[Enums.FontType.HeadlineSmall] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 24,
			Tracking = 0,
			LineHeight = 32,
		}),
		[Enums.FontType.TitleLarge] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 22,
			Tracking = 0,
			LineHeight = 28,
		}),
		[Enums.FontType.TitleMedium] = table.freeze({
			Font = newFontFamily(font, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 16,
			Tracking = 0.15,
			LineHeight = 24,
		}),
		[Enums.FontType.TitleSmall] = table.freeze({
			Font = newFontFamily(font, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.1,
			LineHeight = 20,
		}),
		[Enums.FontType.BodyLarge] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 16,
			Tracking = 0.5,
			LineHeight = 24,
		}),
		[Enums.FontType.BodyMedium] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.25,
			LineHeight = 20,
		}),
		[Enums.FontType.BodySmall] = table.freeze({
			Font = newFontFamily(font, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 12,
			Tracking = 0.4,
			LineHeight = 16,
		}),
		[Enums.FontType.LabelLarge] = table.freeze({
			Font = newFontFamily(font, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.1,
			LineHeight = 20,
		}),
		[Enums.FontType.LabelMedium] = table.freeze({
			Font = newFontFamily(font, WEIGHT[700], Enum.FontStyle.Normal),
			Size = 12,
			Tracking = 0.5,
			LineHeight = 16,
		}),
		[Enums.FontType.LabelSmall] = table.freeze({
			Font = newFontFamily(font, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 11,
			Tracking = 0.5,
			LineHeight = 16,
		}),
	})
	FontCache[font] = self

	return self
end

return Typography
