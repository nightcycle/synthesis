--!strict
--!native
-- Services
-- Packages
-- Modules
local Theme = require("@proj/Theme")
local Typography = require("@proj/Typography")
-- Types
export type Theme = Theme.Theme
export type Typography = Typography.Typography
export type Style = {
	Volume: number,
	IsAnimated: boolean,
	Scale: number,
	Theme: Theme,
	Typography: Typography,
}
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

Util.new = function(
	scale: number,
	volume: number,
	isAnimated: boolean,
	theme: Theme,
	typography: Typography
): Style
	local style: Style = {
		Volume = volume,
		IsAnimated = isAnimated,
		Scale = scale,
		Typography = typography,
		Theme = theme,
	} :: any

	return table.freeze(style)
end

Util.setVolume = function(style: Style, volume: number): Style
	return Util.new(style.Scale, volume, style.IsAnimated, style.Theme, style.Typography)
end

Util.setScale = function(style: Style, scale: number): Style
	return Util.new(scale, style.Volume, style.IsAnimated, style.Theme, style.Typography)
end

Util.setIsAnimated = function(style: Style, isAnimated: boolean): Style
	return Util.new(style.Scale, style.Volume, isAnimated, style.Theme, style.Typography)
end

Util.setTheme = function(style: Style, theme: Theme): Style
	return Util.new(style.Scale, style.Volume, style.IsAnimated, theme, style.Typography)
end

Util.setTypography = function(style: Style, typography: Typography): Style
	return Util.new(style.Scale, style.Volume, style.IsAnimated, style.Theme, typography)
end

return Util
