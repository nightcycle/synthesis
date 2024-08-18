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

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local RippleButton = require("../RippleButton")
	local TextDisplay = require("@comp/TextDisplay")
	local UIPadding = require("@comp/Padding")
	local Style = require("@proj/Style")
	local style = Style.new(2, Enum.Font.BuilderSans, "Dark", Color3.new(1, 0, 0))

	local function newButton()
		local isAnimated, setIsAnimated = React.useState(true)

		return ReactRoblox.createPortal(
			React.createElement(
				RippleButton,
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutoButtonColor = false,
					BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Primary),
					RippleDuration = 0.5,
					BorderSizePixel = 0,
					IsAnimated = isAnimated,
					[React.Event.Activated] = function()
						setIsAnimated(not isAnimated)
					end :: any,
					children = {
						UIListLayout = React.createElement(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, 0),
							} :: RobloxTypes.UIListLayoutProperties
						),
						UICorners = React.createElement(
							"UICorner",
							{
								CornerRadius = UDim.new(0.5, 0),
							} :: RobloxTypes.UICornerProperties
						),
						UIPadding = React.createElement(
							UIPadding.Style,
							{
								Style = style,
								LeftRightDp = 6,
								TopBottomDp = 3,
							} :: UIPadding.StylePaddingProps
						),
						Label = React.createElement(
							TextDisplay.Simple,
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								Text = if isAnimated then "Animated" else "Inanimate",
								ColorRoleType = Enums.ColorRoleType.OnPrimary,
								FontType = Enums.FontType.LabelLarge,
								Style = style,
							} :: TextDisplay.StyleTextDisplayProperties
						),
					},
				} :: RippleButton.RippleButtonProperties
			),
			target
		)
	end

	root:render(React.createElement(newButton, {}))

	return function()
		root:unmount()
		folder:Destroy()
	end
end
