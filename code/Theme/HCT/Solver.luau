--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/hct/hct_solver.ts
local ColorUtil = require("../ColorUtil")
local MathUtil = require("../MathUtil")
local Cam16 = require("./Cam16")
local ViewingConditions = require("../ViewingConditions")

-- material_color_utilities is designed to have a consistent API across
-- platforms and modular components that can be moved around easily. Using a
-- class as a namespace facilitates this.
--
-- tslint:disable:class-as-namespace

type Cam16 = Cam16.Cam16

local Solver = {}

Solver.SCALED_DISCOUNT_FROM_LINRGB = {
	[0] = {
		[0] = 0.001200833568784504,
		[1] = 0.002389694492170889,
		[2] = 0.0002795742885861124,
	},
	[1] = {
		[0] = 0.0005891086651375999,
		[1] = 0.0029785502573438758,
		[2] = 0.0003270666104008398,
	},
	[2] = {
		[0] = 0.00010146692491640572,
		[1] = 0.0005364214359186694,
		[2] = 0.0032979401770712076,
	},
}

Solver.LINRGB_FROM_SCALED_DISCOUNT = {
	[0] = {
		[0] = 1373.2198709594231,
		[1] = -1100.4251190754821,
		[2] = -7.278681089101213,
	},
	[1] = {
		[0] = -271.815969077903,
		[1] = 559.6580465940733,
		[2] = -32.46047482791194,
	},
	[2] = {
		[0] = 1.9622899599665666,
		[1] = -57.173814538844006,
		[2] = 308.7233197812385,
	},
}

Solver.Y_FROM_LINRGB = {
	[0] = 0.2126,
	[1] = 0.7152,
	[2] = 0.0722,
}

local CRITICAL_PLANES_OFFSET = {
	0.015176349177441876,
	0.045529047532325624,
	0.07588174588720938,
	0.10623444424209313,
	0.13658714259697685,
	0.16693984095186062,
	0.19729253930674434,
	0.2276452376616281,
	0.2579979360165119,
	0.28835063437139563,
	0.3188300904430532,
	0.350925934958123,
	0.3848314933096426,
	0.42057480301049466,
	0.458183274052838,
	0.4976837250274023,
	0.5391024159806381,
	0.5824650784040898,
	0.6277969426914107,
	0.6751227633498623,
	0.7244668422128921,
	0.775853049866786,
	0.829304845476233,
	0.8848452951698498,
	0.942497089126609,
	1.0022825574869039,
	1.0642236851973577,
	1.1283421258858297,
	1.1946592148522128,
	1.2631959812511864,
	1.3339731595349034,
	1.407011200216447,
	1.4823302800086415,
	1.5599503113873272,
	1.6398909516233677,
	1.7221716113234105,
	1.8068114625156377,
	1.8938294463134073,
	1.9832442801866852,
	2.075074464868551,
	2.1693382909216234,
	2.2660538449872063,
	2.36523901573795,
	2.4669114995532007,
	2.5710888059345764,
	2.6777882626779785,
	2.7870270208169257,
	2.898822059350997,
	3.0131901897720907,
	3.1301480604002863,
	3.2497121605402226,
	3.3718988244681087,
	3.4967242352587946,
	3.624204428461639,
	3.754355295633311,
	3.887192587735158,
	4.022731918402185,
	4.160988767090289,
	4.301978482107941,
	4.445716283538092,
	4.592217266055746,
	4.741496401646282,
	4.893568542229298,
	5.048448422192488,
	5.20615066083972,
	5.3666897647573375,
	5.5300801301023865,
	5.696336044816294,
	5.865471690767354,
	6.037501145825082,
	6.212438385869475,
	6.390297286737924,
	6.571091626112461,
	6.7548350853498045,
	6.941541251256611,
	7.131223617812143,
	7.323895587840543,
	7.5195704746346665,
	7.7182615035334345,
	7.919981813454504,
	8.124744458384042,
	8.332562408825165,
	8.543448553206703,
	8.757415699253682,
	8.974476575321063,
	9.194643831691977,
	9.417930041841839,
	9.644347703669503,
	9.873909240696694,
	10.106627003236781,
	10.342513269534024,
	10.58158024687427,
	10.8238400726681,
	11.069304815507364,
	11.317986476196008,
	11.569896988756009,
	11.825048221409341,
	12.083451977536606,
	12.345119996613247,
	12.610063955123938,
	12.878295467455942,
	13.149826086772048,
	13.42466730586372,
	13.702830557985108,
	13.984327217668513,
	14.269168601521828,
	14.55736596900856,
	14.848930523210871,
	15.143873411576273,
	15.44220572664832,
	15.743938506781891,
	16.04908273684337,
	16.35764934889634,
	16.66964922287304,
	16.985093187232053,
	17.30399201960269,
	17.62635644741625,
	17.95219714852476,
	18.281524751807332,
	18.614349837764564,
	18.95068293910138,
	19.290534541298456,
	19.633915083172692,
	19.98083495742689,
	20.331304511189067,
	20.685334046541502,
	21.042933821039977,
	21.404114048223256,
	21.76888489811322,
	22.137256497705877,
	22.50923893145328,
	22.884842241736916,
	23.264076429332462,
	23.6469514538663,
	24.033477234264016,
	24.42366364919083,
	24.817520537484558,
	25.21505769858089,
	25.61628489293138,
	26.021211842414342,
	26.429848230738664,
	26.842203703840827,
	27.258287870275353,
	27.678110301598522,
	28.10168053274597,
	28.529008062403893,
	28.96010235337422,
	29.39497283293396,
	29.83362889318845,
	30.276079891419332,
	30.722335150426627,
	31.172403958865512,
	31.62629557157785,
	32.08401920991837,
	32.54558406207592,
	33.010999283389665,
	33.4802739966603,
	33.953417292456834,
	34.430438229418264,
	34.911345834551085,
	35.39614910352207,
	35.88485700094671,
	36.37747846067349,
	36.87402238606382,
	37.37449765026789,
	37.87891309649659,
	38.38727753828926,
	38.89959975977785,
	39.41588851594697,
	39.93615253289054,
	40.460400508064545,
	40.98864111053629,
	41.520882981230194,
	42.05713473317016,
	42.597404951718396,
	43.141702194811224,
	43.6900349931913,
	44.24241185063697,
	44.798841244188324,
	45.35933162437017,
	45.92389141541209,
	46.49252901546552,
	47.065252796817916,
	47.64207110610409,
	48.22299226451468,
	48.808024568002054,
	49.3971762874833,
	49.9904556690408,
	50.587870934119984,
	51.189430279724725,
	51.79514187861014,
	52.40501387947288,
	53.0190544071392,
	53.637271562750364,
	54.259673423945976,
	54.88626804504493,
	55.517063457223934,
	56.15206766869424,
	56.79128866487574,
	57.43473440856916,
	58.08241284012621,
	58.734331877617365,
	59.39049941699807,
	60.05092333227251,
	60.715611475655585,
	61.38457167773311,
	62.057811747619894,
	62.7353394731159,
	63.417162620860914,
	64.10328893648692,
	64.79372614476921,
	65.48848194977529,
	66.18756403501224,
	66.89098006357258,
	67.59873767827808,
	68.31084450182222,
	69.02730813691093,
	69.74813616640164,
	70.47333615344107,
	71.20291564160104,
	71.93688215501312,
	72.67524319850172,
	73.41800625771542,
	74.16517879925733,
	74.9167682708136,
	75.67278210128072,
	76.43322770089146,
	77.1981124613393,
	77.96744375590167,
	78.74122893956174,
	79.51947534912904,
	80.30219030335869,
	81.08938110306934,
	81.88105503125999,
	82.67721935322541,
	83.4778813166706,
	84.28304815182372,
	85.09272707154808,
	85.90692527145302,
	86.72564993000343,
	87.54890820862819,
	88.3767072518277,
	89.2090541872801,
	90.04595612594655,
	90.88742016217518,
	91.73345337380438,
	92.58406282226491,
	93.43925555268066,
	94.29903859396902,
	95.16341895893969,
	96.03240364439274,
	96.9059996312159,
	97.78421388448044,
	98.6670533535366,
	99.55452497210776,
}
Solver.CRITICAL_PLANES = {} :: { [number]: number }
for i, v in ipairs(CRITICAL_PLANES_OFFSET) do
	Solver.CRITICAL_PLANES[i - 1] = v
end

function Solver._sanitizeRadians(angle: number): number
	return (angle + math.pi * 8) % (math.pi * 2)
end

function Solver._trueDelinearized(rgbComponent: number): number
	local normalized = rgbComponent / 100.0
	local delinearized = 0.0
	if normalized <= 0.0031308 then
		delinearized = normalized * 12.92
	else
		delinearized = 1.055 * math.pow(normalized, 1.0 / 2.4) - 0.055
	end
	return delinearized * 255.0
end

function Solver._chromaticAdaptation(component: number): number
	local af = math.pow(math.abs(component), 0.42)
	return math.sign(component) * 400.0 * af / (af + 27.13)
end

function Solver._hueOf(linrgb: { number }): number
	local scaledDiscount = MathUtil.matrixMultiply(linrgb, Solver.SCALED_DISCOUNT_FROM_LINRGB)
	local rA = Solver._chromaticAdaptation(scaledDiscount[0])
	local gA = Solver._chromaticAdaptation(scaledDiscount[1])
	local bA = Solver._chromaticAdaptation(scaledDiscount[2])
	-- redness-greenness
	local a = (11.0 * rA + -12.0 * gA + bA) / 11.0
	-- yellowness-blueness
	local b = (rA + gA - 2.0 * bA) / 9.0
	return math.atan2(b, a)
end

function Solver._areInCyclicOrder(a: number, b: number, c: number): boolean
	local deltaAB = Solver._sanitizeRadians(b - a)
	local deltaAC = Solver._sanitizeRadians(c - a)
	return deltaAB < deltaAC
end

function Solver._intercept(source: number, mid: number, target: number): number
	return (mid - source) / (target - source)
end

function Solver._lerpPoint(source: { number }, t: number, target: { number }): { number }
	return {
		[0] = source[0] + (target[0] - source[0]) * t,
		[1] = source[1] + (target[1] - source[1]) * t,
		[2] = source[2] + (target[2] - source[2]) * t,
	}
end

function Solver._setCoordinate(
	source: { number },
	coordinate: number,
	target: { number },
	axis: number
): { number }
	local t = Solver._intercept(source[axis], coordinate, target[axis])
	return Solver._lerpPoint(source, t, target)
end

function Solver._isBounded(x: number): boolean
	return 0.0 <= x and x <= 100.0
end

function Solver._nthVertex(y: number, n: number): { number }
	local kR = Solver.Y_FROM_LINRGB[0]
	local kG = Solver.Y_FROM_LINRGB[1]
	local kB = Solver.Y_FROM_LINRGB[2]
	local coordA = if n % 4 <= 1 then 0.0 else 100.0
	local coordB = if n % 2 == 0 then 0.0 else 100.0
	if n < 4 then
		local g = coordA
		local b = coordB
		local r = (y - g * kG - b * kB) / kR
		if Solver._isBounded(r) then
			return {
				[0] = r,
				[1] = g,
				[2] = b,
			}
		else
			return {
				[0] = -1.0,
				[1] = -1.0,
				[2] = -1.0,
			}
		end
	elseif n < 8 then
		local b = coordA
		local r = coordB
		local g = (y - r * kR - b * kB) / kG
		if Solver._isBounded(g) then
			return {
				[0] = r,
				[1] = g,
				[2] = b,
			}
		else
			return {
				[0] = -1.0,
				[1] = -1.0,
				[2] = -1.0,
			}
		end
	else
		local r = coordA
		local g = coordB
		local b = (y - r * kR - g * kG) / kB
		if Solver._isBounded(b) then
			return {
				[0] = r,
				[1] = g,
				[2] = b,
			}
		else
			return {
				[0] = -1.0,
				[1] = -1.0,
				[2] = -1.0,
			}
		end
	end
end

function Solver._bisectToSegment(y: number, targetHue: number): { { number } }
	local left = {
		[0] = -1.0,
		[1] = -1.0,
		[2] = -1.0,
	}
	local right = left
	local leftHue = 0.0
	local rightHue = 0.0
	local initialized = false
	local uncut = true
	for n = 0, 12 - 1, 1 do
		local mid = Solver._nthVertex(y, n)
		if mid[0] < 0 then
			continue
		end
		local midHue = Solver._hueOf(mid)
		if not initialized then
			left = mid
			right = mid
			leftHue = midHue
			rightHue = midHue
			initialized = true
			continue
		end
		if uncut or Solver._areInCyclicOrder(leftHue, midHue, rightHue) then
			uncut = false
			if Solver._areInCyclicOrder(leftHue, targetHue, midHue) then
				right = mid
				rightHue = midHue
			else
				left = mid
				leftHue = midHue
			end
		end
	end
	return {
		[0] = left,
		[1] = right,
	}
end

function Solver._midpoint(a: { number }, b: { number }): { number }
	return {
		[0] = (a[0] + b[0]) / 2,
		[1] = (a[1] + b[1]) / 2,
		[2] = (a[2] + b[2]) / 2,
	}
end

function Solver._criticalPlaneBelow(x: number): number
	return math.floor(x - 0.5)
end

function Solver._criticalPlaneAbove(x: number): number
	return math.ceil(x - 0.5)
end

function Solver._bisectToLimit(y: number, targetHue: number): { number }
	local segment = Solver._bisectToSegment(y, targetHue)
	local left = segment[0]
	local leftHue = Solver._hueOf(left)
	local right = segment[1]
	for axis = 0, 3 - 1, 1 do
		if left[axis] ~= right[axis] then
			local lPlane = -1
			local rPlane = 255
			if left[axis] < right[axis] then
				lPlane = Solver._criticalPlaneBelow(Solver._trueDelinearized(left[axis]))
				rPlane = Solver._criticalPlaneAbove(Solver._trueDelinearized(right[axis]))
			else
				lPlane = Solver._criticalPlaneAbove(Solver._trueDelinearized(left[axis]))
				rPlane = Solver._criticalPlaneBelow(Solver._trueDelinearized(right[axis]))
			end
			for i = 0, 8 - 1, 1 do
				if math.abs(rPlane - lPlane) <= 1 then
					break
				else
					local mPlane = math.floor((lPlane + rPlane) / 2.0)
					local midPlaneCoordinate = Solver.CRITICAL_PLANES[mPlane]
					local mid = Solver._setCoordinate(left, midPlaneCoordinate, right, axis)
					local midHue = Solver._hueOf(mid)
					if Solver._areInCyclicOrder(leftHue, targetHue, midHue) then
						right = mid
						rPlane = mPlane
					else
						left = mid
						leftHue = midHue
						lPlane = mPlane
					end
				end
			end
		end
	end
	return Solver._midpoint(left, right)
end

function Solver._inverseChromaticAdaptation(adapted: number): number
	local adaptedAbs = math.abs(adapted)
	local base = math.max(0, 27.13 * adaptedAbs / (400.0 - adaptedAbs))
	return math.sign(adapted) * math.pow(base, 1.0 / 0.42)
end

function Solver._findResultByJ(hueRadians: number, chroma: number, y: number): number
	-- Initial estimate of j.
	local j = math.sqrt(y) * 11.0
	-- ========================================
	-- Operations inlined from Cam16 to avoid repeated calculation
	-- ========================================
	local viewingConditions = ViewingConditions.DEFAULT
	local tInnerCoeff = 1 / math.pow(1.64 - math.pow(0.29, viewingConditions.n), 0.73)
	local eHue = 0.25 * (math.cos(hueRadians + 2.0) + 3.8)
	local p1 = eHue * (50000.0 / 13.0) * viewingConditions.nc * viewingConditions.ncb
	local hSin = math.sin(hueRadians)
	local hCos = math.cos(hueRadians)
	for iterationRound = 0, 5 - 1, 1 do
		-- ========================================
		-- Operations inlined from Cam16 to avoid repeated calculation
		-- ========================================
		local jNormalized = j / 100.0
		local alpha
		if chroma == 0.0 or j == 0.0 then
			alpha = 0.0
		else
			alpha = chroma / math.sqrt(jNormalized)
		end
		local t = math.pow(alpha * tInnerCoeff, 1.0 / 0.9)
		local ac = viewingConditions.aw
			* math.pow(jNormalized, 1.0 / viewingConditions.c / viewingConditions.z)
		local p2 = ac / viewingConditions.nbb
		local gamma = 23.0 * (p2 + 0.305) * t / (23.0 * p1 + 11 * t * hCos + 108.0 * t * hSin)
		local a = gamma * hCos
		local b = gamma * hSin
		local rA = (460.0 * p2 + 451.0 * a + 288.0 * b) / 1403.0
		local gA = (460.0 * p2 - 891.0 * a - 261.0 * b) / 1403.0
		local bA = (460.0 * p2 - 220.0 * a - 6300.0 * b) / 1403.0
		local rCScaled = Solver._inverseChromaticAdaptation(rA)
		local gCScaled = Solver._inverseChromaticAdaptation(gA)
		local bCScaled = Solver._inverseChromaticAdaptation(bA)

		local linrgb = MathUtil.matrixMultiply({
			[0] = rCScaled,
			[1] = gCScaled,
			[2] = bCScaled,
		}, Solver.LINRGB_FROM_SCALED_DISCOUNT)
		-- ========================================
		-- Operations inlined from Cam16 to avoid repeated calculation
		-- ========================================
		if linrgb[0] < 0 or linrgb[1] < 0 or linrgb[2] < 0 then
			return 0
		end
		local kR = Solver.Y_FROM_LINRGB[0]
		local kG = Solver.Y_FROM_LINRGB[1]
		local kB = Solver.Y_FROM_LINRGB[2]
		local fnj = kR * linrgb[0] + kG * linrgb[1] + kB * linrgb[2]
		if fnj <= 0 then
			return 0
		end
		if iterationRound == 4 or math.abs(fnj - y) < 0.002 then
			if linrgb[0] > 100.01 or linrgb[1] > 100.01 or linrgb[2] > 100.01 then
				return 0
			end
			return ColorUtil.argbFromLinrgb(linrgb)
		end
		j = j - (fnj - y) * j / (2 * fnj)
	end
	return 0
end

function Solver.solveToInt(hueDegrees: number, chroma: number, lstar: number): number
	if chroma < 0.0001 or lstar < 0.0001 or lstar > 99.9999 then
		return ColorUtil.argbFromLstar(lstar)
	end
	hueDegrees = MathUtil.sanitizeDegreesDouble(hueDegrees)
	local hueRadians = hueDegrees / 180 * math.pi
	local y = ColorUtil.yFromLstar(lstar)
	local exactAnswer = Solver._findResultByJ(hueRadians, chroma, y)
	if exactAnswer ~= 0 then
		return exactAnswer
	end
	local linrgb = Solver._bisectToLimit(y, hueRadians)
	return ColorUtil.argbFromLinrgb(linrgb)
end

function Solver.solveToCam(hueDegrees: number, chroma: number, lstar: number): Cam16
	return Cam16.fromInt(Solver.solveToInt(hueDegrees, chroma, lstar))
end

return Solver
