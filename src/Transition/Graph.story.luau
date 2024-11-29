--!strict
-- Services
local RunService = game:GetService("RunService")
local AssetService = game:GetService("AssetService")
-- Packages
local Maid = require("@wally/Maid")
local CurveUtil = require("@wally/CurveUtil")

-- Modules
local Enums = require("@proj/Enums")

-- Types
-- Constants
local PAD = 10
local IN_PAD = 2
local X_COUNT = 3
local Y_COUNT = 4
local DURATION = 1.5
-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Module = require(script.Parent)
		local Style = require("@proj/Style")
		local Theme = require("@proj/Theme")
		local Typography = require("@proj/Typography")
		local style = Style.new(
			1,
			0.5,
			true,
			Theme.new(Color3.fromHSV(math.random(), 0.7, 0.7), Enums.SchemeType.Light, 0),
			Typography.fromFont(Enum.Font.BuilderSans)
		)

		local gridLayout = maid:GiveTask(Instance.new("UIGridLayout"))
		gridLayout.CellPadding = UDim2.fromOffset(PAD, PAD)
		gridLayout.CellSize = UDim2.new(1 / X_COUNT, -PAD, 1 / Y_COUNT, -PAD)
		gridLayout.Parent = frame
		do
			local uiPadding = maid:GiveTask(Instance.new("UIPadding"))
			uiPadding.PaddingLeft = UDim.new(0, PAD)
			uiPadding.PaddingRight = UDim.new(0, PAD)
			uiPadding.PaddingTop = UDim.new(0, PAD)
			uiPadding.PaddingBottom = UDim.new(0, PAD)
			uiPadding.Parent = frame
		end

		local order = 0

		local function graphTransition(name: string, solver: (x: number) -> number)
			order += 1
			local x = 0
			local y = solver(x)

			local out = maid:GiveTask(Instance.new("Frame"))
			out.LayoutOrder = order
			out.BackgroundColor3 = style.Theme.Background

			local label = Instance.new("ImageLabel")
			label.Size = UDim2.fromScale(0, 0)
			label.AutomaticSize = Enum.AutomaticSize.XY
			label.Parent = out
			label.BackgroundColor3 = style.Theme.Surface
			label.LayoutOrder = 2

			local image = maid:GiveTask(AssetService:CreateEditableImage({
				Size = Vector2.new(512, 512),
			}) :: EditableImage)

			local subFrame = Instance.new("Frame")
			subFrame.BackgroundColor3 = style.Theme.Surface
			subFrame.BorderSizePixel = 0
			subFrame.Size = UDim2.new(1, 0, 0, 5)
			subFrame.AnchorPoint = Vector2.new(0, 0.5)
			subFrame.Position = UDim2.fromScale(0, 1 - y)

			local function updatePosition()
				y = solver(x)
				subFrame.Position = UDim2.fromScale(0, 1 - y)
			end

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0, IN_PAD)
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			listLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
			listLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
			listLayout.Parent = out

			local uiPadding = maid:GiveTask(Instance.new("UIPadding"))
			uiPadding.PaddingLeft = UDim.new(0, IN_PAD)
			uiPadding.PaddingRight = UDim.new(0, IN_PAD)
			uiPadding.PaddingTop = UDim.new(0, IN_PAD)
			uiPadding.PaddingBottom = UDim.new(0, IN_PAD)
			uiPadding.Parent = out

			local text = maid:GiveTask(Instance.new("TextLabel"))
			text.AutomaticSize = Enum.AutomaticSize.X
			text.BackgroundTransparency = 1
			text.TextScaled = false
			text.TextColor3 = style.Theme.OnBackground
			text.TextSize = 14
			text.Size = UDim2.fromOffset(0, 14)
			text.Text = name
			text.TextXAlignment = Enum.TextXAlignment.Center
			text.LayoutOrder = 1
			text.Parent = out

			local uiAlignment = maid:GiveTask(Instance.new("UISizeConstraint"))
			uiAlignment.MaxSize = Vector2.new(math.huge, text.TextSize + IN_PAD * 2 + 4)
			uiAlignment.MinSize = Vector2.zero
			uiAlignment.Parent = text

			out.Size = UDim2.fromScale(1, 1)
			out.Parent = frame

			local index = 0
			local prevX = 0
			local start = tick()
			maid:GiveTask(RunService.RenderStepped:Connect(function()
				image.Size = label.AbsoluteSize
				local clampX = math.clamp(((tick() - start) % DURATION) / DURATION, 0, 1)
				if clampX <= x then
					index += 1
					prevX = 0
					x = 0
					return
				end
				updatePosition()

				local prevY = solver(prevX)

				local function drawSegment(offset: Vector2)
					local _success, _msg = pcall(function()
						image:DrawLine(
							Vector2.new(prevX, math.clamp(1 - prevY, 0, 1)) * image.Size
								+ offset,
							Vector2.new(clampX, math.clamp(1 - y, 0, 1)) * image.Size
								+ offset,
							if index % 2 == 0
								then style.Theme.OnPrimary
								else style.Theme.OnTertiary,
							0,
							Enum.ImageCombineType.BlendSourceOver
						)
					end)
					-- if not success then
					-- 	warn(msg)
					-- end
				end
				pcall(function()
					image:DrawRectangle(
						Vector2.new(prevX, 0) * label.AbsoluteSize,
						Vector2.new((clampX - prevX), 1) * label.AbsoluteSize
							+ Vector2.new(1, 0),
						-- Color3.fromHSV(
						-- 	if index % 2 == 0 then 0.25 else 0.75,
						-- 	1,
						-- 	1
						-- ),
						if index % 2 == 0
							then style.Theme.Primary
							else style.Theme.Tertiary,
						0,
						Enum.ImageCombineType.BlendSourceOver
					)
				end)

				drawSegment(Vector2.zero)
				drawSegment(Vector2.new(0, 1))
				drawSegment(Vector2.new(0, -1))
				prevX = x
				x = clampX
			end))
		end
		do
			graphTransition("cubic-in", function(x: number): number
				return CurveUtil.ease(x, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
			end)
			graphTransition("cubic-out", function(x: number): number
				return CurveUtil.ease(x, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			end)
			graphTransition("cubic-inout", function(x: number): number
				return CurveUtil.ease(
					x,
					Enum.EasingStyle.Cubic,
					Enum.EasingDirection.InOut
				)
			end)
		end

		do
			graphTransition("exp-in", function(x: number): number
				return CurveUtil.ease(
					x,
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.In
				)
			end)
			graphTransition("exp-out", function(x: number): number
				return CurveUtil.ease(
					x,
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.Out
				)
			end)
			graphTransition("exp-inout", function(x: number): number
				return CurveUtil.ease(
					x,
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.InOut
				)
			end)
		end

		do
			graphTransition("emphasized", Module.Easing[Enums.TransitionType.Emphasized])

			graphTransition(
				"emphasized-decel",
				Module.Easing[Enums.TransitionType.EmphasizedDecelerate]
			)

			graphTransition(
				"emphasized-accel",
				Module.Easing[Enums.TransitionType.EmphasizedAccelerate]
			)
		end

		do
			graphTransition("standard", Module.Easing[Enums.TransitionType.Standard])

			graphTransition(
				"standard-decel",
				Module.Easing[Enums.TransitionType.StandardDecelerate]
			)

			graphTransition(
				"standard-accel",
				Module.Easing[Enums.TransitionType.StandardAccelerate]
			)
		end
	end)
	return function()
		maid:Destroy()
	end
end
