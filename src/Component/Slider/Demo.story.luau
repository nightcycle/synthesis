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
-- Private Functions
local e = React.createElement
-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	task.spawn(function()
		local Interface = require("../Slider")

		local function halfFrame(props: RobloxTypes.GuiObjectProperties & {
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
			local noSnapValue, setNoSnapValue = React.useState(50 :: number | NumberRange)
			local doubleValue, setDoubleValue =
				React.useState(NumberRange.new(5, 50) :: number | NumberRange)
			local disableValue, setDisableValue =
				React.useState(NumberRange.new(5, 50) :: number | NumberRange)
			return e(
				"Frame",
				{
					Name = "HalfFrame",
					BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
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
					Default = e(
						Interface.Full,
						{
							LayoutOrder = 1,
							Value = defaultValue,
							OnChange = function(value: number | NumberRange)
								print("Default-Change", value)
								setDefaultValue(value)
							end,
							OnRelease = function(value: number | NumberRange)
								print("Default-Release", value)
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
							LabelFontData = style:GetFontData(Enums.FontType.LabelLarge),
						} :: Interface.SliderProperties
					),
					NoSnap = e(
						Interface.Full,
						{
							LayoutOrder = 2,
							Value = noSnapValue,
							OnChange = function(value: number | NumberRange)
								print("NoSnap", value)
								setNoSnapValue(value)
							end,
							OnRelease = function(value: number | NumberRange)
								print("NoSnap-Release", value)
							end,
							Range = NumberRange.new(0, 100),
							IsEnabled = true,
							IsAnimated = true,
							Elevation = 0,
							SchemeType = style.SchemeType,
							Size = UDim2.fromScale(0.7, 0),
							Scale = 1,
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
							LabelFontData = style:GetFontData(Enums.FontType.LabelLarge),
						} :: Interface.SliderProperties
					),
					DoubleSlider = e(
						Interface.Full,
						{
							LayoutOrder = 3,
							Value = doubleValue,
							OnChange = function(value: number | NumberRange)
								print("DoubleSlider", value)
								setDoubleValue(value)
							end,
							OnRelease = function(value: number | NumberRange)
								print("DoubleSlider-Release", value)
							end,
							Range = NumberRange.new(0, 100),
							IsEnabled = true,
							IsAnimated = true,
							Elevation = 0,
							SchemeType = style.SchemeType,
							Size = UDim2.fromScale(0.7, 0),
							Scale = 1,
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
							LabelFontData = style:GetFontData(Enums.FontType.BodyLarge),
						} :: Interface.SliderProperties
					),
					Disable = e(
						Interface.Full,
						{
							LayoutOrder = 4,
							Value = disableValue,
							OnChange = function(value: number | NumberRange)
								print("Disable", value)
								setDisableValue(value)
							end,
							Range = NumberRange.new(0, 100),
							IsEnabled = false,
							IsAnimated = true,
							Elevation = 0,
							SchemeType = style.SchemeType,
							Size = UDim2.fromScale(0.7, 0),
							Scale = 1,
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
							LabelFontData = style:GetFontData(Enums.FontType.BodyLarge),
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
