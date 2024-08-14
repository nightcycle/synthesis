--!strict
-- Services
-- Packages
local React = require("@node/@jsdotlua/react")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
-- Types
-- Constants
local MID_IMAGE = "http://www.roblox.com/asset/?id=16331943650"
local TOP_IMAGE = "http://www.roblox.com/asset/?id=16331984401"
local BOTTOM_IMAGE = "http://www.roblox.com/asset/?id=16331988989"
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.new(
	props: RobloxTypes.ScrollingFrameProperties
): React.ReactElement<RobloxTypes.ScrollingFrameProperties, "ScrollingFrame">
	return React.createElement(
		"ScrollingFrame",
		PropUtil.mergeScrollingFrame(
			{
				BottomImage = BOTTOM_IMAGE,
				TopImage = TOP_IMAGE,
				MidImage = MID_IMAGE,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			} :: RobloxTypes.ScrollingFrameProperties,
			props
		)
	)
end

return Util
