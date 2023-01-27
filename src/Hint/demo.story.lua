return function(coreGui)
	local package = script.Parent.Parent
	local packages = package.Parent
	local module = require(script.Parent)
	local Maid = require(packages.maid)
	local ColdFusion = require(packages.coldfusion)

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _mount = _fuse.mount
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local _OUT = _fuse.OUT
	local _REF = _fuse.REF
	local _CHILDREN = _fuse.CHILDREN
	local _ON_EVENT = _fuse.ON_EVENT
	local _ON_PROPERTY = _fuse.ON_PROPERTY

	local label = _new("TextLabel"){
		Parent = coreGui,
		Text = "Text test lol",
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
	}
	local hint = module()({
		Enabled = _Value(true),
		Parent = label,
		AnchorPoint = Vector2.new(0, 1),
		Padding = UDim.new(0, 4),
		Text = "Awesome button that is cool",
	})
	return function()
		hint:Destroy()
	end
end
