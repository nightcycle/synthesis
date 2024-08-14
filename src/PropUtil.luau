--!strict
--!native
local _Package = script
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local RobloxTypes = require(script.Parent:WaitForChild("RobloxTypes"))
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.mergeGuiObject(
	element: RobloxTypes.GuiObjectProperties,
	props: RobloxTypes.GuiObjectProperties
): RobloxTypes.GuiObjectProperties
	return {
		Active = element.Active or props.Active,
		AnchorPoint = element.AnchorPoint or props.AnchorPoint,
		AutomaticSize = element.AutomaticSize or props.AutomaticSize,
		BackgroundColor3 = element.BackgroundColor3 or props.BackgroundColor3,
		BackgroundTransparency = element.BackgroundTransparency or props.BackgroundTransparency,
		BorderColor3 = element.BorderColor3 or props.BorderColor3,
		BorderMode = element.BorderMode or props.BorderMode,
		BorderSizePixel = element.BorderSizePixel or props.BorderSizePixel,
		ClipsDescendants = element.ClipsDescendants or props.ClipsDescendants,
		Interactable = element.Interactable or props.Interactable,
		LayoutOrder = element.LayoutOrder or props.LayoutOrder,
		NextSelectionDown = element.NextSelectionDown or props.NextSelectionDown,
		NextSelectionLeft = element.NextSelectionLeft or props.NextSelectionLeft,
		NextSelectionRight = element.NextSelectionRight or props.NextSelectionRight,
		NextSelectionUp = element.NextSelectionUp or props.NextSelectionUp,
		Position = element.Position or props.Position,
		Rotation = element.Rotation or props.Rotation,
		Selectable = element.Selectable or props.Selectable,
		SelectionImageObject = element.SelectionImageObject or props.SelectionImageObject,
		SelectionOrder = element.SelectionOrder or props.SelectionOrder,
		Size = element.Size or props.Size,
		SizeConstraint = element.SizeConstraint or props.SizeConstraint,
		Transparency = element.Transparency or props.Transparency,
		Visible = element.Visible or props.Visible,
		ZIndex = element.ZIndex or props.ZIndex,
	}
end

function Util.mergeFrame(
	element: RobloxTypes.FrameProperties,
	props: RobloxTypes.FrameProperties
): RobloxTypes.FrameProperties
	local out = Util.mergeGuiObject(element, props) :: RobloxTypes.FrameProperties
	out.Style = element.Style or props.Style
	return out
end

return Util
