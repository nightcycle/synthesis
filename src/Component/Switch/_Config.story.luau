--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local React = require(_Packages:WaitForChild("React"))
local ReactRoblox = require(_Packages:WaitForChild("ReactRoblox"))
-- Modules
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local RobloxTypes = require(_Package:WaitForChild("RobloxTypes"))
local Types = require(_Package:WaitForChild("Types"))

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	task.spawn(function()
		local function makeHalfFrame(
			isDarkMode: boolean,
			color: Color3,
			size: UDim2,
			position: UDim2
		): React.ReactElement<RobloxTypes.FrameProperties, "Frame">
			local style = Style.new(
				1.5,
				Enum.Font.SourceSans,
				if isDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				color
			)

			local Interface = require(script.Parent:WaitForChild("React"))

			return React.createElement(
				"Frame",
				{
					Name = "HalfFrame",
					BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
					BorderSizePixel = 0,
					Size = size,
					Position = position,
				} :: RobloxTypes.FrameProperties,
				{
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 10),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
						} :: RobloxTypes.UIListLayoutProperties
					),

					First = Interface.new({
						LayoutOrder = 1,

						Value = false,
						IsEnabled = true,
						IncludeIconOnSelected = true,
						IncludeIconOnDeselected = true,
						BackgroundColor3 = Color3.new(),
						OnBackgroundColor3 = Color3.new(),
						FillColor3 = Color3.new(),
						ButtonColor3 = Color3.new(),
						OnButtonColor3 = Color3.new(),
						DisabledColor3 = Color3.new(),
						OnDisabledColor3 = Color3.new(),
						Elevation = 0,
						SchemeType = Enums.SchemeType.Light,
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
					children[`Dark{i}`] =
						makeHalfFrame(true, color, UDim2.fromScale(width, 0.5), UDim2.fromScale(x, 0.5))

					children[`Light{i}`] =
						makeHalfFrame(false, color, UDim2.fromScale(width, 0.5), UDim2.fromScale(x, 0))
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
