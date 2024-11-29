--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
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

	local PopUp = require("../PopUp")

	local function newPopUp()
		local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0, 0))
		local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))
		local popUpPosition = absolutePosition + absoluteSize * Vector2.new(0.5, 1)
		return ReactRoblox.createPortal(
			e(
				"TextButton",
				{
					Text = "Test",
					Size = UDim2.new(0, 100, 0, 100),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					[React.Change.AbsolutePosition] = function(inst: TextButton)
						setAbsolutePosition(inst.AbsolutePosition)
					end :: any,
					[React.Change.AbsoluteSize] = function(inst: TextButton)
						setAbsoluteSize(inst.AbsoluteSize)
					end :: any,
				} :: RobloxTypes.TextButtonProperties,
				{
					PopUp = e(
						PopUp,
						{
							TargetAbsolutePosition = popUpPosition,
							DisplayAnchorPoint = Vector2.new(0.5, 0),
							DisplayComponent = function(): React.ReactNode
								return e(
									"TextLabel",
									{
										Text = "Label",
										Size = UDim2.new(0, 100, 0, 100),
										BackgroundColor3 = Color3.fromRGB(0, 255, 0),
									} :: RobloxTypes.TextLabelProperties
								)
							end,
						} :: PopUp.PopUpProperties,
						{}
					),
				}
			),
			target
		)
	end

	root:render(e(newPopUp, {}))

	return function()
		root:unmount()
		folder:Destroy()
	end
end
