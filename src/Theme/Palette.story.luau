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
		local ThemeSolver = require("@proj/Theme/Solver")
		local theme = ThemeSolver.new(Color3.new(0.1, 0, 0.9), {})

		local function displayScheme(palette: Enums.PaletteType): Frame
			local halfFrame = maid:GiveTask(Instance.new("Frame"))
			halfFrame.Size = UDim2.fromScale(1 / 6, 1)

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0, 0)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			for i = 0, 10 do
				local label = Instance.new("TextLabel")
				label.TextColor3 = Color3.new(0.5, 0.5, 0.5)
				label.Text = `{i * 100}`
				label.BackgroundColor3 = theme.Palettes[palette](i / 10)
				label.LayoutOrder = i
				label.Size = UDim2.fromScale(1, 1 / 11)
				label.TextScaled = true
				label.Parent = halfFrame
			end

			return halfFrame
		end

		local pTypes = Enums.getEnumItems("PaletteType")
		for i, pT in ipairs(pTypes) do
			local sch = displayScheme(Enums.PaletteType.Primary)
			sch.Position = UDim2.fromScale((i - 1) / #pTypes, 0)
			sch.Parent = frame
		end
	end)
	return function()
		maid:Destroy()
	end
end
