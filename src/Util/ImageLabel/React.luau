--!strict
-- Services
-- Packages
local React = require("@Packages/React")
-- Modules
local RobloxTypes = require("@Project/RobloxTypes")
local PropUtil = require("@Project/PropUtil")
local Types = require("@Project/Types")
-- Types
type ImageData = Types.ImageData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.new(props: RobloxTypes.ImageLabelProperties & {
	Icon: ImageData?,
	Color: Color3?,
	Transparency: number?,
}): React.ReactElement<RobloxTypes.ImageLabelProperties, "ImageLabel">
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

return Util
