--!strict
-- Services
-- Packages
local React = require("@Package/React")
-- Modules
local RobloxTypes = require("@Project/RobloxTypes")
local Types = require("@Project/Types")
local Style = require("@Project/Style")
-- Types
type ImageData = Types.ImageData
type Style = Style.Style
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.fromStyle(props: {
	LeftRightDp: number,
	TopBottomDp: number,
	Style: Style,
}): React.ReactElement<RobloxTypes.UIPaddingProperties, "UIPadding">
	local leftRight = UDim.new(0, math.round(props.LeftRightDp * props.Style.Scale))
	local topBottom = UDim.new(0, math.round(props.TopBottomDp * props.Style.Scale))

	return React.createElement(
		"UIPadding",
		{
			PaddingTop = topBottom,
			PaddingBottom = topBottom,
			PaddingLeft = leftRight,
			PaddingRight = leftRight,
		} :: RobloxTypes.UIPaddingProperties
	)
end

function Util.fromStyleSimple(props: {
	PaddingDp: number,
	Style: Style,
}): React.ReactElement<RobloxTypes.UIPaddingProperties, "UIPadding">
	local padding = UDim.new(0, math.round(props.PaddingDp * props.Style.Scale))

	return React.createElement(
		"UIPadding",
		{
			PaddingTop = padding,
			PaddingBottom = padding,
			PaddingLeft = padding,
			PaddingRight = padding,
		} :: RobloxTypes.UIPaddingProperties
	)
end

return Util
