--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local Types = require("@proj/Types")
local RobloxTypes = require("@proj/RobloxTypes")
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local Typography = require("@proj/Typography")
local PropUtil = require("@proj/PropUtil")
-- Types
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData
type TextDisplayProperties = RobloxTypes.FrameProperties & {
	Text: string?,
	TextColor3: Color3?,
	TextTransparency: number?,
	FontData: FontData?,
	Scale: number?,
	LeftIcon: ImageData?,
	RightIcon: ImageData?,
	PaddingDp: number?,
	IgnoreLineHeight: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
}
type StyleTextDisplayProperties = RobloxTypes.TextLabelProperties & {
	Text: string?,
	ColorRoleType: Enums.ColorRoleType,
	FontType: Enums.FontType,
	Style: Style,
	Elevation: number?,
}
-- Constants
-- Variables
-- References
-- Private Functions
function newTextIcon(
	icon: ImageData,
	layoutOrder: number,
	size: UDim2,
	color3: Color3,
	transparency: number
): React.ReactElement<RobloxTypes.ImageLabelProperties, "ImageLabel">
	return React.createElement(
		"ImageLabel",
		{
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Image = icon.Image,
			ImageColor3 = color3,
			ImageRectOffset = icon.ImageRectOffset,
			ImageRectSize = icon.ImageRectSize,
			ImageTransparency = transparency,
			Size = size,
		} :: RobloxTypes.ImageLabelProperties
	)
end
-- Class
local Util = {}

function Util.new(
	props: TextDisplayProperties
): React.ReactElement<RobloxTypes.FrameProperties, "Frame">
	local scale: number = props.Scale or 1
	local fontData: FontData = props.FontData
		or Types.FontData.new(Font.fromEnum(Enum.Font.BuilderSans), 14, 1.5)

	local leftIcon: ImageData? = props.LeftIcon or nil
	local rightIcon: ImageData? = props.RightIcon or nil

	local text: string = props.Text or ""
	local textColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	local textTransparency = props.TextTransparency or 0
	local textXAlignment: Enum.TextXAlignment? = props.TextXAlignment

	local ignoreLineHeight = if props.IgnoreLineHeight ~= nil
		then props.IgnoreLineHeight
		else false

	local paddingDp = props.PaddingDp or 2

	local iconSize: UDim2
	do
		local baseDp = if ignoreLineHeight
			then 1
			else Typography.getGuiLineHeight(fontData.LineHeight, fontData.Size)
		local dp = baseDp * Typography.getTextSize(fontData.Size, scale)
		iconSize = UDim2.fromOffset(dp, dp)
	end
	return React.createElement(
		"Frame",
		PropUtil.mergeFrame({} :: RobloxTypes.FrameProperties, props),
		{
			UIListLayout = React.createElement(
				"UIListLayout",
				{
					Padding = UDim.new(0, paddingDp * scale),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					ItemLineAlignment = Enum.ItemLineAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
				} :: RobloxTypes.UIListLayoutProperties
			),
			Label = React.createElement(
				"TextLabel",
				{
					Text = text,
					RichText = true,
					LayoutOrder = 1,
					Visible = text:len() > 0,
					TextColor3 = textColor3,
					TextTransparency = textTransparency,
					BackgroundTransparency = 1,
					TextXAlignment = if textXAlignment
						then textXAlignment
						elseif leftIcon then Enum.TextXAlignment.Center
						else Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Typography.getTextSize(fontData.Size, scale),
					LineHeight = Typography.getGuiLineHeight(
						fontData.LineHeight,
						fontData.Size
					),
					FontFace = fontData.Font,
					Size = UDim2.fromOffset(
						0,
						(
							if ignoreLineHeight
								then 1
								else Typography.getGuiLineHeight(
									fontData.LineHeight,
									fontData.Size
								)
						) * Typography.getTextSize(fontData.Size, scale)
					),
				} :: RobloxTypes.TextLabelProperties
			),
			LeftIcon = if leftIcon
				then newTextIcon(leftIcon, 0, iconSize, textColor3, textTransparency)
				else nil,
			RightIcon = if rightIcon
				then newTextIcon(rightIcon, 2, iconSize, textColor3, textTransparency)
				else nil,
		}
	)
end

function Util.fromStyleSimple(props: StyleTextDisplayProperties): React.ReactElement<
	RobloxTypes.TextLabelProperties,
	"TextLabel"
>
	local fontType: Enums.FontType = props.FontType
	local fontData = props.Style:GetFontData(fontType)
	return React.createElement(
		"TextLabel",
		PropUtil.mergeTextLabel(
			{
				Text = props.Text,
				TextColor3 = props.Style:GetColor(props.ColorRoleType),
				BackgroundTransparency = 1,
				TextSize = Typography.getTextSize(fontData.Size, 1),
				LineHeight = Typography.getGuiLineHeight(
					fontData.LineHeight,
					fontData.Size
				),
				FontFace = fontData.Font,
			} :: RobloxTypes.TextLabelProperties,
			props
		)
	)
end

return Util
