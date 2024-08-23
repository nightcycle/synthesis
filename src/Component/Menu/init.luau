--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
local MaterialIcons = require("@wally/MaterialIcons")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")
local Defaults = require("./Defaults")
local Theme = require("@proj/Theme")
local ButtonContainer = require("@comp/ButtonContainer")
local TextDisplay = require("@comp/TextDisplay")
local IconDisplay = require("@comp/IconDisplay")
local Container = require("@comp/Container")
local PopUpContainer = require("@comp/PopUpContainer")
-- Types
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type MenuBaseProperties = {
	TargetAbsolutePosition: Vector2,
	TargetAbsoluteWidth: number?,
	OnCursorExit: (() -> ())?,
	Elevation: number?,
	Rows: { [number]: (OptionData | ButtonData)? },
}
export type MenuProperties = MenuBaseProperties & {
	SchemeType: Enums.SchemeType?,
	Scale: number?,
	IsAnimated: boolean?,
	SurfaceColor3: Color3?,
	OnSurfaceColor3: Color3?,
	SelectionSurfaceColor3: Color3?,
	SelectionOnSurfaceColor3: Color3?,
	DisabledSurfaceColor3: Color3?,
	DisabledOnSurfaceColor3: Color3?,
	DropShadowColor3: Color3?,
	DropShadowTransparency: number?,
	FontData: Types.FontData?,
	SoundVolume: number?,
}

-- Constants
local SELECTION_CHECK_ICON = MaterialIcons.check
local LEFT_ICON_SIZE_DP = 24
local ICON_PADDING_DP = 12
local BUTTON_PADDING_DP = 1
local MENU_LR_PADDING_DP = 12
local MENU_TB_PADDING_DP = 8
local DIVIDER_THICKNESS_DP = 1
local DIVIDER_PAD_TOP_DP = 7
local DIVIDER_PAD_BOTTOM_DP = 8
local BUTTON_HEIGHT_DP = 48
local RIGHT_ICON_SIZE_DP = 24
-- Variables
-- References
-- Private Functions

-- Class
return function(props: MenuProperties): React.ReactNode
	-- unpack props
	local targetAbsolutePosition: Vector2 = props.TargetAbsolutePosition
	local targetAbsoluteWidth: number? = props.TargetAbsoluteWidth
	local onCursorExit: (() -> ())? = props.OnCursorExit
	local rows: { [number]: (OptionData | ButtonData)? } = props.Rows
	local isAnimated = if props.IsAnimated ~= nil
		then props.IsAnimated
		else Defaults.IsAnimated

	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local scale: number = props.Scale or Defaults.Scale
	local rawSurfaceColor3: Color3 = props.SurfaceColor3 or Defaults.SurfaceColor3
	local rawOnSurfaceColor3: Color3 = props.OnSurfaceColor3 or Defaults.OnSurfaceColor3
	local rawDropShadowColor3: Color3 = props.DropShadowColor3
		or Defaults.DropShadowColor3
	local dropShadowTransparency: number = props.DropShadowTransparency
		or Defaults.DropShadowTransparency
	local rawSelectionSurfaceColor3: Color3 = props.SelectionSurfaceColor3
		or Defaults.SelectionSurfaceColor3
	local rawSelectionOnSurfaceColor3: Color3 = props.SelectionOnSurfaceColor3
		or Defaults.SelectionOnSurfaceColor3
	local rawDisabledSurfaceColor3: Color3 = props.DisabledSurfaceColor3
		or Defaults.DisabledSurfaceColor3
	local rawDisabledOnSurfaceColor3: Color3 = props.DisabledOnSurfaceColor3
		or Defaults.DisabledOnSurfaceColor3
	local fontData: Types.FontData = props.FontData or Defaults.FontData
	local soundVolume: number = props.SoundVolume or Defaults.SoundVolume
	local elevation: number = props.Elevation or Defaults.Elevation

	-- set up state
	-- process state / props
	local surfaceColor3 = Theme.getElevatedColor(rawSurfaceColor3, elevation, schemeType)
	local onSurfaceColor3 =
		Theme.getElevatedColor(rawOnSurfaceColor3, elevation, schemeType)
	local dropShadowColor3 =
		Theme.getElevatedColor(rawDropShadowColor3, elevation, schemeType)
	local selectionSurfaceColor3 =
		Theme.getElevatedColor(rawSelectionSurfaceColor3, elevation, schemeType)
	local selectionOnSurfaceColor3 =
		Theme.getElevatedColor(rawSelectionOnSurfaceColor3, elevation, schemeType)
	local disabledSurfaceColor3 =
		Theme.getElevatedColor(rawDisabledSurfaceColor3, elevation, schemeType)
	local disabledOnSurfaceColor3 =
		Theme.getElevatedColor(rawDisabledOnSurfaceColor3, elevation, schemeType)

	-- components
	local function newButton(
		layoutOrder: number,
		optionData: OptionData | ButtonData
	): React.ReactNode
		local value: boolean? = (optionData :: any)["Value"]
		local textColor3 = if value then selectionOnSurfaceColor3 else onSurfaceColor3
		return React.createElement(
			ButtonContainer,
			{
				Type = Enums.ButtonRenderType.Filled,
				AutomaticSize = Enum.AutomaticSize.X,
				LayoutOrder = layoutOrder,
				LineColor3 = onSurfaceColor3,
				TargetPaddingDp = 0,
				Scale = scale,
				Elevation = elevation,
				Size = UDim2.new(0, 0, 0, BUTTON_HEIGHT_DP),
				SchemeType = schemeType,
				FillColor3 = if not value then surfaceColor3 else selectionSurfaceColor3,
				DisabledFillColor3 = disabledSurfaceColor3,
				DisabledLineColor3 = disabledOnSurfaceColor3,
				IsAnimated = isAnimated,
				IsEnabled = optionData.IsEnabled,
				SoundVolume = soundVolume,
				BorderSizePixel = 0,
				[React.Event.Activated] = function()
					if optionData.IsEnabled then
						if (optionData :: any).OnSelect then
							(optionData :: any).OnSelect(not value)
						elseif (optionData :: any).OnClick then
							(optionData :: any).OnClick()
						end
					end
				end :: any,
				Content = function(
					contentProps: ButtonContainer.ButtonContainerContentProperties
				): React.ReactNode
					return React.createElement(Container, {
						children = {
							UIPadding = React.createElement(
								"UIPadding",
								{
									PaddingLeft = UDim.new(
										0,
										math.ceil(MENU_LR_PADDING_DP * scale)
									),
									PaddingRight = UDim.new(
										0,
										math.ceil(MENU_LR_PADDING_DP * scale)
									),
								} :: RobloxTypes.UIPaddingProperties
							),
							UIListLayout = React.createElement(
								"UIListLayout",
								{
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									Padding = UDim.new(
										0,
										math.round(scale * ICON_PADDING_DP)
									),
									HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
									ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
									VerticalFlex = Enum.UIFlexAlignment.None,
									Wraps = false,
								} :: RobloxTypes.UIListLayoutProperties
							),
							LeftIcon = if optionData.Icon
								then React.createElement(
									IconDisplay,
									{
										LayoutOrder = 1,
										Size = UDim2.fromOffset(
											math.ceil(scale * LEFT_ICON_SIZE_DP),
											math.ceil(scale * LEFT_ICON_SIZE_DP)
										),
										Icon = optionData.Icon,
										IconColor3 = textColor3,
										IconTransparency = contentProps.Transparency,
									} :: IconDisplay.IconDisplayProperties
								)
								else React.createElement(
									"Frame",
									{
										LayoutOrder = 1,
										Size = UDim2.fromOffset(
											math.ceil(scale * LEFT_ICON_SIZE_DP),
											math.ceil(scale * LEFT_ICON_SIZE_DP)
										),
										BackgroundTransparency = 1,
									} :: IconDisplay.IconDisplayProperties
								),
							RightIcon = if value
								then React.createElement(
									IconDisplay,
									{
										LayoutOrder = 3,
										AutomaticSize = Enum.AutomaticSize.None,
										Size = UDim2.fromOffset(
											math.ceil(scale * RIGHT_ICON_SIZE_DP),
											math.ceil(scale * RIGHT_ICON_SIZE_DP)
										),
										Icon = SELECTION_CHECK_ICON,
										IconColor3 = textColor3,
										IconTransparency = contentProps.Transparency,
									} :: IconDisplay.IconDisplayProperties
								)
								else nil,
							TextDisplay = React.createElement(
								TextDisplay.Full,
								{
									LayoutOrder = 2,
									Text = optionData.Text,
									TextColor3 = textColor3,
									TextTransparency = contentProps.Transparency,
									FontData = fontData,
									Scale = scale,
									LeftIcon = nil,
									RightIcon = nil,
									IconSeparationPaddingDp = 0,
									IgnoreLineHeight = false,
									TextXAlignment = Enum.TextXAlignment.Left,
									children = {
										UIFlexItem = React.createElement(
											"UIFlexItem",
											{
												FlexMode = Enum.UIFlexMode.Fill,
												ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
											} :: RobloxTypes.UIFlexItemProperties
										),
									},
								} :: TextDisplay.TextDisplayProperties
							),
						},
					})
				end,
			} :: ButtonContainer.ButtonContainerProperties
		)
	end

	local function newDivider(layoutOrder: number)
		return React.createElement(
			"Frame",
			{
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
			} :: React.ReactNode,
			{
				UIListLayout = React.createElement(
					"UIListLayout",
					{
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, math.round(scale * ICON_PADDING_DP)),
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
						VerticalFlex = Enum.UIFlexAlignment.None,
						Wraps = false,
					} :: RobloxTypes.UIListLayoutProperties
				),
				UIFlexItem = React.createElement(
					"UIFlexItem",
					{
						FlexMode = Enum.UIFlexMode.Fill,
						ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
					} :: RobloxTypes.UIFlexItemProperties
				),
				UIPadding = React.createElement(
					"UIPadding",
					{
						PaddingTop = UDim.new(0, math.ceil(DIVIDER_PAD_TOP_DP * scale)),
						PaddingBottom = UDim.new(
							0,
							math.ceil(DIVIDER_PAD_BOTTOM_DP * scale)
						),
					} :: RobloxTypes.UIPaddingProperties
				),
				Line = React.createElement(
					"Frame",
					{
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						BackgroundColor3 = onSurfaceColor3,
						Size = UDim2.new(
							0,
							0,
							0,
							math.ceil(DIVIDER_THICKNESS_DP * scale)
						),
						AutomaticSize = Enum.AutomaticSize.X,
					} :: React.ReactNode
				),
			}
		)
	end

	local buttons: { [string]: React.ReactNode } = {}
	local maxIndex = 0
	for k, optionData in pairs(rows) do
		maxIndex = math.max(k, maxIndex)
	end
	for i = 1, maxIndex do
		local data = rows[i]
		if data then
			buttons[`Row{i}Button`] = newButton(i, data)
		else
			buttons[`Row{i}Divider`] = newDivider(i)
		end
	end

	local menuContents = React.createElement(React.Fragment, {}, {
		UIListLayout = React.createElement(
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
		UIPadding = React.createElement(
			"UIPadding",
			{
				PaddingTop = UDim.new(0, math.ceil(MENU_TB_PADDING_DP * scale)),
				PaddingBottom = UDim.new(0, math.ceil(MENU_TB_PADDING_DP * scale)),
			} :: RobloxTypes.UIPaddingProperties
		),

		Buttons = React.createElement(React.Fragment, {}, buttons),
	})

	return React.createElement(
		PopUpContainer,
		{
			DisplayAnchorPoint = Vector2.new(0, 0),
			TargetAbsolutePosition = targetAbsolutePosition,
			TargetAbsoluteWidth = targetAbsoluteWidth,
			SurfaceColor3 = rawSurfaceColor3,
			Elevation = elevation,
			SchemeType = schemeType,
			DropShadowColor3 = dropShadowColor3,
			DropShadowTransparency = dropShadowTransparency,
			Scale = scale,
			OnCursorExit = onCursorExit,
			DisplayComponent = function(): React.ReactNode
				return menuContents
			end,
		} :: PopUpContainer.PopUpContainerProperties
	)
end
