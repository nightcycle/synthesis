--!strict
-- Services
-- Packages
local React = require("@wally/React")

-- Modules
local Types = require("@proj/Types")
local Container = require("@comp/Container")
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
-- Types
type ImageData = Types.ImageData
export type PopUpProperties = RobloxTypes.FrameProperties & {
	-- OriginAnchorPoint: Vector2?,
	DisplayAnchorPoint: Vector2?,
	DisplayOrder: number?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
	TargetAbsolutePosition: Vector2,
	DisplayComponent: () -> React.ReactNode,
}
-- Constants
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(props: PopUpProperties): React.ReactNode
	-- local originAnchorPoint: Vector2 = props.OriginAnchorPoint or Vector2.new(0, 0)
	local displayAnchorPoint: Vector2 = props.DisplayAnchorPoint or Vector2.new(0, 0)
	local displayOrder: number = props.DisplayOrder or 0
	local absolutePosition: Vector2 = props.TargetAbsolutePosition
	local zIndexBehavior: Enum.ZIndexBehavior? = props.ZIndexBehavior
	-- local renderPosition, setRenderPosition = React.useState(Vector2.new(0, 0))
	-- local absoluteSize = Vector2.new(0, 0)

	-- local function update(): ()
	-- 	local viewportSize = workspace.CurrentCamera.ViewportSize
	-- 	local xMin = absoluteSize.X * originAnchorPoint.X
	-- 	local yMin = absoluteSize.Y * originAnchorPoint.Y

	-- 	local x = math.clamp(
	-- 		absolutePosition.X,
	-- 		xMin,
	-- 		math.max(xMin, viewportSize.X - absoluteSize.X * (1 - originAnchorPoint.X))
	-- 	)
	-- 	local y = math.clamp(
	-- 		absolutePosition.Y,
	-- 		yMin,
	-- 		math.max(yMin, viewportSize.Y - absoluteSize.Y * (1 - originAnchorPoint.Y))
	-- 	)
	-- 	if renderPosition.X == x and renderPosition.Y == y then
	-- 		return
	-- 	end
	-- 	setRenderPosition(Vector2.new(x, y))
	-- end

	-- update()
	return e(
		"ScreenGui",
		{
			ResetOnSpawn = false,
			DisplayOrder = displayOrder,
			ZIndexBehavior = zIndexBehavior or Enum.ZIndexBehavior.Sibling,
			Enabled = true,
		} :: RobloxTypes.ScreenGuiProperties,
		{
			Container = e(
				Container,
				PropUtil.mergeGuiObject({
					Position = UDim2.fromOffset(absolutePosition.X, absolutePosition.Y),
					AnchorPoint = displayAnchorPoint,
					-- [React.Change.AbsoluteSize] = function(inst: GuiObject): ()
					-- 	absoluteSize = inst.AbsoluteSize
					-- 	update()
					-- end :: any,
					children = {
						DisplayComponent = e(props.DisplayComponent),
						UIListLayout = e(
							"UIListLayout",
							{
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 0),
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
							} :: RobloxTypes.UIListLayoutProperties
						),
					},
				}, props) :: RobloxTypes.GuiObjectProperties
			),
		}
	)
end
