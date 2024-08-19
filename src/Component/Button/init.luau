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
	FontData: FontData?,
}
export type ButtonProperties = BaseButtonProperties & {
	Scale: number?,
	SchemeType: Enums.SchemeType?,
	FillColor3: Color3?,
	TextColor3: Color3,
	FillDisabledColor3: Color3?,
	TextDisabledColor3: Color3?,
	IsAnimated: boolean?,
	ClickVolume: number?,
}
export type StyleButtonProperties = BaseButtonProperties & {
	Style: Style,
	FontType: Enums.FontType?,
}

-- Constants
local ICON_DIM_DP = 24
local BUTTON_PAD_DP = math.ceil((40 - ICON_DIM_DP) / 2)
local TARGET_PAD_DP = math.ceil((48 - (ICON_DIM_DP + 2 * BUTTON_PAD_DP)) / 2)
local TEXT_PAD_UPDOWN_DP = 3
local TEXT_PAD_LEFTRIGHT_DP = 8
-- Variables
-- References
-- Private Functions

-- Class
local Library = {}
Library.Full = function(props: ButtonProperties): React.ReactElement<
	ButtonContainer.ButtonContainerProperties,
	typeof(ButtonContainer)
>
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
	local clickVolume: number = if props.ClickVolume ~= nil
		then props.ClickVolume
		else Defaults.ClickVolume
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

	-- process state / props
	local iconDim = math.ceil(ICON_DIM_DP * scale)
	local iconPad = math.ceil(BUTTON_PAD_DP * scale)
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
	mergeProps.ClickVolume = clickVolume
	mergeProps.TargetPaddingDp = TARGET_PAD_DP
	mergeProps.children = {
		UICorners = React.createElement(
			"UICorner",
			{
				CornerRadius = UDim.new(0.5, 0),
			} :: RobloxTypes.UICornerProperties
		),
		UIPadding = React.createElement(
			"UIPadding",
			{
				PaddingLeft = UDim.new(0, iconPad),
				PaddingRight = UDim.new(0, iconPad),
				PaddingTop = UDim.new(0, iconPad),
				PaddingBottom = UDim.new(0, iconPad),
			} :: RobloxTypes.UIPaddingProperties
		),
	}
	mergeProps.Content = function(
		contentProps: ButtonContainer.ButtonContainerContentProperties
	)
		return React.createElement(React.Fragment, {}, {
			Icon = if not text and icon
				then React.createElement(
					IconDisplay,
					{
						Icon = icon,
						IconColor3 = contentProps.Color3,
						IconTransparency = contentProps.Transparency,
						Size = UDim2.fromOffset(iconDim, iconDim),
					} :: IconDisplay.IconDisplayProperties
				)
				else nil,
			Label = if text
				then React.createElement(
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
						IconSeparationPaddingDp = nil,
						IgnoreLineHeight = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						children = {
							UIPadding = React.createElement(
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
	return React.createElement(
		ButtonContainer,
		mergeProps :: ButtonContainer.ButtonContainerProperties
	)
end

Library.OnSurfacePrimary = function(props: StyleButtonProperties)
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
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfacePrimaryContainer = function(props: StyleButtonProperties)
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
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceSecondary = function(props: StyleButtonProperties)
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
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceSecondaryContainer = function(props: StyleButtonProperties)
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
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceTertiary = function(props: StyleButtonProperties)
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
		print(newProps.TextColor3:ToHex())
	else
		error(`bad type: {newProps.Type}`)
	end

	newProps.TextDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceTertiaryContainer = function(props: StyleButtonProperties)
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
	newProps.ClickVolume = style.Volume
	newProps.FontData = if props.FontType then style:GetFontData(props.FontType) else nil

	return React.createElement(Library.Full, newProps)
end

return Library
