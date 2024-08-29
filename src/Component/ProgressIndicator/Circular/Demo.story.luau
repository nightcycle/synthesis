--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")

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

	local Circular = require("../Circular")
	local Style = require("@proj/Style")
	local style = Style.new(2, Enum.Font.BuilderSans, "Dark", Color3.new(1, 0, 0))

	local function newButton(progress: number?)
		return e(
			Circular.Full,
			{
				FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
				EmptyColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
				SchemeType = style.SchemeType,
				Scale = style.Scale,
				Progress = progress,
				IsEnabled = true,
				Elevation = 0,
			} :: Circular.ProgressIndicatorCircularProperties
		)
	end

	local element = e(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
			BackgroundTransparency = 0,
		} :: RobloxTypes.FrameProperties,
		{

			P25 = newButton(0.25),
			-- P66 = newButton(0.66),
			-- PINF = newButton(nil),
			UIListLayout = e(
				"UIListLayout",
				{
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, math.round(30 * style.Scale)),
				} :: RobloxTypes.UIListLayoutProperties
			),
		}
	)

	local portal = ReactRoblox.createPortal(element, target)
	root:render(portal)

	return function()
		root:unmount()
		folder:Destroy()
	end
end
