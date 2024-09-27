--!strict
-- Services
-- Packages
local Maid = require("@wally/Maid")
-- Modules
local Enums = require("@proj/Enums")
-- Types
-- Constants

-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Theme = require("./Solver")

		local function displayScheme(schemeType: Enums.SchemeType, source: Color3): Frame
			local theme = Theme.new(source)
			local scheme = theme._Schemes[schemeType]
			local halfFrame = maid:GiveTask(Instance.new("Frame"))
			halfFrame.BackgroundColor3 =
				theme:Get(Enums.ColorRoleType.Background, schemeType)

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0.01, 0)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			for i, role in ipairs(Enums.getEnumItems("ColorRoleType")) do
				local v = scheme[role :: Enums.ColorRoleType]
				local label = Instance.new("TextLabel")
				label.TextColor3 = Color3.new(0.5, 0.5, 0.5)
				label.Text = `{role}`
				label.BackgroundColor3 = v
				label.LayoutOrder = (
					Enums.getValueFromEnumItem("ColorRoleType", role) * i
				) + Enums.getValueFromEnumItem("ColorRoleType", role)
				label.Size = UDim2.fromScale(0.9, 1 / 50)
				label.TextScaled = true
				label.Parent = halfFrame
			end

			return halfFrame
		end

		local function tryColor(source: Color3): Frame
			local halfFrame = maid:GiveTask(Instance.new("Frame"))

			local light = displayScheme(Enums.SchemeType.Light, source)
			light.BackgroundColor3 = Color3.new(0.85, 0.85, 0.85)
			light.Position = UDim2.fromScale(0, 0)
			light.Size = UDim2.fromScale(0.5, 1)
			light.Parent = halfFrame

			local dark = displayScheme(Enums.SchemeType.Dark, source)
			dark.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
			dark.Position = UDim2.fromScale(0.5, 0)
			dark.Size = UDim2.fromScale(0.5, 1)
			dark.Parent = halfFrame

			halfFrame.Parent = frame
			return halfFrame
		end

		do
			local red = tryColor(Color3.new(1, 0, 0))
			red.Size = UDim2.fromScale(1 / 3, 1)
			red.Position = UDim2.fromScale(0, 0)
		end

		do
			local green = tryColor(Color3.new(0, 1, 0))
			green.Size = UDim2.fromScale(1 / 3, 1)
			green.Position = UDim2.fromScale(1 / 3, 0)
		end

		do
			local blue = tryColor(Color3.new(0, 0, 1))
			blue.Size = UDim2.fromScale(1 / 3, 1)
			blue.Position = UDim2.fromScale(2 / 3, 0)
		end
	end)
	return function()
		maid:Destroy()
	end
end
