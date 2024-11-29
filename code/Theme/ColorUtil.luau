--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/utils/color_utils.ts
local MathUtil = require("./MathUtil")

export type Rgba = {
	r: number,
	g: number,
	b: number,
	a: number,
}

local SRGB_TO_XYZ = {
	[0] = {
		[0] = 0.41233895,
		[1] = 0.35762064,
		[2] = 0.18051042,
	},
	[1] = {
		[0] = 0.2126,
		[1] = 0.7152,
		[2] = 0.0722,
	},
	[2] = {
		[0] = 0.01932141,
		[1] = 0.11916382,
		[2] = 0.95034478,
	},
}

local XYZ_TO_SRGB = {
	[0] = {
		[0] = 3.2413774792388685,
		[1] = -1.5376652402851851,
		[2] = -0.49885366846268053,
	},
	[1] = {
		[0] = -0.9691452513005321,
		[1] = 1.8758853451067872,
		[2] = 0.04156585616912061,
	},
	[2] = {
		[0] = 0.05562093689691305,
		[1] = -0.20395524564742123,
		[2] = 1.0571799111220335,
	},
}

local WHITE_POINT_D65 = {
	[0] = 95.047,
	[1] = 100.0,
	[2] = 108.883,
}

function clampComponent(value: number)
	if value < 0 then
		return 0
	end
	if value > 255 then
		return 255
	end
	return value
end

function labF(t: number): number
	local e = 216.0 / 24389.0
	local kappa = 24389.0 / 27.0
	if t > e then
		return math.pow(t, 1.0 / 3.0)
	else
		return (kappa * t + 16) / 116
	end
end

function labInvf(ft: number): number
	local e = 216.0 / 24389.0
	local kappa = 24389.0 / 27.0
	local ft3 = ft * ft * ft
	if ft3 > e then
		return ft3
	else
		return (116 * ft - 16) / kappa
	end
end

local Util = {}

function Util.argbFromLinrgb(linrgb: { number }): number
	local r = Util.delinearized(linrgb[0])
	local g = Util.delinearized(linrgb[1])
	local b = Util.delinearized(linrgb[2])
	return Util.argbFromRgb(r, g, b)
end

function Util.argbFromRgb(red: number, green: number, blue: number): number
	return bit32.lshift(255, 24)
		+ bit32.lshift(bit32.band(red, 255), 16)
		+ bit32.lshift(bit32.band(green, 255), 8)
		+ bit32.band(blue, 255)
end

function Util.alphaFromArgb(argb: number): number
	return bit32.band(bit32.rshift(argb, 24), 255)
end

function Util.redFromArgb(argb: number): number
	return bit32.band(bit32.rshift(argb, 16), 255)
end
function Util.greenFromArgb(argb: number): number
	return bit32.band(bit32.rshift(argb, 8), 255)
end

function Util.blueFromArgb(argb: number): number
	return bit32.band(argb, 255)
end

function Util.isOpaque(argb: number): boolean
	return Util.alphaFromArgb(argb) >= 255
end

function Util.argbFromXyz(x: number, y: number, z: number): number
	local matrix = XYZ_TO_SRGB
	local linearR = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2] * z
	local linearG = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2] * z
	local linearB = matrix[2][0] * x + matrix[2][1] * y + matrix[2][2] * z
	local r = Util.delinearized(linearR)
	local g = Util.delinearized(linearG)
	local b = Util.delinearized(linearB)
	return Util.argbFromRgb(r, g, b)
end

function Util.xyzFromArgb(argb: number): { number }
	local r = Util.linearized(Util.redFromArgb(argb))
	local g = Util.linearized(Util.greenFromArgb(argb))
	local b = Util.linearized(Util.blueFromArgb(argb))
	return MathUtil.matrixMultiply({
		[0] = r,
		[1] = g,
		[2] = b,
	}, SRGB_TO_XYZ)
end

function Util.argbFromLab(l: number, a: number, b: number): number
	local whitePoint = WHITE_POINT_D65
	local fy = (l + 16.0) / 116.0
	local fx = a / 500.0 + fy
	local fz = fy - b / 200.0
	local xNormalized = labInvf(fx)
	local yNormalized = labInvf(fy)
	local zNormalized = labInvf(fz)
	local x = xNormalized * whitePoint[0]
	local y = yNormalized * whitePoint[1]
	local z = zNormalized * whitePoint[2]
	return Util.argbFromXyz(x, y, z)
end

function Util.labFromArgb(argb: number): { number }
	local linearR = Util.linearized(Util.redFromArgb(argb))
	local linearG = Util.linearized(Util.greenFromArgb(argb))
	local linearB = Util.linearized(Util.blueFromArgb(argb))
	local matrix = SRGB_TO_XYZ
	local x = matrix[0][0] * linearR + matrix[0][1] * linearG + matrix[0][2] * linearB
	local y = matrix[1][0] * linearR + matrix[1][1] * linearG + matrix[1][2] * linearB
	local z = matrix[2][0] * linearR + matrix[2][1] * linearG + matrix[2][2] * linearB
	local whitePoint = WHITE_POINT_D65
	local xNormalized = x / whitePoint[0]
	local yNormalized = y / whitePoint[1]
	local zNormalized = z / whitePoint[2]
	local fx = labF(xNormalized)
	local fy = labF(yNormalized)
	local fz = labF(zNormalized)
	local l = 116.0 * fy - 16
	local a = 500.0 * (fx - fy)
	local b = 200.0 * (fy - fz)
	return {
		[0] = l,
		[1] = a,
		[2] = b,
	}
end

function Util.argbFromLstar(lstar: number): number
	local y = Util.yFromLstar(lstar)
	local component = Util.delinearized(y)
	return Util.argbFromRgb(component, component, component)
end

function Util.lstarFromArgb(argb: number): number
	local y = Util.xyzFromArgb(argb)[1]
	return 116.0 * labF(y / 100.0) - 16.0
end

function Util.yFromLstar(lstar: number): number
	return 100.0 * labInvf((lstar + 16.0) / 116.0)
end

function Util.lstarFromY(y: number): number
	return labF(y / 100.0) * 116.0 - 16.0
end

function Util.linearized(rgbComponent: number): number
	local normalized = rgbComponent / 255.0
	if normalized <= 0.040449936 then
		return normalized / 12.92 * 100.0
	else
		return math.pow((normalized + 0.055) / 1.055, 2.4) * 100.0
	end
end

function Util.delinearized(rgbComponent: number): number
	local normalized = rgbComponent / 100.0
	local delinearized = 0.0
	if normalized <= 0.0031308 then
		delinearized = normalized * 12.92
	else
		delinearized = 1.055 * math.pow(normalized, 1.0 / 2.4) - 0.055
	end
	return MathUtil.clampInt(0, 255, math.round(delinearized * 255.0))
end

function Util.whitePointD65(): { number }
	return WHITE_POINT_D65
end

function Util.rgbaFromArgb(argb: number): Rgba
	local r = Util.redFromArgb(argb)
	local g = Util.greenFromArgb(argb)
	local b = Util.blueFromArgb(argb)
	local a = Util.alphaFromArgb(argb)
	return {
		r = r,
		g = g,
		b = b,
		a = a,
	}
end

function Util.argbFromRgba(rgba)
	local rValue = clampComponent(rgba.r)
	local gValue = clampComponent(rgba.g)
	local bValue = clampComponent(rgba.b)
	local aValue = clampComponent(rgba.a)
	return bit32.lshift(aValue, 24) + bit32.lshift(rValue, 16) + bit32.lshift(gValue, 8) + bValue
end

return Util
