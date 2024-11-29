--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/palettes/core_palette.ts
local HCT = require("../HCT")
local TonalPalette = require("./Tonal")

export type TonalPalette = TonalPalette.TonalPalette
type HCT = HCT.HCT

export type CorePaletteColors = {
	primary: number,
	secondary: number?,
	tertiary: number?,
	neutral: number?,
	neutralVariant: number?,
	error: number?,
}

export type CorePalette = {
	__index: CorePalette,
	a1: TonalPalette,
	a2: TonalPalette,
	a3: TonalPalette,
	n1: TonalPalette,
	n2: TonalPalette,
	error: TonalPalette,
}

local CorePalette = {}
CorePalette.__index = CorePalette

function CorePalette.of(argb: number): CorePalette
	return CorePalette.new(argb, false)
end

function CorePalette.contentOf(argb: number): CorePalette
	return CorePalette.new(argb, true)
end

function CorePalette.fromColors(colors: CorePaletteColors): CorePalette
	return CorePalette.createPaletteFromColors(false, colors)
end

function CorePalette.contentFromColors(colors: CorePaletteColors): CorePalette
	return CorePalette.createPaletteFromColors(true, colors)
end

function CorePalette.createPaletteFromColors(content: boolean, colors: CorePaletteColors): CorePalette
	local palette = CorePalette.new(colors.primary, content)
	if colors.secondary then
		local p = CorePalette.new(colors.secondary, content)
		palette.a2 = p.a1
	end
	if colors.tertiary then
		local p = CorePalette.new(colors.tertiary, content)
		palette.a3 = p.a1
	end
	if colors.error then
		local p = CorePalette.new(colors.error, content)
		palette.error = p.a1
	end
	if colors.neutral then
		local p = CorePalette.new(colors.neutral, content)
		palette.n1 = p.n1
	end
	if colors.neutralVariant then
		local p = CorePalette.new(colors.neutralVariant, content)
		palette.n2 = p.n2
	end
	return palette
end

function CorePalette.new(argb: number, isContent: boolean)
	local hct = HCT.fromInt(argb)
	local hue = hct:getHue()
	local chroma = hct:getChroma()

	local self: CorePalette = setmetatable({}, CorePalette) :: any

	if isContent then
		self.a1 = TonalPalette.fromHueAndChroma(hue, chroma)
		self.a2 = TonalPalette.fromHueAndChroma(hue, chroma / 3)
		self.a3 = TonalPalette.fromHueAndChroma(hue + 60, chroma / 2)
		self.n1 = TonalPalette.fromHueAndChroma(hue, math.min(chroma / 12, 4))
		self.n2 = TonalPalette.fromHueAndChroma(hue, math.min(chroma / 6, 8))
	else
		self.a1 = TonalPalette.fromHueAndChroma(hue, math.max(48, chroma))
		self.a2 = TonalPalette.fromHueAndChroma(hue, 16)
		self.a3 = TonalPalette.fromHueAndChroma(hue + 60, 24)
		self.n1 = TonalPalette.fromHueAndChroma(hue, 4)
		self.n2 = TonalPalette.fromHueAndChroma(hue, 8)
	end
	self.error = TonalPalette.fromHueAndChroma(25, 84)

	return self
end

return CorePalette
