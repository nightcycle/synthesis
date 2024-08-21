--!strict
-- Services
local UserInputService = game:GetService("UserInputService")
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
local Theme = require("@proj/Theme")
local ButtonContainer = require("@comp/ButtonContainer")
-- Types
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData
type BaseTextFieldProperties = RobloxTypes.FrameProperties & {
	OnSubmit: (input: string?) -> (),
	OnChange: (input: string?) -> (),
	DropDownOptions: { string }?,
	Value: string?,
	IsMultiLine: boolean?,
	IsEnabled: boolean?,
	IsError: boolean?,
	IsFilled: boolean?,
	Label: string?,
	CharacterLimit: number?,
	SupportingText: string?,
	ClearTextOnFocus: boolean?,
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
	local onChange = props.OnChange
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
	local leftIcon: ImageData? = props.Icon
	local dropDownOptions: { string }? = props.DropDownOptions

	local rawHightlightColor3: Color3 = props.HightlightColor3
		or Defaults.HightlightColor3
	local rawBackgroundColor3: Color3 = props.BackgroundColor3 :: Color3
		or Defaults.BackgroundColor3
	local rawErrorColor3: Color3 = props.ErrorColor3 or Defaults.ErrorColor3
	local rawBorderColor3: Color3 = props.BorderColor3 :: Color3 or Defaults.BorderColor3
	local rawTextColor3: Color3 = props.TextColor3 or Defaults.TextColor3
	local rawLabelColor3: Color3 = props.LabelColor3 or Defaults.LabelColor3
	local rawSupportTextColor3: Color3 = props.SupportingTextColor3
		or Defaults.SupportingTextColor3
	local elevation: number = props.Elevation or Defaults.Elevation
	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local bodyFontData: FontData = props.BodyFontData or Defaults.BodyFontData
	local supportFontData: FontData = props.SupportFontData or Defaults.SupportFontData
	local scale: number = props.Scale or Defaults.Scale
	local isMultiLine: boolean = if props.IsMultiLine ~= nil
		then props.IsMultiLine
		else Defaults.IsMultiLine
	local isClearTextOnFocus: boolean = if props.ClearTextOnFocus ~= nil
		then props.ClearTextOnFocus
		else Defaults.ClearTextOnFocus

	-- set up state
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)
	local isTextBoxFocused, setIsTextBoxFocused = React.useState(false)

	local textBoxRef = React.useRef(nil :: TextBox?)
	if isTextBoxFocused then
		local textBox = textBoxRef.current
		if typeof(textBox) == "Instance" and textBox:IsA("TextBox") then
			textBox:CaptureFocus()
		end
	end

	-- process colors
	local hightlightColor3 =
		Theme.getElevatedColor(rawHightlightColor3, elevation, schemeType)
	local backgroundColor3 =
		Theme.getElevatedColor(rawBackgroundColor3, elevation, schemeType)
	local errorColor3 = Theme.getElevatedColor(rawErrorColor3, elevation, schemeType)
	local borderColor3 = Theme.getElevatedColor(rawBorderColor3, elevation, schemeType)
	local textColor3 = Theme.getElevatedColor(rawTextColor3, elevation, schemeType)
	local labelColor3 = Theme.getElevatedColor(rawLabelColor3, elevation, schemeType)
	local supportTextColor3 =
		Theme.getElevatedColor(rawSupportTextColor3, elevation, schemeType)

	-- process stuff
	local state: Enums.ButtonStateType =
		Types._RenderData.getButtonState(isHovered, isPressed, isFocused, isEnabled)

	local iconAddedWidth = (function(): number
		local leftOffset = if leftIcon
			then ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP
			else 0
		local rightOffset = ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP
		return math.ceil((leftOffset + rightOffset) * scale)
	end)()
	local iconSize = UDim2.fromOffset(
		math.ceil(scale * ICON_WIDTH_DP),
		math.ceil(scale * ICON_WIDTH_DP)
	)
	local outlineThickness = math.ceil(
		scale
			* if isTextBoxFocused == false
				then DEFAULT_OUTLINE_THICKNESS_DP
				else FOCUSED_OUTLINE_THICKNESS_DP
	)

	local isLabelMinized = isTextBoxFocused or (value and value:len() > 0)

	local labelFontData = if isLabelMinized then supportFontData else bodyFontData

	local rightIconImage: ImageData? = if isError
		then MaterialIcons.error
		elseif value then MaterialIcons.cancel
		elseif dropDownOptions then MaterialIcons.arrow_drop_down
		else nil

	-- internal functions
	local function formatText(input: string): string
		if characterLimit then
			input = input:sub(1, characterLimit)
		end
		return input
	end

	-- exit focus
	React.useEffect(function()
		if isTextBoxFocused then
			do
				local tBox = textBoxRef.current
				if typeof(tBox) == "Instance" and tBox:IsA("TextBox") then
					tBox:CaptureFocus()
				end
			end

			return function() end
		else
			return function() end
		end
	end)

	-- sub elements
	local upperLabelContainer = React.createElement(
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
					if not leftIcon then
						local pad =
							UDim.new(0, math.ceil(scale * LEFT_RIGHT_NO_ICONS_PADDING_DP))
						return React.createElement(
							"UIPadding",
							{
								PaddingLeft = pad,
								PaddingRight = pad,
								PaddingTop = UDim.new(),
								PaddingBottom = UDim.new(),
							} :: RobloxTypes.UIPaddingProperties
						)
					else
						local pad = UDim.new(
							0,
							math.ceil(scale * LEFT_RIGHT_YES_ICONS_PADDING_DP)
						)
						return React.createElement(
							"UIPadding",
							{
								PaddingLeft = pad,
								PaddingRight = pad,
								PaddingTop = UDim.new(),
								PaddingBottom = UDim.new(),
							} :: RobloxTypes.UIPaddingProperties
						)
					end
				end)(),
				Label = if isLabelMinized and not isFilled
					then React.createElement(
						TextDisplay.Full,
						{
							TextColor3 = if isTextBoxFocused or isError
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
			},
		} :: RobloxTypes.FrameProperties
	)

	local mainButtonTextBox = if isTextBoxFocused or (value and value:len() > 0)
		then React.createElement(
			"TextBox",
			{
				ref = textBoxRef,
				LayoutOrder = 2,
				RichText = true,
				Visible = value and value:len() > 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = textColor3,
				MultiLine = isMultiLine,
				TextTransparency = if isLabelMinized
					then if isEnabled then 0 else DISABLED_TEXT_TRANSPARENCY
					else 1,
				BackgroundTransparency = 1,
				Text = value or "",
				Selectable = false,
				Interactable = isTextBoxFocused,
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Typography.getTextSize(bodyFontData.Size, scale),
				LineHeight = Typography.getGuiLineHeight(
					bodyFontData.LineHeight,
					bodyFontData.Size
				),
				FontFace = bodyFontData.Font,
				Size = if not isLabelMinized or isFilled
					then UDim2.fromOffset(
						0,
						math.ceil(
							scale
								* Typography.getTextSize(bodyFontData.Size, scale)
								* Typography.getGuiLineHeight(
									bodyFontData.LineHeight,
									bodyFontData.Size
								)
						)
					)
					else UDim2.fromOffset(0, 0),
				[React.Change.Text] = function(inst: TextBox)
					if isEnabled and isTextBoxFocused then
						print(`change: {inst.Text}`)
						onChange(formatText(inst.Text))
					end
				end :: any,
				[React.Event.FocusLost] = function(_, enterPressed: boolean)
					if isEnabled then
						setIsTextBoxFocused(false)
						onSubmit(if value then formatText(value) else nil)
					end
				end :: any,
			} :: RobloxTypes.TextBoxProperties
		)
		else nil

	local mainButton = React.createElement(
		"TextButton",
		{
			LayoutOrder = 2,
			Size = UDim2.fromOffset(0, math.ceil(scale * CONTAINER_HEIGHT_DP)),
			BackgroundColor3 = backgroundColor3,
			Text = "",
			BackgroundTransparency = if not isFilled
				then 1
				elseif isEnabled then 0
				else DISABLED_BACKGROUND_TRANSPARENCY,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Event.Activated] = function()
				if isEnabled then
					setIsTextBoxFocused(not isTextBoxFocused)
				end
			end :: any,
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
		} :: RobloxTypes.TextButtonProperties,
		{
			UIStroke = React.createElement(
				"UIStroke",
				{
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = if isTextBoxFocused or isError
						then hightlightColor3
						elseif state == Enums.ButtonStateType.Hovered then textColor3
						else borderColor3,
					Enabled = not isFilled,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = if isEnabled then 0 else DISABLED_OUTLINE_TRANSPARENCY,
					Thickness = outlineThickness,
				} :: RobloxTypes.UIStrokeProperties
			),
			UICorner = React.createElement(
				"UICorner",
				{
					CornerRadius = UDim.new(0, math.ceil(scale * RADIUS_DP)),
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
			CenterContainer = React.createElement(
				Container,
				{
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.fromOffset(0, math.ceil(scale * ICON_WIDTH_DP)),
					children = {
						InputTextBox = mainButtonTextBox,
						Label = if isFilled or not isLabelMinized
							then React.createElement(
								TextDisplay.Full,
								{
									TextColor3 = if isLabelMinized
										then labelColor3
										else hightlightColor3,
									Scale = scale,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextTransparency = if isEnabled
										then 0
										else DISABLED_TEXT_TRANSPARENCY,
									FontData = labelFontData,
									Text = label,
								} :: TextDisplay.TextDisplayProperties
							)
							else nil,
						UIListLayout = React.createElement(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								Padding = UDim.new(0, 0),
								HorizontalFlex = Enum.UIFlexAlignment.Fill,
								ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
								VerticalFlex = Enum.UIFlexAlignment.None,
								Wraps = false,
							} :: RobloxTypes.UIListLayoutProperties
						),
					},
				} :: RobloxTypes.FrameProperties
			),
			RightIconIconButton = if rightIconImage
				then React.createElement("ImageButton", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,

					AutomaticSize = Enum.AutomaticSize.XY,
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

					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 0),
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					RightIcon = React.createElement(
						IconDisplay,
						{
							Icon = rightIconImage,
							IconColor3 = if isError then errorColor3 else textColor3,
							IconTransparency = if isError then 0 else 1,
							Scale = scale,
							Size = iconSize,
						} :: IconDisplay.IconDisplayProperties
					),
				})
				else nil,
			LeftIcon = if leftIcon
				then React.createElement(
					IconDisplay,
					{
						LayoutOrder = 0,
						Icon = leftIcon,
						IconColor3 = textColor3,
						IconTransparency = if isEnabled
							then 0
							else DISABLED_TEXT_TRANSPARENCY,
						Scale = scale,
						Size = iconSize,
					} :: IconDisplay.IconDisplayProperties
				)
				else nil,
			UIListLayout = React.createElement(
				"UIListLayout",
				{
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, math.ceil(scale * TEXT_AND_ICON_PADDING_DP)),
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					ItemLineAlignment = Enum.ItemLineAlignment.Center,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
					Wraps = false,
				} :: RobloxTypes.UIListLayoutProperties
			),
			UIPadding = (function(): React.ReactNode
				local pad = UDim.new(0, math.ceil(scale * TEXT_AND_ICON_PADDING_DP))
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
		}
	)

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
					UpperLabelContainer = upperLabelContainer,
					MainButton = mainButton,
					LowerContextContainer = React.createElement(Container, {
						LayoutOrder = 3,
						children = {
							UIListLayout = React.createElement(
								"UIListLayout",
								{
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									Padding = UDim.new(0, 0),
									HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
									ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
									VerticalFlex = Enum.UIFlexAlignment.None,
									Wraps = false,
								} :: RobloxTypes.UIListLayoutProperties
							),
							CharacterCount = React.createElement(
								TextDisplay.Full,
								{
									LayoutOrder = 2,
									TextColor3 = if isError
										then errorColor3
										else supportTextColor3,
									Scale = scale,
									TextTransparency = if characterLimit
										then if isEnabled
											then 0
											else DISABLED_TEXT_TRANSPARENCY
										else 1,
									FontData = supportFontData,
									TextXAlignment = Enum.TextXAlignment.Right,
									Text = if characterLimit and value
										then `{value:len()} / {characterLimit}`
										else "",
								} :: TextDisplay.TextDisplayProperties
							),
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
						},
					}),
				},
			} :: RobloxTypes.FrameProperties,
			props
		)
	)
end

return Library
