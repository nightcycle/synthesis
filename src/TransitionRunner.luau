--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@node/@jsdotlua/react")
local CurveUtil = require("@wally/CurveUtil")

-- Modules
local Enums = require("@proj/Enums")
local Transition = require("@proj/Transition")
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
-- Types
export type TransitionRunner = {
	Set: (self: TransitionRunner, value: boolean, onComplete: (() -> ())?) -> (),
	Update: (self: TransitionRunner, value: boolean) -> (),
	Stop: (self: TransitionRunner) -> (),
	Get: (self: TransitionRunner) -> number,
	Disconnect: (self: TransitionRunner) -> (),
}

-- Class
return function(
	component: React.ComponentClass<unknown>,
	stateKey: string,
	initialAlpha: number,
	transitionType: Enums.TransitionType,
	transitionDuration: Enums.TransitionDuration
): TransitionRunner
	local goalAlpha = initialAlpha
	local currentAlpha = initialAlpha

	local duration = Transition.Duration[transitionDuration]
	local transitionSolver = Transition.Easing[transitionType]

	local isDisconnected = false
	local connection: RBXScriptConnection? = nil
	local function stop()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	local function play(onComplete: (() -> ())?)
		stop()
		connection = RunService.RenderStepped:Connect(function(dt: number)
			if isDisconnected then
				return
			end
			if currentAlpha == goalAlpha then
				if onComplete then
					onComplete()
				end
				return
			end
			currentAlpha += dt * math.sign(goalAlpha - currentAlpha) / duration
			currentAlpha = math.clamp(currentAlpha, 0, 1)
			component:setState({
				[stateKey] = currentAlpha,
			})
		end)
	end
	return {
		Set = function(self: TransitionRunner, value: boolean, onComplete: (() -> ())?)
			if isDisconnected then
				return
			end
			goalAlpha = if value then 1 else 0
			play(onComplete)
		end,
		Update = function(self: TransitionRunner, value: boolean)
			if isDisconnected then
				return
			end
			goalAlpha = if value then 1 else 0
		end,
		Stop = function(self: TransitionRunner)
			if isDisconnected then
				return
			end
			stop()
		end,
		Get = function(self: TransitionRunner): number
			if goalAlpha == 1 then
				return transitionSolver(currentAlpha)
			else
				return 1 - transitionSolver(1 - currentAlpha)
			end
		end,
		Disconnect = function(self: TransitionRunner)
			isDisconnected = true
			stop()
		end,
	}
end
