--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/hct/viewing_conditions.ts
local MathUtil = require(script.Parent:WaitForChild("MathUtil"))
local ColorUtil = require(script.Parent:WaitForChild("ColorUtil"))

export type ViewingConditions = {
	__index: ViewingConditions,
	DEFAULT: ViewingConditions,
	n: number,
	aw: number,
	nbb: number,
	ncb: number,
	c: number,
	nc: number,
	rgbD: { number },
	fl: number,
	fLRoot: number,
	z: number,
	make: (
		whitePoint: { number }?,
		adaptingLuminance: number?,
		backgroundLstar: number?,
		surround: number?,
		discountingIlluminant: boolean?
	) -> ViewingConditions,
	new: (
		n: number,
		aw: number,
		nbb: number,
		ncb: number,
		c: number,
		nc: number,
		rgbD: { number },
		fl: number,
		fLRoot: number,
		z: number
	) -> ViewingConditions,
}

local ViewingConditions = {} :: ViewingConditions
ViewingConditions.__index = ViewingConditions

function ViewingConditions.make(
	whitePoint: { number }?,
	adaptingLuminance: number?,
	backgroundLstar: number?,
	surround: number?,
	discountingIlluminant: boolean?
): ViewingConditions
	whitePoint = whitePoint or ColorUtil.whitePointD65()
	assert(whitePoint)
	adaptingLuminance = adaptingLuminance or (200.0 / math.pi) * ColorUtil.yFromLstar(50.0) / 100.0
	assert(adaptingLuminance)
	backgroundLstar = backgroundLstar or 50.0
	assert(backgroundLstar)
	surround = surround or 2.0
	assert(surround)
	discountingIlluminant = if discountingIlluminant == nil then false else discountingIlluminant
	assert(discountingIlluminant ~= nil)

	local xyz = whitePoint
	local rW = xyz[0] * 0.401288 + xyz[1] * 0.650173 + xyz[2] * -0.051461
	local gW = xyz[0] * -0.250268 + xyz[1] * 1.204414 + xyz[2] * 0.045854
	local bW = xyz[0] * -0.002079 + xyz[1] * 0.048952 + xyz[2] * 0.953127
	local f = 0.8 + surround / 10.0

	local c = if f >= 0.9
		then MathUtil.lerp(0.59, 0.69, (f - 0.9) * 10.0)
		else MathUtil.lerp(0.525, 0.59, (f - 0.8) * 10.0)
	local d = if discountingIlluminant
		then 1.0
		else f * (1.0 - (1.0 / 3.6) * math.exp((-adaptingLuminance - 42.0) / 92.0))

	d = if d > 1.0 then 1.0 elseif d < 0.0 then 0.0 else d

	local nc = f
	local rgbD = {
		[0] = d * (100.0 / rW) + 1.0 - d,
		[1] = d * (100.0 / gW) + 1.0 - d,
		[2] = d * (100.0 / bW) + 1.0 - d,
	}
	local k = 1.0 / (5.0 * adaptingLuminance + 1.0)
	local k4 = k * k * k * k
	local k4F = 1.0 - k4

	local fl = k4 * adaptingLuminance + 0.1 * k4F * k4F * ((5.0 * adaptingLuminance) ^ (1 / 3))

	local n = ColorUtil.yFromLstar(backgroundLstar) / whitePoint[1]
	local z = 1.48 + math.sqrt(n)
	local nbb = 0.725 / math.pow(n, 0.2)
	local ncb = nbb
	local rgbAFactors = {
		[0] = math.pow((fl * rgbD[0] * rW) / 100.0, 0.42),
		[1] = math.pow((fl * rgbD[1] * gW) / 100.0, 0.42),
		[2] = math.pow((fl * rgbD[2] * bW) / 100.0, 0.42),
	}
	local rgbA = {
		[0] = (400.0 * rgbAFactors[0]) / (rgbAFactors[0] + 27.13),
		[1] = (400.0 * rgbAFactors[1]) / (rgbAFactors[1] + 27.13),
		[2] = (400.0 * rgbAFactors[2]) / (rgbAFactors[2] + 27.13),
	}
	local aw = (2.0 * rgbA[0] + rgbA[1] + 0.05 * rgbA[2]) * nbb
	return ViewingConditions.new(n, aw, nbb, ncb, c, nc, rgbD, fl, math.pow(fl, 0.25), z)
end

function ViewingConditions.new(
	n: number,
	aw: number,
	nbb: number,
	ncb: number,
	c: number,
	nc: number,
	rgbD: { number },
	fl: number,
	fLRoot: number,
	z: number
): ViewingConditions
	local self: ViewingConditions = setmetatable({}, ViewingConditions) :: any
	self.n = n
	self.aw = aw
	self.nbb = nbb
	self.ncb = ncb
	self.c = c
	self.nc = nc
	self.rgbD = rgbD
	self.fl = fl
	self.fLRoot = fLRoot
	self.z = z

	return self
end

ViewingConditions.DEFAULT = ViewingConditions.make()

return ViewingConditions
