--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
-- Modules
local Enums = require("@proj/Enums")
local Transition = require("@proj/Transition")
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(
	initialAlpha: number,
	goalAlpha: number,
	duration: number | Enums.TransitionDuration,
	isAnimated: boolean?
): number
	local alpha, setAlpha = React.useState(initialAlpha)
	isAnimated = if isAnimated ~= nil then isAnimated else true

	local durValue: number = if typeof(duration) == "number"
		then duration
		else Transition.Duration[duration]

	React.useEffect(function()
		if isAnimated then
			if alpha ~= goalAlpha then
				local connection: RBXScriptConnection
				local currentAlpha = alpha
				connection = RunService.RenderStepped:Connect(function(dt: number)
					if goalAlpha ~= currentAlpha then
						local direction = math.sign(goalAlpha - currentAlpha)
						local deltaAlpha = dt * direction / durValue
						currentAlpha = math.clamp(currentAlpha + deltaAlpha, 0, 1)
						setAlpha(currentAlpha)
					else
						connection:Disconnect()
					end
				end)
				return function()
					connection:Disconnect()
				end
			else
				return function() end
			end
		else
			if alpha ~= goalAlpha then
				setAlpha(goalAlpha)
			end
			return function() end
		end
	end, { goalAlpha, isAnimated :: any })

	return alpha
end
