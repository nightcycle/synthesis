--!strict
--!native
-- Services
-- @Packages
local React = require("@wally/React")
local ReactRoblox = require("@wally/ReactRoblox")
local MaterialIcons = require("@wally/MaterialIcons")
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
		local Interface = require("../TextField")

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
			local defaultFilledValue, setDefaultFilledValue =
				React.useState(nil :: string?)
			local defaultOutlinedValue, setDefaultOutlinedValue =
				React.useState(nil :: string?)
			local dropDownOutlinedValue, setDropDownOutlinedValue =
				React.useState(nil :: string?)

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
					DefaultFilled = e(
						Interface.Full,
						{
							Value = defaultFilledValue,
							OnSubmit = function(txt: string)
								print(`submit: {txt}`)
							end,
							OnChange = function(txt: string)
								print(`change: {txt}`)
								setDefaultFilledValue(txt)
							end,
							IsEnabled = true,
							IsError = false,
							IsFilled = true,
							Label = "Label",
							BackgroundColor3 = style.Theme.SurfaceContainer,
							BorderHightlightColor3 = style.Theme.Primary,
							ErrorColor3 = style.Theme.Error,
							BorderColor3 = style.Theme.OnSurface,
							TextColor3 = style.Theme.OnSurface,
							LabelColor3 = style.Theme.OnSurface,
							SupportingTextColor3 = style.Theme.OnSurface,
							CharacterLimit = 20,
							SupportingText = "Supporting Text",
							Icon = MaterialIcons.vpn_key,
							Elevation = 0,
							SchemeType = Enums.SchemeType.Light,
							BodyFontData = style.Typography.BodyLarge,
							SupportFontData = style.Typography.LabelSmall,
							Scale = 1,
						} :: any
					),
					DefaultOutlined = e(
						Interface.Full,
						{
							Value = defaultOutlinedValue,
							OnSubmit = function(txt: string?)
								print(`submit: {txt}`)
							end,
							OnChange = function(txt: string?)
								print(`change: {txt}`)
								setDefaultOutlinedValue(txt)
							end,
							IsEnabled = true,
							IsError = false,
							IsFilled = false,
							LayoutOrder = 2,
							Label = "Label",
							IsClearButtonEnabled = false,
							BackgroundColor3 = style.Theme.SurfaceContainer,
							BorderHightlightColor3 = style.Theme.Primary,
							ErrorColor3 = style.Theme.Error,
							BorderColor3 = style.Theme.OnSurface,
							TextColor3 = style.Theme.OnSurface,
							LabelColor3 = style.Theme.OnSurface,
							SupportingTextColor3 = style.Theme.OnSurface,
							CharacterLimit = 20,
							SupportingText = "Supporting Text",
							-- Icon = MaterialIcons.vpn_key,
							Elevation = 0,
							SchemeType = Enums.SchemeType.Light,
							BodyFontData = style.Typography.BodyLarge,
							SupportFontData = style.Typography.LabelSmall,
							Scale = 1,
						} :: Interface.TextFieldProperties
					),
					DropdownOutlined = e(
						Interface.Full,
						{
							Value = dropDownOutlinedValue,
							OnSubmit = function(txt: string?)
								print(`submit: {txt}`)
							end,
							OnChange = function(txt: string?)
								print(`change: {txt}`)
								setDropDownOutlinedValue(txt)
							end,
							IsEnabled = true,
							IsError = false,
							IsFilled = false,
							LayoutOrder = 3,
							Label = "Label",
							Size = UDim2.fromScale(0.8, 0),
							IsClearButtonEnabled = false,
							BackgroundColor3 = style.Theme.SurfaceContainer,
							BorderHightlightColor3 = style.Theme.Primary,
							ErrorColor3 = style.Theme.Error,
							BorderColor3 = style.Theme.OnSurface,
							TextColor3 = style.Theme.OnSurface,
							LabelColor3 = style.Theme.OnSurface,
							SupportingTextColor3 = style.Theme.OnSurface,
							CharacterLimit = 20,
							SupportingText = "Supporting Text",
							DropDownOptions = {
								"Option 1",
								"Option 2",
								"Option 3",
								"Option 4",
								"Option 5",
							},
							-- Icon = MaterialIcons.vpn_key,
							Elevation = 0,
							SchemeType = Enums.SchemeType.Light,
							BodyFontData = style.Typography.BodyLarge,
							SupportFontData = style.Typography.LabelSmall,
							Scale = 1,
						} :: Interface.TextFieldProperties
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
