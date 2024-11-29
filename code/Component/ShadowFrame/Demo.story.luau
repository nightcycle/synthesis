--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local ShadowFrame = require("../ShadowFrame")

	local element = e(
		ShadowFrame,
		{
			Size = UDim2.new(0, 200, 0, 200),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ShadowColor3 = Color3.new(0, 0, 0),
			ShadowTransparency = 0.6,
			ShadowCornerRadius = UDim.new(0, 10),
			Elevation = 0,
			SchemeType = nil,
		} :: ShadowFrame.ShadowFrameProperties
	)

	local portal = ReactRoblox.createPortal(element, target)
	root:render(portal)

	return function()
		root:unmount()
		folder:Destroy()
	end
end
