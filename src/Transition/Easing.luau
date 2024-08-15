--!strict
--!native
-- Services
-- Packages
local CurveUtil = require("@wally/CurveUtil")
-- Modules
local Enums = require("@proj/Enums")
-- Types
-- Constants
local EMP_FLIP_POINT = 0.2
local EMP_WEIGHT = 0.45
local STD_FLIP_POINT = 0.2
local STD_WEIGHT = 0.2
-- Variables
-- References
-- Private Functions
-- Class
return {
	[Enums.TransitionType.Emphasized] = function(x: number): number
		if x < EMP_FLIP_POINT then
			return CurveUtil.ease(x / EMP_FLIP_POINT, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
				* EMP_WEIGHT
		else
			return EMP_WEIGHT
				+ (1 - EMP_WEIGHT)
					* CurveUtil.ease(
						(x - EMP_FLIP_POINT) / (1 - EMP_FLIP_POINT),
						Enum.EasingStyle.Exponential,
						Enum.EasingDirection.Out
					)
		end
	end,
	[Enums.TransitionType.EmphasizedDecelerate] = function(x: number): number
		return (CurveUtil.ease(x, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) ^ 0.5)
	end,
	[Enums.TransitionType.EmphasizedAccelerate] = function(x: number): number
		return (CurveUtil.ease(x, Enum.EasingStyle.Exponential, Enum.EasingDirection.In) ^ 1.25)
	end,
	[Enums.TransitionType.Standard] = function(x: number): number
		if x < STD_FLIP_POINT then
			return CurveUtil.ease(x / STD_FLIP_POINT, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
				* STD_WEIGHT
		else
			return STD_WEIGHT
				+ (1 - STD_WEIGHT)
					* CurveUtil.ease(
						(x - STD_FLIP_POINT) / (1 - STD_FLIP_POINT),
						Enum.EasingStyle.Cubic,
						Enum.EasingDirection.Out
					)
		end
	end,
	[Enums.TransitionType.StandardAccelerate] = function(x: number): number
		return (CurveUtil.ease(x, Enum.EasingStyle.Cubic, Enum.EasingDirection.In) ^ 1.25)
	end,
	[Enums.TransitionType.StandardDecelerate] = function(x: number): number
		return (CurveUtil.ease(x, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out) ^ 0.5)
	end,
}
