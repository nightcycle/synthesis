--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
-- Modules
local Enums = require("@proj/Enums")
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

	task.spawn(function()
		local Interface = require("../RadioButton")

		local function halfFrame(props: RobloxTypes.GuiObjectProperties & {
			Color3: Color3,
			IsDarkMode: boolean,
		}): React.ReactNode
			local Style = require("@proj/Style")
			local Theme = require("@proj/Theme")
			local Typography = require("@proj/Typography")
			local style = Style.new(
				1,
				0.5,
				true,
				Theme.new(
					props.Color3,
					if props.IsDarkMode
						then Enums.SchemeType.Dark
						else Enums.SchemeType.Light,
					0
				),
				Typography.fromFont(Enum.Font.BuilderSans)
			)
			local defaultSelection, setDefaultSelection = React.useState(true)
			local inanimateSelection, setInanimateSelection = React.useState(false)
			local noIconSelection, setNoIconSelection = React.useState(true)
			local disabledSelection, setDisabledSelection =
				React.useState(math.random() > 0.5)
			return e(
				"Frame",
				{
					Name = "HalfFrame",
					BackgroundColor3 = style.Theme.Surface,
					BorderSizePixel = 0,
					Size = props.Size,
					Position = props.Position,
				} :: RobloxTypes.GuiObjectProperties,
				{
					UIListLayout = e(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 10),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
						} :: RobloxTypes.UIListLayoutProperties
					),

					-- Enums.ColorRoleType.SurfaceContainerHighest,
					-- Enums.ColorRoleType.Outline,
					-- Enums.ColorRoleType.Primary,
					-- Enums.ColorRoleType.PrimaryContainer,
					-- Enums.ColorRoleType.OnPrimaryContainer,
					-- Enums.ColorRoleType.Surface,
					-- Enums.ColorRoleType.OnSurface,

					-- backgroundColor: Enums.ColorRoleType,
					-- onBackgroundColor: Enums.ColorRoleType,
					-- fillColor: Enums.ColorRoleType,
					-- buttonColor: Enums.ColorRoleType,
					-- onButtonColor: Enums.ColorRoleType,
					-- disabledColor: Enums.ColorRoleType,
					-- onDisabledColor: Enums.ColorRoleType,

					Default = e(
						Interface.Full,
						{
							LayoutOrder = 1,
							Value = defaultSelection,
							OnChange = function(value: boolean)
								print("Default", value)
								setDefaultSelection(value)
							end,
							IsEnabled = true,
							IsAnimated = true,
							IncludeIconOnSelected = true,
							IncludeIconOnDeselected = true,
							OutlineColor3 = style.Theme.OnSurfaceVariant,
							FillColor3 = style.Theme.Primary,
							IconColor3 = style.Theme.OnPrimary,
							DisabledColor3 = style.Theme.OnSurface,
							Elevation = 0,
							SchemeType = style.Theme.SchemeType,
							Scale = 1,
						} :: Interface.RadioButtonProperties
					),

					Inanimate = e(Interface.Full, {
						LayoutOrder = 1,
						Value = inanimateSelection,
						OnChange = function(value: boolean)
							print("Inanimate", value)
							setInanimateSelection(value)
						end,
						IsEnabled = true,
						IsAnimated = false,
						IncludeIconOnSelected = true,
						IncludeIconOnDeselected = true,
						OutlineColor3 = style.Theme.OnSurfaceVariant,
						FillColor3 = style.Theme.Primary,
						IconColor3 = style.Theme.OnPrimary,
						DisabledColor3 = style.Theme.OnSurface,
						Elevation = 0,
						SchemeType = style.Theme.SchemeType,
						Scale = 1,
					}),

					NoIcons = e(Interface.Full, {
						LayoutOrder = 2,
						Value = noIconSelection,
						OnChange = function(value: boolean)
							print("NoIcons", value)
							setNoIconSelection(value)
						end,
						IsEnabled = true,
						IsAnimated = true,
						IncludeIconOnSelected = false,
						IncludeIconOnDeselected = false,
						OutlineColor3 = style.Theme.OnSurfaceVariant,
						FillColor3 = style.Theme.Primary,
						IconColor3 = style.Theme.OnPrimary,
						DisabledColor3 = style.Theme.OnSurface,
						Elevation = 0,
						SchemeType = style.Theme.SchemeType,
						Scale = 1,
					}),

					Disabled = e(Interface.Full, {
						LayoutOrder = 3,
						Value = disabledSelection,
						OnChange = function(value: boolean)
							warn("Disabled", value)
							setDisabledSelection(value)
						end,
						IsEnabled = false,
						IsAnimated = true,
						IncludeIconOnSelected = true,
						IncludeIconOnDeselected = true,
						OutlineColor3 = style.Theme.OnSurfaceVariant,
						FillColor3 = style.Theme.Primary,
						IconColor3 = style.Theme.OnPrimary,
						DisabledColor3 = style.Theme.OnSurface,
						Elevation = 0,
						SchemeType = style.Theme.SchemeType,
						Scale = 1,
					}),
				}
			)
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			-- Color3.fromHSV(0, 0.25, 0.8),
			-- Color3.fromHSV(0, 0.9, 0.5),
			Color3.fromHSV(0.6, 0.9, 0.7),
			Color3.fromHSV(0.35, 0.9, 0.7),
			-- Color3.fromHSV(0.1, 0.9, 0.7),
		}

		local element = e(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			} :: RobloxTypes.GuiObjectProperties,
			(function(): { [string]: any }
				local children: { [string]: any } = {}
				for i, color in ipairs(COLORS) do
					local x = (i - 1) / #COLORS
					local width = 1 / #COLORS

					children[`Dark{i}`] = e(halfFrame, {
						Color3 = color,
						IsDarkMode = true,
						Size = UDim2.fromScale(width, 0.5),
						Position = UDim2.fromScale(x, 0.5),
					})

					children[`Light{i}`] = e(halfFrame, {
						Color3 = color,
						IsDarkMode = false,
						Size = UDim2.fromScale(width, 0.5),
						Position = UDim2.fromScale(x, 0),
					})
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
