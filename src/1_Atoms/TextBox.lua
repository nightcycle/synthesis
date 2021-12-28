local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()
	local config = {}
	util.mergeConfig(config, params)

	local Input = fusion.State(config.Input or "")

	local filter = filterConstructor.new(game.Players.LocalPlayer)

	local text = fusion.Computed(function()
		return filter:Get(Input:get())
	end)
	local inst

	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name
	config.Text = config.Text or ""
	config.TextXAlignment = config.TextXAlignment or Enum.TextXAlignment.Left
	config.TextYAlignment = config.TextYAlignment or Enum.TextYAlignment.Center
	config.PlaceholderText = config.PlaceholderText or "Input Text Here"
	config[fusion.OnEvent "FocusLost"] = function()
		Input:set(inst.Text)
	end

	inst = fusion.New "TextBox" (config)
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Primary",
		TextClass = "Body",
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Elevation",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Dropshadow",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("InputEffect",{
		StartSize = config.Size or UDim2.fromScale(1,1),
		InputSizeBump = UDim.new(0, 10),
		InputElevationBump = 1,
		StartElevation = 1,
		Parent = inst,
	}))

	--bind to attributes
	util.setPublicState("Input", Input, inst, maid)
	util.init(script.Name, inst, maid)
	return inst
end

return constructor