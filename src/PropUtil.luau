--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.mergeInstance(
	element: RobloxTypes.InstanceProperties,
	props: RobloxTypes.InstanceProperties
): RobloxTypes.InstanceProperties
	local out = {
		Archivable = if element.Archivable ~= nil
			then element.Archivable
			else props.Archivable,
		Name = element.Name or props.Name,
		children = React.createElement(
			React.Fragment,
			nil,
			element.children or {},
			props.children or {}
		),
	}
	for k, v in pairs(element) do
		if typeof(k) ~= "string" then
			out[k] = v
		end
	end
	for k, v in pairs(props) do
		if typeof(k) ~= "string" then
			out[k] = v
		end
	end

	return out
end

Util.mergeGuiBaseProperties = Util.mergeInstance

function Util.mergeGuiObject2D(
	element: RobloxTypes.GuiBase2dProperties,
	props: RobloxTypes.GuiBase2dProperties
): RobloxTypes.GuiBase2dProperties
	local out =
		Util.mergeGuiBaseProperties(element, props) :: RobloxTypes.GuiBase2dProperties
	out.AutoLocalize = if element.AutoLocalize ~= nil
		then element.AutoLocalize
		else props.AutoLocalize
	out.RootLocalizationTable = element.RootLocalizationTable
		or props.RootLocalizationTable
	out.SelectionBehaviorDown = element.SelectionBehaviorDown
		or props.SelectionBehaviorDown
	out.SelectionBehaviorLeft = element.SelectionBehaviorLeft
		or props.SelectionBehaviorLeft
	out.SelectionBehaviorRight = element.SelectionBehaviorRight
		or props.SelectionBehaviorRight
	out.SelectionBehaviorUp = element.SelectionBehaviorUp or props.SelectionBehaviorUp
	out.SelectionGroup = element.SelectionGroup or props.SelectionGroup
	return out
end

function Util.mergeGuiObject(
	element: RobloxTypes.GuiObjectProperties,
	props: RobloxTypes.GuiObjectProperties
): RobloxTypes.GuiObjectProperties
	local out = Util.mergeGuiObject2D(element, props) :: RobloxTypes.GuiObjectProperties
	out.Active = if element.Active ~= nil then element.Active else props.Active
	out.AnchorPoint = element.AnchorPoint or props.AnchorPoint
	out.AutomaticSize = element.AutomaticSize or props.AutomaticSize
	out.BackgroundColor3 = element.BackgroundColor3 or props.BackgroundColor3
	out.BackgroundTransparency = element.BackgroundTransparency
		or props.BackgroundTransparency
	out.BorderColor3 = element.BorderColor3 or props.BorderColor3
	out.BorderMode = element.BorderMode or props.BorderMode
	out.BorderSizePixel = element.BorderSizePixel or props.BorderSizePixel
	out.ClipsDescendants = if element.ClipsDescendants ~= nil
		then element.ClipsDescendants
		else props.ClipsDescendants
	out.Interactable = if element.Interactable ~= nil
		then element.Interactable
		else props.Interactable
	out.LayoutOrder = element.LayoutOrder or props.LayoutOrder
	out.NextSelectionDown = element.NextSelectionDown or props.NextSelectionDown
	out.NextSelectionLeft = element.NextSelectionLeft or props.NextSelectionLeft
	out.NextSelectionRight = element.NextSelectionRight or props.NextSelectionRight
	out.NextSelectionUp = element.NextSelectionUp or props.NextSelectionUp
	out.Position = element.Position or props.Position
	out.Rotation = element.Rotation or props.Rotation
	out.Selectable = if element.Selectable ~= nil
		then element.Selectable
		else props.Selectable
	out.SelectionImageObject = element.SelectionImageObject or props.SelectionImageObject
	out.SelectionOrder = element.SelectionOrder or props.SelectionOrder
	out.Size = element.Size or props.Size
	out.SizeConstraint = element.SizeConstraint or props.SizeConstraint
	out.Transparency = element.Transparency or props.Transparency
	out.Visible = if element.Visible ~= nil then element.Visible else props.Visible
	out.ZIndex = element.ZIndex or props.ZIndex

	return out
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

function Util.mergeGuiButton(
	element: RobloxTypes.GuiButtonProperties,
	props: RobloxTypes.GuiButtonProperties
): RobloxTypes.GuiButtonProperties
	local out = Util.mergeGuiObject(element, props) :: RobloxTypes.GuiButtonProperties
	out.AutoButtonColor = if element.AutoButtonColor ~= nil
		then element.AutoButtonColor
		else props.AutoButtonColor
	out.Modal = if element.Modal ~= nil then element.Modal else props.Modal
	out.Selected = if element.Selected ~= nil then element.Selected else props.Selected
	out.Style = element.Style or props.Style
	return out
end

function Util.mergeImageButton(
	element: RobloxTypes.ImageButtonProperties,
	props: RobloxTypes.ImageButtonProperties
): RobloxTypes.ImageButtonProperties
	local out = Util.mergeGuiButton(element, props) :: RobloxTypes.ImageButtonProperties
	out.Image = element.Image or props.Image
	out.ImageColor3 = element.ImageColor3 or props.ImageColor3
	out.ImageRectOffset = element.ImageRectOffset or props.ImageRectOffset
	out.ImageRectSize = element.ImageRectSize or props.ImageRectSize
	out.ImageTransparency = element.ImageTransparency or props.ImageTransparency
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
	local out =
		Util.mergeGuiObject(element, props) :: RobloxTypes.ScrollingFrameProperties
	out.AutomaticCanvasSize = element.AutomaticCanvasSize or props.AutomaticCanvasSize
	out.BottomImage = element.BottomImage or props.BottomImage
	out.CanvasPosition = element.CanvasPosition or props.CanvasPosition
	out.CanvasSize = element.CanvasSize or props.CanvasSize
	out.ElasticBehavior = element.ElasticBehavior or props.ElasticBehavior
	out.HorizontalScrollBarInset = element.HorizontalScrollBarInset
		or props.HorizontalScrollBarInset
	out.MidImage = element.MidImage or props.MidImage
	out.ScrollBarImageColor3 = element.ScrollBarImageColor3 or props.ScrollBarImageColor3
	out.ScrollBarImageTransparency = element.ScrollBarImageTransparency
		or props.ScrollBarImageTransparency
	out.ScrollBarThickness = element.ScrollBarThickness or props.ScrollBarThickness
	out.ScrollingDirection = element.ScrollingDirection or props.ScrollingDirection
	out.ScrollingEnabled = element.ScrollingEnabled or props.ScrollingEnabled
	out.TopImage = element.TopImage or props.TopImage
	out.VerticalScrollBarInset = element.VerticalScrollBarInset
		or props.VerticalScrollBarInset
	out.VerticalScrollBarPosition = element.VerticalScrollBarPosition
		or props.VerticalScrollBarPosition
	return out
end

Util.mergeGuiLabel = Util.mergeGuiObject

function Util.mergeTextLabel(
	element: RobloxTypes.TextLabelProperties,
	props: RobloxTypes.TextLabelProperties
): RobloxTypes.TextLabelProperties
	local out = Util.mergeGuiLabel(element, props) :: RobloxTypes.TextLabelProperties
	out.Font = element.Font or props.Font
	out.LineHeight = element.LineHeight or props.LineHeight
	out.RichText = if element.RichText ~= nil then element.RichText else props.RichText
	out.Text = element.Text or props.Text
	out.TextColor3 = element.TextColor3 or props.TextColor3
	out.TextScaled = if element.TextScaled ~= nil
		then element.TextScaled
		else props.TextScaled
	out.TextSize = element.TextSize or props.TextSize
	out.TextStrokeColor3 = element.TextStrokeColor3 or props.TextStrokeColor3
	out.TextStrokeTransparency = element.TextStrokeTransparency
		or props.TextStrokeTransparency
	out.TextTransparency = element.TextTransparency or props.TextTransparency
	out.TextWrapped = if element.TextWrapped ~= nil
		then element.TextWrapped
		else props.TextWrapped
	out.TextXAlignment = element.TextXAlignment or props.TextXAlignment
	out.TextYAlignment = element.TextYAlignment or props.TextYAlignment

	out.FontFace = element.FontFace or props.FontFace
	out.MaxVisibleGraphemes = element.MaxVisibleGraphemes or props.MaxVisibleGraphemes
	out.OpenTypeFeatures = element.OpenTypeFeatures or props.OpenTypeFeatures
	out.TextDirection = element.TextDirection or props.TextDirection
	out.TextTruncate = element.TextTruncate or props.TextTruncate

	return out
end

return Util
