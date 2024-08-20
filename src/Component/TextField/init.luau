--!strict
-- Services
-- Packages
local React = require("@wally/React")
local MaterialIcons = require("@wally/MaterialIcons")
-- Modules
local Types = require("@proj/Types")
local RobloxTypes = require("@proj/RobloxTypes")
local Style = require("@proj/Style")
local PropUtil = require("@proj/PropUtil")
local Enums = require("@proj/Enums")
local Defaults = require("./Defaults")
local Container = require("@comp/Container")
local TextDisplay = require("@comp/TextDisplay")
local Typography = require("@proj/Typography")
local IconDisplay = require("@comp/IconDisplay")
-- Types
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData
type BaseTextFieldProperties = RobloxTypes.FrameProperties & {
	OnSubmit: (input: string) -> (),
	OnInput: ((input: string) -> ())?,
	DropDownOptions: { string }?,
	Value: string?,
	IsEnabled: boolean?,
	IsError: boolean?,
	IsFilled: boolean?,
	Label: string?,
	CharacterLimit: number?,
	SupportingText: string?,
	Icon: ImageData?,
}
export type TextFieldProperties = BaseTextFieldProperties & {
	HightlightColor3: Color3?,
	BackgroundColor3: Color3?,
	ErrorColor3: Color3?,
	BorderColor3: Color3?,
	TextColor3: Color3?,
	LabelColor3: Color3?,
	SupportingTextColor3: Color3?,
	Elevation: number?,
	SchemeType: Enums.SchemeType?,
	BodyFontData: FontData?,
	SupportFontData: FontData?,
	Scale: number?,
}
export type StyleTextFieldProperties = BaseTextFieldProperties & {
	Style: Style,
}

-- Constants
local CONTAINER_HEIGHT_DP = 42
local LEFT_RIGHT_NO_ICONS_PADDING_DP = 14
local LEFT_RIGHT_YES_ICONS_PADDING_DP = 10
local TEXT_AND_ICON_PADDING_DP = 14
local SUPPORTING_TEXT_PADDING_DP = 4
local MIN_WIDTH_DP = math.round(CONTAINER_HEIGHT_DP * 1.5)
local DEFAULT_OUTLINE_THICKNESS_DP = 1
local FOCUSED_OUTLINE_THICKNESS_DP = 2
local RADIUS_DP = 4
local ICON_WIDTH_DP = 18
local DISABLED_TEXT_TRANSPARENCY = 1 - 0.38
local DISABLED_OUTLINE_TRANSPARENCY = 1 - 0.12
local DISABLED_BACKGROUND_TRANSPARENCY = 1 - 0.04
-- Variables
-- References
-- Private Functions
-- Class
local Library = {}

function Library.Full(props: TextFieldProperties): React.ReactNode
	-- unpack props
	local onSubmit = props.OnSubmit
	local onInput: ((input: string) -> ())? = props.OnInput
	local value: string? = props.Value
	local isEnabled: boolean = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled
	local isError: boolean = if props.IsError ~= nil
		then props.IsError
		else Defaults.IsError
	local isFilled: boolean = if props.IsFilled ~= nil
		then props.IsFilled
		else Defaults.IsFilled
	local label: string? = props.Label
	local characterLimit: number? = props.CharacterLimit
	local supportingText: string? = props.SupportingText
	local icon: ImageData? = props.Icon
	local dropDownOptions: { string }? = props.DropDownOptions

	local hightlightColor3: Color3 = props.HightlightColor3 or Defaults.HightlightColor3
	local backgroundColor3: Color3 = props.BackgroundColor3 :: Color3
		or Defaults.BackgroundColor3
	local errorColor3: Color3 = props.ErrorColor3 or Defaults.ErrorColor3
	local borderColor3: Color3 = (props.BorderColor3 :: Color3) or Defaults.BorderColor3
	local textColor3: Color3 = props.TextColor3 or Defaults.TextColor3
	local labelColor3: Color3 = props.LabelColor3 or Defaults.LabelColor3
	local supportTextColor3: Color3 = props.SupportingTextColor3
		or Defaults.SupportingTextColor3
	local elevation: number = props.Elevation or Defaults.Elevation
	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local bodyFontData: FontData = props.BodyFontData or Defaults.BodyFontData
	local supportFontData: FontData = props.SupportFontData or Defaults.SupportFontData
	local scale: number = props.Scale or Defaults.Scale

	-- set up state
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)

	local textBoxRef = React.createRef()

	-- process stuff
	local state: Enums.ButtonStateType =
		Types._RenderData.getButtonState(isHovered, isPressed, isFocused, isEnabled)

	local iconAddedWidth = (function(): number
		local leftOffset = if icon then ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP else 0
		local rightOffset = ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP
		return math.ceil((leftOffset + rightOffset) * scale)
	end)()

	local outlineThickness = math.ceil(
		scale
			* if isFocused == false
				then DEFAULT_OUTLINE_THICKNESS_DP
				else FOCUSED_OUTLINE_THICKNESS_DP
	)

	local isLabelMinized = if isFocused or (value and value:len() > 0)
		then true
		else false

	local labelFontData = if isLabelMinized then supportFontData else bodyFontData

	local rightIconImage: ImageData? = if isError
		then MaterialIcons.error
		elseif value then MaterialIcons.cancel
		elseif dropDownOptions then MaterialIcons.arrow_drop_down
		else nil

	return React.createElement(
		Container,
		PropUtil.mergeFrame(
			{

				children = {
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							Padding = UDim.new(
								0,
								math.round(scale * SUPPORTING_TEXT_PADDING_DP)
							),
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					UpperLabelContainer = React.createElement(
						Container,
						{
							LayoutOrder = 1,
							children = {
								UIListLayout = React.createElement(
									"UIListLayout",
									{
										SortOrder = Enum.SortOrder.LayoutOrder,
										FillDirection = Enum.FillDirection.Horizontal,
										VerticalAlignment = Enum.VerticalAlignment.Center,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										Padding = UDim.new(
											0,
											math.round(scale * TEXT_AND_ICON_PADDING_DP)
										),
										HorizontalFlex = Enum.UIFlexAlignment.Fill,
										ItemLineAlignment = Enum.ItemLineAlignment.Center,
										VerticalFlex = Enum.UIFlexAlignment.Fill,
										Wraps = false,
									} :: RobloxTypes.UIListLayoutProperties
								),
								UIPadding = (function(): React.ReactNode
									if not icon then
										local pad = UDim.new(
											0,
											math.ceil(
												scale * LEFT_RIGHT_NO_ICONS_PADDING_DP
											)
										)
										return React.createElement(
											"UIPadding",
											{
												PaddingLeft = pad,
												PaddingRight = pad,
												PaddingTop = pad,
												PaddingBottom = pad,
											} :: RobloxTypes.UIPaddingProperties
										)
									else
										local pad = UDim.new(
											0,
											math.ceil(
												scale * LEFT_RIGHT_YES_ICONS_PADDING_DP
											)
										)
										return React.createElement(
											"UIPadding",
											{
												PaddingLeft = pad,
												PaddingRight = pad,
												PaddingTop = pad,
												PaddingBottom = pad,
											} :: RobloxTypes.UIPaddingProperties
										)
									end
								end)(),
								Label = if not isFocused
									then React.createElement(
										TextDisplay.Full,
										{
											TextColor3 = if isFocused or isError
												then labelColor3
												else hightlightColor3,
											Scale = scale,
											TextTransparency = if not isFilled
												then if isLabelMinized then 0 else 1
												else 1,
											FontData = supportFontData,
											Text = label,
										} :: TextDisplay.TextDisplayProperties
									)
									else nil,
								[React.Event.Activated] = function()
									if isEnabled == false then
										return
									end
									local textBox = textBoxRef.current
									if
										typeof(textBox) == "Instance"
										and textBox:IsA("TextBox")
									then
										textBox:CaptureFocus()
									end
								end :: any,
								[React.Event.InputBegan] = function(
									_,
									input: InputObject
								)
									if
										input.UserInputType
										== Enum.UserInputType.MouseMovement
									then
										if not isHovered then
											setIsHovered(true)
										end
									elseif
										input.UserInputType
										== Enum.UserInputType.MouseButton1
									then
										if not isPressed then
											setIsPressed(true)
										end
									end
								end :: any,
								[React.Event.InputEnded] = function(
									_,
									input: InputObject
								)
									if
										input.UserInputType
										== Enum.UserInputType.MouseMovement
									then
										if isHovered then
											setIsHovered(false)
										end
									elseif
										input.UserInputType
										== Enum.UserInputType.MouseButton1
									then
										if isPressed then
											setIsPressed(false)
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
							},
						} :: RobloxTypes.FrameProperties
					),
					TextButton = React.createElement(
						"TextButton",
						{
							LayoutOrder = 2,
							Size = UDim2.fromOffset(
								0,
								math.ceil(scale * CONTAINER_HEIGHT_DP)
							),
							BackgroundColor3 = backgroundColor3,
							Text = "",
							BackgroundTransparency = if not isFilled
								then 1
								elseif isEnabled then 0
								else DISABLED_BACKGROUND_TRANSPARENCY,
							AutomaticSize = Enum.AutomaticSize.XY,
						} :: RobloxTypes.TextButtonProperties,
						{
							UIStroke = React.createElement(
								"UIStroke",
								{
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									Color = if isFocused or isError
										then hightlightColor3
										elseif
											state == Enums.ButtonStateType.Hovered
										then textColor3
										else borderColor3,
									Enabled = not isFilled,
									LineJoinMode = Enum.LineJoinMode.Round,
									Transparency = if isEnabled
										then 0
										else DISABLED_OUTLINE_TRANSPARENCY,
									Thickness = outlineThickness,
								} :: RobloxTypes.UIStrokeProperties
							),
							UICorner = React.createElement(
								"UICorner",
								{
									CornerRadius = UDim.new(
										0,
										math.ceil(scale * RADIUS_DP)
									),
								} :: RobloxTypes.UICornerProperties
							),
							UISizeConstraint = React.createElement(
								"UISizeConstraint",
								{
									MinSize = Vector2.new(
										math.ceil((scale * MIN_WIDTH_DP) + iconAddedWidth),
										0
									),
								} :: RobloxTypes.UISizeConstraintProperties
							),
							Container = React.createElement(
								Container,
								{
									LayoutOrder = 3,
									AutomaticSize = Enum.AutomaticSize.X,
									Size = UDim2.fromOffset(
										0,
										math.ceil(scale * ICON_WIDTH_DP)
									),
									children = {
										TextBox = React.createElement(
											"TextBox",
											{
												ref = textBoxRef,
												LayoutOrder = 2,
												RichText = true,
												Visible = true,
												TextColor3 = textColor3,
												TextTransparency = if isLabelMinized
													then if isEnabled
														then 0
														else DISABLED_TEXT_TRANSPARENCY
													else 1,
												BackgroundTransparency = 1,
												Text = value,
												Selectable = false,
												TextXAlignment = Enum.TextXAlignment.Left,
												TextSize = Typography.getTextSize(
													bodyFontData.Size,
													scale
												),
												LineHeight = Typography.getGuiLineHeight(
													bodyFontData.LineHeight,
													bodyFontData.Size
												),
												FontFace = bodyFontData.Font,
												Size = if isLabelMinized
													then UDim2.fromOffset(
														0,
														math.ceil(
															scale
																* Typography.getTextSize(
																	bodyFontData.Size,
																	scale
																)
																* Typography.getGuiLineHeight(
																	bodyFontData.LineHeight,
																	bodyFontData.Size
																)
														)
													)
													else UDim2.fromOffset(0, 0),
												[React.Event.FocusLost] = function(
													inst: TextBox
												)
													if isFocused then
														setIsFocused(false)
													end
													if onSubmit then
														local content = inst.Text
														if characterLimit then
															content = content:sub(
																1,
																characterLimit
															)
														end

														onSubmit(content)
													end
												end :: any,
												[React.Event.FocusGained] = function()
													if isEnabled then
														if not isFocused then
															setIsFocused(true)
														end
													end
												end :: any,
												[React.Change.Text] = function(
													inst: TextBox
												)
													if isEnabled then
														if onInput then
															local content = inst.Text
															if characterLimit then
																content = content:sub(
																	1,
																	characterLimit
																)
															end
															onInput(content)
														end
													end
												end :: any,
											} :: RobloxTypes.TextBoxProperties
										),
										TextLabel = React.createElement(
											TextDisplay.Full,
											{
												TextColor3 = if isLabelMinized
													then labelColor3
													else hightlightColor3,
												Scale = scale,
												TextTransparency = if isEnabled
													then 0
													else DISABLED_TEXT_TRANSPARENCY,
												FontData = labelFontData,
												Text = label,
												Visible = if not isFilled
													then isLabelMinized == false
													else true,
											} :: TextDisplay.TextDisplayProperties
										),
										UIListLayout = React.createElement(
											"UIListLayout",
											{
												SortOrder = Enum.SortOrder.LayoutOrder,
												FillDirection = Enum.FillDirection.Vertical,
												VerticalAlignment = Enum.VerticalAlignment.Center,
												HorizontalAlignment = Enum.HorizontalAlignment.Left,
												Padding = UDim.new(0, 0),
												HorizontalFlex = Enum.UIFlexAlignment.Fill,
												ItemLineAlignment = Enum.ItemLineAlignment.Center,
												VerticalFlex = Enum.UIFlexAlignment.None,
												Wraps = false,
											} :: RobloxTypes.UIListLayoutProperties
										),
									},
								} :: RobloxTypes.FrameProperties
							),
							IconButton = React.createElement("ImageButton", {
								LayoutOrder = 3,
								[React.Event.Activated] = function()
									if value and isError then
										onSubmit("")
									else
										if dropDownOptions and #dropDownOptions > 0 then
											-- TODO
											warn("drop it like it's hot")
										end
									end
								end :: any,
							}, {
								UIAspectRatioConstraint = React.createElement(
									"UIAspectRatioConstraint",
									{
										AspectRatio = 1,
										AspectType = Enum.AspectType.FitWithinMaxSize,
										DominantAxis = Enum.DominantAxis.Height,
									} :: RobloxTypes.UIAspectRatioConstraintProperties
								),
								UIListLayout = React.createElement(
									"UIListLayout",
									{
										SortOrder = Enum.SortOrder.LayoutOrder,
										FillDirection = Enum.FillDirection.Vertical,
										VerticalAlignment = Enum.VerticalAlignment.Center,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										Padding = UDim.new(0, 0),
										HorizontalFlex = Enum.UIFlexAlignment.None,
										ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
										VerticalFlex = Enum.UIFlexAlignment.None,
										Wraps = false,
									} :: RobloxTypes.UIListLayoutProperties
								),
								IconContainer = React.createElement(Container, {}, {
									RightIcon = if rightIconImage
										then React.createElement(IconDisplay, {
											Icon = rightIconImage,
											IconColor3 = if isError
												then errorColor3
												else textColor3,
											IconTransparency = if isError then 0 else 1,
											Scale = scale,
										})
										else nil,
								}),
							}),
							UIListLayout = React.createElement(
								"UIListLayout",
								{
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									Padding = UDim.new(
										0,
										math.ceil(scale * TEXT_AND_ICON_PADDING_DP)
									),
									HorizontalFlex = Enum.UIFlexAlignment.Fill,
									ItemLineAlignment = Enum.ItemLineAlignment.Center,
									VerticalFlex = Enum.UIFlexAlignment.Fill,
									Wraps = false,
								} :: RobloxTypes.UIListLayoutProperties
							),
							UIPadding = (function(): React.ReactNode
								local pad = UDim.new(
									0,
									math.ceil(scale * TEXT_AND_ICON_PADDING_DP)
								)
								return React.createElement(
									"UIPadding",
									{
										PaddingLeft = pad,
										PaddingRight = pad,
										PaddingTop = pad,
										PaddingBottom = pad,
									} :: RobloxTypes.UIPaddingProperties
								)
							end)(),
							SupportingText = React.createElement(
								TextDisplay.Full,
								{
									LayoutOrder = 1,
									TextColor3 = if isError
										then errorColor3
										else supportTextColor3,
									Scale = scale,
									TextTransparency = if supportingText
											and supportingText:len() > 0
										then if isEnabled
											then 0
											else DISABLED_TEXT_TRANSPARENCY
										else 1,
									FontData = supportFontData,
									Text = supportingText,
								} :: TextDisplay.TextDisplayProperties
							),
							CharacterCount = React.createElement(
								TextDisplay.Full,
								{
									LayoutOrder = 2,
									TextColor3 = if isError
										then errorColor3
										else supportTextColor3,
									Scale = scale,
									TextTransparency = if supportingText
											and supportingText:len() > 0
										then if isEnabled
											then 0
											else DISABLED_TEXT_TRANSPARENCY
										else 1,
									FontData = supportFontData,
									TextXAlignment = Enum.TextXAlignment.Right,
									Text = if characterLimit and value
										then string.format(
											"%d/%d",
											value:len(),
											characterLimit
										)
										else "",
								} :: TextDisplay.TextDisplayProperties
							),
						}
					),
				},
			} :: RobloxTypes.FrameProperties,
			props
		)
	)
end

return Library
