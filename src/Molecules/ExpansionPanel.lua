local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)

	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or f.v(""),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or f.v(Color3.fromHex("#FFFFFF")),
		Width = util.import(params.Width) or f.v(UDim.new(1, 0)),
		Open = util.import(params.Open) or f.v(false),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	local _TextSize = f.get(function()
		return public.Typography:get().TextSize
	end)
	local _Padding = f.get(function()
		return public.Typography:get().Padding
	end)
	local _ContentAbsoluteSize = f.v(Vector2.new(0,0))
	--construct
	local inst
	inst = util.set(f.new "Frame", public, params, {
		BackgroundColor3 = public.BackgroundColor,
		BorderSizePixel = 0,
		Size = util.tween(f.get(function()
			local width = public.Width:get()
			local paddingHeight = _Padding:get().Offset
			local textHeight = _TextSize:get()
			local contentHeight = _ContentAbsoluteSize:get().Y
			local minHeight = paddingHeight*3 + textHeight
			local height = UDim.new(0, minHeight)
			if public.Open:get() then
				height = UDim.new(0, minHeight + paddingHeight + contentHeight)
			end
			return UDim2.new(width, height)
		end)),
		[f.c] = {
			f.new "UIListLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			f.new "Frame" {
				Name = "Header",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0),
				[f.c] = {
					f.new "ImageButton" {
						Name = "keyboard_arrow_down",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						LayoutOrder = 8,
						Position = UDim2.fromScale(1, 0.5),
						Size = UDim2.fromOffset(14, 14),
						ZIndex = 2,
						Rotation = util.tween(f.get(function()
							if public.Open:get() then
								return 180
							else
								return 0
							end
						end), {EasingStyle = Enum.EasingStyle.Circular}),
						Image = "rbxassetid://3926305904",
						ImageColor3 = public.TextColor,
						ImageRectOffset = Vector2.new(404, 284),
						ImageRectSize = Vector2.new(36, 36),
						[f.e "Activated"] = function()
							public.Open:set(not public.Open:get())
						end,
					},
					f.new "UIPadding" {
						PaddingBottom = _Padding,
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
						PaddingTop = _Padding,
					},
					f.new "TextLabel" {
						AnchorPoint = Vector2.new(0, 0.5),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 0.5),
						Font = Enum.Font.SourceSans,
						Text = "Text goes here",
						TextColor3 = public.TextColor,
						TextSize = 14,
					},
				},
			},
			f.new "Frame" {
				Name = "Body",
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				ClipsDescendants = true,
				Size = util.tween(f.get(function()
					local padSize = _Padding:get().Offset
					local absSize = _ContentAbsoluteSize:get()
					local isOpen = public.Open:get()
					if isOpen then
						return UDim2.new(1, 0, 0, absSize.Y + padSize*2)
					else
						return UDim2.fromScale(1,0)
					end
				end)),
				[f.c] = {
					f.new "Frame" {
						Name = "Content",
						Size = UDim2.fromScale(1,0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						[f.dt "AbsoluteSize"] = function()
							local body = inst:WaitForChild("Body")
							local contentFrame = body:WaitForChild("Content")
							_ContentAbsoluteSize:set(contentFrame.AbsoluteSize)
						end,
					},
					f.new "UIListLayout" {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = _Padding,
					},
					f.new "UIPadding" {
						PaddingBottom = _Padding,
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
						PaddingTop = _Padding,
					},
				},
			},
			f.new "UICorner" {
				CornerRadius = util.cornerRadius,
			},
			f.new "UIPadding" {
				PaddingBottom = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
				PaddingTop = _Padding,
			},
		},
	})
	return inst
end

return constructor