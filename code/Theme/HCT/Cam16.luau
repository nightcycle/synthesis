--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/hct/cam16.ts
local ColorUtil = require("../ColorUtil")
local ViewingConditions = require("../ViewingConditions")

-- Types
type ViewingConditions = ViewingConditions.ViewingConditions
export type Cam16 = {
	__index: Cam16,
	hue: number,
	chroma: number,
	j: number,
	q: number,
	m: number,
	s: number,
	jstar: number,
	astar: number,
	bstar: number,
	new: (
		hue: number,
		chroma: number,
		j: number,
		q: number,
		m: number,
		s: number,
		jstar: number,
		astar: number,
		bstar: number
	) -> Cam16,
	fromInt: (argb: number) -> Cam16,
	fromIntInViewingConditions: (argb: number, viewingConditions: ViewingConditions) -> Cam16,
	fromJchInViewingConditions: (
		j: number,
		c: number,
		h: number,
		viewingConditions: ViewingConditions
	) -> Cam16,
	fromUcs: (jstar: number, astar: number, bstar: number) -> Cam16,
	fromJch: (j: number, c: number, h: number) -> Cam16,
	fromUcsInViewingConditions: (
		jstar: number,
		astar: number,
		bstar: number,
		viewingConditions: ViewingConditions
	) -> Cam16,
	distance: (self: Cam16, other: Cam16) -> number,
	toInt: (self: Cam16) -> number,
	viewed: (self: Cam16, viewingConditions: ViewingConditions) -> number,
	fromXyzInViewingConditions: (
		x: number,
		y: number,
		z: number,
		viewingConditions: ViewingConditions
	) -> Cam16,
	xyzInViewingConditions: (self: Cam16, viewingConditions: ViewingConditions) -> { number },
}

-- Class
local Cam16 = {} :: Cam16
Cam16.__index = Cam16

function Cam16.new(
	hue: number,
	chroma: number,
	j: number,
	q: number,
	m: number,
	s: number,
	jstar: number,
	astar: number,
	bstar: number
)
	local self: Cam16 = setmetatable({}, Cam16) :: any
	self.hue = hue
	self.chroma = chroma
	self.j = j
	self.q = q
	self.m = m
	self.s = s
	self.jstar = jstar
	self.astar = astar
	self.bstar = bstar
	table.freeze(self)
	return self
end

function Cam16:distance(other: Cam16): number
	local dJ = self.jstar - other.jstar
	local dA = self.astar - other.astar
	local dB = self.bstar - other.bstar
	local dEPrime = math.sqrt(dJ * dJ + dA * dA + dB * dB)
	local dE = 1.41 * math.pow(dEPrime, 0.63)
	return dE
end

function Cam16.fromInt(argb: number): Cam16
	return Cam16.fromIntInViewingConditions(argb, ViewingConditions.DEFAULT)
end

function Cam16.fromIntInViewingConditions(argb: number, viewingConditions: ViewingConditions): Cam16
	local red = bit32.rshift(bit32.band(argb, 0x00ff0000), 16)
	local green = bit32.rshift(bit32.band(argb, 0x0000ff00), 8)
	local blue = bit32.band(argb, 0x000000ff)

	local redL = ColorUtil.linearized(red)
	local greenL = ColorUtil.linearized(green)
	local blueL = ColorUtil.linearized(blue)

	local x = 0.41233895 * redL + 0.35762064 * greenL + 0.18051042 * blueL
	local y = 0.2126 * redL + 0.7152 * greenL + 0.0722 * blueL
	local z = 0.01932141 * redL + 0.11916382 * greenL + 0.95034478 * blueL
	local rC = 0.401288 * x + 0.650173 * y - 0.051461 * z
	local gC = -0.250268 * x + 1.204414 * y + 0.045854 * z
	local bC = -0.002079 * x + 0.048952 * y + 0.953127 * z

	local rD = viewingConditions.rgbD[0] * rC
	local gD = viewingConditions.rgbD[1] * gC
	local bD = viewingConditions.rgbD[2] * bC

	local rAF = math.pow((viewingConditions.fl * math.abs(rD)) / 100.0, 0.42)
	local gAF = math.pow((viewingConditions.fl * math.abs(gD)) / 100.0, 0.42)
	local bAF = math.pow((viewingConditions.fl * math.abs(bD)) / 100.0, 0.42)

	local rA = (math.sign(rD) * 400.0 * rAF) / (rAF + 27.13)
	local gA = (math.sign(gD) * 400.0 * gAF) / (gAF + 27.13)
	local bA = (math.sign(bD) * 400.0 * bAF) / (bAF + 27.13)

	local a = (11.0 * rA + -12.0 * gA + bA) / 11.0
	local b = (rA + gA - 2.0 * bA) / 9.0
	local u = (20.0 * rA + 20.0 * gA + 21.0 * bA) / 20.0
	local p2 = (40.0 * rA + 20.0 * gA + bA) / 20.0
	local atan2 = math.atan2(b, a)
	local atanDegrees = (atan2 * 180.0) / math.pi
	local hue: number
	if atanDegrees < 0 then
		hue = atanDegrees + 360.0
	elseif atanDegrees >= 360 then
		hue = atanDegrees - 360.0
	else
		hue = atanDegrees
	end
	local hueRadians = (hue * math.pi) / 180.0

	local ac = p2 * viewingConditions.nbb
	local j = 100.0 * math.pow(ac / viewingConditions.aw, viewingConditions.c * viewingConditions.z)
	local q = (4.0 / viewingConditions.c)
		* math.sqrt(j / 100.0)
		* (viewingConditions.aw + 4.0)
		* viewingConditions.fLRoot

	local huePrime
	if hue < 20.14 then
		huePrime = hue + 360
	else
		huePrime = hue
	end

	local eHue = 0.25 * (math.cos((huePrime * math.pi) / 180.0 + 2.0) + 3.8)
	local p1 = (50000.0 / 13.0) * eHue * viewingConditions.nc * viewingConditions.ncb
	local t = (p1 * math.sqrt(a * a + b * b)) / (u + 0.305)
	local alpha = math.pow(t, 0.9) * math.pow(1.64 - math.pow(0.29, viewingConditions.n), 0.73)
	local c = alpha * math.sqrt(j / 100.0)
	local m = c * viewingConditions.fLRoot
	local s = 50.0 * math.sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))
	local jstar = ((1.0 + 100.0 * 0.007) * j) / (1.0 + 0.007 * j)
	local mstar = (1.0 / 0.0228) * math.log(1.0 + 0.0228 * m)
	local astar = mstar * math.cos(hueRadians)
	local bstar = mstar * math.sin(hueRadians)

	return Cam16.new(hue, c, j, q, m, s, jstar, astar, bstar)
end

function Cam16.fromJch(j: number, c: number, h: number): Cam16
	return Cam16.fromJchInViewingConditions(j, c, h, ViewingConditions.DEFAULT)
end

function Cam16.fromJchInViewingConditions(
	j: number,
	c: number,
	h: number,
	viewingConditions: ViewingConditions
): Cam16
	local q = (4.0 / viewingConditions.c)
		* math.sqrt(j / 100.0)
		* (viewingConditions.aw + 4.0)
		* viewingConditions.fLRoot
	local m = c * viewingConditions.fLRoot
	local alpha = c / math.sqrt(j / 100.0)
	local s = 50.0 * math.sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))
	local hueRadians = (h * math.pi) / 180.0
	local jstar = ((1.0 + 100.0 * 0.007) * j) / (1.0 + 0.007 * j)
	local mstar = (1.0 / 0.0228) * math.log(1.0 + 0.0228 * m)
	local astar = mstar * math.cos(hueRadians)
	local bstar = mstar * math.sin(hueRadians)
	return Cam16.new(h, c, j, q, m, s, jstar, astar, bstar)
end

function Cam16.fromUcs(jstar: number, astar: number, bstar: number): Cam16
	return Cam16.fromUcsInViewingConditions(jstar, astar, bstar, ViewingConditions.DEFAULT)
end

function Cam16.fromUcsInViewingConditions(
	jstar: number,
	astar: number,
	bstar: number,
	viewingConditions: ViewingConditions
): Cam16
	local a = astar
	local b = bstar
	local m = math.sqrt(a * a + b * b)
	local M = (math.exp(m * 0.0228) - 1.0) / 0.0228
	local c = M / viewingConditions.fLRoot
	local h = math.atan2(b, a) * (180.0 / math.pi)
	if h < 0.0 then
		h += 360.0
	end
	local j = jstar / (1 - (jstar - 100) * 0.007)
	return Cam16.fromJchInViewingConditions(j, c, h, viewingConditions)
end

function Cam16:toInt(): number
	return self:viewed(ViewingConditions.DEFAULT)
end

function Cam16:viewed(viewingConditions: ViewingConditions): number
	local alpha
	if self.chroma == 0.0 or self.j == 0.0 then
		alpha = 0.0
	else
		alpha = self.chroma / math.sqrt(self.j / 100.0)
	end

	local t = math.pow(alpha / math.pow(1.64 - math.pow(0.29, viewingConditions.n), 0.73), 1.0 / 0.9)
	local hRad = (self.hue * math.pi) / 180.0

	local eHue = 0.25 * (math.cos(hRad + 2.0) + 3.8)
	local ac = viewingConditions.aw
		* math.pow(self.j / 100.0, 1.0 / viewingConditions.c / viewingConditions.z)
	local p1 = eHue * (50000.0 / 13.0) * viewingConditions.nc * viewingConditions.ncb
	local p2 = ac / viewingConditions.nbb

	local hSin = math.sin(hRad)
	local hCos = math.cos(hRad)

	local gamma = (23.0 * (p2 + 0.305) * t) / (23.0 * p1 + 11.0 * t * hCos + 108.0 * t * hSin)
	local a = gamma * hCos
	local b = gamma * hSin
	local rA = (460.0 * p2 + 451.0 * a + 288.0 * b) / 1403.0
	local gA = (460.0 * p2 - 891.0 * a - 261.0 * b) / 1403.0
	local bA = (460.0 * p2 - 220.0 * a - 6300.0 * b) / 1403.0

	local rCBase = math.max(0, (27.13 * math.abs(rA)) / (400.0 - math.abs(rA)))
	local rC = math.sign(rA) * (100.0 / viewingConditions.fl) * math.pow(rCBase, 1.0 / 0.42)
	local gCBase = math.max(0, (27.13 * math.abs(gA)) / (400.0 - math.abs(gA)))
	local gC = math.sign(gA) * (100.0 / viewingConditions.fl) * math.pow(gCBase, 1.0 / 0.42)
	local bCBase = math.max(0, (27.13 * math.abs(bA)) / (400.0 - math.abs(bA)))
	local bC = math.sign(bA) * (100.0 / viewingConditions.fl) * math.pow(bCBase, 1.0 / 0.42)

	local rF = rC / viewingConditions.rgbD[1]
	local gF = gC / viewingConditions.rgbD[2]
	local bF = bC / viewingConditions.rgbD[3]

	local x = 1.86206786 * rF - 1.01125463 * gF + 0.14918677 * bF
	local y = 0.38752654 * rF + 0.62144744 * gF - 0.00897398 * bF
	local z = -0.01584150 * rF - 0.03412294 * gF + 1.04996444 * bF

	-- Assuming ColorUtil.argbFromXyz is a function that converts XYZ to ARGB.
	local argb = ColorUtil.argbFromXyz(x, y, z)
	return argb
end

function Cam16.fromXyzInViewingConditions(
	x: number,
	y: number,
	z: number,
	viewingConditions: ViewingConditions
): Cam16
	local rC = 0.401288 * x + 0.650173 * y - 0.051461 * z
	local gC = -0.250268 * x + 1.204414 * y + 0.045854 * z
	local bC = -0.002079 * x + 0.048952 * y + 0.953127 * z

	--Discount illuminant
	local rD = viewingConditions.rgbD[0] * rC
	local gD = viewingConditions.rgbD[1] * gC
	local bD = viewingConditions.rgbD[2] * bC

	--chromatic adaptation
	local rAF = math.pow(viewingConditions.fl * math.abs(rD) / 100.0, 0.42)
	local gAF = math.pow(viewingConditions.fl * math.abs(gD) / 100.0, 0.42)
	local bAF = math.pow(viewingConditions.fl * math.abs(bD) / 100.0, 0.42)
	local rA = math.sign(rD) * 400.0 * rAF / (rAF + 27.13)
	local gA = math.sign(gD) * 400.0 * gAF / (gAF + 27.13)
	local bA = math.sign(bD) * 400.0 * bAF / (bAF + 27.13)

	--redness-greenness
	local a = (11.0 * rA + -12.0 * gA + bA) / 11.0
	--yellowness-blueness
	local b = (rA + gA - 2.0 * bA) / 9.0

	--auxiliary components
	local u = (20.0 * rA + 20.0 * gA + 21.0 * bA) / 20.0
	local p2 = (40.0 * rA + 20.0 * gA + bA) / 20.0

	--hue
	local atan2 = math.atan2(b, a)
	local atanDegrees = atan2 * 180.0 / math.pi

	local hue
	if atanDegrees < 0 then
		hue = atanDegrees + 360.0
	elseif atanDegrees >= 360 then
		hue = atanDegrees - 360
	else
		hue = atanDegrees
	end
	local hueRadians = hue * math.pi / 180.0

	--achromatic response to color
	local ac = p2 * viewingConditions.nbb

	--CAM16 lightness and brightness
	local J = 100.0 * math.pow(ac / viewingConditions.aw, viewingConditions.c * viewingConditions.z)
	local Q = (4.0 / viewingConditions.c)
		* math.sqrt(J / 100.0)
		* (viewingConditions.aw + 4.0)
		* viewingConditions.fLRoot

	local huePrime = hue < 20.14 and hue + 360 or hue
	local eHue = 0.25 * (math.cos(huePrime * math.pi / 180.0 + 2.0) + 3.8)
	local p1 = 50000.0 / 13.0 * eHue * viewingConditions.nc * viewingConditions.ncb
	local t = p1 * math.sqrt(a * a + b * b) / (u + 0.305)
	local alpha = math.pow(t, 0.9) * math.pow(1.64 - math.pow(0.29, viewingConditions.n), 0.73)

	--CAM16 chroma, colorfulness, chroma
	local C = alpha * math.sqrt(J / 100.0)
	local M = C * viewingConditions.fLRoot
	local s = 50.0 * math.sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))

	--CAM16-UCS components
	local jstar = (1.0 + 100.0 * 0.007) * J / (1.0 + 0.007 * J)
	local mstar = math.log(1.0 + 0.0228 * M) / 0.0228
	local astar = mstar * math.cos(hueRadians)
	local bstar = mstar * math.sin(hueRadians)
	return Cam16.new(hue, C, J, Q, M, s, jstar, astar, bstar)
end

--- XYZ representation of CAM16 seen in [viewingConditions].
function Cam16:xyzInViewingConditions(viewingConditions: ViewingConditions): { number }
	local alpha
	if self.chroma == 0.0 or self.j == 0.0 then
		alpha = 0.0
	else
		alpha = self.chroma / math.sqrt(self.j / 100.0)
	end

	local t = math.pow(alpha / math.pow(1.64 - math.pow(0.29, viewingConditions.n), 0.73), 1.0 / 0.9)
	local hRad = self.hue * math.pi / 180.0

	local eHue = 0.25 * (math.cos(hRad + 2.0) + 3.8)
	local ac = viewingConditions.aw
		* math.pow(self.j / 100.0, 1.0 / (viewingConditions.c * viewingConditions.z))

	local p1 = eHue * (50000.0 / 13.0) * viewingConditions.nc * viewingConditions.ncb

	local p2 = (ac / viewingConditions.nbb)

	local hSin = math.sin(hRad)
	local hCos = math.cos(hRad)

	local gamma = 23.0 * (p2 + 0.305) * t / (23.0 * p1 + 11 * t * hCos + 108.0 * t * hSin)
	local a = gamma * hCos
	local b = gamma * hSin
	local rA = (460.0 * p2 + 451.0 * a + 288.0 * b) / 1403.0
	local gA = (460.0 * p2 - 891.0 * a - 261.0 * b) / 1403.0
	local bA = (460.0 * p2 - 220.0 * a - 6300.0 * b) / 1403.0

	local rCBase = math.max(0, (27.13 * math.abs(rA)) / (400.0 - math.abs(rA)))
	local rC = math.sign(rA) * (100.0 / viewingConditions.fl) * math.pow(rCBase, 1.0 / 0.42)
	local gCBase = math.max(0, (27.13 * math.abs(gA)) / (400.0 - math.abs(gA)))
	local gC = math.sign(gA) * (100.0 / viewingConditions.fl) * math.pow(gCBase, 1.0 / 0.42)
	local bCBase = math.max(0, (27.13 * math.abs(bA)) / (400.0 - math.abs(bA)))
	local bC = math.sign(bA) * (100.0 / viewingConditions.fl) * math.pow(bCBase, 1.0 / 0.42)
	local rF = rC / viewingConditions.rgbD[0]
	local gF = gC / viewingConditions.rgbD[1]
	local bF = bC / viewingConditions.rgbD[2]

	local x = 1.86206786 * rF - 1.01125463 * gF + 0.14918677 * bF
	local y = 0.38752654 * rF + 0.62144744 * gF - 0.00897398 * bF
	local z = -0.01584150 * rF - 0.03412294 * gF + 1.04996444 * bF

	return {
		[0] = x,
		[1] = y,
		[2] = z,
	}
end

return Cam16
