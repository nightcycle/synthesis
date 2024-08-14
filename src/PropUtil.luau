--!strict
--!native
-- Services
-- Packages
-- Modules
local RobloxTypes = require("@Project/RobloxTypes")
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

function Util.mergeImageLabel(
	element: RobloxTypes.ImageLabelProperties,
	props: RobloxTypes.ImageLabelProperties
): RobloxTypes.ImageLabelProperties
	local out = Util.mergeGuiObject(element, props) :: RobloxTypes.ImageLabelProperties
	out.Image = element.Image or props.Image
	out.ImageColor3 = element.ImageColor3 or props.ImageColor3
	out.ImageRectOffset = element.ImageRectOffset or props.ImageRectOffset
	out.ImageRectSize = element.ImageRectSize or props.ImageRectSize
	out.ImageTransparency = element.ImageTransparency or props.ImageTransparency
	out.ResampleMode = element.ResampleMode or props.ResampleMode
	out.ScaleType = element.ScaleType or props.ScaleType
	out.SliceCenter = element.SliceCenter or props.SliceCenter
	out.SliceScale = element.SliceScale or props.SliceScale
	out.TileSize = element.TileSize or props.TileSize
	return out
end

function Util.mergeScrollingFrame(
	element: RobloxTypes.ScrollingFrameProperties,
	props: RobloxTypes.ScrollingFrameProperties
): RobloxTypes.ScrollingFrameProperties
	local out = Util.mergeGuiObject(element, props) :: RobloxTypes.ScrollingFrameProperties
	out.AutomaticCanvasSize = element.AutomaticCanvasSize or props.AutomaticCanvasSize
	out.BottomImage = element.BottomImage or props.BottomImage
	out.CanvasPosition = element.CanvasPosition or props.CanvasPosition
	out.CanvasSize = element.CanvasSize or props.CanvasSize
	out.ElasticBehavior = element.ElasticBehavior or props.ElasticBehavior
	out.HorizontalScrollBarInset = element.HorizontalScrollBarInset or props.HorizontalScrollBarInset
	out.MidImage = element.MidImage or props.MidImage
	out.ScrollBarImageColor3 = element.ScrollBarImageColor3 or props.ScrollBarImageColor3
	out.ScrollBarImageTransparency = element.ScrollBarImageTransparency or props.ScrollBarImageTransparency
	out.ScrollBarThickness = element.ScrollBarThickness or props.ScrollBarThickness
	out.ScrollingDirection = element.ScrollingDirection or props.ScrollingDirection
	out.ScrollingEnabled = element.ScrollingEnabled or props.ScrollingEnabled
	out.TopImage = element.TopImage or props.TopImage
	out.VerticalScrollBarInset = element.VerticalScrollBarInset or props.VerticalScrollBarInset
	out.VerticalScrollBarPosition = element.VerticalScrollBarPosition or props.VerticalScrollBarPosition
	return out
end
return Util
