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
local Theme = require("@proj/Theme")
local Menu = require("@comp/Menu")
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
	IsClearButtonEnabled: boolean?,
	IsFilled: boolean?,
	Label: string?,
	CharacterLimit: number?,
	SupportingText: string?,
	ClearTextOnFocus: boolean?,
	Icon: ImageData?,
	Elevation: number?,
}
export type TextFieldProperties = BaseTextFieldProperties & {
	BorderHightlightColor3: Color3?,
	BackgroundColor3: Color3?,
	ErrorColor3: Color3?,
	BorderColor3: Color3?,
	TextColor3: Color3?,
	LabelColor3: Color3?,
	SupportingTextColor3: Color3?,
	SchemeType: Enums.SchemeType?,
	BodyFontData: FontData?,
	SupportFontData: FontData?,
	DropDownShadowColor3: Color3?,
	DropDownShadowTransparency: number?,
	Scale: number?,
	SoundVolume: number?,
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
local DROP_DOWN_ICON = MaterialIcons.arrow_drop_down
local CANCEL_ICON = MaterialIcons.cancel
local ERROR_ICON = MaterialIcons.error
-- Variables
-- References
-- Private Functions
local e = React.createElement
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
	local soundVolume: number = props.SoundVolume or Defaults.SoundVolume
	if dropDownOptions and #dropDownOptions == 0 then
		dropDownOptions = nil
	end

	local rawBorderHightlightColor3: Color3 = props.BorderHightlightColor3
		or Defaults.BorderHightlightColor3
	local rawBackgroundColor3: Color3 = props.BackgroundColor3 :: Color3
		or Defaults.BackgroundColor3
	local rawErrorColor3: Color3 = props.ErrorColor3 or Defaults.ErrorColor3
	local rawBorderColor3: Color3 = props.BorderColor3 :: Color3 or Defaults.BorderColor3
	local rawTextColor3: Color3 = props.TextColor3 or Defaults.TextColor3
	local rawLabelColor3: Color3 = props.LabelColor3 or Defaults.LabelColor3
	local rawSupportTextColor3: Color3 = props.SupportingTextColor3
		or Defaults.SupportingTextColor3
	local rawDropDownShadowColor3: Color3? = props.DropDownShadowColor3
	local dropShadowTransparency: number? = props.DropDownShadowTransparency
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
	local isClearButtonEnabled: boolean = if props.IsClearButtonEnabled ~= nil
		then props.IsClearButtonEnabled
		else Defaults.IsClearButtonEnabled

	-- set up state
	local isHovered, setIsHovered = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local isFocused, setIsFocused = React.useState(false)
	local isTextBoxFocused, setIsTextBoxFocused = React.useState(false)
	local isDropDownOpen, setIsDropDownOpen = React.useState(false)
	local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))
	local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0, 0))

	local textBoxRef = React.useRef(nil :: TextBox?)
	if isTextBoxFocused then
		local textBox = textBoxRef.current
		if typeof(textBox) == "Instance" and textBox:IsA("TextBox") then
			textBox:CaptureFocus()
		end
	end

	-- process colors
	local borderHightlightColor3 =
		Theme.getElevatedColor(rawBorderHightlightColor3, elevation, schemeType)
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
		then ERROR_ICON
		elseif
			isClearButtonEnabled
			and value
			and value:len() > 0
			and not isTextBoxFocused
		then CANCEL_ICON
		elseif dropDownOptions then DROP_DOWN_ICON
		else nil
	local bottomLineThickness =
		math.max(math.ceil((if isTextBoxFocused then 1 else 0.5) * outlineThickness), 1)

	-- internal functions
	local function formatText(input: string): string
		if characterLimit then
			input = input:sub(1, characterLimit)
		end
		return input
	end
	value = value and formatText(value)

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
	local upperLabelContainer = e(
		Container,
		{
			LayoutOrder = 1,
			children = {
				UIListLayout = e(
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
						return e(
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
						return e(
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
				Label = if not isFilled
					then e(
						TextDisplay.Full,
						{
							TextColor3 = if isTextBoxFocused
								then borderHightlightColor3
								elseif isError then errorColor3
								else borderHightlightColor3,
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
		} :: RobloxTypes.GuiObjectProperties
	)

	local mainButtonTextBox = if isTextBoxFocused or (value and value:len() > 0)
		then e(
			"TextBox",
			{
				ref = textBoxRef,
				LayoutOrder = 2,
				RichText = true,
				Visible = (value and value:len() > 0) or isTextBoxFocused,
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
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTruncate = if isTextBoxFocused
					then Enum.TextTruncate.None
					else Enum.TextTruncate.AtEnd,
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
						local text = formatText(inst.Text)
						if text ~= value then
							onChange(text)
						end
						inst.Text = text
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

	local buttonInternals = e(React.Fragment, {}, {
		DropDown = if dropDownOptions and isDropDownOpen
			then e(
				Menu,
				{
					TargetAbsolutePosition = absolutePosition
						+ Vector2.new(0, absoluteSize.Y),
					TargetAbsoluteWidth = absoluteSize.X,
					SurfaceColor3 = backgroundColor3,
					OnSurfaceColor3 = textColor3,
					SelectionSurfaceColor3 = backgroundColor3,
					SelectionOnSurfaceColor3 = borderHightlightColor3,
					FontData = bodyFontData,
					Elevation = elevation,
					SchemeType = schemeType,
					SoundVolume = soundVolume,
					DropDownShadowColor3 = rawDropDownShadowColor3,
					DropDownShadowTransparency = dropShadowTransparency,
					OnCursorExit = function()
						setIsDropDownOpen(false)
					end,
					Rows = (function(): { [number]: Types.ButtonData }
						local rows: { [number]: Types.ButtonData } = {}
						for i, option in ipairs(dropDownOptions) do
							if value ~= option then
								table.insert(
									rows,
									Types.ButtonData.new(function()
										onChange(option)
										onSubmit(option)
										setIsDropDownOpen(false)
									end, nil, option)
								)
							end
						end
						return rows
					end)(),
				} :: Menu.MenuProperties
			)
			else nil,
		CenterContainer = e(
			Container,
			{
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, math.ceil(scale * ICON_WIDTH_DP)),
				ClipsDescendants = true,
				children = {
					InputTextBox = mainButtonTextBox,
					Label = if isFilled or not isLabelMinized
						then e(
							TextDisplay.Full,
							{
								TextColor3 = if isLabelMinized and isFilled
									then borderHightlightColor3
									else labelColor3,
								Scale = scale,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = if isLabelMinized
									then Enum.TextYAlignment.Bottom
									else Enum.TextYAlignment.Center,
								TextTransparency = if isEnabled
									then 0
									else DISABLED_TEXT_TRANSPARENCY,
								FontData = if isLabelMinized
									then supportFontData
									else labelFontData,
								Text = label,
							} :: TextDisplay.TextDisplayProperties
						)
						else nil,
					UIListLayout = e(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							Padding = UDim.new(0, 0),
							HorizontalFlex = Enum.UIFlexAlignment.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					-- UIFlexItem = e(
					-- 	"UIFlexItem",
					-- 	{
					-- 		FlexMode = Enum.UIFlexMode.Fill,
					-- 		ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
					-- 	} :: RobloxTypes.UIFlexItemProperties
					-- ),
				},
			} :: RobloxTypes.GuiObjectProperties
		),
		DropDownIconButton = if rightIconImage == DROP_DOWN_ICON
			then e("ImageButton", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,

				AutomaticSize = Enum.AutomaticSize.XY,
				[React.Event.Activated] = function()
					setIsDropDownOpen(true)
				end :: any,
			}, {

				UIListLayout = e(
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
				UIAspectRatioConstraint = e(
					"UIAspectRatioConstraint",
					{
						AspectRatio = 1,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Height,
					} :: RobloxTypes.UIAspectRatioConstraintProperties
				),
				Icon = if rightIconImage
					then e(
						IconDisplay,
						{
							Icon = rightIconImage,
							IconColor3 = textColor3,
							IconTransparency = if isEnabled
								then 0
								else DISABLED_TEXT_TRANSPARENCY,
							Scale = scale,
							Size = iconSize,
						} :: IconDisplay.IconDisplayProperties
					)
					else nil,
			})
			else nil,
		ClearIconButton = if rightIconImage == CANCEL_ICON
			then e("ImageButton", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,

				AutomaticSize = Enum.AutomaticSize.XY,
				[React.Event.Activated] = function()
					if value then
						onChange("")
					end
				end :: any,
			}, {

				UIListLayout = e(
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
				UIAspectRatioConstraint = e(
					"UIAspectRatioConstraint",
					{
						AspectRatio = 1,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Height,
					} :: RobloxTypes.UIAspectRatioConstraintProperties
				),
				Icon = if rightIconImage
					then e(
						IconDisplay,
						{
							Icon = rightIconImage,
							IconColor3 = textColor3,
							IconTransparency = if isEnabled
								then 0
								else DISABLED_TEXT_TRANSPARENCY,
							Scale = scale,
							Size = iconSize,
						} :: IconDisplay.IconDisplayProperties
					)
					else nil,
			})
			else nil,
		ErrorIcon = if rightIconImage == ERROR_ICON
			then e(
				IconDisplay,
				{
					LayoutOrder = 3,
					Icon = rightIconImage,
					IconColor3 = textColor3,
					IconTransparency = if isEnabled
						then 0
						else DISABLED_TEXT_TRANSPARENCY,
					Scale = scale,
					Size = iconSize,
				} :: IconDisplay.IconDisplayProperties
			)
			else nil,
		LeftIcon = if leftIcon
			then e(
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
		UIListLayout = e(
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
			local zero = UDim.new(0, 0)
			return e(
				"UIPadding",
				{
					PaddingLeft = pad,
					PaddingRight = pad,
					PaddingTop = zero,
					PaddingBottom = zero,
				} :: RobloxTypes.UIPaddingProperties
			)
		end)(),
	})

	local mainButton = e(
		"TextButton",
		{
			LayoutOrder = 2,
			Size = UDim2.fromOffset(
				0,
				math.ceil(scale * CONTAINER_HEIGHT_DP)
					- if isFilled then bottomLineThickness else 0
			),
			BackgroundColor3 = backgroundColor3,
			Text = "",
			BackgroundTransparency = if not isFilled
				then 1
				elseif isEnabled then 0
				else DISABLED_BACKGROUND_TRANSPARENCY,
			[React.Event.Activated] = function()
				if isEnabled then
					if not isTextBoxFocused and isClearTextOnFocus then
						onChange("")
					end
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
			[React.Change.AbsoluteSize] = if dropDownOptions
				then function(inst: TextButton)
					setAbsoluteSize(inst.AbsoluteSize)
				end :: any
				else nil,
			[React.Change.AbsolutePosition] = if dropDownOptions
				then function(inst: TextButton)
					setAbsolutePosition(inst.AbsolutePosition)
				end :: any
				else nil,
		} :: RobloxTypes.TextButtonProperties,
		{
			UIStroke = e(
				"UIStroke",
				{
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = if isTextBoxFocused or isError
						then borderHightlightColor3
						elseif state == Enums.ButtonStateType.Hovered then textColor3
						else borderColor3,
					Enabled = not isFilled,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = if isEnabled then 0 else DISABLED_OUTLINE_TRANSPARENCY,
					Thickness = outlineThickness,
				} :: RobloxTypes.UIStrokeProperties
			),
			UICorner = e(
				"UICorner",
				{
					CornerRadius = UDim.new(0, math.ceil(scale * RADIUS_DP)),
				} :: RobloxTypes.UICornerProperties
			),
			UISizeConstraint = e(
				"UISizeConstraint",
				{
					MinSize = Vector2.new(
						math.ceil((scale * MIN_WIDTH_DP) + iconAddedWidth),
						0
					),
				} :: RobloxTypes.UISizeConstraintProperties
			),
			Internals = if not isFilled
				then buttonInternals
				else e(
					Container,
					{
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						children = {
							OutlineInternals = buttonInternals,
							UIFlexItem = e(
								"UIFlexItem",
								{
									FlexMode = Enum.UIFlexMode.Fill,
									ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
								} :: RobloxTypes.UIFlexItemProperties
							),
						},
					} :: RobloxTypes.GuiObjectProperties
				),
			FilledButtonListLayout = if isFilled
				then e(
					"UIListLayout",
					{
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 0),
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
						VerticalFlex = Enum.UIFlexAlignment.None,
						Wraps = false,
					} :: RobloxTypes.UIListLayoutProperties
				)
				else nil,
			BottomLine = if isFilled
				then e(
					"Frame",
					{
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						-- Visible = isTextBoxFocused or isError,
						LayoutOrder = 2,
						BackgroundColor3 = if isError
							then errorColor3
							else borderHightlightColor3,
						Size = UDim2.new(0, 0, 0, bottomLineThickness),
					} :: RobloxTypes.GuiObjectProperties
				)
				else nil,
			-- TopLine = if isFilled
			-- 	then e(
			-- 		"Frame",
			-- 		{
			-- 			BorderSizePixel = 0,
			-- 			AutomaticSize = Enum.AutomaticSize.X,
			-- 			BackgroundTransparency = 1,
			-- 			-- Visible = isTextBoxFocused or isError,
			-- 			LayoutOrder = 0,
			-- 			Size = UDim2.new(0, 0, 0, bottomLineThickness),
			-- 		} :: RobloxTypes.GuiObjectProperties
			-- 	)
			-- 	else nil,
		}
	)

	return e(
		Container,
		PropUtil.mergeGuiObject(
			{

				children = {
					UIListLayout = e(
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
							HorizontalFlex = Enum.UIFlexAlignment.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					UpperLabelContainer = upperLabelContainer,
					MainButton = mainButton,
					LowerContextContainer = e(Container, {
						LayoutOrder = 3,
						children = {
							UIListLayout = e(
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
							CharacterCount = e(
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
							SupportingText = e(
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
			} :: RobloxTypes.GuiObjectProperties,
			props
		)
	)
end

function Library._OnSurfaceHighlightColor(
	props: StyleTextFieldProperties,
	colorRole: Enums.ColorRoleType
): React.ReactNode
	local style = props.Style

	local newProps = table.clone(props) :: TextFieldProperties;
	(newProps :: any).Style = nil
	newProps.SchemeType = style.SchemeType
	newProps.Scale = style.Scale
	newProps.BorderHightlightColor3 = style:GetColor(colorRole)
	newProps.BackgroundColor3 = style:GetColor(Enums.ColorRoleType.SurfaceContainer)
	newProps.ErrorColor3 = style:GetColor(Enums.ColorRoleType.Error)
	newProps.BorderColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.LabelColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.SupportingTextColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.BodyFontData = style:GetFontData(Enums.FontType.BodyLarge)
	newProps.SupportFontData = style:GetFontData(Enums.FontType.LabelSmall)
	newProps.DropDownShadowColor3 = style:GetColor(Enums.ColorRoleType.Shadow)
	newProps.DropDownShadowTransparency = nil
	newProps.SoundVolume = style.Volume

	return e(Library.Full, newProps)
end

function Library.Primary(props: StyleTextFieldProperties): React.ReactNode
	return Library._OnSurfaceHighlightColor(props, Enums.ColorRoleType.Primary)
end

function Library.Secondary(props: StyleTextFieldProperties): React.ReactNode
	return Library._OnSurfaceHighlightColor(props, Enums.ColorRoleType.Secondary)
end

function Library.Tertiary(props: StyleTextFieldProperties): React.ReactNode
	return Library._OnSurfaceHighlightColor(props, Enums.ColorRoleType.Tertiary)
end

return Library
