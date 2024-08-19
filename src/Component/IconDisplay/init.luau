--!strict
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
local Types = require("@proj/Types")
-- Types
type ImageData = Types.ImageData
export type IconDisplayProperties = RobloxTypes.ImageLabelProperties & {
	Icon: ImageData?,
	Color: Color3?,
	Transparency: number?,
}
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(
	props: IconDisplayProperties
): React.ReactElement<RobloxTypes.ImageLabelProperties, "ImageLabel">
	local i = props.Icon
	return React.createElement(
		"ImageLabel",
		PropUtil.mergeImageLabel({
			Image = if i then i.Image else nil,
			ImageRectOffset = if i then i.ImageRectOffset else nil,
			ImageRectSize = if i then i.ImageRectSize else nil,
			BackgroundTransparency = 1,
			ImageColor3 = props.Color,
			ImageTransparency = props.Transparency,
		}, props)
	)
end
