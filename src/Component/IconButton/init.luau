--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
local CurveUtil = require("@wally/CurveUtil")
-- Modules
local PropUtil = require("@proj/PropUtil")
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")
local Sounds = require("@proj/Sounds")
local Types = require("@proj/Types")
local IconDisplay = require("@comp/IconDisplay")
local ButtonContainer = require("@comp/ButtonContainer")
local Style = require("@proj/Style")
local Defaults = require("./Defaults")

-- Types
type Style = Style.Style
type BaseIconButtonProperties = RobloxTypes.GuiButtonProperties & {
	IsEnabled: boolean?,
	Elevation: number?,
	Type: Enums.ButtonRenderType,
	Icon: Types.ImageData,
}
export type IconButtonProperties = BaseIconButtonProperties & {
	Scale: number?,
	SchemeType: Enums.SchemeType?,
	FillColor3: Color3?,
	IconColor3: Color3,
	FillDisabledColor3: Color3?,
	IconDisabledColor3: Color3?,
	IsAnimated: boolean?,
	ClickVolume: number?,
}
export type StyleIconButtonProperties = BaseIconButtonProperties & {
	Style: Style,
}

-- Constants
local ICON_DIM_DP = 24
local BUTTON_PAD_DP = math.ceil((40 - ICON_DIM_DP) / 2)
local TARGET_PAD_DP = math.ceil((48 - (ICON_DIM_DP + 2 * BUTTON_PAD_DP)) / 2)
-- Variables
-- References
-- Private Functions

-- Class
local Library = {}
Library.Full = function(props: IconButtonProperties): React.ReactElement<
	ButtonContainer.ButtonContainerProperties,
	typeof(ButtonContainer)
>
	-- unpack props
	local buttonType: Enums.ButtonRenderType = props.Type
	local fillColor3: Color3? = props.FillColor3 or Defaults.FillColor3
	local iconColor3: Color3 = props.IconColor3 or Defaults.IconColor3
	local fillDisabledColor3: Color3? = props.FillDisabledColor3
		or Defaults.FillDisabledColor3
	local iconDisabledColor3: Color3? = props.IconDisabledColor3
		or Defaults.IconDisabledColor3
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
	mergeProps.LineColor3 = iconColor3
	mergeProps.DisabledLineColor3 = iconDisabledColor3
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
		return React.createElement(
			IconDisplay,
			{
				Icon = props.Icon,
				IconColor3 = contentProps.Color3,
				IconTransparency = contentProps.Transparency,
				Size = UDim2.fromOffset(iconDim, iconDim),
			} :: IconDisplay.IconDisplayProperties
		)
	end
	return React.createElement(
		ButtonContainer,
		mergeProps :: ButtonContainer.ButtonContainerProperties
	)
end

Library.OnSurfacePrimary = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Primary)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnPrimary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.Primary)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfacePrimaryContainer = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceSecondary = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnSecondary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceSecondaryContainer = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnSecondaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceTertiary = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnTertiary)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

Library.OnSurfaceTertiaryContainer = function(props: StyleIconButtonProperties)
	local style = props.Style

	local newProps = table.clone(props) :: IconButtonProperties;
	(newProps :: any).Style = nil
	newProps.Scale = style.Scale
	newProps.SchemeType = style.SchemeType
	if newProps.Type == Enums.ButtonRenderType.Filled then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.OnTertiaryContainer)
	elseif
		newProps.Type == Enums.ButtonRenderType.Outlined
		or newProps.Type == Enums.ButtonRenderType.TextIcon
	then
		newProps.FillColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
		newProps.IconColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
	else
		error(`bad type: {newProps.Type}`)
	end
	newProps.IconDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.FillDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface)
	newProps.IsAnimated = style.IsAnimated
	newProps.ClickVolume = style.Volume

	return React.createElement(Library.Full, newProps)
end

return Library
