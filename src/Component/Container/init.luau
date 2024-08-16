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
	local newProps = PropUtil.mergeFrame({
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, props)
	if props.BackgroundTransparency then
		newProps.BackgroundTransparency = props.BackgroundTransparency
	end
	if props.BorderSizePixel then
		newProps.BorderSizePixel = props.BorderSizePixel
	end
	if props.Size then
		newProps.Size = props.Size
	end
	if props.AutomaticSize then
		newProps.AutomaticSize = props.AutomaticSize
	end
	return React.createElement("Frame", newProps)
end
