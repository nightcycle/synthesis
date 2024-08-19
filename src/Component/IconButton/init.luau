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
-- Types
export type IconButtonProperties = RobloxTypes.GuiButtonProperties & {
	Type: Enums.ButtonRenderType,
	Icon: Types.ImageData,
	Scale: number?,
	Elevation: number?,
	SchemeType: Enums.SchemeType?,
	FillColor3: Color3?,
	IconColor3: Color3,
	DisabledColor3: Color3?,
	IsAnimated: boolean?,
	IsEnabled: boolean?,
	ClickVolume: number?,
}
-- Constants
local ICON_DIM_DP = 24
local BUTTON_PAD_DP = math.ceil((40 - ICON_DIM_DP) / 2)
local TARGET_PAD_DP = math.ceil((48 - ICON_DIM_DP) / 2)
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
	local fillColor3: Color3? = props.FillColor3
	local iconColor3: Color3 = props.IconColor3
	local isAnimated: boolean = if props.IsAnimated ~= nil then props.IsAnimated else true
	local clickVolume: number = if props.ClickVolume ~= nil
		then props.ClickVolume
		else 0.5
	local isEnabled: boolean = if props.IsEnabled ~= nil then props.IsEnabled else true
	local scale = if props.Scale ~= nil then props.Scale else 1
	local schemeType = if props.SchemeType ~= nil
		then props.SchemeType
		else Enums.SchemeType.Light
	local elevation = if props.Elevation ~= nil then props.Elevation else 0

	-- process state / props
	local iconDim = math.ceil(ICON_DIM_DP * scale)

	local mergeProps: ButtonContainer.ButtonContainerProperties =
		PropUtil.mergeGuiButton({}, props) :: ButtonContainer.ButtonContainerProperties

	mergeProps.Type = buttonType
	mergeProps.Scale = scale
	mergeProps.Elevation = elevation
	mergeProps.SchemeType = schemeType
	mergeProps.FillColor3 = fillColor3
	mergeProps.LineColor3 = iconColor3
	mergeProps.DisabledLineColor3 = props.DisabledColor3
	mergeProps.IsAnimated = isAnimated
	mergeProps.IsEnabled = isEnabled
	mergeProps.ClickVolume = clickVolume
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
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
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
				Color = contentProps.Color3,
				Transparency = contentProps.Transparency,
				Size = UDim2.fromOffset(iconDim, iconDim),
			} :: IconDisplay.IconDisplayProperties
		)
	end
	return React.createElement(
		ButtonContainer,
		mergeProps :: ButtonContainer.ButtonContainerProperties
	)
end

return Library
