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

	local Circular = require("../Circular")
	local Style = require("@proj/Style")
	local Theme = require("@proj/Theme")
	local Typography = require("@proj/Typography")
	local style = Style.new(
		1,
		0.5,
		true,
		Theme.new(Color3.new(1, 0, 0), "Dark", 0),
		Typography.fromFont(Enum.Font.BuilderSans)
	)
	local function newButton(progress: number?)
		return e(
			Circular.Full,
			{
				FillColor3 = style.Theme.Primary,
				EmptyColor3 = style.Theme.PrimaryContainer,
				SchemeType = style.Theme.SchemeType,
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
			BackgroundColor3 = style.Theme.Surface,
			BackgroundTransparency = 0,
		} :: RobloxTypes.GuiObjectProperties,
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
