--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
local MaterialIcons = require("@wally/MaterialIcons")

-- Modules
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local RobloxTypes = require("@proj/RobloxTypes")
local Container = require("@comp/Container")
local TextDisplay = require("@comp/TextDisplay")

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	task.spawn(function()
		local Interface = require("../IconButton")

		local function halfFrame(
			props: RobloxTypes.FrameProperties & {
				Color3: Color3,
				IsDarkMode: boolean,
			}
		): React.ReactElement<RobloxTypes.FrameProperties, "Frame">
			local style = Style.new(
				1,
				Enum.Font.SourceSans,
				if props.IsDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				props.Color3
			)

			local function newThemeBlock(
				name: string,
				backgroundRole: Enums.ColorRoleType
			)
				local comp: typeof(Interface.OnSurfacePrimary) = Interface[name]

				local function newButton(renderType: Enums.ButtonRenderType)
					return React.createElement(
						comp,
						{
							AutomaticSize = Enum.AutomaticSize.XY,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Type = renderType,
							-- LayoutOrder = 2,
							IsEnabled = true,
							Icon = MaterialIcons.watch_later,
							Style = style,
							[React.Event.Activated] = function()
								print(`click "{renderType}"`)
							end :: any,
						} :: any
					)
				end

				return React.createElement(Container, {
					BackgroundTransparency = 0,
					BackgroundColor3 = style:GetColor(backgroundRole),
					BorderSizePixel = 1,
					BorderColor3 = style:GetColor(Enums.ColorRoleType.Outline),
				}, {
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.Name,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, math.round(5 * style.Scale)),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							-- VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly,
						} :: RobloxTypes.UIListLayoutProperties
					),
					-- Divider1 = React.createElement("Frame", {
					-- 	BackgroundTransparency = 0,
					-- 	LayoutOrder = 0,
					-- 	BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline),
					-- 	BorderSizePixel = 0,
					-- 	Size = UDim2.new(1, 0, 0, 1),
					-- }),
					Title = React.createElement(
						TextDisplay.Simple,
						{
							Text = name,
							AutomaticSize = Enum.AutomaticSize.XY,
							Color = Enums.ColorRoleType.OnSurface,
							FontType = Enums.FontType.TitleMedium,
							Style = style,
							LayoutOrder = 1,
						} :: TextDisplay.StyleTextDisplayProperties
					),
					Container = React.createElement(Container, {
						LayoutOrder = 2,
						children = {
							UIListLayout = React.createElement(
								"UIListLayout",
								{
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Horizontal,
									Padding = UDim.new(0, math.round(5 * style.Scale)),
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									-- VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly,
								} :: RobloxTypes.UIListLayoutProperties
							),
							FilledButton = newButton(Enums.ButtonRenderType.Filled),
							IconButton = newButton(Enums.ButtonRenderType.TextIcon),
							OutlinedButton = newButton(Enums.ButtonRenderType.Outlined),
						},
					}),

					-- Divider2 = React.createElement("Frame", {
					-- 	BackgroundTransparency = 0,
					-- 	LayoutOrder = 3,
					-- 	BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline),
					-- 	BorderSizePixel = 0,
					-- 	Size = UDim2.new(1, 0, 0, 1),
					-- }),
				})
			end

			return React.createElement(
				"Frame",
				{
					Name = "HalfFrame",
					BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Background),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = props.Size,
					Position = props.Position,
				} :: RobloxTypes.FrameProperties,
				{
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.Name,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 5 * style.Scale),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							HorizontalFlex = Enum.UIFlexAlignment.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
							VerticalFlex = Enum.UIFlexAlignment.Fill,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					OnSurfacePrimary = newThemeBlock(
						"OnSurfacePrimary",
						Enums.ColorRoleType.Surface
					),
					OnSurfaceSecondary = newThemeBlock(
						"OnSurfaceSecondary",
						Enums.ColorRoleType.Surface
					),
					OnSurfaceTertiary = newThemeBlock(
						"OnSurfaceTertiary",
						Enums.ColorRoleType.Surface
					),
				}
			)
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			Color3.fromHSV(0, 0.9, 0.8),
			Color3.fromHSV(0.6, 0.9, 0.7),
			Color3.fromHSV(0.6, 0.9, 0.7),
		}

		local element = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			} :: RobloxTypes.FrameProperties,
			(function(): { [string]: any }
				local children: { [string]: any } = {}
				for i, color in ipairs(COLORS) do
					local x = (i - 1) / #COLORS
					local width = 1 / #COLORS

					if i % 2 == 0 then
						children[`Dark{i}`] = React.createElement(halfFrame, {
							Color3 = color,
							IsDarkMode = true,
							Size = UDim2.fromScale(width, 1),
							Position = UDim2.fromScale(x, 0),
						})
					else
						children[`Light{i}`] = React.createElement(halfFrame, {
							Color3 = color,
							IsDarkMode = false,
							Size = UDim2.fromScale(width, 1),
							Position = UDim2.fromScale(x, 0),
						})
					end
				end
				return children
			end)()
		)
		local portal = ReactRoblox.createPortal(element, target)
		root:render(portal)
	end)

	return function()
		root:unmount()
		folder:Destroy()
	end
end
