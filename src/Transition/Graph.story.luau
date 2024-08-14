--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local RunService = game:GetService("RunService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local CurveUtil = require(_Packages:WaitForChild("CurveUtil"))

-- Modules
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
-- Constants
local PAD = 10
local IN_PAD = 2
local X_COUNT = 3
local Y_COUNT = 4
local DURATION = 0.75
-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Module = require(script.Parent)
		local style = Style.new(
			1,
			Enum.Font.SourceSans,
			Enums.SchemeType.Light,
			Color3.fromHSV(math.random(), 0.7, 0.7)
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
			local xState = _Value(0)
			local yState = _Computed(function(x: number): number
				return solver(x)
			end, xState)

			local image = Instance.new("EditableImage")
			local out = maid:GiveTask(Instance.new("Frame"))
			out.LayoutOrder = order
			out.BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Background)

			local label = _new("ImageLabel")({
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Parent = out,
				BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
				LayoutOrder = 2,
				Children = {
					image :: any,
					_new("Frame")({
						BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 5),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = _Computed(function(y: number): UDim2
							return UDim2.fromScale(0, 1 - y)
						end, yState),
					}),
				},
			}) :: ImageLabel

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
			text.TextColor3 = style:GetColor(Enums.ColorRoleType.OnBackground)
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
				local x = math.clamp(((tick() - start) % DURATION) / DURATION, 0, 1)
				if x < xState:Get() then
					-- image:DrawRectangle(
					-- 	Vector2.zero,
					-- 	label.AbsoluteSize,
					-- 	Color3.new(1,1,1),
					-- 	0
					-- )
					index += 1
					prevX = 0
				end
				local y = solver(x)

				local prevY = solver(prevX)

				local function drawSegment(offset: Vector2)
					pcall(function()
						image:DrawLine(
							Vector2.new(prevX, math.clamp(1 - prevY, 0, 1)) * image.Size + offset,
							Vector2.new(x, math.clamp(1 - y, 0, 1)) * image.Size + offset,
							if index % 2 == 0
								then style:GetColor(Enums.ColorRoleType.OnPrimary)
								else style:GetColor(Enums.ColorRoleType.OnTertiary),
							0,
							Enum.ImageCombineType.Overwrite
						)
					end)
				end
				pcall(function()
					image:DrawRectangle(
						Vector2.new(prevX, 0) * label.AbsoluteSize,
						Vector2.new((x - prevX), 1) * label.AbsoluteSize + Vector2.new(1, 0),
						-- Color3.fromHSV(
						-- 	if index % 2 == 0 then 0.25 else 0.75,
						-- 	1,
						-- 	1
						-- ),
						if index % 2 == 0
							then style:GetColor(Enums.ColorRoleType.Primary)
							else style:GetColor(Enums.ColorRoleType.Tertiary),
						0,
						Enum.ImageCombineType.Overwrite
					)
				end)

				drawSegment(Vector2.zero)
				drawSegment(Vector2.new(0, 1))
				drawSegment(Vector2.new(0, -1))
				xState:Set(x)
				prevX = x
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
				return CurveUtil.ease(x, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
			end)
		end

		do
			graphTransition("exp-in", function(x: number): number
				return CurveUtil.ease(x, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
			end)
			graphTransition("exp-out", function(x: number): number
				return CurveUtil.ease(x, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
			end)
			graphTransition("exp-inout", function(x: number): number
				return CurveUtil.ease(x, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
			end)
		end

		do
			graphTransition("emphasized", Module.Easing[Enums.TransitionType.Emphasized])

			graphTransition("emphasized-decel", Module.Easing[Enums.TransitionType.EmphasizedDecelerate])

			graphTransition("emphasized-accel", Module.Easing[Enums.TransitionType.EmphasizedAccelerate])
		end

		do
			graphTransition("standard", Module.Easing[Enums.TransitionType.Standard])

			graphTransition("standard-decel", Module.Easing[Enums.TransitionType.StandardDecelerate])

			graphTransition("standard-accel", Module.Easing[Enums.TransitionType.StandardAccelerate])
		end
	end)
	return function()
		maid:Destroy()
	end
end
