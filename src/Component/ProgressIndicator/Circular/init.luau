--!strict
--!native
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
local Spring = require("@wally/Spring")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Enums = require("@proj/Enums")
local Style = require("@proj/Style")
local Types = require("@proj/Types")
local Defaults = require("./Defaults")
local Theme = require("@proj/Theme")
local PropUtil = require("@proj/PropUtil")

-- Types
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type BaseCircularProgressIndicatorProperties = RobloxTypes.GuiObjectProperties & {
	Progress: number?,
	IsEnabled: boolean?,
	Elevation: number?,
}
type Style = Style.Style
type Spring = Spring.Spring
export type CircularProgressIndicatorProperties = BaseCircularProgressIndicatorProperties & {
	FillColor3: Color3?,
	EmptyColor3: Color3?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
}
export type StyleCircularProgressIndicatorProperties =
	BaseCircularProgressIndicatorProperties
	& {
		Style: Style,
	}

-- Constants
local DIAMETER_DP = 36 --48
local RING_ASSET_URL = "rbxassetid://3587367081"
local ROTATION_OFFSET = 180
local BUFFER = 10

-- Variables
-- References
-- Private Functions
function tickAlpha(period: number, offset: number?): number
	offset = offset or 0
	assert(offset)
	return ((tick() - offset) % period) / period
end
function tickCycle(period: number, offset: number?): number
	return math.cos(math.rad(360) * tickAlpha(period, offset))
end
function newSemiRotaryElement(
	progressStart: number,
	progressFinish: number,
	color3: Color3,
	transparency: number
): React.ReactNode
	return React.createElement(
		"CanvasGroup",
		{
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		} :: RobloxTypes.CanvasGroupProperties,
		{
			UIGradient = React.createElement(
				"UIGradient",
				{
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.499, 0),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Rotation = (progressStart + ROTATION_OFFSET) % 360,
				} :: RobloxTypes.UIGradientProperties
			),
			ImageLabel = React.createElement(
				"ImageLabel",
				{
					Image = RING_ASSET_URL,
					ImageColor3 = color3,
					ImageTransparency = transparency,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
				} :: RobloxTypes.ImageLabelProperties,
				{
					UIGradient = React.createElement(
						"UIGradient",
						{
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(0.499, 1),
								NumberSequenceKeypoint.new(0.5, 0),
								NumberSequenceKeypoint.new(1, 0),
							}),
							Rotation = (progressFinish + ROTATION_OFFSET) % 360,
						} :: RobloxTypes.UIGradientProperties
					),
				}
			),
		}
	)
end

function newRotaryElement(props: RobloxTypes.GuiObjectProperties & {
	ProgressStart: number,
	ProgressWidth: number,
	Color3: Color3,
	Transparency: number,
}): React.ReactNode
	local progressFinish = (props.ProgressStart + props.ProgressWidth) % 360
	local progressMid = (props.ProgressStart + props.ProgressWidth * 0.5) % 360

	return React.createElement(
		"Frame",
		PropUtil.mergeGuiObject(
			{
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
			} :: RobloxTypes.GuiObjectProperties,
			props
		),
		{
			SemiRotor1 = newSemiRotaryElement(
				props.ProgressStart,
				progressMid,
				props.Color3,
				props.Transparency
			),
			SemiRotor2 = newSemiRotaryElement(
				progressMid,
				progressFinish,
				props.Color3,
				props.Transparency
			),
		}
	)
end

-- Class
local Library = {}

Library.Full = function(props: CircularProgressIndicatorProperties): React.ReactNode
	-- unpack props
	local progress: number? = props.Progress
	local isEnabled: boolean = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled
	local rawFillColor3: Color3 = props.FillColor3 or Defaults.FillColor3
	local rawEmptyColor3: Color3 = props.EmptyColor3 or Defaults.EmptyColor3
	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local elevation: number = props.Elevation or Defaults.Elevation
	local scale: number = props.Scale or Defaults.Scale

	-- state
	local progressStart, setProgressStart = React.useState(0)
	local progressWidth, setProgressWidth = React.useState(0)
	local startSpring, setStartSpring = React.useState(Spring.new(30, 40, 0))
	local widthSpring, setWidthSpring = React.useState(Spring.new(70, 80, 0))

	-- process internal properties
	local fillColor3 = Theme.getElevatedColor(rawFillColor3, elevation, schemeType)
	local emptyColor3 = Theme.getElevatedColor(rawEmptyColor3, elevation, schemeType)
	local transparency = if isEnabled then 0 else 1
	local isActive = not progress or progress ~= progressWidth

	-- update state
	React.useEffect(function()
		if isActive then
			local connection: RBXScriptConnection
			connection = RunService.RenderStepped:Connect(function(deltaTime: number)
				if progress ~= nil then
					assert(progress)
					startSpring:Set(0)
					widthSpring:Set(progress * 360)
				else
					local start = (360 * tickAlpha(2)) % 360
					local width = (180 + 140 * tickCycle(5)) % 360

					startSpring:Set(start)
					widthSpring:Set(width)
				end

				if startSpring.Position - 180 > startSpring.Goal then
					startSpring.Position -= 360
				elseif startSpring.Position + 180 < startSpring.Goal then
					startSpring.Position += 360
				end

				startSpring:Step(deltaTime)
				widthSpring:Step(deltaTime)

				local newProgressStart = startSpring:Get() % 360
				if newProgressStart ~= progressStart then
					setProgressStart(newProgressStart)
					setStartSpring(startSpring)
				end
				local newProgressWidth = widthSpring:Get() % 360
				if newProgressWidth ~= progressWidth then
					setProgressWidth(newProgressWidth)
					setWidthSpring(widthSpring)
				end
			end)

			return function()
				connection:Disconnect()
			end
		else
			return function() end
		end
	end)

	return React.createElement(
		"Frame",
		PropUtil.mergeGuiObject(
			{
				Size = UDim2.fromOffset(
					math.ceil(scale * DIAMETER_DP),
					math.ceil(scale * DIAMETER_DP)
				),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
			} :: RobloxTypes.GuiObjectProperties,
			props
		),
		{
			Fill = newRotaryElement({
				ProgressStart = progressStart,
				ProgressWidth = progressWidth,
				Color3 = fillColor3,
				Transparency = transparency,
				ZIndex = 2,
			}),
			Empty = newRotaryElement({
				ProgressStart = (progressStart + progressWidth + BUFFER) % 360,
				ProgressWidth = 360 - progressWidth - BUFFER * 2,
				Color3 = emptyColor3,
				Transparency = transparency,
				ZIndex = 1,
			}),
		}
	)
end

function Library.OnSurfacePrimary(
	props: StyleCircularProgressIndicatorProperties
): React.ReactNode
	local style = props.Style
	local mergeProps = table.clone(props) :: CircularProgressIndicatorProperties
	mergeProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Primary)
	mergeProps.EmptyColor3 = style:GetColor(Enums.ColorRoleType.PrimaryContainer)
	mergeProps.SchemeType = style.SchemeType
	mergeProps.Scale = style.Scale

	return React.createElement(Library.Full, mergeProps)
end

function Library.OnSurfaceSecondary(
	props: StyleCircularProgressIndicatorProperties
): React.ReactNode
	local style = props.Style
	local mergeProps = table.clone(props) :: CircularProgressIndicatorProperties
	mergeProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Secondary)
	mergeProps.EmptyColor3 = style:GetColor(Enums.ColorRoleType.SecondaryContainer)
	mergeProps.SchemeType = style.SchemeType
	mergeProps.Scale = style.Scale

	return React.createElement(Library.Full, mergeProps)
end

function Library.OnSurfaceTertiary(
	props: StyleCircularProgressIndicatorProperties
): React.ReactNode
	local style = props.Style
	local mergeProps = table.clone(props) :: CircularProgressIndicatorProperties
	mergeProps.FillColor3 = style:GetColor(Enums.ColorRoleType.Tertiary)
	mergeProps.EmptyColor3 = style:GetColor(Enums.ColorRoleType.TertiaryContainer)
	mergeProps.SchemeType = style.SchemeType
	mergeProps.Scale = style.Scale

	return React.createElement(Library.Full, mergeProps)
end

return Library
