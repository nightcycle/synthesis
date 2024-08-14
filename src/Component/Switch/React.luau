--!strict
-- Services
local SoundService = game:GetService("SoundService")

-- @Packages
local Maid = require("@Package/Maid")
local Icons = require("@Package/MaterialIcons")
local React = require("@Package/React")

-- Modules
local Types = require("@Project/Types")
local Style = require("@Project/Style")
local Enums = require("@Project/Enums")
local Sounds = require("@Project/Sounds")
local Theme = require("@Project/Theme")
local RobloxTypes = require("@Project/RobloxTypes")
local PropUtil = require("@Project/PropUtil")
local Defaults = require("./Defaults")

-- Types
type Maid = Maid.Maid
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type SwitchRenderData = {
	Text: AppearanceData,
	Button: AppearanceData,
	Background: AppearanceData,
	Outline: AppearanceData,
}
type FontData = Types.FontData
type SwitchProperties = RobloxTypes.FrameProperties & {
	Value: boolean?,
	IsEnabled: boolean?,
	IncludeIconOnSelected: boolean?,
	IncludeIconOnDeselected: boolean?,
	BackgroundColor3: Color3?,
	OnBackgroundColor3: Color3?,
	FillColor3: Color3?,
	ButtonColor3: Color3?,
	OnButtonColor3: Color3?,
	DisabledColor3: Color3?,
	OnDisabledColor3: Color3?,
	Elevation: number?,
	SchemeType: Enums.SchemeType?,
	FontData: FontData?,
	Scale: number?,
}
-- Constants
local SWITCH_HEIGHT_DP = 32
local SWITCH_WIDTH_DP = 52
local KNOB_YES_ICON_SIZE_DP = 28
local KNOB_NO_ICON_SELECTED_SIZE_DP = 24
local KNOB_NO_ICON_UNSELECTED_SIZE_DP = 16
local ICON_SIZE_DP = 16
local OUTLINE_THICKNESS_DP = 2
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

-- Class
local Interface = {}

do
	local Component: React.ComponentClass<SwitchProperties> = React.Component:extend("Switch")

	function Component:init()
		self:setState({
			Value = false,
			IsHovered = false,
			IsPressed = false,
			IsFocused = false,
		})
	end

	function Component:render()
		-- unpack state
		local value: boolean = self.state.Value
		local isHovered: boolean = self.state.IsHovered
		local isPressed: boolean = self.state.IsPressed
		local isFocused: boolean = self.state.IsFocused

		-- unpack properties
		local backgroundColor3: Color3 = self.props.BackgroundColor3 :: Color3?
			or Defaults.New.BackgroundColor3
		local onBackgroundColor3: Color3 = self.props.OnBackgroundColor3 :: Color3?
			or Defaults.New.OnBackgroundColor3
		local elevation: number = self.props.Elevation :: number? or Defaults.New.Elevation
		local schemeType: Enums.SchemeType = self.props.SchemeType :: Enums.SchemeType?
			or Defaults.New.SchemeType
		local buttonColor3: Color3 = self.props.ButtonColor3 :: Color3? or Defaults.New.ButtonColor3
		local onButtonColor3: Color3 = self.props.OnButtonColor3 :: Color3? or Defaults.New.OnButtonColor3
		local disabledColor3: Color3 = self.props.DisabledColor3 :: Color3? or Defaults.New.DisabledColor3
		local onDisabledColor3: Color3 = self.props.OnDisabledColor3 :: Color3?
			or Defaults.New.OnDisabledColor3
		local fillColor3: Color3 = (self.props.FillColor3 :: Color3?) or Defaults.New.FillColor3
		local scale = (self.props.Scale :: number?) or Defaults.New.Scale

		-- solve some internal stuff
		local icon: ImageData?
		if value == true and self.props.IncludeIconOnSelected then
			icon = Icons.check
		elseif value == false and self.props.IncludeIconOnDeselected then
			icon = Icons.close
		end

		local state: Enums.ButtonStateType
		if self.props.IsEnabled then
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

		local renderData: SwitchRenderData

		if value then
			if state == Enums.ButtonStateType.Enabled then
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(Theme.getElevatedColor(buttonColor3, elevation, schemeType), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0)
				)
			elseif state == Enums.ButtonStateType.Disabled then
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(disabledColor3, elevation, schemeType),
						1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onDisabledColor3, elevation, schemeType),
						1 - 0.38
					)
				)
			elseif state == Enums.ButtonStateType.Hovered then
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(Theme.getElevatedColor(buttonColor3, elevation, schemeType), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0.08),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0)
				)
			elseif state == Enums.ButtonStateType.Focused then
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(Theme.getElevatedColor(buttonColor3, elevation, schemeType), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0.1),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0)
				)
			elseif state == Enums.ButtonStateType.Pressed then
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onButtonColor3, elevation, schemeType),
						0
					),
					Types._AppearanceData.new(Theme.getElevatedColor(buttonColor3, elevation, schemeType), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0.1),
					Types._AppearanceData.new(Theme.getElevatedColor(fillColor3, elevation, schemeType), 0)
				)
			else
				error(`invalid selected render data at {state}`)
			end
		else
			if state == Enums.ButtonStateType.Enabled then
				renderData = newSwitchRenderData(
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
				renderData = newSwitchRenderData(
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						1 - 0.38
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						1
					),
					Types._AppearanceData.new(
						Theme.getElevatedColor(onBackgroundColor3, elevation, schemeType),
						1 - 0.38
					)
				)
			elseif state == Enums.ButtonStateType.Hovered then
				renderData = newSwitchRenderData(
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
				renderData = newSwitchRenderData(
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
				renderData = newSwitchRenderData(
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

		local buttonSize = if icon
			then KNOB_YES_ICON_SIZE_DP
			else if value then KNOB_NO_ICON_SELECTED_SIZE_DP else KNOB_NO_ICON_UNSELECTED_SIZE_DP

		local switchSize = UDim2.fromOffset(
			math.round(scale * SWITCH_WIDTH_DP - (OUTLINE_THICKNESS_DP * 2)),
			math.round(scale * SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2))
		)

		local outlineThickness = math.round(scale * OUTLINE_THICKNESS_DP)

		local useStroke = renderData.Background.Color3 ~= renderData.Outline.Color3
			or renderData.Background.Transparency ~= renderData.Outline.Transparency

		return React.createElement(
			"Frame",
			PropUtil.mergeFrame(
				{
					Size = UDim2.fromOffset(
						switchSize.X.Offset + outlineThickness * 2,
						switchSize.Y.Offset + outlineThickness * 2
					),
					BackgroundColor3 = renderData.Background.Color3,
					BackgroundTransparency = if useStroke then 1 else renderData.Background.Transparency,
				} :: RobloxTypes.FrameProperties,
				self.props
			),
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
					BackgroundTransparency = if useStroke then renderData.Background.Transparency else 1,
					[React.Event.InputBegan] = function(_, input: InputObject)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							self:setState({
								IsHovered = true,
							})
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
							self:setState({
								IsPressed = true,
							})
						end
					end,
					[React.Event.InputEnded] = function(_, input: InputObject)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							self:setState({
								IsHovered = false,
							})
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
							self:setState({
								IsPressed = false,
							})
						end
					end,
					[React.Event.Activated] = function()
						if self.props.IsEnabled then
							self:setState({
								Value = not value,
							})

							local sound = Instance.new("Sound")
							sound.Volume = 1
							if not value then
								sound.SoundId =
									Sounds.Library[Enums.SoundType.navigation_forward_selection_minimal]
							else
								sound.SoundId =
									Sounds.Library[Enums.SoundType.navigation_backward_selection_minimal]
							end
							SoundService:PlayLocalSound(sound)
							sound:Destroy()
						end
					end,
					[React.Event.SelectionGained] = function()
						self:setState({
							IsFocused = true,
						})
					end,
					[React.Event.SelectionLost] = function()
						self:setState({
							IsFocused = false,
						})
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
								math.round(scale * (SWITCH_HEIGHT_DP - OUTLINE_THICKNESS_DP * 2) / 2)
							),
						} :: RobloxTypes.UICornerProperties
					),
					UIPadding = (function()
						local widthPaddingState: UDim
						do
							local size = scale * (SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2) - buttonSize)
							if icon then
								size += math.max(0, math.round((switchSize.Y.Offset - buttonSize * scale)))
							end
							widthPaddingState = UDim.new(0, math.round(size / 2))
						end
						local heightPaddingState: UDim
						do
							local size = SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2) - buttonSize
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
								math.round(scale * buttonSize),
								math.round(scale * buttonSize)
							),
							Position = if value then UDim2.fromScale(1, 0.5) else UDim2.fromScale(0, 0.5),
							AnchorPoint = if value then Vector2.new(1, 0.5) else Vector2.new(0, 0.5),
							BackgroundTransparency = renderData.Button.Transparency,
							BorderSizePixel = 0,
							BackgroundColor3 = renderData.Button.Color3,
						} :: RobloxTypes.FrameProperties,
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
							UICorner = React.createElement(
								"UICorner",
								{
									CornerRadius = UDim.new(0, math.round(scale * buttonSize / 2)),
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
									ImageRectOffset = if icon then icon.ImageRectOffset else Vector2.zero,
									ImageRectSize = if icon then icon.ImageRectSize else Vector2.zero,
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

	Interface.new = Component
end

return Interface
