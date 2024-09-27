--!strict
--!native
-- Services
-- Packages
-- Modules
local Enums = require("@proj/Enums")
local TypographySolver = require("./Solver")
local Types = require("@proj/Types")
-- Types
export type FontData = Types.FontData
export type Typography = {
	_CacheKey: string,
	DisplayLarge: FontData,
	DisplayMedium: FontData,
	DisplaySmall: FontData,
	HeadlineLarge: FontData,
	HeadlineMedium: FontData,
	HeadlineSmall: FontData,
	TitleLarge: FontData,
	TitleMedium: FontData,
	TitleSmall: FontData,
	BodyLarge: FontData,
	BodyMedium: FontData,
	BodySmall: FontData,
	LabelLarge: FontData,
	LabelMedium: FontData,
	LabelSmall: FontData,
	[Enums.FontType]: FontData,
}
-- Constants
-- Variables
-- References
local TypographyCache: { [string]: Typography? } = {}
-- Private Functions
-- Class
local Util = {}

Util.getTextSize = TypographySolver.getTextSize
Util.getGuiLineHeight = TypographySolver.getGuiLineHeight
Util.apply = TypographySolver.apply

Util.new = function(fonts: { [Enums.FontType]: FontData }): Typography
	local solver = TypographySolver.new(fonts)

	local key = solver:Hash()
	if TypographyCache then
		local cached = TypographyCache[key]
		if cached then
			return cached
		end
	end

	local typography: Typography = {
		_CacheKey = key,
	} :: any

	for i, v: Enums.FontType in ipairs(Enums.getEnumItems("FontType") :: { any }) do
		typography[v] = solver:Get(v)
	end

	table.freeze(typography)
	TypographyCache[key] = typography
	return typography
end

Util.fromFont = function(font: Enum.Font): Typography
	local solver = TypographySolver.fromFont(font)
	return Util.new(solver._Fonts)
end

return Util
