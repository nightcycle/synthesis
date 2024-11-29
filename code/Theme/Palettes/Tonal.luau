--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/palettes/tonal_palette.ts
local HCT = require(script.Parent.Parent:WaitForChild("HCT"))

type HCT = HCT.HCT
export type TonalPalette = {
	__index: TonalPalette,
	cache: { [number]: number },
	hue: number,
	chroma: number,
	keyColor: HCT,
	fromInt: (argb: number) -> TonalPalette,
	fromHct: (hct: HCT) -> TonalPalette,
	fromHueAndChroma: (hue: number, chroma: number) -> TonalPalette,
	new: (hue: number, chroma: number, keyColor: HCT) -> TonalPalette,
	createKeyColor: (hue: number, chroma: number) -> HCT,
	getTone: (self: TonalPalette, tone: number) -> number,
	getHCT: (self: TonalPalette, tone: number) -> HCT,
}

local TonalPalette = {} :: TonalPalette
TonalPalette.__index = TonalPalette

function TonalPalette.fromInt(argb: number): TonalPalette
	local hct = HCT.fromInt(argb)
	return TonalPalette.fromHct(hct)
end

function TonalPalette.fromHct(hct: HCT): TonalPalette
	return TonalPalette.new(hct:getHue(), hct:getChroma(), hct)
end

function TonalPalette.fromHueAndChroma(hue: number, chroma: number): TonalPalette
	return TonalPalette.new(hue, chroma, TonalPalette.createKeyColor(hue, chroma))
end

function TonalPalette.new(hue: number, chroma: number, keyColor: HCT): TonalPalette
	local self: TonalPalette = setmetatable({}, TonalPalette) :: any
	self.hue = hue
	self.chroma = chroma
	self.keyColor = keyColor
	self.cache = {}
	return self
end

function TonalPalette.createKeyColor(hue: number, chroma: number): HCT
	local startTone = 50.0
	local smallestDeltaHct = HCT.from(hue, chroma, startTone)
	local smallestDelta = math.abs(smallestDeltaHct:getChroma() - chroma)
	-- Starting from T50, check T+/-delta to see if they match the requested
	-- chroma.
	--
	-- Starts from T50 because T50 has the most chroma available, on
	-- average. Thus it is most likely to have a direct answer and minimize
	-- iteration.
	for delta = 1.0, 50.0 - 1, 1.0 do
		-- Termination condition rounding instead of minimizing delta to avoid
		-- case where requested chroma is 16.51, and the closest chroma is 16.49.
		-- Error is minimized, but when rounded and displayed, requested chroma
		-- is 17, key color's chroma is 16.
		if math.round(chroma) == math.round(smallestDeltaHct:getChroma()) then
			return smallestDeltaHct
		end

		local hctAdd = HCT.from(hue, chroma, startTone + delta)
		local hctAddDelta = math.abs(hctAdd:getChroma() - chroma)
		if hctAddDelta < smallestDelta then
			smallestDelta = hctAddDelta
			smallestDeltaHct = hctAdd
		end

		local hctSubtract = HCT.from(hue, chroma, startTone - delta)
		local hctSubtractDelta = math.abs(hctSubtract:getChroma() - chroma)
		if hctSubtractDelta < smallestDelta then
			smallestDelta = hctSubtractDelta
			smallestDeltaHct = hctSubtract
		end
	end

	return smallestDeltaHct
end

function TonalPalette:getTone(tone: number): number
	local argb = self.cache[tone] -- self.cache.get(tone);

	if argb == nil then
		argb = HCT.from(self.hue, self.chroma, tone):toInt()
		self.cache[tone] = argb
	end

	return argb
end

function TonalPalette:getHCT(tone: number): HCT
	return HCT.fromInt(self:getTone(tone))
end

return TonalPalette
