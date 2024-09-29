--!strict
--!native
-- Services
-- Packages
-- Modules
local Enums = require("@proj/Enums")
local ThemeSolver = require("./Solver")
-- Types
export type Theme = {
	_CacheKey: string,
	Seed: Color3,
	SchemeType: Enums.SchemeType,
	Elevation: number,
	Primary: Color3,
	OnPrimary: Color3,
	PrimaryContainer: Color3,
	OnPrimaryContainer: Color3,
	Secondary: Color3,
	OnSecondary: Color3,
	SecondaryContainer: Color3,
	OnSecondaryContainer: Color3,
	Tertiary: Color3,
	OnTertiary: Color3,
	TertiaryContainer: Color3,
	OnTertiaryContainer: Color3,
	Error: Color3,
	OnError: Color3,
	ErrorContainer: Color3,
	OnErrorContainer: Color3,
	Background: Color3,
	OnBackground: Color3,
	Surface: Color3,
	OnSurface: Color3,
	SurfaceVariant: Color3,
	OnSurfaceVariant: Color3,
	Outline: Color3,
	OutlineVariant: Color3,
	Shadow: Color3,
	Scrim: Color3,
	InverseSurface: Color3,
	InverseOnSurface: Color3,
	InversePrimary: Color3,
	SurfaceDim: Color3,
	SurfaceBright: Color3,
	SurfaceContainerLowest: Color3,
	SurfaceContainerLow: Color3,
	SurfaceContainer: Color3,
	SurfaceContainerHigh: Color3,
	SurfaceContainerHighest: Color3,
	SurfaceTint: Color3,
	[Enums.ColorRoleType]: Color3,
}
-- Constants
-- Variables
-- References
local ThemeCache: { [string]: Theme? } = {}
-- Private Functions
-- Class
local Util = {}

Util.getElevatedColor = ThemeSolver.getElevatedColor

Util.new = function<CustomColorRoleType>(seed: Color3, schemeType: Enums.SchemeType, elevation: number): Theme
	local solver = ThemeSolver.new(seed)

	local key = `{seed:ToHex()}-{schemeType}-{elevation}`
	if ThemeCache then
		local cached = ThemeCache[key]
		if cached then
			return cached
		end
	end

	local theme: Theme = {
		_CacheKey = key,
		Seed = seed,
		SchemeType = schemeType,
		Elevation = 0,
	} :: any

	for i, v: Enums.ColorRoleType in
		ipairs(Enums.getEnumItems("ColorRoleType") :: { any })
	do
		theme[v] = solver:Get(v, schemeType, elevation)
	end

	table.freeze(theme)
	ThemeCache[key] = theme
	return theme
end

Util.setElevation = function<CustomColorRoleType>(theme: Theme, elevation: number): Theme
	return Util.new(theme.Seed, theme.SchemeType, elevation)
end

Util.setSeed = function<CustomColorRoleType>(theme: Theme, seed: Color3): Theme
	return Util.new(seed, theme.SchemeType, theme.Elevation)
end

Util.setSchemeType = function<CustomColorRoleType>(theme: Theme, schemeType: Enums.SchemeType): Theme
	return Util.new(theme.Seed, schemeType, theme.Elevation)
end

return Util
