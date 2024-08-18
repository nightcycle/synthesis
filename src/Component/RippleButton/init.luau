--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
local CurveUtil = require("@wally/CurveUtil")
-- Modules
local PropUtil = require("@proj/PropUtil")
local RobloxTypes = require("@proj/RobloxTypes")
-- Types

export type RippleButtonProperties = RobloxTypes.GuiButtonProperties & {
	BackgroundColor3: Color3?,
	RippleColor3: Color3?,
	RippleDuration: number?,
	IsAnimated: boolean?,
}
-- Constants
local RIP_STEP = 0.005
local MOVE_WEIGHT = 0.7 -- the percent of the duration spent on the moving part
local MOVE_BUFFER = 0.2
-- Variables
-- References
-- Private Functions

-- Class

return function(
	props: RippleButtonProperties
): React.ReactElement<RobloxTypes.GuiButtonProperties, "ImageButton">
	local backgroundColor3: Color3 = props.BackgroundColor3 :: Color3
		or Color3.new(1, 1, 1)
	local rippleColor3: Color3 = props.RippleColor3
		or Color3.new(1, 1, 1):Lerp(backgroundColor3, 0.8)
	local rippleDuration = props.RippleDuration or 0.5
	local isAnimated = if props.IsAnimated ~= nil then props.IsAnimated else true
	local currentRippleAlpha, setCurrentRippleAlpha = React.useState(0)
	local isRippleReset, setIsRippleReset = React.useState(false)
	local originRippleAlpha: number?, setOriginRippleAlpha =
		React.useState(nil :: number?)
	local rippleSequence: ColorSequence?

	React.useEffect(function()
		if isAnimated and originRippleAlpha ~= nil then
			local connection: RBXScriptConnection
			connection = RunService.RenderStepped:Connect(function(dt: number)
				local nextRippleAlpha =
					math.clamp(currentRippleAlpha + dt / rippleDuration, 0, 1)
				if isRippleReset then
					setIsRippleReset(false)
					nextRippleAlpha = 0
				end
				if nextRippleAlpha == 1 then
					setOriginRippleAlpha(nil)
				else
					setCurrentRippleAlpha(nextRippleAlpha)
				end
			end)
			return function()
				connection:Disconnect()
			end
		else
			return function() end
		end
	end)
	if originRippleAlpha ~= nil then
		if
			math.round(currentRippleAlpha) ~= currentRippleAlpha
			or originRippleAlpha ~= currentRippleAlpha
		then
			local alpha = currentRippleAlpha -- reassigning in case I want to do easing later
			local moveAlpha = 1
				- CurveUtil.ease(
					1 - math.clamp(alpha / MOVE_WEIGHT, 0, 1),
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.In
				)
			local fadeAlpha = CurveUtil.ease(
				math.clamp(
					(alpha - (MOVE_WEIGHT * MOVE_BUFFER))
						/ (MOVE_WEIGHT * (1 + MOVE_BUFFER)),
					0,
					1
				),
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			)
			local leftOffset = math.clamp(
				originRippleAlpha - moveAlpha,
				RIP_STEP,
				math.max(originRippleAlpha - RIP_STEP, RIP_STEP * 1.5)
			)
			local rightOffset = math.clamp(
				originRippleAlpha + moveAlpha,
				math.min(originRippleAlpha + RIP_STEP, 1 - RIP_STEP * 1.5),
				1 - RIP_STEP
			)
			local currentRippleColor = rippleColor3:Lerp(backgroundColor3, fadeAlpha)
			rippleSequence = ColorSequence.new({
				ColorSequenceKeypoint.new(0, backgroundColor3),
				ColorSequenceKeypoint.new(leftOffset - RIP_STEP * 0.5, backgroundColor3),
				ColorSequenceKeypoint.new(leftOffset, currentRippleColor),
				ColorSequenceKeypoint.new(rightOffset, currentRippleColor),
				ColorSequenceKeypoint.new(rightOffset + RIP_STEP * 0.5, backgroundColor3),
				ColorSequenceKeypoint.new(1, backgroundColor3),
			})
		else
			rippleSequence = ColorSequence.new(backgroundColor3)
		end
	else
		rippleSequence = ColorSequence.new(Color3.new(1, 1, 1))
	end
	assert(rippleSequence)

	return React.createElement(
		"ImageButton",
		PropUtil.mergeGuiButton(
			{
				BackgroundColor3 = if not isAnimated or originRippleAlpha == nil
					then backgroundColor3
					else Color3.new(1, 1, 1),
				[React.Event.MouseButton1Up] = if isAnimated
					then function(button: GuiButton, x: number, y: number)
						setIsRippleReset(true)
						setOriginRippleAlpha(
							math.clamp(
								(x - button.AbsolutePosition.X) / button.AbsoluteSize.X,
								0,
								1
							)
						)
						setCurrentRippleAlpha(0)
					end :: any
					else nil,
				children = {
					UIGradient = if isAnimated
						then React.createElement(
							"UIGradient",
							{
								Color = rippleSequence,
							} :: RobloxTypes.UIGradientProperties
						)
						else nil,
				},
			} :: RobloxTypes.ImageButtonProperties,
			props
		)
	)
end
