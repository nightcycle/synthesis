--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/scheme/scheme.ts

local CorePalette = require("./Palettes/Core")
type TonalPalette = CorePalette.TonalPalette
type CorePalette = CorePalette.CorePalette
export type SchemeData = {
	primary: number,
	onPrimary: number,
	primaryContainer: number,
	onPrimaryContainer: number,
	secondary: number,
	onSecondary: number,
	secondaryContainer: number,
	onSecondaryContainer: number,
	tertiary: number,
	onTertiary: number,
	tertiaryContainer: number,
	onTertiaryContainer: number,
	error: number,
	onError: number,
	errorContainer: number,
	onErrorContainer: number,
	background: number,
	onBackground: number,
	surface: number,
	onSurface: number,
	surfaceVariant: number,
	onSurfaceVariant: number,
	outline: number,
	outlineVariant: number,
	shadow: number,
	scrim: number,
	inverseSurface: number,
	inverseOnSurface: number,
	inversePrimary: number,

	surfaceDim: number,
	surfaceBright: number,
	surfaceContainerLowest: number,
	surfaceContainerLow: number,
	surfaceContainer: number,
	surfaceContainerHigh: number,
	surfaceContainerHighest: number,
	surfaceTint: number,
}

export type Scheme = {
	__index: Scheme,
	new: (data: SchemeData) -> Scheme,
	light: (argb: number) -> Scheme,
	dark: (argb: number) -> Scheme,
	lightContent: (argb: number) -> Scheme,
	darkContent: (argb: number) -> Scheme,
	lightFromCorePalette: (core: CorePalette) -> Scheme,
	darkFromCorePalette: (core: CorePalette) -> Scheme,
	toJSON: (self: Scheme) -> SchemeData,
} & SchemeData

local Scheme = {} :: Scheme
Scheme.__index = Scheme

function Scheme:toJSON(): SchemeData
	local data: SchemeData = table.clone(self) :: any
	return data
end

function Scheme.light(argb: number): Scheme
	return Scheme.lightFromCorePalette(CorePalette.of(argb))
end

function Scheme.dark(argb: number): Scheme
	return Scheme.darkFromCorePalette(CorePalette.of(argb))
end

function Scheme.lightContent(argb: number): Scheme
	return Scheme.lightFromCorePalette(CorePalette.contentOf(argb))
end

function Scheme.darkContent(argb: number): Scheme
	return Scheme.darkFromCorePalette(CorePalette.contentOf(argb))
end

function Scheme.lightFromCorePalette(core: CorePalette): Scheme
	return Scheme.new({
		primary = core.a1:getTone(40),
		onPrimary = core.a1:getTone(100),
		primaryContainer = core.a1:getTone(90),
		onPrimaryContainer = core.a1:getTone(10),
		secondary = core.a2:getTone(40),
		onSecondary = core.a2:getTone(100),
		secondaryContainer = core.a2:getTone(90),
		onSecondaryContainer = core.a2:getTone(10),
		tertiary = core.a3:getTone(40),
		onTertiary = core.a3:getTone(100),
		tertiaryContainer = core.a3:getTone(90),
		onTertiaryContainer = core.a3:getTone(10),
		error = core.error:getTone(40),
		onError = core.error:getTone(100),
		errorContainer = core.error:getTone(90),
		onErrorContainer = core.error:getTone(10),
		background = core.n1:getTone(99),
		onBackground = core.n1:getTone(10),
		surface = core.n1:getTone(99),
		onSurface = core.n1:getTone(10),
		surfaceVariant = core.n2:getTone(90),
		onSurfaceVariant = core.n2:getTone(30),
		outline = core.n2:getTone(50),
		outlineVariant = core.n2:getTone(80),
		shadow = core.n1:getTone(0),
		scrim = core.n1:getTone(0),
		inverseSurface = core.n1:getTone(20),
		inverseOnSurface = core.n1:getTone(95),
		inversePrimary = core.a1:getTone(80),
		surfaceDim = core.n1:getTone(87),
		surfaceBright = core.n1:getTone(98),
		surfaceContainerLowest = core.n1:getTone(100),
		surfaceContainerLow = core.n1:getTone(96),
		surfaceContainer = core.n1:getTone(94),
		surfaceContainerHigh = core.n1:getTone(92),
		surfaceContainerHighest = core.n1:getTone(90),
		surfaceTint = core.n1:getTone(40),
	})
end

function Scheme.darkFromCorePalette(core: CorePalette): Scheme
	return Scheme.new({
		primary = core.a1:getTone(80),
		onPrimary = core.a1:getTone(20),
		primaryContainer = core.a1:getTone(30),
		onPrimaryContainer = core.a1:getTone(90),
		secondary = core.a2:getTone(80),
		onSecondary = core.a2:getTone(20),
		secondaryContainer = core.a2:getTone(30),
		onSecondaryContainer = core.a2:getTone(90),
		tertiary = core.a3:getTone(80),
		onTertiary = core.a3:getTone(20),
		tertiaryContainer = core.a3:getTone(30),
		onTertiaryContainer = core.a3:getTone(90),
		error = core.error:getTone(80),
		onError = core.error:getTone(20),
		errorContainer = core.error:getTone(30),
		onErrorContainer = core.error:getTone(80),
		background = core.n1:getTone(10),
		onBackground = core.n1:getTone(90),
		surface = core.n1:getTone(10),
		onSurface = core.n1:getTone(90),
		surfaceVariant = core.n2:getTone(30),
		onSurfaceVariant = core.n2:getTone(80),
		outline = core.n2:getTone(60),
		outlineVariant = core.n2:getTone(30),
		shadow = core.n1:getTone(0),
		scrim = core.n1:getTone(0),
		inverseSurface = core.n1:getTone(90),
		inverseOnSurface = core.n1:getTone(20),
		inversePrimary = core.a1:getTone(40),

		surfaceDim = core.n1:getTone(6),
		surfaceBright = core.n1:getTone(24),
		surfaceContainerLowest = core.n1:getTone(4),
		surfaceContainerLow = core.n1:getTone(10),
		surfaceContainer = core.n1:getTone(12),
		surfaceContainerHigh = core.n1:getTone(17),
		surfaceContainerHighest = core.n1:getTone(22),
		surfaceTint = core.n1:getTone(80),
	})
end

function Scheme.new(data: SchemeData): Scheme
	local self: Scheme = setmetatable(table.clone(data), Scheme) :: any
	return self
end

return Scheme
