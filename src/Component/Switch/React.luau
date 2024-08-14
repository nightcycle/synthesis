--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))
local React = require(_Packages:WaitForChild("React"))
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Sounds = require(_Package:WaitForChild("Sounds"))
local Theme = require(_Package:WaitForChild("Theme"))
local RobloxTypes = require(_Package:WaitForChild("RobloxTypes"))
local Defaults = require(script.Parent:WaitForChild("Defaults"))
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
type SwitchProperties = RobloxTypes.ImageButtonProperties & {
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

function Interface.new(
	input: SwitchProperties
): React.ReactElement<RobloxTypes.ImageButtonProperties, "ImageButton">
	local props: typeof(Defaults.New) = table.clone(input) :: any
	for k, v in pairs(Defaults.New) do
		if props[k] == nil then
			props[k] = v
		end
	end

	local value, setValue = React.useState(props.Value)
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)

	local icon = if value == true and props.IncludeIconOnSelected
		then Icons.check
		elseif value == false and props.IncludeIconOnDeselected then Icons.close
		else nil

	local unselectedRenderDataSet = table.freeze({
		[Enums.ButtonStateType.Enabled] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Disabled] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			)
		),
		[Enums.ButtonStateType.Hovered] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.08
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Focused] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Pressed] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.BackgroundColor3, props.Elevation, props.SchemeType),
				1 - 0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnBackgroundColor3, props.Elevation, props.SchemeType),
				0
			)
		),
	})

	local selectedRenderDataSet = table.freeze({
		[Enums.ButtonStateType.Enabled] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.ButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Disabled] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnDisabledColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.DisabledColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnDisabledColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnDisabledColor3, props.Elevation, props.SchemeType),
				1 - 0.38
			)
		),
		[Enums.ButtonStateType.Hovered] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.ButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0.08
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Focused] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.ButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0
			)
		),
		[Enums.ButtonStateType.Pressed] = newSwitchRenderData(
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.OnButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.ButtonColor3, props.Elevation, props.SchemeType),
				0
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0.1
			),
			Types._AppearanceData.new(
				Theme.getElevatedColor(props.FillColor3, props.Elevation, props.SchemeType),
				0
			)
		),
	})

	local state: Enums.ButtonStateType
	if props.IsEnabled then
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

	local renderData: SwitchRenderData = if value
		then selectedRenderDataSet[state]
		else unselectedRenderDataSet[state]

	local buttonSize = if icon
		then KNOB_YES_ICON_SIZE_DP
		else if value then KNOB_NO_ICON_SELECTED_SIZE_DP else KNOB_NO_ICON_UNSELECTED_SIZE_DP

	local switchSize = UDim2.fromOffset(
		math.round(props.Scale * SWITCH_WIDTH_DP - (OUTLINE_THICKNESS_DP * 2)),
		math.round(props.Scale * SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2))
	)

	local outlineThickness = math.round(props.Scale * OUTLINE_THICKNESS_DP)

	local useStroke = renderData.Background.Color3 ~= renderData.Outline.Color3
		or renderData.Background.Transparency ~= renderData.Background.Transparency

	return React.createElement(
		"ImageButton",
		{
			Name = "Switch",
			Size = UDim2.fromOffset(
				switchSize.X.Offset + outlineThickness * 2,
				switchSize.Y.Offset + outlineThickness * 2
			),
			BackgroundColor3 = renderData.Background.Color3,
			BackgroundTransparency = if useStroke then 1 else renderData.Background.Transparency,
		} :: RobloxTypes.ImageButtonProperties,
		{
			UICorner = React.createElement(
				"UICorner",
				{
					CornerRadius = UDim.new(0, math.round(props.Scale * SWITCH_HEIGHT_DP / 2)),
				} :: RobloxTypes.UICornerProperties
			),
			InnerSwitch = React.createElement("ImageButton", {
				Size = switchSize,
				Position = UDim2.fromOffset(outlineThickness, outlineThickness),
				BackgroundColor3 = renderData.Background.Color3,
				BackgroundTransparency = if useStroke then renderData.Background.Transparency else 1,
				[React.Event.InputBegan] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						setIsHovered(true)
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						setIsPressed(true)
					end
				end,
				[React.Event.InputEnded] = function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						setIsHovered(false)
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						setIsPressed(false)
					end
				end,
				[React.Event.Activated] = function()
					if props.IsEnabled then
						setValue(not value)

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
					setIsFocused(true)
				end,
				[React.Event.SelectionLost] = function()
					setIsFocused(false)
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
							math.round(props.Scale * (SWITCH_HEIGHT_DP - OUTLINE_THICKNESS_DP * 2) / 2)
						),
					} :: RobloxTypes.UICornerProperties
				),
				UIPadding = (function()
					local widthPaddingState: UDim
					do
						local size = props.Scale
							* (SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2) - buttonSize)
						if icon then
							size += math.max(0, math.round((switchSize.Y.Offset - buttonSize * props.Scale)))
						end
						widthPaddingState = UDim.new(0, math.round(size / 2))
					end
					local heightPaddingState: UDim
					do
						local size = SWITCH_HEIGHT_DP - (OUTLINE_THICKNESS_DP * 2) - buttonSize
						heightPaddingState = UDim.new(0, math.round(props.Scale * size / 2))
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
							math.round(props.Scale * buttonSize),
							math.round(props.Scale * buttonSize)
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
								CornerRadius = UDim.new(0, math.round(props.Scale * buttonSize / 2)),
							} :: RobloxTypes.UICornerProperties
						),
						Icon = React.createElement(
							"ImageLabel",
							{
								Size = UDim2.fromOffset(
									math.round(props.Scale * ICON_SIZE_DP),
									math.round(props.Scale * ICON_SIZE_DP)
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

return Interface
