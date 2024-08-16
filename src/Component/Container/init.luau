--!strict
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(
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
