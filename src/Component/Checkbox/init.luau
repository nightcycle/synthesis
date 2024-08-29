--!strict
-- Services
-- @Packages
local Maid = require("@wally/Maid")
local React = require("@wally/React")
local Icons = require("@wally/MaterialIcons")
-- Modules
local Types = require("@proj/Types")
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local Sounds = require("@proj/Sounds")
local Theme = require("@proj/Theme")
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
local Defaults = require("./Defaults")
local Transition = require("@proj/Transition")
local PopUp = require("@comp/PopUp")
-- Hooks
local useLerp = require("@hook/useLerp")
-- Types
type Maid = Maid.Maid
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type Style = Style.Style
type RenderData = Types.RenderData
type BaseCheckboxProperties = RobloxTypes.GuiObjectProperties & {
	Value: boolean,
	OnChange: (isSelected: boolean) -> (),
	IsEnabled: boolean?,
}

export type CheckboxProperties = BaseCheckboxProperties & {
	IsAnimated: boolean?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
	OutlineColor3: Color3?,
	FillColor3: Color3?,
	IconColor3: Color3?,
	DisabledColor3: Color3?,
	OnDisabledColor3: Color3?,
	Elevation: number?,
	SoundVolume: number?,
}

export type StyleCheckboxProperties = BaseCheckboxProperties & {
	Style: Style,
}
-- Constants
local BUTTON_SIZE_DP = 18
local TRANSITION_TYPE = Enums.TransitionType.Emphasized
local TRANSITION_DURATION = Enums.TransitionDuration.Short4
local CHECK_ICON = Icons.check
local DASH_ICON = Icons.remove
local LAYER_SIZE_DP = 40
local CHECKBOX_SIZE_DP = 18
local CHECKBOX_SHAPE_DP = 2
local UNSELECT_OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions
local e = React.createElement

-- Class
local Library = {}
Library.Full = function(props: CheckboxProperties): React.ReactNode
	-- unpack properties
	local value: boolean = props.Value
	local onChanged: (newValue: boolean) -> () = props.OnChange
	local elevation: number = props.Elevation :: number? or Defaults.Elevation
	local schemeType: Enums.SchemeType = props.SchemeType :: Enums.SchemeType?
		or Defaults.SchemeType
	local soundVolume: number? = props.SoundVolume or Defaults.SoundVolume
	local disabledColor3: Color3 = props.DisabledColor3 :: Color3?
		or Defaults.DisabledColor3
	local onDisabledColor3: Color3 = props.OnDisabledColor3 :: Color3?
		or Defaults.OnDisabledColor3
	local fillColor3: Color3 = props.FillColor3 :: Color3? or Defaults.FillColor3
	local iconColor3: Color3 = props.IconColor3 :: Color3? or Defaults.IconColor3
	local outlineColor3: Color3 = props.OutlineColor3 :: Color3? or Defaults.OutlineColor3

	local scale = (props.Scale :: number?) or Defaults.Scale
	local isAnimated = if props.IsAnimated ~= nil
		then props.IsAnimated
		else Defaults.IsAnimated
	local isEnabled = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled

	-- unpack state
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)
	local knobAbsoluteSize, setKnobAbsoluteSize = React.useState(Vector2.new(0, 0))
	local knobAbsolutePosition, setKnobAbsolutePosition =
		React.useState(Vector2.new(0, 0))

	-- processing
	local state: Enums.ButtonStateType
	if isEnabled then
		if isPressed then
			state = Enums.ButtonStateType.Pressed
		elseif isHovered then
			state = Enums.ButtonStateType.Hovered
		elseif isFocused then
			state = Enums.ButtonStateType.Focused
		else
			state = Enums.ButtonStateType.Enabled
		end
	else
		state = Enums.ButtonStateType.Disabled
	end

	local function playSound()
		if soundVolume <= 0 then
			return
		end
		local soundType = Enums.SoundType.navigation_forward_selection_minimal
		if value then
			soundType = Enums.SoundType.navigation_backward_selection_minimal
		end
		Sounds.play(soundType, soundVolume)
	end

	local isBubbleEnabled = (isHovered or isPressed or isFocused)
		and isEnabled
		and isAnimated

	local goalAlpha, setGoalAlpha = React.useState(if value then 1 else 0)
	if value and goalAlpha ~= 1 then
		setGoalAlpha(1)
	elseif not value and goalAlpha ~= 0 then
		setGoalAlpha(0)
	end

	local goalBubbleAlpha, setGoalBubbleAlpha = React.useState(0)
	if isBubbleEnabled and goalBubbleAlpha ~= 1 then
		setGoalBubbleAlpha(1)
	elseif not isBubbleEnabled and goalBubbleAlpha ~= 0 then
		setGoalBubbleAlpha(0)
	end
	local rawAlpha = useLerp(goalAlpha, goalAlpha, TRANSITION_DURATION, isAnimated)
	local rawBubbleAlpha = useLerp(0, goalBubbleAlpha, TRANSITION_DURATION, isAnimated)

	local alpha = Transition.Easing[TRANSITION_TYPE](rawAlpha)
	local bubbleAlpha = Transition.Easing[TRANSITION_TYPE](rawBubbleAlpha)

	local renderData: RenderData
	if state == Enums.ButtonStateType.Enabled then
		renderData = Types._RenderData.new(
			scale,
			Types._AppearanceData.new(
				Theme.getElevatedColor(outlineColor3, elevation, schemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(fillColor3, elevation, schemeType),
				1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(iconColor3, elevation, schemeType),
				0
			),
			nil,
			nil,
			nil,
			nil
		)
	elseif state == Enums.ButtonStateType.Hovered then
		renderData = Types._RenderData.new(
			scale,
			Types._AppearanceData.new(
				Theme.getElevatedColor(outlineColor3, elevation + 1, schemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(fillColor3, elevation + 1, schemeType),
				1 - 0.08
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(iconColor3, elevation + 1, schemeType),
				0
			),
			nil,
			nil,
			nil,
			nil
		)
	elseif state == Enums.ButtonStateType.Focused then
		renderData = Types._RenderData.new(
			scale,
			Types._AppearanceData.new(
				Theme.getElevatedColor(outlineColor3, elevation, schemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(fillColor3, elevation, schemeType),
				1 - 0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(iconColor3, elevation, schemeType),
				0
			),
			nil,
			nil,
			nil,
			nil
		)
	elseif state == Enums.ButtonStateType.Pressed then
		renderData = Types._RenderData.new(
			scale,
			Types._AppearanceData.new(
				Theme.getElevatedColor(outlineColor3, elevation - 1, schemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(fillColor3, elevation - 1, schemeType),
				1 - 0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(iconColor3, elevation - 1, schemeType),
				0
			),
			nil,
			nil,
			nil,
			nil
		)
	else -- disabled
		renderData = Types._RenderData.new(
			scale,
			Types._AppearanceData.new(
				Theme.getElevatedColor(disabledColor3, elevation, schemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(disabledColor3, elevation, schemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
				1 - 0.38
			),
			nil,
			nil,
			nil,
			nil
		)
	end

	local icon: ImageData?
	if value == nil then
		icon = DASH_ICON
	elseif value == true then
		icon = CHECK_ICON
	end

	local borderData = renderData.Border
	assert(borderData, "borderData should exist")

	local backgroundData = renderData.Background
	assert(backgroundData, "backgroundData should exist")

	local fillTransparency = 1 - (1 - borderData.Transparency) * alpha

	return e(
		"ImageButton",
		PropUtil.mergeGuiObject(
			{
				Size = UDim2.fromOffset(
					math.round(scale * LAYER_SIZE_DP),
					math.round(scale * LAYER_SIZE_DP)
				),
				Active = isEnabled,
				BackgroundTransparency = 1,
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
					print("activate")
					if props.IsEnabled then
						print("click")
						onChanged(not value)
						if not isAnimated then
							playSound()
						end
					end
				end,
				[React.Event.SelectionGained] = function()
					if props.IsEnabled then
						if not isFocused then
							setIsFocused(true)
						end
					end
				end,
				[React.Event.SelectionLost] = function()
					if props.IsEnabled then
						if isFocused then
							setIsFocused(false)
						end
					end
				end,
				[React.Change.AbsolutePosition] = function(inst: ImageButton)
					if knobAbsolutePosition ~= inst.AbsolutePosition then
						setKnobAbsolutePosition(inst.AbsolutePosition)
					end
				end :: any,
				[React.Change.AbsoluteSize] = function(inst: ImageButton)
					if knobAbsoluteSize ~= inst.AbsoluteSize then
						setKnobAbsoluteSize(inst.AbsoluteSize)
					end
				end :: any,
			} :: RobloxTypes.GuiObjectProperties,
			props
		),
		{
			UIListLayout = e(
				"UIListLayout",
				{
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					ItemLineAlignment = Enum.ItemLineAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				} :: RobloxTypes.UIListLayoutProperties
			),
			Bubble = if isAnimated
					and (math.round(bubbleAlpha) ~= bubbleAlpha or isBubbleEnabled)
				then e(PopUp, {
					DisplayAnchorPoint = Vector2.new(0.5, 0.5),
					TargetAbsolutePosition = knobAbsolutePosition
						+ knobAbsoluteSize * Vector2.new(0.5, 0.5),
					DisplayComponent = function(): React.ReactNode
						local bubbleSize =
							math.ceil(2 * scale * BUTTON_SIZE_DP * bubbleAlpha)
						return e(
							"Frame",
							{
								BackgroundTransparency = 1 - 0.2 * bubbleAlpha,
								BackgroundColor3 = fillColor3,
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(bubbleSize, bubbleSize),
							} :: RobloxTypes.FrameProperties,
							{
								e(
									"UICorner",
									{
										CornerRadius = UDim.new(0.5, 0),
									} :: RobloxTypes.UICornerProperties
								),
							}
						)
					end,
				})
				else nil,
			Box = e(
				"ImageLabel",
				{
					Size = (function(): UDim2
						local dpWidth = CHECKBOX_SIZE_DP - (UNSELECT_OUTLINE_WIDTH_DP * 2)
						return UDim2.fromOffset(
							math.round(scale * dpWidth),
							math.round(scale * dpWidth)
						)
					end)(),
					BackgroundTransparency = fillTransparency,
					ImageTransparency = fillTransparency,
					BackgroundColor3 = backgroundData.Color3,
					ImageColor3 = if renderData.Text
						then renderData.Text.Color3
						else Color3.new(1, 1, 1),
					Image = if icon then icon.Image else "",
					ImageRectOffset = if icon then icon.ImageRectOffset else Vector2.zero,
					ImageRectSize = if icon then icon.ImageRectSize else Vector2.zero,
				} :: RobloxTypes.ImageLabelProperties,
				{
					UICorner = e(
						"UICorner",
						{
							CornerRadius = UDim.new(
								0,
								math.round(scale * CHECKBOX_SHAPE_DP)
							),
						} :: RobloxTypes.UICornerProperties
					),
					UIStroke = e(
						"UIStroke",
						{
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = if value == false
								then borderData.Color3
								else backgroundData.Color3,
							LineJoinMode = Enum.LineJoinMode.Round,
							Thickness = math.round(scale * UNSELECT_OUTLINE_WIDTH_DP),
							Transparency = borderData.Transparency,
						} :: RobloxTypes.UIStrokeProperties
					),
				}
			),
		}
	)
end

Library.Primary = function(props: StyleCheckboxProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: CheckboxProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.SchemeType
	newProps.Scale = style.Scale
	newProps.OutlineColor3 = style:GetColor(Enums.ColorRoleType.OnSurfaceVariant)
	newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Primary)
	newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnPrimary)
	newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
	newProps.SoundVolume = style.Volume

	return e(Library.Full, newProps)
end

Library.Secondary = function(props: StyleCheckboxProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: CheckboxProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.SchemeType
	newProps.Scale = style.Scale
	newProps.OutlineColor3 = style:GetColor(Enums.ColorRoleType.OnSurfaceVariant)
	newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
	newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnSecondary)
	newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
	newProps.SoundVolume = style.Volume

	return e(Library.Full, newProps)
end

Library.Tertiary = function(props: StyleCheckboxProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: CheckboxProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.SchemeType
	newProps.Scale = style.Scale
	newProps.OutlineColor3 = style:GetColor(Enums.ColorRoleType.OnSurfaceVariant)
	newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
	newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnTertiary)
	newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
	newProps.SoundVolume = style.Volume

	return e(Library.Full, newProps)
end

Library.OnSurface = function(props: StyleCheckboxProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: CheckboxProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.SchemeType
	newProps.Scale = style.Scale
	newProps.OutlineColor3 = style:GetColor(Enums.ColorRoleType.Outline)
	newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.SurfaceContainerHigh)
	newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
	newProps.SoundVolume = style.Volume

	return e(Library.Full, newProps)
end

return Library
