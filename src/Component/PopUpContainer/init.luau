--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")
local Defaults = require("./Defaults")
local Theme = require("@proj/Theme")
local ShadowFrame = require("@comp/ShadowFrame")
local Container = require("@comp/Container")
local PopUp = require("@comp/PopUp")
local ScrollingContainer = require("@comp/ScrollingContainer")
-- Types
type ButtonData = Types.ButtonData
type PopUpContainerBaseProperties = {
	TargetAbsolutePosition: Vector2,
	TargetAbsoluteWidth: number?,
	OnCursorExit: (() -> ())?,
	DisplayOrder: number?,
	Elevation: number?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
	DisplayComponent: () -> React.ReactNode,
}
export type PopUpContainerProperties = PopUpContainerBaseProperties & {
	SchemeType: Enums.SchemeType?,
	Scale: number?,
	SurfaceColor3: Color3?,
	DropShadowColor3: Color3?,
	DropShadowTransparency: number?,
}

-- Constants
local CORNER_RADIUS_DP = 4
local BUTTON_PADDING_DP = 1
local MENU_TB_PADDING_DP = 8
local EDGE_PADDING_DP = 8
local SHADOW_OFFSET_DP = Vector2.new(2, 2) * 2
local MIN_HEIGHT_DP = 150
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(props: PopUpContainerProperties): React.ReactNode
	-- unpack props
	local displayComponent = props.DisplayComponent
	local targetAbsolutePosition: Vector2 = props.TargetAbsolutePosition
	local targetAbsoluteWidth: number? = props.TargetAbsoluteWidth
	local onCursorExit: (() -> ())? = props.OnCursorExit
	local displayOrder: number = props.DisplayOrder or 0

	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local scale: number = props.Scale or Defaults.Scale
	local rawSurfaceColor3: Color3 = props.SurfaceColor3 or Defaults.SurfaceColor3
	local rawDropShadowColor3: Color3 = props.DropShadowColor3
		or Defaults.DropShadowColor3
	local dropShadowTransparency: number = props.DropShadowTransparency
		or Defaults.DropShadowTransparency

	local elevation: number = props.Elevation or Defaults.Elevation
	local zIndexBehavior: Enum.ZIndexBehavior? = props.ZIndexBehavior

	-- set up state
	local viewportSize, setViewportSize =
		React.useState(workspace.CurrentCamera.ViewportSize)
	local popUpContainerAbsoluteSize, popUpContainerSetAbsoluteSize =
		React.useState(Vector2.new(0, 0))

	-- process state / props
	local minHeightPx = math.ceil(MIN_HEIGHT_DP * scale)

	local vLimit = viewportSize.Y - math.ceil(EDGE_PADDING_DP * scale)
	local heightOffsetPx = math.max(minHeightPx - (vLimit - targetAbsolutePosition.Y), 0)
	if
		heightOffsetPx > 0
		and targetAbsolutePosition.Y + popUpContainerAbsoluteSize.Y > vLimit
	then
		targetAbsolutePosition = targetAbsolutePosition - Vector2.new(0, heightOffsetPx)
	end
	do
		local xLimit = viewportSize.X - math.ceil(EDGE_PADDING_DP * scale)
		local xCur = targetAbsolutePosition.X + popUpContainerAbsoluteSize.X
		if xCur > xLimit then
			targetAbsolutePosition = targetAbsolutePosition
				- Vector2.new(xCur - xLimit, 0)
		end
	end

	local isClipping = targetAbsolutePosition.Y + popUpContainerAbsoluteSize.Y > vLimit

	local cornerRadius = UDim.new(0, math.ceil(CORNER_RADIUS_DP * scale))
	local surfaceColor3 = Theme.getElevatedColor(rawSurfaceColor3, elevation, schemeType)
	local dropShadowColor3 =
		Theme.getElevatedColor(rawDropShadowColor3, elevation, schemeType)

	-- effects
	React.useEffect(function()
		local connection: RBXScriptConnection
		connection = workspace.CurrentCamera
			:GetPropertyChangedSignal("ViewportSize")
			:Connect(function()
				setViewportSize(workspace.CurrentCamera.ViewportSize)
			end)
		return function()
			connection:Disconnect()
		end
	end, {})

	local popUpContainerContents = e(React.Fragment, {}, {
		UIListLayout = e(
			"UIListLayout",
			{
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, math.ceil(BUTTON_PADDING_DP * scale)),
				HorizontalFlex = if targetAbsoluteWidth
					then Enum.UIFlexAlignment.Fill
					else Enum.UIFlexAlignment.None,
				ItemLineAlignment = if targetAbsoluteWidth
					then Enum.ItemLineAlignment.Stretch
					else Enum.ItemLineAlignment.Automatic,
				VerticalFlex = Enum.UIFlexAlignment.None,
				Wraps = false,
			} :: RobloxTypes.UIListLayoutProperties
		),
		UIPadding = e(
			"UIPadding",
			{
				PaddingTop = UDim.new(0, math.ceil(MENU_TB_PADDING_DP * scale)),
				PaddingBottom = UDim.new(0, math.ceil(MENU_TB_PADDING_DP * scale)),
			} :: RobloxTypes.UIPaddingProperties
		),

		Display = displayComponent(),
	})

	local xSize = if targetAbsoluteWidth then targetAbsoluteWidth else 0
	local ySize = if isClipping then vLimit - targetAbsolutePosition.Y + 1 else 0
	local popUpContainerContainer = e(
		Container,
		{
			Size = UDim2.fromOffset(xSize, ySize),
			AutomaticSize = if not isClipping
				then if targetAbsoluteWidth
					then Enum.AutomaticSize.Y
					else Enum.AutomaticSize.XY
				elseif targetAbsoluteWidth then Enum.AutomaticSize.None
				else Enum.AutomaticSize.X,
			BackgroundTransparency = 0,
			BackgroundColor3 = surfaceColor3,
			[React.Change.AbsoluteSize] = function(inst: GuiObject)
				popUpContainerSetAbsoluteSize(inst.AbsoluteSize)
			end :: any,
			[React.Event.InputEnded] = if onCursorExit
				then function(_, input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						onCursorExit()
					end
				end
				else nil,
			children = {
				UICorner = e(
					"UICorner",
					{
						CornerRadius = cornerRadius,
					} :: RobloxTypes.UICornerProperties
				),
				UIClipPadding = if isClipping
					then e(
						"UIPadding",
						{
							-- PaddingRight = cornerRadius,
							-- PaddingLeft = cornerRadius,
							PaddingTop = cornerRadius,
							PaddingBottom = cornerRadius,
						} :: RobloxTypes.UIPaddingProperties
					)
					else nil,
				ScrollingListLayout = if isClipping
					then e(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							Padding = UDim.new(0, 0),
							HorizontalFlex = Enum.UIFlexAlignment.None,
							ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					)
					else nil,
				ScrollingContainer = if isClipping
					then e(
						ScrollingContainer,
						{
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ScrollBarThickness = math.ceil(12 * scale),
							ScrollBarImageColor3 = Theme.getElevatedColor(
								rawSurfaceColor3,
								elevation + 2,
								schemeType
							),
							AutomaticSize = if targetAbsoluteWidth
								then Enum.AutomaticSize.None
								else Enum.AutomaticSize.X,
							Size = UDim2.fromScale(
								if targetAbsoluteWidth then 1 else 0,
								1
							),
							CanvasSize = UDim2.fromScale(0, 0),
							AutomaticCanvasSize = Enum.AutomaticSize.Y,

							children = {
								Content = popUpContainerContents,
							},
						} :: RobloxTypes.ScrollingFrameProperties
					)
					else popUpContainerContents,
			},
		} :: RobloxTypes.GuiObjectProperties
	)

	local shadowFrame = e(
		ShadowFrame,
		{
			Name = "ShadowFrame",
			ShadowColor3 = dropShadowColor3,
			ShadowTransparency = dropShadowTransparency,
			ShadowCornerRadius = cornerRadius,
			Elevation = elevation,
			SchemeType = schemeType,
			Scale = scale,
			AutomaticSize = Enum.AutomaticSize.XY,

			children = {
				UIListLayout = e(
					"UIListLayout",
					{
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						Padding = UDim.new(0, 0),
						HorizontalFlex = Enum.UIFlexAlignment.None,
						ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
						VerticalFlex = Enum.UIFlexAlignment.None,
						Wraps = false,
					} :: RobloxTypes.UIListLayoutProperties
				),
				UIPadding = e(
					"UIPadding",
					{
						PaddingRight = UDim.new(0, math.ceil(SHADOW_OFFSET_DP.X * scale)),
						PaddingBottom = UDim.new(
							0,
							math.ceil(SHADOW_OFFSET_DP.Y * scale)
						),
					} :: RobloxTypes.UIPaddingProperties
				),
				PopUpContainer = popUpContainerContainer,
			},
		} :: ShadowFrame.ShadowFrameProperties
	)

	return e(
		PopUp,
		{
			DisplayAnchorPoint = Vector2.new(0, 0),
			DisplayOrder = displayOrder,
			ZIndexBehavior = zIndexBehavior,
			TargetAbsolutePosition = targetAbsolutePosition,
			DisplayComponent = function(): React.ReactNode
				return shadowFrame
			end,
		} :: PopUp.PopUpProperties
	)
end
