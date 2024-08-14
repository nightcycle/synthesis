--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local CurveUtil = require(_Packages:WaitForChild("CurveUtil"))
local ReactSpring = require(_Packages:WaitForChild("ReactSpring"))
-- Modules
local Enums = require(_Package:WaitForChild("Enums"))

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
-- Types
-- Class
local Util = {}
Util.Spring = {
	[Enums.TransitionType.Emphasized] = function(): (ReactSpring.AnimationStyle, ReactSpring.ControllerApi) end,
}
Util.Easing = {
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

Util.Duration = {
	[Enums.TransitionDuration.Short1] = 50 / 1000,
	[Enums.TransitionDuration.Short2] = 100 / 1000,
	[Enums.TransitionDuration.Short3] = 150 / 1000,
	[Enums.TransitionDuration.Short4] = 200 / 1000,
	[Enums.TransitionDuration.Medium1] = 250 / 1000,
	[Enums.TransitionDuration.Medium2] = 300 / 1000,
	[Enums.TransitionDuration.Medium3] = 350 / 1000,
	[Enums.TransitionDuration.Medium4] = 400 / 1000,
	[Enums.TransitionDuration.Long1] = 450 / 1000,
	[Enums.TransitionDuration.Long2] = 500 / 1000,
	[Enums.TransitionDuration.Long3] = 550 / 1000,
	[Enums.TransitionDuration.Long4] = 600 / 1000,
	[Enums.TransitionDuration.ExtraLong1] = 700 / 1000,
	[Enums.TransitionDuration.ExtraLong2] = 800 / 1000,
	[Enums.TransitionDuration.ExtraLong3] = 900 / 1000,
	[Enums.TransitionDuration.ExtraLong4] = 1000 / 1000,
}

return Util
