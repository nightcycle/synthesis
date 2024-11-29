--!strict

--- @class Switch
--- A true / false input component often used in menus. Read more [here](https://m3.material.io/components/switch/overview).

--- @prop Value boolean
--- @within Switch
--- The current value of the switch.

--- @prop OnChange (newValue: boolean) -> ()
--- @within Switch
--- A callback that fires when the switch is toggled.

--- @prop IsEnabled boolean
--- @within Switch
--- Whether the switch is enabled. Defaults to `true`.

--- @prop IsAnimated boolean
--- @within Switch
--- Whether the switch should animate when toggled. Defaults to `true`.

--- @prop IncludeIconOnSelected boolean
--- @within Switch
--- Whether to include an icon when the switch is selected. Defaults to `true`.

--- @prop IncludeIconOnDeselected boolean
--- @within Switch
--- Whether to include an icon when the switch is deselected. Defaults to `true`.

--- @prop BackgroundColor3 Color3
--- @within Switch
--- The color of the switch when it is deselected.

--- @prop OnBackgroundColor3 Color3
--- @within Switch
--- The color of the switch when it is selected.

--- @prop FillColor3 Color3
--- @within Switch
--- The color of the switch's fill.

--- @prop ButtonColor3 Color3
--- @within Switch
--- The color of the switch's button when it is deselected.

--- @prop OnButtonColor3 Color3
--- @within Switch
--- The color of the switch's button when it is selected.

--- @prop DisabledColor3 Color3
--- @within Switch
--- The color of the switch when it is disabled and deselected.

--- @prop OnDisabledColor3 Color3
--- @within Switch
--- The color of the switch when it is disabled and selected.

--- @prop Elevation number
--- @within Switch
--- The elevation of the switch. Defaults to `0`.

--- @prop SchemeType Enums.SchemeType
--- @within Switch
--- The scheme type of the switch. Defaults to `Enums.SchemeType.Light`.

--- @prop Scale number
--- @within Switch
--- The scale of the switch. Defaults to `1`.

-- Services
-- @Packages
local Maid = require("@wally/Maid")
local Icons = require("@wally/MaterialIcons")
local React = require("@wally/React")
-- Modules
local Types = require("@proj/Types")
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local Sounds = require("@proj/Sounds")
local Theme = require("@proj/Theme")
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
local Defaults = require("./Defaults")
local PopUp = require("@comp/PopUp")
local Transition = require("@proj/Transition")
-- Hooks
local useLerp = require("@hook/useLerp")
-- Types
type Maid = Maid.Maid
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type Style = Style.Style
type SwitchRenderData = {
	Text: AppearanceData,
	Button: AppearanceData,
	Background: AppearanceData,
	Outline: AppearanceData,
}
type BaseSwitchProperties = RobloxTypes.GuiObjectProperties & {
	Value: boolean,
	OnChange: (newValue: boolean) -> (),
	IsEnabled: boolean?,
	Elevation: number?,
	IncludeIconOnSelected: boolean?,
	IncludeIconOnDeselected: boolean?,
}

export type SwitchProperties = BaseSwitchProperties & {
	IsAnimated: boolean?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
	BackgroundColor3: Color3?,
	OnBackgroundColor3: Color3?,
	FillColor3: Color3?,
	ButtonColor3: Color3?,
	OnButtonColor3: Color3?,
	DisabledColor3: Color3?,
	OnDisabledColor3: Color3?,
	SoundVolume: number?,
}

export type StyleSwitchProperties = BaseSwitchProperties & {
	Style: Style,
}
-- Constants
local SWITCH_HEIGHT_DP = 32
local SWITCH_WIDTH_DP = 52
local KNOB_YES_ICON_SIZE_DP = 28
local KNOB_NO_ICON_SELECTED_SIZE_DP = 24
local KNOB_NO_ICON_UNSELECTED_SIZE_DP = 16
local ICON_SIZE_DP = 16
local OUTLINE_THICKNESS_DP = 2
local TRANSITION_TYPE = Enums.TransitionType.Emphasized
local TRANSITION_DURATION = Enums.TransitionDuration.Short4
-- Variables
-- References
-- Private Functions
local e = React.createElement
function newSwitchRenderData(
	text: AppearanceData,
	button: AppearanceData,
	background: AppearanceData,
	outline: AppearanceData
): SwitchRenderData
	return table.freeze({
		Text = text,
		Button = button,
		Background = background,
		Outline = outline,
	})
end

-- Class
local Library = {}
Library.Full = function(props: SwitchProperties): React.ReactNode
	-- unpack properties
	local value: boolean = props.Value
	local onChanged: (newValue: boolean) -> () = props.OnChange
	local soundVolume: number = props.SoundVolume or Defaults.SoundVolume
	local backgroundColor3: Color3 = props.BackgroundColor3 :: Color3?
		or Defaults.BackgroundColor3
	local onBackgroundColor3: Color3 = props.OnBackgroundColor3 :: Color3?
		or Defaults.OnBackgroundColor3
	local elevation: number = props.Elevation :: number? or Defaults.Elevation
	local schemeType: Enums.SchemeType = props.SchemeType :: Enums.SchemeType?
		or Defaults.SchemeType
	local buttonColor3: Color3 = props.ButtonColor3 :: Color3? or Defaults.ButtonColor3
	local onButtonColor3: Color3 = props.OnButtonColor3 :: Color3?
		or Defaults.OnButtonColor3
	local disabledColor3: Color3 = props.DisabledColor3 :: Color3?
		or Defaults.DisabledColor3
	local onDisabledColor3: Color3 = props.OnDisabledColor3 :: Color3?
		or Defaults.OnDisabledColor3
	local fillColor3: Color3 = props.FillColor3 :: Color3? or Defaults.FillColor3
	local scale = (props.Scale :: number?) or Defaults.Scale
	local isAnimated = if props.IsAnimated ~= nil
		then props.IsAnimated
		else Defaults.IsAnimated
	local isEnabled = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled
	local includeIconOnSelected = if props.IncludeIconOnSelected ~= nil
		then props.IncludeIconOnSelected
		else Defaults.IncludeIconOnSelected
	local includeIconOnDeselected = if props.IncludeIconOnDeselected ~= nil
		then props.IncludeIconOnDeselected
		else Defaults.IncludeIconOnDeselected

	-- unpack state
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)
	local knobAbsoluteSize, setKnobAbsoluteSize = React.useState(Vector2.new(0, 0))
	local knobAbsolutePosition, setKnobAbsolutePosition =
		React.useState(Vector2.new(0, 0))

	-- solve some internal stuff
	local icon: ImageData?
	if value == true and includeIconOnSelected then
		icon = Icons.check
	elseif value == false and includeIconOnDeselected then
		icon = Icons.close
	end

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

	local function getRenderData(focusValue: boolean): SwitchRenderData
		if focusValue then
			if state == Enums.ButtonStateType.Enabled then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(buttonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Disabled then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.12
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.12
					)
				)
			elseif state == Enums.ButtonStateType.Hovered then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(buttonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0.08
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Focused then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(buttonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0.1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Pressed then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(buttonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0.1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(fillColor3, elevation, schemeType),
						0
					)
				)
			else
				error(`invalid selected render data at {state}`)
			end
		else
			if state == Enums.ButtonStateType.Enabled then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Disabled then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.12
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1 - 0.38
					)
				)
			elseif state == Enums.ButtonStateType.Hovered then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						1 - 0.08
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Focused then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						1 - 0.1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					)
				)
			elseif state == Enums.ButtonStateType.Pressed then
				return newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(backgroundColor3, elevation, schemeType),
						1 - 0.1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						0
					)
				)
			else
				error(`invalid unselected render data at {state}`)
			end
		end
	end

	local selectedRenderData: SwitchRenderData = getRenderData(true)
	local unselectedRenderData: SwitchRenderData = getRenderData(false)

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

	local renderData: SwitchRenderData = if isAnimated
		then newSwitchRenderData(
			Types._AppearanceData.lerp(
				unselectedRenderData.Text,
				selectedRenderData.Text,
				alpha
			),
			Types._AppearanceData.lerp(
				unselectedRenderData.Button,
				selectedRenderData.Button,
				alpha
			),
			Types._AppearanceData.lerp(
				unselectedRenderData.Background,
				selectedRenderData.Background,
				alpha
			),
			Types._AppearanceData.lerp(
				unselectedRenderData.Outline,
				selectedRenderData.Outline,
				alpha
			)
		)
		elseif value then selectedRenderData
		else unselectedRenderData

	local buttonSize: number
	if icon then
		buttonSize = KNOB_YES_ICON_SIZE_DP
	else
		local start: number
		local goal: number
		local buttonAlpha: number
		if value then
			start = KNOB_NO_ICON_UNSELECTED_SIZE_DP
			goal = KNOB_NO_ICON_SELECTED_SIZE_DP
			buttonAlpha = alpha
		else
			start = KNOB_NO_ICON_SELECTED_SIZE_DP
			goal = KNOB_NO_ICON_UNSELECTED_SIZE_DP
			buttonAlpha = 1 - alpha
		end
		buttonSize = start + (goal - start) * buttonAlpha
	end

	local switchSize = UDim2.fromOffset(
		math.round(scale * SWITCH_WIDTH_DP - (OUTLINE_THICKNESS_DP * 2)),
		math.round(scale * SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2))
	)

	local outlineThickness = math.round(scale * OUTLINE_THICKNESS_DP)

	local useStroke = renderData.Background.Color3 ~= renderData.Outline.Color3
		or renderData.Background.Transparency ~= renderData.Outline.Transparency

	return e(
		"ImageButton",
		PropUtil.mergeImageButton(
			{
				Size = UDim2.fromOffset(
					switchSize.X.Offset + outlineThickness * 2,
					switchSize.Y.Offset + outlineThickness * 2
				),
				Active = isEnabled,
				AutoButtonColor = false,
				BackgroundColor3 = renderData.Background.Color3,
				BackgroundTransparency = if useStroke
					then 1
					else renderData.Background.Transparency,
			} :: RobloxTypes.ImageButtonProperties,
			props :: any
		) :: RobloxTypes.GuiObjectProperties,
		{
			UICorner = e(
				"UICorner",
				{
					CornerRadius = UDim.new(0, math.round(scale * SWITCH_HEIGHT_DP / 2)),
				} :: RobloxTypes.UICornerProperties
			),
			InnerSwitch = e("ImageButton", {
				Size = switchSize,
				Position = UDim2.fromOffset(outlineThickness, outlineThickness),
				BackgroundColor3 = renderData.Background.Color3,
				Active = isEnabled,
				BackgroundTransparency = if useStroke
					then renderData.Background.Transparency
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
				end,
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
					if props.IsEnabled then
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
			}, {
				UIStroke = e(
					"UIStroke",
					{
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = renderData.Outline.Color3,
						LineJoinMode = Enum.LineJoinMode.Round,
						Thickness = outlineThickness,
						Enabled = useStroke,
						Transparency = renderData.Outline.Transparency,
					} :: RobloxTypes.UIStrokeProperties
				),
				UICorner = e(
					"UICorner",
					{
						CornerRadius = UDim.new(
							0,
							math.round(
								scale * (SWITCH_HEIGHT_DP - OUTLINE_THICKNESS_DP * 2) / 2
							)
						),
					} :: RobloxTypes.UICornerProperties
				),
				UIPadding = (function(): React.ReactNode
					local widthPaddingState: UDim
					do
						local size = scale
							* (SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2) - buttonSize)
						if icon then
							size += math.max(
								0,
								math.round((switchSize.Y.Offset - buttonSize * scale))
							)
						end
						widthPaddingState = UDim.new(0, math.round(size / 2))
					end
					local heightPaddingState: UDim
					do
						local size = SWITCH_HEIGHT_DP
							- (OUTLINE_THICKNESS_DP * 2)
							- buttonSize
						heightPaddingState = UDim.new(0, math.round(scale * size / 2))
					end
					return e(
						"UIPadding",
						{
							PaddingTop = heightPaddingState,
							PaddingBottom = heightPaddingState,
							PaddingLeft = widthPaddingState,
							PaddingRight = widthPaddingState,
						} :: RobloxTypes.UIPaddingProperties
					)
				end)(),
				Knob = e(
					"Frame",
					{
						Size = UDim2.fromOffset(
							math.ceil(scale * buttonSize),
							math.ceil(scale * buttonSize)
						),
						Position = UDim2.fromScale(alpha, 0.5),
						AnchorPoint = Vector2.new(alpha, 0.5),
						BackgroundTransparency = renderData.Button.Transparency,
						BorderSizePixel = 0,
						BackgroundColor3 = renderData.Button.Color3,
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
					{
						Bubble = if isAnimated
								and (
									math.round(bubbleAlpha) ~= bubbleAlpha
									or isBubbleEnabled
								)
							then e(PopUp, {
								DisplayAnchorPoint = Vector2.new(0.5, 0.5),
								TargetAbsolutePosition = knobAbsolutePosition
									+ knobAbsoluteSize * Vector2.new(0.5, 0.5),
								DisplayComponent = function(): React.ReactNode
									local bubbleSize = math.ceil(
										1.35 * scale * SWITCH_HEIGHT_DP * bubbleAlpha
									)
									return e(
										"Frame",
										{
											BackgroundTransparency = 1
												- 0.2 * bubbleAlpha,
											BackgroundColor3 = fillColor3,
											BorderSizePixel = 0,
											Size = UDim2.fromOffset(
												bubbleSize,
												bubbleSize
											),
										} :: RobloxTypes.GuiObjectProperties,
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
						UICorner = e(
							"UICorner",
							{
								CornerRadius = UDim.new(
									0,
									math.round(scale * buttonSize / 2)
								),
							} :: RobloxTypes.UICornerProperties
						),
						Icon = e(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(
									math.round(scale * ICON_SIZE_DP),
									math.round(scale * ICON_SIZE_DP)
								),
								BackgroundTransparency = 1,
								ImageTransparency = renderData.Text.Transparency,
								Visible = icon ~= nil,
								ImageColor3 = renderData.Text.Color3,
								ImageContent = if icon
										and typeof(icon.Image) == "Content"
									then icon.Image
									else "",
								Image = if icon
										and typeof(icon.Image) == "string"
									then icon.Image
									else "",
								ImageRectOffset = if icon
									then icon.ImageRectOffset
									else Vector2.zero,
								ImageRectSize = if icon
									then icon.ImageRectSize
									else Vector2.zero,
							} :: RobloxTypes.ImageLabelProperties,
							{
								UICorner = e(
									"UICorner",
									{
										CornerRadius = UDim.new(0.5, 0),
									} :: RobloxTypes.UICornerProperties
								),
							}
						),
					}
				),
			}),
		}
	)
end

Library.Primary = function(props: StyleSwitchProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: SwitchProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.Theme.SchemeType
	newProps.Scale = style.Scale

	newProps.BackgroundColor3 = style.Theme.SurfaceContainerHighest
	newProps.OnBackgroundColor3 = style.Theme.Outline
	newProps.FillColor3 = style.Theme.Primary
	newProps.ButtonColor3 = style.Theme.PrimaryContainer
	newProps.OnButtonColor3 = style.Theme.OnPrimaryContainer
	newProps.DisabledColor3 = style.Theme.OnSurface
	newProps.OnDisabledColor3 = style.Theme.Surface
	newProps.SoundVolume = style.Volume
	return e(Library.Full, newProps)
end
Library.Secondary = function(props: StyleSwitchProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: SwitchProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.Theme.SchemeType
	newProps.Scale = style.Scale

	newProps.BackgroundColor3 = style.Theme.SurfaceContainerHighest
	newProps.OnBackgroundColor3 = style.Theme.Outline
	newProps.FillColor3 = style.Theme.Secondary
	newProps.ButtonColor3 = style.Theme.SecondaryContainer
	newProps.OnButtonColor3 = style.Theme.OnSecondaryContainer
	newProps.DisabledColor3 = style.Theme.OnSurface
	newProps.OnDisabledColor3 = style.Theme.Surface
	newProps.SoundVolume = style.Volume
	return e(Library.Full, newProps)
end
Library.Tertiary = function(props: StyleSwitchProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: SwitchProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.Theme.SchemeType
	newProps.Scale = style.Scale

	newProps.BackgroundColor3 = style.Theme.SurfaceContainerHighest
	newProps.OnBackgroundColor3 = style.Theme.Outline
	newProps.FillColor3 = style.Theme.Tertiary
	newProps.ButtonColor3 = style.Theme.TertiaryContainer
	newProps.OnButtonColor3 = style.Theme.OnTertiaryContainer
	newProps.DisabledColor3 = style.Theme.OnSurface
	newProps.OnDisabledColor3 = style.Theme.Surface
	newProps.SoundVolume = style.Volume
	return e(Library.Full, newProps)
end

Library.OnSurface = function(props: StyleSwitchProperties): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: SwitchProperties;
	(newProps :: any).Style = nil
	newProps.IsAnimated = style.IsAnimated
	newProps.SchemeType = style.Theme.SchemeType
	newProps.Scale = style.Scale

	newProps.BackgroundColor3 = style.Theme.OutlineVariant
	newProps.OnBackgroundColor3 = style.Theme.OnSurface
	newProps.FillColor3 = style.Theme.Outline

	newProps.ButtonColor3 = style.Theme.SurfaceContainerHigh
	newProps.OnButtonColor3 = style.Theme.OnSurface

	newProps.DisabledColor3 = style.Theme.OnSurface
	newProps.OnDisabledColor3 = style.Theme.Surface
	newProps.SoundVolume = style.Volume
	return e(Library.Full, newProps)
end

return Library
