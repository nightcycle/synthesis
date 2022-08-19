--!strict
local SoundService = game:GetService("SoundService")

local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local Signal = require(packages:WaitForChild("signal"))

local Bubble = require(package:WaitForChild("Bubble"))

export type CheckboxParameters = Types.FrameParameters & {
	Scale: ParameterValue<number>?,
	Value: ParameterValue<boolean>?,
	EnableSound: ParameterValue<Sound>?,
	DisableSound: ParameterValue<Sound>?,
}

export type Checkbox = Frame

return function (config: CheckboxParameters): Checkbox
	local _Maid: Maid = Maid.new()
	local _Fuse: Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)
	local Scale = _import(config.Scale, 1)
	local BorderColor3 = _import(config.BorderColor3, Color3.fromHSV(0,0,0.4))
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0.6,1,1))

	local Value = _Value(if typeof(config.Value) == "boolean" then config.Value elseif typeof(config.Value) == "table" then config.Value:Get() else false)
	local ES: any = _import(config.EnableSound, nil); local EnableSound: State<Sound?> = ES
	local DS: any = _import(config.DisableSound, nil); local DisableSound: State<Sound?> = DS
	local Padding = _Computed(function(scale: number)
		return math.round(6 * scale)
	end, Scale)
	local Width = _Computed(function(scale: number)
		return math.round(scale * 20)
	end, Scale)
	
	local TweenColor = _Computed(function(val, borderColor3, backgroundColor3)
		if not val then
			return borderColor3
		else
			return backgroundColor3
		end
	end, Value, BorderColor3, BackgroundColor3):Tween()

	local Activated = Signal.new()
	_Maid:GiveTask(Activated)

	local BubbleEnabled = _Value(false)
	_Maid:GiveTask(Activated:Connect(function()
		if not Value:Get() == true then
			local clickSound = EnableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		else
			local clickSound = DisableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		end
		if Value:IsA("Value") then
			Value:Set(not Value:Get())
		end
		if BubbleEnabled:Get() == false then
			BubbleEnabled:Set(true)
			task.wait(0.2)
			BubbleEnabled:Set(false)
		end
	end))
	local Output: Frame
	local parameters = {
		Name = Name,
		Size = _Computed(Width, function(width: number)
			return UDim2.fromOffset(width * 2, width * 2)
		end),
		BackgroundTransparency = 1,
		Children = {
			_new "ImageButton" {
				Name = "Button",
				ZIndex = 3,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Position = UDim2.fromScale(0.5,0.5),
				Size = UDim2.fromScale(1,1),
				AnchorPoint = Vector2.new(0.5,0.5),
				[_Fuse.Event "Activated"] = function()
					Activated:Fire()
					if BubbleEnabled:Get() then
						local bubble = Bubble.new {
							Parent = Output,
						}
						local fireFunction: Instance? = bubble:WaitForChild("Fire")
						assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
						fireFunction:Invoke()
					end
				end
			},
			_new "ImageLabel" {
				Name = "ImageLabel",
				ZIndex = 2,
				Image = "rbxassetid://3926305904",
				ImageRectOffset = Vector2.new(312,4),
				ImageRectSize = Vector2.new(24,24),
				ImageColor3 = BorderColor3,
				ImageTransparency = _Computed(function(val)
					if val then return 0 else return 1 end
				end, Value):Tween(),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = TweenColor,
				BackgroundTransparency = _Computed(function(val)
					if val then
						return 0
					else
						return 0.999
					end
				end, Value):Tween(),
				Size = _Computed(function(width: number, padding: number)
					return UDim2.fromOffset(width-padding, width-padding)
				end, Width, Padding),
				BorderSizePixel = 0,
				Children = {
					_new "UICorner" {
						CornerRadius = _Computed(Padding, function(padding: number)
							return UDim.new(0,math.round(padding*0.5))
						end)
					},
					_new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(Padding, function(padding: number)
							return math.round(padding*0.25)
						end),
						Transparency = 0,
						Color = TweenColor,
					}
				} :: {Instance}
			},
		} :: {Instance}

	}
	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end
	-- print("Parameters", parameters, self)
	Output = _new("Frame")(parameters)
	Util.cleanUpPrep(_Maid, Output)
	return Output
end
