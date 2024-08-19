--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
local MaterialIcons = require("@wally/MaterialIcons")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local IconButton = require("../Button")
	local Style = require("@proj/Style")
	local style = Style.new(2, Enum.Font.BuilderSans, "Dark", Color3.new(1, 0, 0))

	local function newButton(renderType: Enums.ButtonRenderType)
		local lineColorRole = if renderType == Enums.ButtonRenderType.Filled
			then Enums.ColorRoleType.OnPrimary
			else Enums.ColorRoleType.OnSurface
		return React.createElement(
			IconButton.Full,
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Type = renderType,
				
				FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
				IconColor3 = style:GetColor(lineColorRole),
				Icon = MaterialIcons.watch_later,
				IsAnimated = true,
				[React.Event.Activated] = function()
					print(`click "{renderType}"`)
				end :: any,
			} :: IconButton.ButtonProperties
		)
	end

	local element = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
	}, {

		FilledButton = newButton(Enums.ButtonRenderType.Filled),
		OutlinedButton = newButton(Enums.ButtonRenderType.Outlined),
		TextButton = newButton(Enums.ButtonRenderType.TextIcon),
		UIListLayout = React.createElement(
			"UIListLayout",
			{
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, math.round(10 * style.Scale)),
			} :: RobloxTypes.UIListLayoutProperties
		),
	})

	local portal = ReactRoblox.createPortal(element, target)
	root:render(portal)

	return function()
		root:unmount()
		folder:Destroy()
	end
end
