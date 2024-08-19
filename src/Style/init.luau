--!strict
-- Services
-- Packages
local HashUtil = require("@wally/HashUtil")

-- Modules
local Typography = require("@proj/Typography")
local Theme = require("@proj/Theme")
local Enums = require("@proj/Enums")

-- Types
export type Theme = Theme.Theme
export type Typography = Typography.Typography
export type FontData = Typography.FontData
export type Style = {
	__index: Style,
	Scale: number,
	IsAnimated: boolean,
	Volume: number,
	SchemeType: Enums.SchemeType,
	_Theme: Theme,
	_Typography: Typography,
	GetElevatedColor: (self: Style, color: Color3, elevation: number) -> Color3,
	GetColor: (self: Style, role: Enums.ColorRoleType, elevation: number?) -> Color3,
	GetCustomColor: (
		self: Style,
		name: string,
		customType: Enums.CustomColorType,
		elevation: number?
	) -> Color3,
	GetFont: (self: Style, fontType: Enums.FontType) -> Font,
	GetFontData: (self: Style, fontType: Enums.FontType) -> FontData,
	GetTextSize: (self: Style, fontType: Enums.FontType) -> number,
	GetLineHeight: (self: Style, fontType: Enums.FontType) -> number,
	new: (
		scale: number,
		typographyOrFont: Typography | Enum.Font,
		schemeType: Enums.SchemeType,
		themeOrColor: Color3 | Theme,
		isAnimated: boolean?
	) -> Style,
}

-- Constants
-- Variables
local Cache: { [string]: Style } = {}

-- References
-- Private Functions

-- Class
local Style = {} :: Style
Style.__index = Style

function Style:GetColor(role: Enums.ColorRoleType, elevation: number?): Color3
	return self._Theme:Get(role, self.SchemeType, elevation)
end

function Style:GetElevatedColor(color: Color3, elevation: number): Color3
	return self._Theme.getElevatedColor(color, elevation, self.SchemeType)
end

function Style:GetCustomColor(
	name: string,
	customType: Enums.CustomColorType,
	elevation: number?
): Color3
	return self._Theme:GetCustom(name, customType, self.SchemeType, elevation)
end

function Style:GetFont(fontType: Enums.FontType): Font
	return self._Typography:Get(fontType).Font
end

function Style:GetFontData(fontType: Enums.FontType): FontData
	return table.clone(self._Typography:Get(fontType))
end

function Style:GetTextSize(fontType: Enums.FontType): number
	return Typography.getTextSize(self._Typography:Get(fontType).Size, self.Scale)
end

function Style:GetLineHeight(fontType: Enums.FontType): number
	return Typography.getGuiLineHeight(
		self._Typography:Get(fontType).LineHeight,
		self._Typography:Get(fontType).Size
	)
end

function Style.new(
	scale: number,
	typographyOrFont: Typography | Enum.Font,
	schemeType: Enums.SchemeType,
	themeOrColor: Color3 | Theme,
	isAnimated: boolean?,
	volume: number?
): Style
	local typography: Typography
	if typeof(typographyOrFont) == "EnumItem" then
		typography = Typography.fromFont(typographyOrFont)
	else
		typography = typographyOrFont
	end

	local theme: Theme
	if typeof(themeOrColor) == "Color3" then
		theme = Theme.new(themeOrColor)
	else
		theme = themeOrColor
	end

	local hash = HashUtil.md5(`{scale}+{typography:Hash()}+{schemeType}+{theme:Hash()}`)
	if Cache[hash] then
		return Cache[hash]
	end

	local self: Style = setmetatable({}, Style) :: any
	self.Scale = scale
	self.SchemeType = schemeType
	self.IsAnimated = if isAnimated ~= nil then isAnimated else true
	self.Volume = volume or 0.5
	self._Theme = theme
	self._Typography = typography

	table.freeze(self)
	Cache[hash] = self

	return self
end

return Style
