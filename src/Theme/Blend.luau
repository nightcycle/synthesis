--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/blend/blend.ts
local Cam16 = require("./HCT/Cam16")
local HCT = require("./HCT")
local ColorUtil = require("./ColorUtil")
local MathUtil = require("./MathUtil")

type HCT = HCT.HCT

local Blend = {}

function Blend.harmonize(designColor: number, sourceColor: number): number
	local fromHct: HCT = HCT.fromInt(designColor)
	local toHct: HCT = HCT.fromInt(sourceColor)
	local differenceDegrees = MathUtil.differenceDegrees(fromHct:getHue(), toHct:getHue())
	local rotationDegrees = math.min(differenceDegrees * 0.5, 15.0)
	local outputHue = MathUtil.sanitizeDegreesDouble(
		fromHct:getHue() + rotationDegrees * MathUtil.rotationDirection(fromHct:getHue(), toHct:getHue())
	)
	return HCT.from(outputHue, fromHct:getChroma(), fromHct:getTone()):toInt()
end

function Blend.hctHue(from: number, to: number, amount: number): number
	local ucs = Blend.cam16Ucs(from, to, amount)
	local ucsCam = Cam16.fromInt(ucs)
	local fromCam = Cam16.fromInt(from)
	local blended = HCT.from(ucsCam.hue, fromCam.chroma, ColorUtil.lstarFromArgb(from))
	return blended:toInt()
end

function Blend.cam16Ucs(from: number, to: number, amount: number): number
	local fromCam = Cam16.fromInt(from)
	local toCam = Cam16.fromInt(to)
	local fromJ = fromCam.jstar
	local fromA = fromCam.astar
	local fromB = fromCam.bstar
	local toJ = toCam.jstar
	local toA = toCam.astar
	local toB = toCam.bstar
	local jstar = fromJ + (toJ - fromJ) * amount
	local astar = fromA + (toA - fromA) * amount
	local bstar = fromB + (toB - fromB) * amount
	return Cam16.fromUcs(jstar, astar, bstar):toInt()
end

return Blend
