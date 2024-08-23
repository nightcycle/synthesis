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
local Enums = require("@proj/Enums")
local Style = require("@proj/Style")
-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local PopUpContainer = require("../PopUpContainer")

	local function newPopUp()
		local style = Style.new(
			1,
			Enum.Font.BuilderSans,
			Enums.SchemeType.Light,
			Color3.new(1, 0, 0)
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
			React.createElement(
				"TextButton",
				{
					Text = "Test",
					Size = UDim2.new(0, 200, 0, 40),
					Position = UDim2.fromScale(0.4, 0.8),
					BackgroundTransparency = 0.5,

					BackgroundColor3 = style:GetColor(
						Enums.ColorRoleType.PrimaryContainer
					),
					TextColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
					[React.Change.AbsolutePosition] = function(inst: TextButton)
						setAbsolutePosition(inst.AbsolutePosition)
					end :: any,
					[React.Change.AbsoluteSize] = function(inst: TextButton)
						setAbsoluteSize(inst.AbsoluteSize)
					end :: any,
				} :: RobloxTypes.TextButtonProperties,
				{
					PopUpContainer = React.createElement(
						PopUpContainer,
						{
							TargetAbsolutePosition = popUpPosition,
							TargetAbsoluteWidth = absoluteSize.X,
							SurfaceColor3 = style:GetColor(
								Enums.ColorRoleType.SurfaceContainerHigh
							),
							DisplayComponent = function(): React.ReactNode
								return React.createElement(
									"TextButton",
									{
										Text = "Container Content",
										Size = UDim2.new(0, 200, 0, 200),
										Position = UDim2.fromScale(0.4, 0.5),
										BackgroundTransparency = 1,
										TextColor3 = style:GetColor(
											Enums.ColorRoleType.OnSurface
										),
									} :: RobloxTypes.TextButtonProperties
								)
							end,
						} :: PopUpContainer.PopUpContainerProperties
					),
				}
			),
			target
		)
	end

	root:render(React.createElement(newPopUp, {}))

	return function()
		root:unmount()
		folder:Destroy()
	end
end
