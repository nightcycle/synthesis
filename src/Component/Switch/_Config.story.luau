--!strict
--!native
-- Services
-- @Packages
local React = require("@node/@jsdotlua/react")
local ReactRoblox = require("@node/@jsdotlua/react-roblox")
-- Modules
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local RobloxTypes = require("@proj/RobloxTypes")
local Types = require("@proj/Types")

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	task.spawn(function()
		local Interface = require(script.Parent:WaitForChild("React"))

		local function halfFrame(props: RobloxTypes.FrameProperties & {
			Color3: Color3,
			IsDarkMode: boolean,
		}): React.ReactElement<RobloxTypes.FrameProperties, "Frame">
			local style = Style.new(
				1.5,
				Enum.Font.SourceSans,
				if props.IsDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				props.Color3
			)
			local defaultSelection, setdefaultSelection = React.useState(false)
			local noIconSelection, setNoIconSelection = React.useState(true)
			local disabledSelection, setDisabledSelection = React.useState(true)
			return React.createElement(
				"Frame",
				{
					Name = "HalfFrame",
					BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
					BorderSizePixel = 0,
					Size = props.Size,
					Position = props.Position,
				} :: RobloxTypes.FrameProperties,
				{
					UIListLayout = React.createElement(
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

					Default = React.createElement(Interface.new, {
						LayoutOrder = 1,
						Value = defaultSelection,
						OnChanged = function(value: boolean)
							print("Default", value)
							setdefaultSelection(value)
						end,
						IsEnabled = true,
						IncludeIconOnSelected = true,
						IncludeIconOnDeselected = true,
						BackgroundColor3 = style:GetColor(Enums.ColorRoleType.SurfaceContainerHighest),
						OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.Outline),
						FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
						ButtonColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
						OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
						DisabledColor3 = style:GetColor(Enums.ColorRoleType.Surface),
						OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.OnSurface),
						Elevation = 0,
						SchemeType = style.SchemeType,
						FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
						Scale = 1,
					}),

					NoIcons = React.createElement(Interface.new, {
						LayoutOrder = 2,
						Value = noIconSelection,
						OnChanged = function(value: boolean)
							print("NoIcons", value)
							setNoIconSelection(value)
						end,
						IsEnabled = true,
						IncludeIconOnSelected = false,
						IncludeIconOnDeselected = false,
						BackgroundColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
						OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
						FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
						ButtonColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
						OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
						DisabledColor3 = style:GetColor(Enums.ColorRoleType.InversePrimary),
						OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.InverseOnSurface),
						Elevation = 0,
						SchemeType = style.SchemeType,
						FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
						Scale = 1,
					}),

					Disabled = React.createElement(Interface.new, {
						LayoutOrder = 3,
						Value = disabledSelection,
						OnChanged = function(value: boolean)
							warn("Disabled", value)
							setDisabledSelection(value)
						end,
						IsEnabled = false,
						IncludeIconOnSelected = true,
						IncludeIconOnDeselected = true,
						BackgroundColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
						OnBackgroundColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
						FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
						ButtonColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer),
						OnButtonColor3 = style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
						DisabledColor3 = style:GetColor(Enums.ColorRoleType.InversePrimary),
						OnDisabledColor3 = style:GetColor(Enums.ColorRoleType.InverseOnSurface),
						Elevation = 0,
						SchemeType = style.SchemeType,
						FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
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

					children[`Dark{i}`] = React.createElement(halfFrame, {
						Color3 = color,
						IsDarkMode = true,
						Size = UDim2.fromScale(width, 0.5),
						Position = UDim2.fromScale(x, 0.5),
					})

					children[`Light{i}`] = React.createElement(halfFrame, {
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
