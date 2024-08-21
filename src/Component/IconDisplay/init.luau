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
	IconColor3: Color3?,
	IconTransparency: number?,
}
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(props: IconDisplayProperties): React.ReactNode
	local i = props.Icon

	return React.createElement(
		"ImageLabel",
		PropUtil.mergeImageLabel({
			Image = if i then i.Image else nil,
			ImageRectOffset = if i then i.ImageRectOffset else nil,
			ImageRectSize = if i then i.ImageRectSize else nil,
			BackgroundTransparency = 1,
			ImageColor3 = props.IconColor3,
			ImageTransparency = props.IconTransparency,
			children = {
				UIAspectRatioConstraint = React.createElement(
					"UIAspectRatioConstraint",
					{
						AspectRatio = 1,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = Enum.DominantAxis.Height,
					} :: RobloxTypes.UIAspectRatioConstraintProperties
				),
			},
		}, props)
	)
end
