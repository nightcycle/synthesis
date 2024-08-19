--!strict

--- @class Switch
--- A true / false input component often used in menus. Read more [here](https://m3.material.io/components/switch/overview).

--- @prop Value boolean
--- @within Switch
--- The current value of the switch.

--- @prop OnChanged (newValue: boolean) -> ()
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
local Transition = require("@proj/Transition")
local PopUp = require("@comp/PopUp")
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
	OnChanged: (newValue: boolean) -> (),
	IsEnabled: boolean?,
	Elevation: number?,
	IncludeIconOnSelected: boolean?,
	IncludeIconOnDeselected: boolean?,
	ClickVolume: number?,
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
}

export type ThemeSwitchProperties = BaseSwitchProperties & {
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
local TRANSITION_DURATION = Enums.TransitionDuration.Long1
local ALPHA_RUNNER_KEY = "AlphaRunner"
local RIPPLE_ALPHA_RUNNER_KEY = "BubbleAlphaRunner"
-- Variables
-- References
-- Private Functions
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
function getAlphaRunner(
	self: React.ComponentClass<SwitchProperties>
): Transition.TransitionRunner
	return self[ALPHA_RUNNER_KEY]
end
function getBubbleAlphaRunner(
	self: React.ComponentClass<SwitchProperties>
): Transition.TransitionRunner
	return self[RIPPLE_ALPHA_RUNNER_KEY]
end
-- Class
local Component: React.ComponentClass<SwitchProperties> = React.Component:extend("Switch")

function Component:init(initialProps: SwitchProperties): ()
	self[ALPHA_RUNNER_KEY] = Transition.Runner(
		self,
		"Alpha",
		initialProps.Value and 1 or 0,
		TRANSITION_TYPE,
		TRANSITION_DURATION
	)
	self[RIPPLE_ALPHA_RUNNER_KEY] = Transition.Runner(
		self,
		"BubbleAlpha",
		0,
		TRANSITION_TYPE,
		Enums.TransitionDuration.Medium4
	)
	self:setState({
		IsHovered = false,
		IsPressed = false,
		IsFocused = false,
		TargetValue = initialProps.Value,
		BubbleAlpha = getBubbleAlphaRunner(self):Get(),
		Alpha = getAlphaRunner(self):Get(),
		KnobAbsolutePosition = Vector2.new(0, 0),
		KnobAbsoluteSize = Vector2.new(0, 0),
	})
	-- local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0, 0))
	-- local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))
end

function Component:render(): React.ReactElement<
	RobloxTypes.GuiObjectProperties,
	"ImageButton"
>
	-- unpack state
	local isHovered: boolean = self.state.IsHovered
	local isPressed: boolean = self.state.IsPressed
	local isFocused: boolean = self.state.IsFocused

	-- unpack properties
	local value: boolean = self.props.Value
	local onChanged: (newValue: boolean) -> () = self.props.OnChanged
	local clickVolume: number = self.props.ClickVolume or Defaults.ClickVolume
	local backgroundColor3: Color3 = self.props.BackgroundColor3 :: Color3?
		or Defaults.BackgroundColor3
	local onBackgroundColor3: Color3 = self.props.OnBackgroundColor3 :: Color3?
		or Defaults.OnBackgroundColor3
	local elevation: number = self.props.Elevation :: number? or Defaults.Elevation
	local schemeType: Enums.SchemeType = self.props.SchemeType :: Enums.SchemeType?
		or Defaults.SchemeType
	local buttonColor3: Color3 = self.props.ButtonColor3 :: Color3?
		or Defaults.ButtonColor3
	local onButtonColor3: Color3 = self.props.OnButtonColor3 :: Color3?
		or Defaults.OnButtonColor3
	local disabledColor3: Color3 = self.props.DisabledColor3 :: Color3?
		or Defaults.DisabledColor3
	local onDisabledColor3: Color3 = self.props.OnDisabledColor3 :: Color3?
		or Defaults.OnDisabledColor3
	local fillColor3: Color3 = self.props.FillColor3 :: Color3? or Defaults.FillColor3
	local scale = (self.props.Scale :: number?) or Defaults.Scale
	local isAnimated = if self.props.IsAnimated ~= nil
		then self.props.IsAnimated
		else Defaults.IsAnimated
	local isEnabled = if self.props.IsEnabled ~= nil
		then self.props.IsEnabled
		else Defaults.IsEnabled
	local includeIconOnSelected = if self.props.IncludeIconOnSelected ~= nil
		then self.props.IncludeIconOnSelected
		else Defaults.IncludeIconOnSelected
	local includeIconOnDeselected = if self.props.IncludeIconOnDeselected ~= nil
		then self.props.IncludeIconOnDeselected
		else Defaults.IncludeIconOnDeselected

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

	if not isAnimated then
		getAlphaRunner(self):Stop()
	else
		getAlphaRunner(self):Update(value)
	end
	local function playSound()
		if clickVolume <= 0 then
			return
		end
		local soundType = Enums.SoundType.navigation_forward_selection_minimal
		if value then
			soundType = Enums.SoundType.navigation_backward_selection_minimal
		end
		Sounds.play(soundType, clickVolume)
	end

	local isBubbleEnabled = (isHovered or isPressed or isFocused) and isEnabled

	if isAnimated then
		getAlphaRunner(self):Set(value, playSound)
		getBubbleAlphaRunner(self):Set(isBubbleEnabled)
	else
		isBubbleEnabled = false
	end

	local alpha = if isAnimated then getAlphaRunner(self):Get() elseif value then 1 else 0
	local bubbleAlpha = if isAnimated then getBubbleAlphaRunner(self):Get() else 0

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

	return React.createElement(
		"ImageButton",
		PropUtil.mergeImageButton(
			{
				Size = UDim2.fromOffset(
					switchSize.X.Offset + outlineThickness * 2,
					switchSize.Y.Offset + outlineThickness * 2
				),
				AutoButtonColor = false,
				BackgroundColor3 = renderData.Background.Color3,
				BackgroundTransparency = if useStroke
					then 1
					else renderData.Background.Transparency,
			} :: RobloxTypes.ImageButtonProperties,
			self.props :: any
		) :: RobloxTypes.GuiObjectProperties,
		{
			UICorner = React.createElement(
				"UICorner",
				{
					CornerRadius = UDim.new(0, math.round(scale * SWITCH_HEIGHT_DP / 2)),
				} :: RobloxTypes.UICornerProperties
			),
			InnerSwitch = React.createElement("ImageButton", {
				Size = switchSize,
				Position = UDim2.fromOffset(outlineThickness, outlineThickness),
				BackgroundColor3 = renderData.Background.Color3,
				BackgroundTransparency = if useStroke
					then renderData.Background.Transparency
					else 1,
				[React.Event.InputBegan] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if not isHovered then
							self:setState({
								IsHovered = true,
							})
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not isPressed then
							self:setState({
								IsPressed = true,
							})
						end
					end
				end,
				[React.Event.InputEnded] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if isHovered then
							self:setState({
								IsHovered = false,
							})
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if isPressed then
							self:setState({
								IsPressed = false,
							})
						end
					end
				end,
				[React.Event.Activated] = function()
					if self.props.IsEnabled then
						onChanged(not value)
						self:setState({
							TargetValue = not value,
						})
						if not isAnimated then
							playSound()
						end
					end
				end,
				[React.Event.SelectionGained] = function()
					if self.props.IsEnabled then
						if not isFocused then
							self:setState({
								IsFocused = true,
							})
						end
					end
				end,
				[React.Event.SelectionLost] = function()
					if self.props.IsEnabled then
						if isFocused then
							self:setState({
								IsFocused = false,
							})
						end
					end
				end,
			}, {
				UIStroke = React.createElement(
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
				UICorner = React.createElement(
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
				UIPadding = (function(): React.ReactElement<
					RobloxTypes.UIPaddingProperties,
					"UIPadding"
				>
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
					return React.createElement(
						"UIPadding",
						{
							PaddingTop = heightPaddingState,
							PaddingBottom = heightPaddingState,
							PaddingLeft = widthPaddingState,
							PaddingRight = widthPaddingState,
						} :: RobloxTypes.UIPaddingProperties
					)
				end)(),
				Knob = React.createElement(
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
							if
								self.state.KnobAbsolutePosition ~= inst.AbsolutePosition
							then
								self:setState({
									KnobAbsolutePosition = inst.AbsolutePosition,
								})
							end
						end :: any,
						[React.Change.AbsoluteSize] = function(inst: ImageButton)
							if self.state.KnobAbsoluteSize ~= inst.AbsoluteSize then
								self:setState({
									KnobAbsoluteSize = inst.AbsoluteSize,
								})
							end
						end :: any,
					} :: RobloxTypes.FrameProperties,
					{
						Bubble = if isAnimated
								and (
									math.round(bubbleAlpha) ~= bubbleAlpha
									or isBubbleEnabled
								)
							then React.createElement(PopUp, {
								DisplayAnchorPoint = Vector2.new(0.5, 0.5),
								TargetAbsolutePosition = self.state.KnobAbsolutePosition
									+ self.state.KnobAbsoluteSize
										* Vector2.new(0.5, 0.5),
								DisplayComponent = function(): React.ReactElement<
									RobloxTypes.FrameProperties,
									"Frame"
								>
									local bubbleSize = math.ceil(
										1.35 * scale * SWITCH_HEIGHT_DP * bubbleAlpha
									)
									return React.createElement(
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
										} :: RobloxTypes.FrameProperties,
										{
											React.createElement(
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
						UIListLayout = React.createElement(
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
						UICorner = React.createElement(
							"UICorner",
							{
								CornerRadius = UDim.new(
									0,
									math.round(scale * buttonSize / 2)
								),
							} :: RobloxTypes.UICornerProperties
						),
						Icon = React.createElement(
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
								Image = if icon then icon.Image else "",
								ImageRectOffset = if icon
									then icon.ImageRectOffset
									else Vector2.zero,
								ImageRectSize = if icon
									then icon.ImageRectSize
									else Vector2.zero,
							} :: RobloxTypes.ImageLabelProperties,
							{
								UICorner = React.createElement(
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

function Component:willUnmount()
	getAlphaRunner(self):Disconnect()
	getBubbleAlphaRunner(self):Disconnect()
end

return {
	Full = Component,
	OnSurfacePrimary = function(
		props: ThemeSwitchProperties
	): React.ReactElement<SwitchProperties, "OnSurfacePrimary">
		local style = props.Style

		local newProps = table.clone(props) :: SwitchProperties;
		(newProps :: any).Style = nil
		newProps.IsAnimated = style.IsAnimated
		newProps.SchemeType = style.SchemeType
		newProps.Scale = style.Scale

		newProps.BackgroundColor3 =
			style:GetColor(Enums.ColorRoleType.SurfaceContainerHighest)
		newProps.OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline)
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Primary)
		newProps.ButtonColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer)
		newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
		newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
		newProps.ClickVolume = style.Volume
		return React.createElement(Component, newProps)
	end,
	OnSurfaceSecondary = function(props: ThemeSwitchProperties): React.ReactElement<
		SwitchProperties,
		"OnSurfaceSecondary"
	>
		local style = props.Style

		local newProps = table.clone(props) :: SwitchProperties;
		(newProps :: any).Style = nil
		newProps.IsAnimated = style.IsAnimated
		newProps.SchemeType = style.SchemeType
		newProps.Scale = style.Scale

		newProps.BackgroundColor3 =
			style:GetColor(Enums.ColorRoleType.SurfaceContainerHighest)
		newProps.OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline)
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
		newProps.ButtonColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnSecondaryContainer)
		newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
		newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
		newProps.ClickVolume = style.Volume
		return React.createElement(Component, newProps)
	end,
	OnSurfaceTertiary = function(props: ThemeSwitchProperties): React.ReactElement<
		SwitchProperties,
		"OnSurfaceTertiary"
	>
		local style = props.Style

		local newProps = table.clone(props) :: SwitchProperties;
		(newProps :: any).Style = nil
		newProps.IsAnimated = style.IsAnimated
		newProps.SchemeType = style.SchemeType
		newProps.Scale = style.Scale

		newProps.BackgroundColor3 =
			style:GetColor(Enums.ColorRoleType.SurfaceContainerHighest)
		newProps.OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline)
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
		newProps.ButtonColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnTertiaryContainer)
		newProps.DisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
		newProps.OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface)
		newProps.ClickVolume = style.Volume
		return React.createElement(Component, newProps)
	end,
}
