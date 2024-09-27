--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local PropUtil = require("@proj/PropUtil")
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")
local IconDisplay = require("@comp/IconDisplay")
local TextDisplay = require("@comp/TextDisplay")
local ButtonContainer = require("@comp/ButtonContainer")
local Style = require("@proj/Style")
local Defaults = require("./Defaults")

-- Types
type Style = Style.Style
type FontData = Types.FontData
type BaseButtonProperties = RobloxTypes.GuiButtonProperties & {
	IsEnabled: boolean?,
	Elevation: number?,
	Type: Enums.ButtonRenderType,
	Icon: Types.ImageData?,
	Text: string?,
	PaddingDp: number?,
}
export type ButtonProperties = BaseButtonProperties & {
	Scale: number?,
	FontData: FontData?,
	SchemeType: Enums.SchemeType?,
	FillColor3: Color3?,
	TextColor3: Color3,
	FillDisabledColor3: Color3?,
	TextDisabledColor3: Color3?,
	IsAnimated: boolean?,
	SoundVolume: number?,
}
export type StyleButtonProperties = BaseButtonProperties & {
	Style: Style,
	FontType: Enums.FontType?,
}

-- Constants
local ICON_DIM_DP = 16
local INNER_PAD_DP = 4
local TARGET_PAD_DP = 6
local TEXT_PAD_UPDOWN_DP = 2
local TEXT_PAD_LEFTRIGHT_DP = 6
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
local Library = {}
Library.Full = function(props: ButtonProperties): React.ReactNode
	-- unpack props
	local buttonType: Enums.ButtonRenderType = props.Type
	local icon: Types.ImageData? = props.Icon
	local text: string? = props.Text
	local fontData: FontData? = props.FontData or Defaults.FontData
	local fillColor3: Color3? = props.FillColor3 or Defaults.FillColor3
	local textColor3: Color3 = props.TextColor3 or Defaults.TextColor3
	local fillDisabledColor3: Color3? = props.FillDisabledColor3
		or Defaults.FillDisabledColor3
	local textDisabledColor3: Color3? = props.TextDisabledColor3
		or Defaults.TextDisabledColor3
	local isAnimated: boolean = if props.IsAnimated ~= nil
		then props.IsAnimated
		else Defaults.IsAnimated
	local soundVolume: number = if props.SoundVolume ~= nil
		then props.SoundVolume
		else Defaults.SoundVolume
	local isEnabled: boolean = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled
	local scale = if props.Scale ~= nil then props.Scale else Defaults.Scale
	local schemeType = if props.SchemeType ~= nil
		then props.SchemeType
		else Defaults.SchemeType
	local elevation = if props.Elevation ~= nil
		then props.Elevation
		else Defaults.Elevation
	local paddingDp = props.PaddingDp or INNER_PAD_DP
	-- process state / props
	local iconDim = math.ceil(ICON_DIM_DP * scale)
	local buttonPad = math.ceil(paddingDp * scale)
	local mergeProps: ButtonContainer.ButtonContainerProperties =
		PropUtil.mergeGuiButton({}, props) :: ButtonContainer.ButtonContainerProperties

	mergeProps.Type = buttonType
	mergeProps.Scale = scale
	mergeProps.Elevation = elevation
	mergeProps.SchemeType = schemeType
	mergeProps.FillColor3 = fillColor3
	mergeProps.LineColor3 = textColor3
	mergeProps.DisabledLineColor3 = textDisabledColor3
	mergeProps.DisabledFillColor3 = fillDisabledColor3
	mergeProps.IsAnimated = isAnimated
	mergeProps.IsEnabled = isEnabled
	mergeProps.SoundVolume = soundVolume
	mergeProps.TargetPaddingDp = TARGET_PAD_DP
	mergeProps.children = {
		UICorners = e(
			"UICorner",
			{
				CornerRadius = UDim.new(0.5, 0),
			} :: RobloxTypes.UICornerProperties
		),
		UIPadding = e(
			"UIPadding",
			{
				PaddingLeft = UDim.new(0, buttonPad),
				PaddingRight = UDim.new(0, buttonPad),
				PaddingTop = UDim.new(0, buttonPad),
				PaddingBottom = UDim.new(0, buttonPad),
			} :: RobloxTypes.UIPaddingProperties
		),
	}
	mergeProps.Content = function(
		contentProps: ButtonContainer.ButtonContainerContentProperties
	)
		return e(React.Fragment, {}, {
			Icon = if not text and icon
				then e(
					IconDisplay,
					{
						Icon = icon,
						IconColor3 = contentProps.Color3,
						IconTransparency = contentProps.Transparency,
						Size = UDim2.fromOffset(iconDim, iconDim),
						AspectType = Enum.AspectType.FitWithinMaxSize,
					} :: IconDisplay.IconDisplayProperties
				)
				else nil,
			Label = if text
				then e(
					TextDisplay.Full,
					{
						Text = text,
						TextColor3 = contentProps.Color3,
						TextTransparency = contentProps.Transparency,
						AutomaticSize = Enum.AutomaticSize.XY,
						FontData = fontData,
						Scale = scale,
						LeftIcon = icon,
						RightIcon = nil,
						IconSeparationPaddingDp = 8,
						IgnoreLineHeight = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						children = {
							UIPadding = e(
								"UIPadding",
								{
									PaddingLeft = UDim.new(
										0,
										math.ceil(TEXT_PAD_LEFTRIGHT_DP * scale)
									),
									PaddingRight = UDim.new(
										0,
										math.ceil(TEXT_PAD_LEFTRIGHT_DP * scale)
									),
									PaddingTop = UDim.new(
										0,
										math.ceil(TEXT_PAD_UPDOWN_DP * scale)
									),
									PaddingBottom = UDim.new(
										0,
										math.ceil(TEXT_PAD_UPDOWN_DP * scale)
									),
								} :: RobloxTypes.UIPaddingProperties
							),
						},
					} :: TextDisplay.TextDisplayProperties
				)
				else nil,
		})
	end
	return e(ButtonContainer, mergeProps :: ButtonContainer.ButtonContainerProperties)
end

Library.Primary = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Primary)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnPrimary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.Primary)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

Library.PrimaryContainer = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

Library.Secondary = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnSecondary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

Library.SecondaryContainer = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnSecondaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

Library.Tertiary = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnTertiary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
	else
		error(`bad type: {newProps.Type}`)
	end

	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

Library.TertiaryContainer = function(props: StyleButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: ButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.OnTertiaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.TextColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.SoundVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return e(Library.Full, newProps)
end

return Library
