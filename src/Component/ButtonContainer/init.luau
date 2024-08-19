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
local Enums = require("@proj/Enums")
local Sounds = require("@proj/Sounds")
local Types = require("@proj/Types")
-- Types
export type ButtonContainerContentProperties = {
	Color3: Color3,
	Transparency: number,
}
export type ButtonContainerProperties = RobloxTypes.GuiButtonProperties & {
	Type: Enums.ButtonRenderType,
	Content: (ButtonContainerContentProperties) -> React.ReactElement<any, any>,
	LineColor3: Color3,
	TargetPaddingDp: number?,
	Scale: number?,
	Elevation: number?,
	SchemeType: Enums.SchemeType?,
	FillColor3: Color3?,
	RippleColor3: Color3?,
	DisabledFillColor3: Color3?,
	DisabledLineColor3: Color3?,
	IsAnimated: boolean?,
	IsEnabled: boolean?,
	ClickVolume: number?,
	RippleDuration: number?,
}
-- Constants
local SOUND_TYPE = Enums.SoundType.ui_tap_variant_01
local RIP_STEP = 0.005
local MOVE_WEIGHT = 0.7 -- the percent of the duration spent on the moving part
local MOVE_BUFFER = 0.2
-- Variables
-- References
-- Private Functions

-- Class

return function(
	props: ButtonContainerProperties
): React.ReactElement<RobloxTypes.GuiButtonProperties, "ImageButton">
	-- unpack props
	local buttonType: Enums.ButtonRenderType = props.Type
	local rawFillColor3: Color3? = props.FillColor3
	local rawLineColor3: Color3 = props.LineColor3
	local disabledFillColor3: Color3? = props.DisabledFillColor3
	local disabledLineColor3: Color3? = props.DisabledLineColor3
	local isAnimated: boolean = if props.IsAnimated ~= nil then props.IsAnimated else true
	local clickVolume: number = if props.ClickVolume ~= nil
		then props.ClickVolume
		else 0.5
	local isEnabled: boolean = if props.IsEnabled ~= nil then props.IsEnabled else true
	local scale = if props.Scale ~= nil then props.Scale else 1
	local schemeType = if props.SchemeType ~= nil
		then props.SchemeType
		else Enums.SchemeType.Light
	local elevation = if props.Elevation ~= nil then props.Elevation else 0
	local rippleDuration = props.RippleDuration or 0.5
	local targetPaddingDp = props.TargetPaddingDp or 0

	local currentRippleAlpha, setCurrentRippleAlpha = React.useState(0)
	local isRippleReset, setIsRippleReset = React.useState(false)
	local originRippleAlpha: number?, setOriginRippleAlpha =
		React.useState(nil :: number?)
	local rippleSequence: ColorSequence?

	-- unpack state
	local isHovered: boolean, setIsHovered = React.useState(false)
	local isPressed: boolean, setIsPressed = React.useState(false)
	local isFocused: boolean, setIsFocused = React.useState(false)

	-- process state / props
	local isRippleEnabled = isAnimated
		and buttonType == Enums.ButtonRenderType.Filled
		and rippleDuration > 0
	local renderData = Types._RenderData.solveButton(
		buttonType,
		Types._RenderData.getButtonState(isHovered, isPressed, isFocused, isEnabled),
		scale,
		schemeType,
		elevation,
		rawLineColor3,
		rawFillColor3,
		rawLineColor3,
		disabledFillColor3,
		disabledLineColor3,
		disabledLineColor3
	)

	local backgroundData = renderData.Background
	local borderData = renderData.Border

	local backgroundColor3: Color3? = if backgroundData
		then backgroundData.Color3
		else nil
	local borderColor3: Color3? = if borderData then borderData.Color3 else nil
	local rippleColor3: Color3? = if backgroundColor3
		then props.RippleColor3 or Color3.new(1, 1, 1):Lerp(backgroundColor3, 0.8)
		else nil
	local textData = renderData.Text
	assert(textData)
	local textColor3 = textData.Color3
	local textTransparency = textData.Transparency
	assert(textTransparency)
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

	if
		originRippleAlpha ~= nil
		and rippleColor3
		and isRippleEnabled
		and backgroundColor3
	then
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

	local buttonBackgroundColor3 = if isRippleEnabled
			and originRippleAlpha ~= nil
		then Color3.new(1, 1, 1)
		else backgroundColor3
	local buttonBackgroundTransparency = if backgroundData
		then backgroundData.Transparency
		else 1

	local targetPadPx = math.ceil(targetPaddingDp * scale)

	local buttonContents = {
		UIGradient = if isRippleEnabled and backgroundData
			then React.createElement(
				"UIGradient",
				{
					Color = rippleSequence,
					Transparency = NumberSequence.new(backgroundData.Transparency),
				} :: RobloxTypes.UIGradientProperties
			)
			else nil,
		Content = props.Content({
			Color3 = textColor3,
			Transparency = textTransparency,
		}),

		Border = if borderData
			then React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = borderColor3,
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = math.ceil(scale * 2),
				Transparency = borderData.Transparency,
			})
			else nil,
	}

	local propCopy: RobloxTypes.GuiButtonProperties =
		table.clone(props) :: RobloxTypes.GuiButtonProperties
	do
		for k, v in pairs(propCopy.children or {}) do
			buttonContents[k] = v
		end
		propCopy.children = nil
	end
	return React.createElement(
		"ImageButton",
		PropUtil.mergeGuiButton(
			{
				AutoButtonColor = false,
				Active = isEnabled,
				BackgroundColor3 = if targetPaddingDp == 0
					then buttonBackgroundColor3
					else nil,
				BackgroundTransparency = if targetPaddingDp == 0
					then buttonBackgroundTransparency
					else 1,
				[React.Event.InputBegan] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if not isHovered then
							setIsHovered(true)
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not isPressed then
							setIsPressed(true)
						end
					end
				end :: any,
				[React.Event.InputEnded] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if isHovered then
							setIsHovered(false)
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if isPressed then
							setIsPressed(false)
						end
					end
				end,
				[React.Event.Activated] = function()
					if isEnabled then
						if clickVolume >= 0 then
							Sounds.play(SOUND_TYPE, clickVolume)
						end
					end
				end,
				[React.Event.SelectionGained] = function()
					if isEnabled then
						if not isFocused then
							setIsFocused(true)
						end
					end
				end,
				[React.Event.SelectionLost] = function()
					if isEnabled then
						if isFocused then
							setIsFocused(false)
						end
					end
				end,

				[React.Event.MouseButton1Up] = if isRippleEnabled
					then function(button: GuiButton, x: number, y: number)
						if not isEnabled then
							return
						end
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
					TargetPadding = if targetPaddingDp ~= 0
						then React.createElement(
							"UIPadding",
							{
								PaddingLeft = UDim.new(0, targetPadPx),
								PaddingRight = UDim.new(0, targetPadPx),
								PaddingTop = UDim.new(0, targetPadPx),
								PaddingBottom = UDim.new(0, targetPadPx),
							} :: RobloxTypes.UIPaddingProperties
						)
						else nil,
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 0),
							HorizontalFlex = Enum.UIFlexAlignment.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Center,
							VerticalFlex = Enum.UIFlexAlignment.Fill,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					ButtonContents = if targetPaddingDp == 0
						then React.createElement(React.Fragment, {}, buttonContents)
						else nil,
					InnerButton = if targetPaddingDp ~= 0
						then React.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundColor3 = buttonBackgroundColor3,
								BackgroundTransparency = buttonBackgroundTransparency,
							} :: RobloxTypes.FrameProperties,
							buttonContents
						)
						else nil,
				},
			} :: RobloxTypes.ImageButtonProperties,
			propCopy
		)
	)
end
