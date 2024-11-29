--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
local MaterialIcons = require("@wally/MaterialIcons")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Types = require("@proj/Types")
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

	local Menu = require("../Menu")

	local function newPopUp()
		local Style = require("@proj/Style")
		local Theme = require("@proj/Theme")
		local Typography = require("@proj/Typography")
		local style = Style.new(
			2,
			0.5,
			true,
			Theme.new(Color3.new(1, 0, 0), "Dark", 0),
			Typography.fromFont(Enum.Font.BuilderSans)
		)
		-- Style.new(
		-- 	1,
		-- 	Enum.Font.SourceSans,
		-- 	if props.IsDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
		-- 	props.Color3
		-- )

		local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0, 0))
		local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))
		local popUpPosition = absolutePosition + absoluteSize * Vector2.new(0, 1)
		return ReactRoblox.createPortal(
			e(
				"TextButton",
				{
					Text = "Test",
					Size = UDim2.new(0, 200, 0, 40),
					Position = UDim2.fromScale(0.4, 0.5),
					BackgroundTransparency = 0.5,

					BackgroundColor3 = style.Theme.PrimaryContainer,
					TextColor3 = style.Theme.OnPrimaryContainer,
					[React.Change.AbsolutePosition] = function(inst: TextButton)
						setAbsolutePosition(inst.AbsolutePosition)
					end :: any,
					[React.Change.AbsoluteSize] = function(inst: TextButton)
						setAbsoluteSize(inst.AbsoluteSize)
					end :: any,
				} :: RobloxTypes.TextButtonProperties,
				{
					Menu = e(
						Menu,
						{
							TargetAbsolutePosition = popUpPosition,
							TargetAbsoluteWidth = absoluteSize.X,
							SurfaceColor3 = style.Theme.SurfaceContainerHigh,
							OnSurfaceColor3 = style.Theme.OnSurface,
							SelectionSurfaceColor3 = style.Theme.SecondaryContainer,
							SelectionOnSurfaceColor3 = style.Theme.OnSecondaryContainer,
							Rows = {
								[1] = Types.ButtonData.new(function()
									print("Button 1")
								end, MaterialIcons.tv, "Button 1"),
								[2] = Types.ButtonData.new(function()
									print("Button 2")
								end, nil, "Button 2"),
								[4] = Types.ButtonData.new(function()
									print("Button 3")
								end, nil, "Button 3"),
							},
						} :: Menu.MenuProperties,
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
