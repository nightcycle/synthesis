--!strict
-- Services
-- Packages
local React = require("@Packages/React")
-- Modules
local RobloxTypes = require("@Project/RobloxTypes")
local PropUtil = require("@Project/PropUtil")
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.new(
	props: RobloxTypes.FrameProperties
): React.ReactElement<RobloxTypes.FrameProperties, "Frame">
	return React.createElement(
		"Frame",
		PropUtil.mergeFrame({
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, props)
	)
end

return Util
