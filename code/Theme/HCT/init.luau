--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/hct/hct.ts
local Solver = require(script:WaitForChild("Solver"))
local Cam16 = require(script:WaitForChild("Cam16"))
local ColorUtil = require(script.Parent:WaitForChild("ColorUtil"))
local ViewingConditions = require(script.Parent:WaitForChild("ViewingConditions"))

type ViewingConditions = ViewingConditions.ViewingConditions

export type HCT = {
	__index: HCT,
	argb: number,
	_internalHue: number,
	_internalChroma: number,
	_internalTone: number,
	from: (hue: number, chroma: number, tone: number) -> HCT,
	fromInt: (argb: number) -> HCT,
	fromColor3: (color3: Color3) -> HCT,
	new: (argb: number) -> HCT,
	setHue: (self: HCT, newHue: number) -> (),
	setChroma: (self: HCT, newChroma: number) -> (),
	setTone: (self: HCT, newTone: number) -> (),
	getHue: (self: HCT) -> number,
	getChroma: (self: HCT) -> number,
	getTone: (self: HCT) -> number,
	toInt: (self: HCT) -> number,
	toColor3: (self: HCT) -> Color3,
	_setInternalState: (self: HCT, argb: number) -> (),
	inViewingConditions: (self: HCT, vc: ViewingConditions) -> (),
}

local HCT = {} :: HCT
HCT.__index = HCT

function HCT:toInt(): number
	return self.argb
end

function HCT:getHue(): number
	return self._internalHue
end

function HCT:setHue(newHue: number): ()
	self:_setInternalState(Solver.solveToInt(newHue, self._internalChroma, self._internalTone))
end

function HCT:getChroma(): number
	return self._internalChroma
end

function HCT:setChroma(newChroma: number): ()
	self:_setInternalState(Solver.solveToInt(self._internalHue, newChroma, self._internalTone))
end

function HCT:getTone(): number
	return self._internalTone
end

function HCT:setTone(newTone: number): ()
	self:_setInternalState(Solver.solveToInt(self._internalHue, self._internalChroma, newTone))
end

function HCT:_setInternalState(argb: number)
	local cam = Cam16.fromInt(argb)
	self._internalHue = cam.hue
	self._internalChroma = cam.chroma
	self._internalTone = ColorUtil.lstarFromArgb(argb)
	self.argb = argb
end

function HCT:inViewingConditions(vc: ViewingConditions): HCT
	local cam = Cam16.fromInt(self:toInt())
	local viewedInVc = cam:xyzInViewingConditions(vc)
	local recastInVc = Cam16.fromXyzInViewingConditions(
		viewedInVc[0],
		viewedInVc[1],
		viewedInVc[2],
		ViewingConditions.make()
	)
	local recastHct = HCT.from(recastInVc.hue, recastInVc.chroma, ColorUtil.lstarFromY(viewedInVc[1]))
	return recastHct
end

function HCT.new(argb: number): HCT
	local cam = Cam16.fromInt(argb)
	local self: HCT = setmetatable({}, HCT) :: any
	self._internalHue = cam.hue
	self._internalChroma = cam.chroma
	self._internalTone = ColorUtil.lstarFromArgb(argb)
	self.argb = argb
	return self
end

function HCT.from(hue: number, chroma: number, tone: number): HCT
	return HCT.new(Solver.solveToInt(hue, chroma, tone))
end

function HCT.fromInt(argb: number): HCT
	return HCT.new(argb)
end

function HCT.fromColor3(color3: Color3): HCT
	local function rgbToXyz(r: number, g: number, b: number): (number, number, number)
		-- Assuming sRGB color space and using a common conversion formula
		r = (r > 0.04045) and ((r + 0.055) / 1.055) ^ 2.4 or r / 12.92
		g = (g > 0.04045) and ((g + 0.055) / 1.055) ^ 2.4 or g / 12.92
		b = (b > 0.04045) and ((b + 0.055) / 1.055) ^ 2.4 or b / 12.92

		-- Convert to XYZ using the RGB to XYZ matrix for sRGB
		local x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
		local y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
		local z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041

		return x, y, z
	end

	local function xyzToLab(x: number, y: number, z: number): (number, number, number)
		-- Observer = 2°, Illuminant = D65
		local refX, refY, refZ = 0.95047, 1.00000, 1.08883
		x = x / refX
		y = y / refY
		z = z / refZ

		x = (x > 0.008856) and x ^ (1 / 3) or (7.787 * x) + (16 / 116)
		y = (y > 0.008856) and y ^ (1 / 3) or (7.787 * y) + (16 / 116)
		z = (z > 0.008856) and z ^ (1 / 3) or (7.787 * z) + (16 / 116)

		local l = (116 * y) - 16
		local a = 500 * (x - y)
		local b = 200 * (y - z)

		return l, a, b
	end

	local function labToHct(l: number, a: number, b: number): (number, number, number)
		-- Convert LAB to HCT (Hue, Chroma, Tone)
		local hue = math.deg(math.atan2(b, a))
		if hue < 0 then
			hue = hue + 360
		end

		local chroma = math.sqrt(a ^ 2 + b ^ 2)
		local tone = l -- In LAB, L* represents lightness which is analogous to tone

		return hue, chroma, tone
	end

	return HCT.from(labToHct(xyzToLab(rgbToXyz(color3.R, color3.G, color3.B))))
end

function HCT:toColor3(): Color3
	local function hctToLab(hue: number, chroma: number, tone: number): (number, number, number)
		-- Convert HCT back to LAB
		local a = chroma * math.cos(math.rad(hue))
		local b = chroma * math.sin(math.rad(hue))
		local l = tone -- In LAB, L* represents lightness which is analogous to tone
		return l, a, b
	end

	local function labToXyz(l: number, a: number, b: number): (number, number, number)
		local y = (l + 16) / 116
		local x = a / 500 + y
		local z = y - b / 200

		-- Observer= 2°, Illuminant= D65
		local refX, refY, refZ = 0.95047, 1.00000, 1.08883
		x = (x ^ 3 > 0.008856) and x ^ 3 or (x - 16 / 116) / 7.787
		y = (y ^ 3 > 0.008856) and y ^ 3 or (y - 16 / 116) / 7.787
		z = (z ^ 3 > 0.008856) and z ^ 3 or (z - 16 / 116) / 7.787

		x = refX * x
		y = refY * y
		z = refZ * z

		return x, y, z
	end

	local function xyzToRgb(x: number, y: number, z: number): (number, number, number)
		-- Convert XYZ to RGB
		local r = x * 3.2406 + y * -1.5372 + z * -0.4986
		local g = x * -0.9689 + y * 1.8758 + z * 0.0415
		local b = x * 0.0557 + y * -0.2040 + z * 1.0570

		r = (r > 0.0031308) and 1.055 * (r ^ (1 / 2.4)) - 0.055 or 12.92 * r
		g = (g > 0.0031308) and 1.055 * (g ^ (1 / 2.4)) - 0.055 or 12.92 * g
		b = (b > 0.0031308) and 1.055 * (b ^ (1 / 2.4)) - 0.055 or 12.92 * b

		-- Clamp the values to the 0-1 range
		r = math.max(0, math.min(1, r))
		g = math.max(0, math.min(1, g))
		b = math.max(0, math.min(1, b))

		return r, g, b
	end
	return Color3.new(xyzToRgb(labToXyz(hctToLab(self:getHue(), self:getChroma(), self:getTone()))))
end

return HCT
