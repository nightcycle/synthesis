--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
-- Modules
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local RobloxTypes = require("@proj/RobloxTypes")

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	task.spawn(function()
		local Interface = require("../Slider")

		local function halfFrame(props: RobloxTypes.FrameProperties & {
			Color3: Color3,
			IsDarkMode: boolean,
		}): React.ReactNode
			local style = Style.new(
				1,
				Enum.Font.SourceSans,
				if props.IsDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				props.Color3
			)
			local defaultValue, setDefaultValue =
				React.useState(50 :: number | NumberRange)

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
					Default = React.createElement(
						Interface.Full,
						{
							LayoutOrder = 1,
							Value = defaultValue,
							OnChange = function(value: number | NumberRange)
								print("Default", value)
								setDefaultValue(value)
							end,
							Range = NumberRange.new(0, 100),
							IsEnabled = true,
							IsAnimated = true,
							Elevation = 0,
							SchemeType = style.SchemeType,
							Size = UDim2.fromScale(0.7, 0),
							Scale = 1,
							SnapCount = 5,
							IsLabelEnabled = true,
							FillColor3 = style:GetColor(Enums.ColorRoleType.Primary),
							ContainerColor3 = style:GetColor(
								Enums.ColorRoleType.PrimaryContainer
							),
							LabelColor3 = style:GetColor(
								Enums.ColorRoleType.SurfaceContainerHighest
							),
							OnLabelColor3 = style:GetColor(Enums.ColorRoleType.OnSurface),
							OnFillColor3 = style:GetColor(Enums.ColorRoleType.OnPrimary),
							OnContainerColor3 = style:GetColor(
								Enums.ColorRoleType.OnPrimaryContainer
							),
							LabelFontData = style:GetFontData(Enums.FontType.LabelSmall),
						} :: Interface.SliderProperties
					),
				}
			)
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			Color3.fromHSV(0.6, 0.9, 0.7),
			Color3.fromHSV(0.35, 0.9, 0.7),
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
