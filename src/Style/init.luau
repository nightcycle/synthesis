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

return Util
