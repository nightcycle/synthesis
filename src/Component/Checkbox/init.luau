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

-- Types
type Maid = Maid.Maid
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type Style = Style.Style
type RenderData = Types.RenderData
type BaseCheckboxProperties = RobloxTypes.GuiObjectProperties & {
	Value: boolean,
	OnChanged: (isSelected: boolean) -> (),
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
	ClickVolume: number?,
}

export type StyleCheckboxProperties = BaseCheckboxProperties & {
	Style: Style,
}
-- Constants
local BUTTON_SIZE_DP = 18
local TRANSITION_TYPE = Enums.TransitionType.Emphasized
local TRANSITION_DURATION = Enums.TransitionDuration.Long1
local ALPHA_RUNNER_KEY = "AlphaRunner"
local RIPPLE_ALPHA_RUNNER_KEY = "BubbleAlphaRunner"
local CHECK_ICON = Icons.check
local DASH_ICON = Icons.remove
local LAYER_SIZE_DP = 40
local CHECKBOX_SIZE_DP = 18
local CHECKBOX_SHAPE_DP = 2
local UNSELECT_OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions
function getAlphaRunner(
	self: React.ComponentClass<CheckboxProperties>
): Transition.TransitionRunner
	return self[ALPHA_RUNNER_KEY]
end
function getBubbleAlphaRunner(
	self: React.ComponentClass<CheckboxProperties>
): Transition.TransitionRunner
	return self[RIPPLE_ALPHA_RUNNER_KEY]
end
-- Class
local Component: React.ComponentClass<CheckboxProperties> =
	React.Component:extend("Checkbox")

function Component:init(initialProps: CheckboxProperties): ()
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
	local elevation: number = self.props.Elevation :: number? or Defaults.Elevation
	local schemeType: Enums.SchemeType = self.props.SchemeType :: Enums.SchemeType?
		or Defaults.SchemeType
	local clickVolume: number? = self.props.ClickVolume or Defaults.ClickVolume
	local disabledColor3: Color3 = self.props.DisabledColor3 :: Color3?
		or Defaults.DisabledColor3
	local onDisabledColor3: Color3 = self.props.OnDisabledColor3 :: Color3?
		or Defaults.OnDisabledColor3
	local fillColor3: Color3 = self.props.FillColor3 :: Color3? or Defaults.FillColor3
	local iconColor3: Color3 = self.props.IconColor3 :: Color3? or Defaults.IconColor3
	local outlineColor3: Color3 = self.props.OutlineColor3 :: Color3?
		or Defaults.OutlineColor3

	local scale = (self.props.Scale :: number?) or Defaults.Scale
	local isAnimated = if self.props.IsAnimated ~= nil
		then self.props.IsAnimated
		else Defaults.IsAnimated
	local isEnabled = if self.props.IsEnabled ~= nil
		then self.props.IsEnabled
		else Defaults.IsEnabled

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

	return React.createElement(
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
				end :: any,
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
					print("activate")
					if self.props.IsEnabled then
						print("click")
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
				[React.Change.AbsolutePosition] = function(inst: ImageButton)
					if self.state.KnobAbsolutePosition ~= inst.AbsolutePosition then
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
			} :: RobloxTypes.GuiObjectProperties,
			self.props
		),
		{
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
			Bubble = if isAnimated
					and (math.round(bubbleAlpha) ~= bubbleAlpha or isBubbleEnabled)
				then React.createElement(PopUp, {
					DisplayAnchorPoint = Vector2.new(0.5, 0.5),
					TargetAbsolutePosition = self.state.KnobAbsolutePosition
						+ self.state.KnobAbsoluteSize * Vector2.new(0.5, 0.5),
					DisplayComponent = function(): React.ReactElement<
						RobloxTypes.FrameProperties,
						"Frame"
					>
						local bubbleSize =
							math.ceil(2 * scale * BUTTON_SIZE_DP * bubbleAlpha)
						return React.createElement(
							"Frame",
							{
								BackgroundTransparency = 1 - 0.2 * bubbleAlpha,
								BackgroundColor3 = fillColor3,
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(bubbleSize, bubbleSize),
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
			Box = React.createElement(
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
					UICorner = React.createElement(
						"UICorner",
						{
							CornerRadius = UDim.new(
								0,
								math.round(scale * CHECKBOX_SHAPE_DP)
							),
						} :: RobloxTypes.UICornerProperties
					),
					UIStroke = React.createElement(
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

function Component:willUnmount()
	getAlphaRunner(self):Disconnect()
	getBubbleAlphaRunner(self):Disconnect()
end

return {
	Full = Component,
	OnSurfacePrimary = function(props: StyleCheckboxProperties): React.ReactElement<
		CheckboxProperties,
		"OnSurfacePrimary"
	>
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
		newProps.ClickVolume = style.Volume

		return React.createElement(Component, newProps)
	end,
	OnSurfaceSecondary = function(props: StyleCheckboxProperties): React.ReactElement<
		CheckboxProperties,
		"OnSurfaceSecondary"
	>
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
		newProps.ClickVolume = style.Volume

		return React.createElement(Component, newProps)
	end,
	OnSurfaceTertiary = function(props: StyleCheckboxProperties): React.ReactElement<
		CheckboxProperties,
		"OnSurfaceTertiary"
	>
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
		newProps.ClickVolume = style.Volume

		return React.createElement(Component, newProps)
	end,
}
