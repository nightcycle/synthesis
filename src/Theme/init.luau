--!strict
--!native
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local HashUtil = require("@wally/HashUtil")
local TableUtil = require("@wally/TableUtil")

-- Modules
local Enums = require("@proj/Enums")
local ThemeUtil = require("./ThemeUtil")
local HCT = require("./HCT")
local Blend = require("./Blend")

-- Types
type GoogleHCT = HCT.HCT
type GoogleCustomColor = ThemeUtil.CustomColor
type GoogleTheme = ThemeUtil.Theme
type GoogleScheme = ThemeUtil.Scheme
type GoogleTonalPalette = ThemeUtil.TonalPalette
type GoogleColorGroup = ThemeUtil.ColorGroup
export type Scheme = { [Enums.ColorRoleType]: Color3 }
export type TonalPalette = (alpha: number, noClamp: boolean?) -> Color3
export type CustomColorGroup = {
	Name: string,
	Value: number,
	IsBlended: boolean,
	Schemes: {
		[Enums.SchemeType]: { [Enums.CustomColorType]: Color3 },
	},
}
export type Theme = {
	__index: Theme,
	Source: Color3,
	_Schemes: { [Enums.SchemeType]: Scheme },
	Palettes: { [Enums.PaletteType]: TonalPalette },
	_CustomColors: {
		[string]: CustomColorGroup,
	},
	_Hash: string,
	Hash: (self: Theme) -> string,
	Get: (self: Theme, role: Enums.ColorRoleType, schemeType: Enums.SchemeType, elevation: number?) -> Color3,
	GetCustom: (
		self: Theme,
		name: string,
		customType: Enums.CustomColorType,
		schemeType: Enums.SchemeType,
		elevation: number?
	) -> Color3,
	getElevatedColor: (color: Color3, elevation: number, schemeType: Enums.SchemeType) -> Color3,
	new: (source: Color3, custom: { [string]: Color3 }?) -> Theme,
}
-- Constants
local ELEVATION_TINTS = { 0, 0.05, 0.08, 0.11, 0.12, 0.14 }
-- Variables
local Cache: { [string]: Theme } = {}
-- References
-- Private Functions

-- Class
local Theme = {} :: Theme
Theme.__index = Theme

function Theme:Hash()
	return self._Hash
end

function Theme.new(source: Color3, custom: { [string]: Color3 }?): Theme
	local hash = ""
	do
		local hashInput = `{source:ToHex()}+` .. "{"
		if custom then
			local keys = TableUtil.keys(custom)
			table.sort(keys)
			for i, k in ipairs(keys) do
				hashInput ..= `{k}={custom[k]:ToHex()},`
			end
		end
		hashInput ..= "}"
		hash = HashUtil.md5(hashInput)
	end
	if Cache[hash] then
		return Cache[hash]
	end

	local googleTheme: GoogleTheme
	do
		local customColors: { [number]: GoogleCustomColor } = {}
		if custom then
			for k, color in pairs(custom) do
				table.insert(customColors, ThemeUtil.customColor(HCT.fromColor3(source):toInt(), k, false))
			end
		end

		googleTheme = ThemeUtil.themeFromSourceColor(HCT.fromColor3(source):toInt(), customColors)
	end

	local lightScheme: Scheme
	local darkScheme: Scheme
	do
		local function fromScheme(scheme: GoogleScheme): Scheme
			return table.freeze({
				[Enums.ColorRoleType.Primary] = HCT.fromInt(scheme.primary):toColor3(),
				[Enums.ColorRoleType.OnPrimary] = HCT.fromInt(scheme.onPrimary):toColor3(),
				[Enums.ColorRoleType.PrimaryContainer] = HCT.fromInt(scheme.primaryContainer):toColor3(),
				[Enums.ColorRoleType.OnPrimaryContainer] = HCT.fromInt(scheme.onPrimaryContainer):toColor3(),
				[Enums.ColorRoleType.InversePrimary] = HCT.fromInt(scheme.inversePrimary):toColor3(),
				[Enums.ColorRoleType.Secondary] = HCT.fromInt(scheme.secondary):toColor3(),
				[Enums.ColorRoleType.OnSecondary] = HCT.fromInt(scheme.onSecondary):toColor3(),
				[Enums.ColorRoleType.SecondaryContainer] = HCT.fromInt(scheme.secondaryContainer):toColor3(),
				[Enums.ColorRoleType.OnSecondaryContainer] = HCT.fromInt(scheme.onSecondaryContainer)
					:toColor3(),
				[Enums.ColorRoleType.Tertiary] = HCT.fromInt(scheme.tertiary):toColor3(),
				[Enums.ColorRoleType.OnTertiary] = HCT.fromInt(scheme.onTertiary):toColor3(),
				[Enums.ColorRoleType.TertiaryContainer] = HCT.fromInt(scheme.tertiaryContainer):toColor3(),
				[Enums.ColorRoleType.OnTertiaryContainer] = HCT.fromInt(scheme.onTertiaryContainer)
					:toColor3(),
				[Enums.ColorRoleType.Error] = HCT.fromInt(scheme.error):toColor3(),
				[Enums.ColorRoleType.OnError] = HCT.fromInt(scheme.onError):toColor3(),
				[Enums.ColorRoleType.ErrorContainer] = HCT.fromInt(scheme.errorContainer):toColor3(),
				[Enums.ColorRoleType.OnErrorContainer] = HCT.fromInt(scheme.onErrorContainer):toColor3(),
				[Enums.ColorRoleType.Background] = HCT.fromInt(scheme.background):toColor3(),
				[Enums.ColorRoleType.OnBackground] = HCT.fromInt(scheme.onBackground):toColor3(),
				[Enums.ColorRoleType.Surface] = HCT.fromInt(scheme.surface):toColor3(),
				[Enums.ColorRoleType.OnSurface] = HCT.fromInt(scheme.onSurface):toColor3(),
				[Enums.ColorRoleType.SurfaceVariant] = HCT.fromInt(scheme.surfaceVariant):toColor3(),
				[Enums.ColorRoleType.OnSurfaceVariant] = HCT.fromInt(scheme.onSurfaceVariant):toColor3(),
				[Enums.ColorRoleType.InverseSurface] = HCT.fromInt(scheme.inverseSurface):toColor3(),
				[Enums.ColorRoleType.InverseOnSurface] = HCT.fromInt(scheme.inverseOnSurface):toColor3(),
				[Enums.ColorRoleType.SurfaceDim] = HCT.fromInt(scheme.surfaceDim):toColor3(),
				[Enums.ColorRoleType.SurfaceBright] = HCT.fromInt(scheme.surfaceBright):toColor3(),
				[Enums.ColorRoleType.SurfaceContainerLowest] = HCT.fromInt(scheme.surfaceContainerLowest)
					:toColor3(),
				[Enums.ColorRoleType.SurfaceContainerLow] = HCT.fromInt(scheme.surfaceContainerLow)
					:toColor3(),
				[Enums.ColorRoleType.SurfaceContainer] = HCT.fromInt(scheme.surfaceContainer):toColor3(),
				[Enums.ColorRoleType.SurfaceContainerHigh] = HCT.fromInt(scheme.surfaceContainerHigh)
					:toColor3(),
				[Enums.ColorRoleType.SurfaceContainerHighest] = HCT.fromInt(scheme.surfaceContainerHighest)
					:toColor3(),
				[Enums.ColorRoleType.SurfaceTint] = HCT.fromInt(scheme.surfaceTint):toColor3(),
				[Enums.ColorRoleType.Outline] = HCT.fromInt(scheme.outline):toColor3(),
				[Enums.ColorRoleType.OutlineVariant] = HCT.fromInt(scheme.outlineVariant):toColor3(),
				[Enums.ColorRoleType.Shadow] = HCT.fromInt(scheme.shadow):toColor3(),
				[Enums.ColorRoleType.Scrim] = HCT.fromInt(scheme.scrim):toColor3(),
			}) :: Scheme
		end
		lightScheme = fromScheme(googleTheme.schemes.light)
		darkScheme = fromScheme(googleTheme.schemes.dark)
	end

	local primaryPalette: TonalPalette
	local secondaryPalette: TonalPalette
	local tertiaryPalette: TonalPalette
	local neutralPalette: TonalPalette
	local neutralVariantPalette: TonalPalette
	local errorPalette: TonalPalette
	do
		local function fromPalette(tonalPalette: GoogleTonalPalette): TonalPalette
			return function(alpha: number, noClamp: boolean?): Color3
				return HCT.fromInt(
					tonalPalette:getTone(if noClamp then alpha * 100 else math.clamp(alpha, 0.05, 0.9) * 100)
				):toColor3()
			end
		end
		primaryPalette = fromPalette(googleTheme.palettes.primary)
		secondaryPalette = fromPalette(googleTheme.palettes.secondary)
		tertiaryPalette = fromPalette(googleTheme.palettes.tertiary)
		neutralPalette = fromPalette(googleTheme.palettes.neutral)
		neutralVariantPalette = fromPalette(googleTheme.palettes.neutralVariant)
		errorPalette = fromPalette(googleTheme.palettes.error)
	end

	local customColors: { [string]: CustomColorGroup } = {}
	do
		local function fromColorGroup(group: GoogleColorGroup): { [Enums.ColorRoleType]: Color3 }
			return table.freeze({
				[Enums.CustomColorType.Custom] = HCT.fromInt(group.color):toColor3(),
				[Enums.CustomColorType.OnCustom] = HCT.fromInt(group.onColor):toColor3(),
				[Enums.CustomColorType.CustomContainer] = HCT.fromInt(group.colorContainer):toColor3(),
				[Enums.CustomColorType.OnCustomContainer] = HCT.fromInt(group.onColorContainer):toColor3(),
			})
		end
		for i, colorGroup in pairs(googleTheme.customColors) do
			local cGroup: CustomColorGroup = {
				Name = colorGroup.color.name,
				Value = colorGroup.value,
				IsBlended = colorGroup.color.blend,
				Schemes = {
					Light = fromColorGroup(colorGroup.light),
					Dark = fromColorGroup(colorGroup.dark),
				},
			}
			table.freeze(cGroup)
			customColors[colorGroup.color.name] = cGroup
		end
	end

	local theme: Theme = setmetatable({
		Source = source,
		_Schemes = table.freeze({
			Light = lightScheme,
			Dark = darkScheme,
		}),
		_Hash = hash,
		Palettes = table.freeze({
			Primary = primaryPalette,
			Secondary = secondaryPalette,
			Tertiary = tertiaryPalette,
			Neutral = neutralPalette,
			NeutralVariant = neutralVariantPalette,
			Error = errorPalette,
		}),
		CustomColors = table.freeze(customColors),
	}, Theme) :: any
	table.freeze(theme)
	Cache[hash] = theme
	return theme
end

function Theme.getElevatedColor(color: Color3, elevation: number, schemeType: Enums.SchemeType): Color3
	local hct = HCT.fromColor3(color)
	local tone = hct:getTone()
	elevation += 1
	elevation = math.clamp(elevation, 1, #ELEVATION_TINTS)
	if ELEVATION_TINTS[elevation] then
		local newColor = HCT.fromColor3(color)
		newColor:setTone(tone + (tone * ELEVATION_TINTS[elevation]))
		return newColor:toColor3()
	else
		local up = math.ceil(elevation)
		local down = math.floor(elevation)

		local downColor = HCT.fromColor3(color)
		downColor:setTone(tone - (tone * ELEVATION_TINTS[down]))

		local upColor = HCT.fromColor3(color)
		upColor:setTone(tone + (tone * ELEVATION_TINTS[up]))

		return HCT.fromInt(Blend.cam16Ucs(downColor:toInt(), upColor:toInt(), (elevation - down))):toColor3()
	end
end

function Theme:GetCustom(
	name: string,
	customType: Enums.CustomColorType,
	schemeType: Enums.SchemeType,
	elevation: number?
): Color3
	local customColorGroup: CustomColorGroup = self._CustomColors[name]
	assert(customColorGroup, `no custom color group at {name}`)

	local color: Color3 = customColorGroup.Schemes[schemeType][customType]

	if elevation then
		return self.getElevatedColor(color, elevation, schemeType)
	else
		return color
	end
end

function Theme:Get(role: Enums.ColorRoleType, schemeType: Enums.SchemeType, elevation: number?): Color3
	local scheme: Scheme = self._Schemes[schemeType]

	local color: Color3 = scheme[role :: Enums.ColorRoleType]
	assert(color, `no role named {role}`)

	if elevation then
		return self.getElevatedColor(color, elevation, schemeType)
	else
		return color
	end
end

return Theme
