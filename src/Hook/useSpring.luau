--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
local Spring = require("@wally/Spring")
-- Modules
-- Types
-- Constants
local SUCCESS_RANGE = 0.005
-- Variables
-- References
-- Private Functions
-- Class
return function(
	initial: number,
	goal: number,
	damp: number,
	freq: number,
	isAnimated: boolean?
): number
	local value, setValue = React.useState(initial)
	local velocity, setVelocity = React.useState(0)
	isAnimated = if isAnimated ~= nil then isAnimated else true

	React.useEffect(function(): () -> ()
		if isAnimated then
			if value ~= goal then
				local connection: RBXScriptConnection

				local spring = Spring.new(damp, freq, value)
				spring.Velocity = velocity
				spring:Set(goal)

				connection = RunService.RenderStepped:Connect(function(dt: number)
					spring:Step(dt)
					setVelocity(spring.Velocity)

					local currentValue = spring:Get()

					if math.abs(spring.Velocity) <= SUCCESS_RANGE then
						currentValue = goal
						setVelocity(0)
						connection:Disconnect()
					end

					if currentValue ~= value then
						setValue(currentValue)
					end
				end)

				return function()
					connection:Disconnect()
				end
			else
				return function() end
			end
		else
			if value ~= goal then
				setValue(goal)
			end
			return function() end
		end
	end, { goal, isAnimated :: any })

	return value
end
