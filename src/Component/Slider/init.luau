--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
local TableUtil = require("@wally/TableUtil")
-- Modules
local PropUtil = require("@proj/PropUtil")
local RobloxTypes = require("@proj/RobloxTypes")
local Theme = require("@proj/Theme")
local Enums = require("@proj/Enums")
local Types = require("@proj/Types")
local Style = require("@proj/Style")
local Defaults = require("./Defaults")
local Sounds = require("@proj/Sounds")
-- Types
type Style = Style.Style
export type BaseSliderProperties = RobloxTypes.GuiButtonProperties & {
	Range: NumberRange,
	Value: number | NumberRange,
	OnChange: (value: number | NumberRange) -> (),
	OnRelease: ((value: number | NumberRange) -> ())?,
	SnapCount: number?,
	IsLabelEnabled: boolean?,
	IsEnabled: boolean?,
	Elevation: number?,
}
export type SliderProperties = BaseSliderProperties & {
	FillColor3: Color3?,
	ContainerColor3: Color3?,
	OnFillColor3: Color3?,
	OnContainerColor3: Color3?,
	DisabledFillColor3: Color3?,
	DisabledContainerColor3: Color3?,
	DisabledOnFillColor3: Color3?,
	DisabledOnContainerColor3: Color3?,
	LabelColor3: Color3?,
	OnLabelColor3: Color3?,
	LabelFontData: Types.FontData?,
	SoundVolume: number?,
	IsAnimated: boolean?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
}
export type StyleSliderProperties = BaseSliderProperties & {
	Style: Style,
}
-- Constants
local BAR_HEIGHT_DP = 16
local HANDLE_HEIGHT_DP = 44
local HANDLE_WIDTH_DP = 6
local PRESSED_HANDLE_WIDTH_DP = 2
local DISABLED_HANDLE_WIDTH_DP = 4
local DOT_DIAMETER_DP = 4
local LEFTRIGHT_PAD_DP = 4
local HANDLE_PAD_DP = 6
local DISABLED_TRANSPARENCY = 1 - 0.38
local SEQ_STEP = 0.0005
local SOUND_TYPE = Enums.SoundType.ui_tap_variant_01

-- Variables
-- References
-- Private Functions
local packSequence = function(sequence: {
	[number]: Color3,
} | {
	[number]: number,
}): NumberSequence | ColorSequence
	if typeof((sequence :: any)[0]) == "Color3" then
		local out: { ColorSequenceKeypoint } = {}
		for t, value in pairs(sequence) do
			table.insert(out, ColorSequenceKeypoint.new(t, value))
		end
		table.sort(
			out,
			function(a: ColorSequenceKeypoint, b: ColorSequenceKeypoint): boolean
				return a.Time < b.Time
			end
		)
		return ColorSequence.new(out)
	else
		local out: { NumberSequenceKeypoint } = {}
		for t, value in pairs(sequence) do
			table.insert(out, NumberSequenceKeypoint.new(t, value))
		end
		table.sort(
			out,
			function(a: NumberSequenceKeypoint, b: NumberSequenceKeypoint): boolean
				return a.Time < b.Time
			end
		)
		return NumberSequence.new(out)
	end
end

local drawPackSequence = function<V>(transitions: { [number]: V }): { [number]: V }
	transitions = table.clone(transitions)
	local times = TableUtil.keys(transitions)
	table.sort(times)
	-- print("\ntrans", transitions)
	do
		local defaultStartV: V = transitions[0]
		local defaultEndV: V = transitions[1]
		assert(defaultStartV, "No default start value")
		assert(defaultEndV, "No default end value")
		local closestPreStart: V?
		local closestPostFinish: V?

		local clipTransitions = {}
		for i, t in ipairs(times) do
			if t <= 0 then
				closestPreStart = if i < #times
					then transitions[times[i + 1]]
					else transitions[t]
			elseif t > 1 then
				closestPostFinish = transitions[t]
				break
			else
				clipTransitions[t] = transitions[t]
			end
		end

		clipTransitions[0] = closestPreStart or defaultStartV
		clipTransitions[1] = closestPostFinish or defaultEndV

		times = TableUtil.keys(clipTransitions)
		table.sort(times)
		transitions = clipTransitions
	end

	-- print("trans 2", transitions)

	local outValues: { V } = { transitions[0] }
	local outTimes: { number } = { 0 }
	assert(#outTimes == 1 and #outValues == 1, "Invalid initial state")
	for i = 2, #times - 1 do
		local t = times[i]
		local v = transitions[t]
		local pV = outValues[#outValues]
		local pT = outTimes[#outTimes]
		if v ~= pV or pT == 0 then
			local stepT = pT + SEQ_STEP
			if stepT < t and pT ~= 0 and stepT < 1 then
				table.insert(outValues, v)
				table.insert(outTimes, stepT)
			end

			table.insert(outValues, v)
			table.insert(outTimes, t)
		else
			outTimes[#outTimes] = t
		end
	end

	do
		local finalStep = outTimes[#outTimes] + SEQ_STEP
		if finalStep < 1 then
			table.insert(outValues, transitions[1])
			table.insert(outTimes, finalStep)
		end
	end

	table.insert(outValues, transitions[1])
	table.insert(outTimes, 1)

	local out: { [number]: V } = {}
	for i, t in ipairs(outTimes) do
		out[t] = outValues[i]
	end

	-- print(`times:`, outTimes)
	-- print(`values:`, outValues)

	return out
end

-- Class
local Library = {}
Library.Full = function(props: SliderProperties): React.ReactNode
	-- unpack props
	local range: NumberRange = props.Range
	local value: NumberRange | number = props.Value
	local onChange: (NumberRange | number) -> () = props.OnChange
	local onRelease: ((NumberRange | number) -> ())? = props.OnRelease
	local snapCount: number? = props.SnapCount or Defaults.SnapCount
	local isLabelEnabled: boolean = if props.IsLabelEnabled ~= nil
		then props.IsLabelEnabled
		else Defaults.IsLabelEnabled
	local isEnabled: boolean = if props.IsEnabled ~= nil
		then props.IsEnabled
		else Defaults.IsEnabled
	local isAnimated: boolean = if props.IsAnimated ~= nil
		then props.IsAnimated
		else Defaults.IsAnimated
	local elevation: number = props.Elevation or Defaults.Elevation
	local scale: number = props.Scale or Defaults.Scale
	local soundVolume: number = props.SoundVolume or Defaults.SoundVolume
	local schemeType: Enums.SchemeType = props.SchemeType or Defaults.SchemeType
	local labelFontData: Types.FontData = props.LabelFontData or Defaults.LabelFontData
	local fillColor3: Color3 = props.FillColor3 or Defaults.FillColor3
	local containerColor3: Color3 = props.ContainerColor3 or Defaults.ContainerColor3
	local onFillColor3: Color3 = props.OnFillColor3 or Defaults.OnFillColor3
	local onContainerColor3: Color3 = props.OnContainerColor3
		or Defaults.OnContainerColor3
	local labelColor3: Color3 = props.LabelColor3 or Defaults.LabelColor3
	local onLabelColor3: Color3 = props.OnLabelColor3 or Defaults.OnLabelColor3

	local disabledFillColor3: Color3 = props.DisabledFillColor3
		or Defaults.DisabledFillColor3
	local disabledContainerColor3: Color3 = props.DisabledContainerColor3
		or Defaults.DisabledContainerColor3
	local disabledOnFillColor3: Color3 = props.DisabledOnFillColor3
		or Defaults.DisabledOnFillColor3
	local disabledOnContainerColor3: Color3 = props.DisabledOnContainerColor3
		or Defaults.DisabledOnContainerColor3

	local labelFontData: Types.FontData = props.LabelFontData or Defaults.LabelFontData

	-- set up state
	local absoluteSize: Vector2, setAbsoluteSize = React.useState(Vector2.new(0, 0))
	local selectionIndex: number?, setSelectionIndex = React.useState(nil :: number?)
	local isHovered: boolean, setIsHovered = React.useState(false)
	local isPressed: boolean, setIsPressed = React.useState(false)
	local isFocused: boolean, setIsFocused = React.useState(false)

	-- process value
	local function formatScalarValue(scalarValue: number): number
		local outValue = math.clamp(scalarValue, range.Min, range.Max)
		if snapCount then
			local alpha = (outValue - range.Min) / (range.Max - range.Min)
			local interval = (range.Max - range.Min) / (snapCount - 1)
			outValue = range.Min
				+ math.round(math.round(alpha * (snapCount - 1)) * interval)
		else
			outValue = math.round(outValue)
		end
		return outValue
	end

	if typeof(value) == "number" then
		local formatValue = formatScalarValue(value)
		if formatValue ~= value then
			value = formatValue
			onChange(value)
		end
	else
		local formatMinValue = formatScalarValue(value.Min)
		local formatMaxValue = formatScalarValue(value.Max)
		if formatMinValue ~= value.Min or formatMaxValue ~= value.Max then
			value = NumberRange.new(formatMinValue, formatMaxValue)
			onChange(value)
		end
	end

	local handleAlpha1: number, handleAlpha2: number?
	if typeof(value) == "number" then
		print("value", value, "range", range.Min, "-", range.Max)
		handleAlpha1 = math.clamp((value - range.Min) / (range.Max - range.Min), 0, 1)
	else
		handleAlpha1 = math.clamp((value.Min - range.Min) / (range.Max - range.Min), 0, 1)
		handleAlpha2 = math.clamp((value.Max - range.Min) / (range.Max - range.Min), 0, 1)
	end

	-- process other internal variables
	local padPx = math.ceil(LEFTRIGHT_PAD_DP * scale)
	local actualFillColor3 = Theme.getElevatedColor(
		if isEnabled then fillColor3 else disabledFillColor3,
		elevation,
		schemeType
	)
	local actualContainerColor3 = Theme.getElevatedColor(
		if isEnabled then containerColor3 else disabledContainerColor3,
		elevation,
		schemeType
	)
	local actualOnFillColor3 = Theme.getElevatedColor(
		if isEnabled then onFillColor3 else disabledOnFillColor3,
		elevation,
		schemeType
	)
	local actualOnContainerColor3 = Theme.getElevatedColor(
		if isEnabled then onContainerColor3 else disabledOnContainerColor3,
		elevation,
		schemeType
	)
	local state =
		Types._RenderData.getButtonState(isHovered, isPressed, isFocused, isEnabled)
	local handleWidthPx1: number
	if
		state == Enums.ButtonStateType.Enabled
		or state == Enums.ButtonStateType.Hovered
	then
		handleWidthPx1 = math.ceil(HANDLE_WIDTH_DP * scale)
	elseif state == Enums.ButtonStateType.Disabled then
		handleWidthPx1 = math.ceil(DISABLED_HANDLE_WIDTH_DP * scale)
	else
		handleWidthPx1 = math.ceil(PRESSED_HANDLE_WIDTH_DP * scale)
	end

	-- solve handles color / number sequence
	local handleAlphaWidth1 = handleWidthPx1 / absoluteSize.X
	local leftRightPadAlphaWidth = padPx / absoluteSize.X

	local handleTransparencySequence: NumberSequence?
	local barTransparencySequence: NumberSequence?
	local barFillColorSequence: ColorSequence?

	local transparency = if state == Enums.ButtonStateType.Disabled
		then DISABLED_TRANSPARENCY
		else 0

	if absoluteSize.X > 0 then
		if handleAlpha2 then
			local handleAlphaWidth2: number
			if selectionIndex == 2 then
				handleAlphaWidth2 = handleAlphaWidth1
				handleAlphaWidth1 = math.ceil(HANDLE_WIDTH_DP * scale) / absoluteSize.X
			else
				handleAlphaWidth2 = math.ceil(HANDLE_WIDTH_DP * scale) / absoluteSize.X
			end
			local minAlpha = math.clamp(
				leftRightPadAlphaWidth + handleAlpha1 * (1 - 2 * leftRightPadAlphaWidth),
				leftRightPadAlphaWidth,
				1 - leftRightPadAlphaWidth
			)
			local minHandleGapAlphaWidth = (
				handleAlphaWidth1 + (2 * math.ceil(HANDLE_PAD_DP * scale))
			) / absoluteSize.X
			local minFinish = math.clamp(minAlpha + handleAlphaWidth1 / 2, 0, 1)
			local minStart = math.clamp(minAlpha - handleAlphaWidth1 / 2, 0, 1)
			local minGapStart = math.clamp(minStart - minHandleGapAlphaWidth / 2, 0, 1)
			local minGapFinish = math.clamp(minFinish + minHandleGapAlphaWidth / 2, 0, 1)

			local maxHandleGapAlphaWidth = (
				handleAlphaWidth2 + (2 * math.ceil(HANDLE_PAD_DP * scale))
			) / absoluteSize.X
			local maxAlpha = math.clamp(
				leftRightPadAlphaWidth + handleAlpha2 * (1 - 2 * leftRightPadAlphaWidth),
				leftRightPadAlphaWidth,
				1 - leftRightPadAlphaWidth
			)

			local maxFinish = math.clamp(maxAlpha + handleAlphaWidth2 / 2, 0, 1)
			local maxStart = math.clamp(maxAlpha - handleAlphaWidth2 / 2, 0, 1)
			local maxGapStart = math.clamp(maxStart - maxHandleGapAlphaWidth / 2, 0, 1)
			local maxGapFinish = math.clamp(maxFinish + maxHandleGapAlphaWidth / 2, 0, 1)

			do
				local handleTransData = {
					[0] = 1,
					[1] = 1,
				}
				handleTransData[minStart] = 1
				handleTransData[minFinish] = transparency

				handleTransData[maxStart] = 1
				handleTransData[maxFinish] = transparency

				handleTransparencySequence =
					packSequence(drawPackSequence(handleTransData)) :: NumberSequence

				local barTransData = {
					[0] = transparency,
					[1] = transparency,
				}
				local barColorData: { [number]: Color3 } = {
					[0] = actualContainerColor3,
					[1] = actualContainerColor3,
				}
				if maxGapStart > minGapFinish then
					barTransData[minGapStart] = transparency
					barTransData[minGapFinish] = 1

					barTransData[maxGapStart] = transparency
					barTransData[maxGapFinish] = 1
				else
					barTransData[minGapStart] = transparency
					barTransData[maxGapFinish] = 1
				end
				barColorData[minGapStart] = actualContainerColor3
				barColorData[maxGapFinish] = actualFillColor3
				barTransparencySequence =
					packSequence(drawPackSequence(barTransData)) :: NumberSequence
				barFillColorSequence =
					packSequence(drawPackSequence(barColorData)) :: ColorSequence
			end
		else
			-- print("handleAlpha1", handleAlpha1)
			local handleGapAlphaWidth = (
				handleWidthPx1 + (2 * math.ceil(HANDLE_PAD_DP * scale))
			) / absoluteSize.X
			local renderAlpha1 = math.clamp(
				leftRightPadAlphaWidth + handleAlpha1 * (1 - 2 * leftRightPadAlphaWidth),
				leftRightPadAlphaWidth,
				1 - leftRightPadAlphaWidth
			)

			local handle1Finish = math.clamp(renderAlpha1 + handleAlphaWidth1 / 2, 0, 1)
			local handle1Start = math.clamp(renderAlpha1 - handleAlphaWidth1 / 2, 0, 1)

			local handle1GapStart =
				math.clamp(handle1Start - handleGapAlphaWidth / 2, 0, 1)
			local handle1GapFinish =
				math.clamp(handle1Finish + handleGapAlphaWidth / 2, 0, 1)
			if handle1Finish > handle1Start then
				do
					local handleTransData = {
						[0] = 1,
						[1] = 1,
					}
					handleTransData[handle1Start] = 1
					handleTransData[handle1Finish] = transparency
					handleTransparencySequence =
						packSequence(drawPackSequence(handleTransData)) :: NumberSequence
				end

				local barTransData = {
					[0] = transparency,

					[1] = transparency,
				}
				barTransData[handle1GapStart] = transparency
				barTransData[handle1GapFinish] = 1
				barTransparencySequence =
					packSequence(drawPackSequence(barTransData)) :: NumberSequence

				local barColorData: { [number]: Color3 } = {}
				for t, v in pairs(barTransData) do
					if t > handleAlpha1 then
						barColorData[t] = actualContainerColor3
					else
						barColorData[t] = actualFillColor3
					end
				end
				barFillColorSequence = packSequence(barColorData) :: ColorSequence
			else
				handleTransparencySequence = NumberSequence.new(1)
				barTransparencySequence = NumberSequence.new(transparency)
			end
		end
	end

	local function updateHandle(
		button: ImageButton,
		x: number,
		y: number,
		isOnRelease: boolean
	)
		if not isEnabled then
			return
		end
		if not isPressed then
			return
		end
		local start = button.AbsolutePosition.X + padPx
		local width = button.AbsoluteSize.X - (2 * padPx)
		local alpha = math.clamp((x - start) / width, 0, 1)

		if not selectionIndex then
			if handleAlpha2 then
				local minDist = math.abs(handleAlpha1 - alpha)
				local maxDist = math.abs(handleAlpha2 - alpha)
				print(`h1:`, handleAlpha1, `h2:`, handleAlpha2, `alpha:`, alpha)
				print(`minDist:`, minDist, `maxDist:`, maxDist)

				if minDist < maxDist then
					setSelectionIndex(1)
				else
					setSelectionIndex(2)
				end
			else
				if selectionIndex ~= 1 then
					setSelectionIndex(1)
				end
			end
		elseif isOnRelease then
			setSelectionIndex(nil)
		end
		if typeof(value) == "number" then
			local newValue =
				formatScalarValue(range.Min + alpha * (range.Max - range.Min))
			if newValue == value then
				return
			end
			if isOnRelease then
				if onRelease then
					onRelease(newValue)
				end
			else
				onChange(newValue)
			end
		elseif selectionIndex then
			local minVal, maxVal = value.Min, value.Max
			local newVal = formatScalarValue(range.Min + alpha * (range.Max - range.Min))
			local outValue: NumberRange
			if selectionIndex == 1 then
				if newVal == minVal then
					return
				end
				if newVal >= maxVal then
					return
				end
				outValue = NumberRange.new(newVal, maxVal)
			else
				if newVal == maxVal then
					return
				end
				if newVal <= minVal then
					return
				end
				outValue = NumberRange.new(minVal, newVal)
			end

			if isOnRelease then
				if onRelease then
					onRelease(outValue)
				end
			else
				onChange(outValue)
			end
		end
	end

	return React.createElement(
		"ImageButton",
		PropUtil.mergeGuiButton(
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				[React.Event.InputBegan] = function(
					inst: ImageButton,
					input: InputObject
				)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if not isHovered then
							setIsHovered(true)
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not isPressed then
							setIsPressed(true)
						end
					end
				end :: any,
				[React.Event.MouseLeave] = function()
					if isHovered then
						setIsHovered(false)
					end
					if isPressed then
						setIsPressed(false)
					end
					if selectionIndex then
						setSelectionIndex(nil)
					end
				end,
				[React.Event.InputChanged] = function(
					inst: ImageButton,
					input: InputObject
				)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						updateHandle(inst, input.Position.X, input.Position.Y, false)
					end
				end :: any,
				[React.Event.InputEnded] = function(
					inst: ImageButton,
					input: InputObject
				)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if isHovered then
							setIsHovered(false)
						end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
						if isPressed then
							setIsPressed(false)
						end
					end
				end,
				[React.Event.Activated] = function()
					if isEnabled then
						if soundVolume >= 0 then
							Sounds.play(SOUND_TYPE, soundVolume)
						end
					end
				end,
				[React.Event.SelectionGained] = function()
					if isEnabled then
						if not isFocused then
							setIsFocused(true)
						end
					end
				end,
				[React.Event.SelectionLost] = function()
					if isEnabled then
						if isFocused then
							setIsFocused(false)
						end
					end
				end,
				[React.Event.MouseButton1Down] = function(
					inst: ImageButton,
					x: number,
					y: number
				)
					updateHandle(inst, x, y, false)
				end,
				[React.Event.MouseButton1Up] = function(
					inst: ImageButton,
					x: number,
					y: number
				)
					updateHandle(inst, x, y, true)
				end,
				[React.Change.AbsoluteSize] = function(inst: ImageButton)
					setAbsoluteSize(inst.AbsoluteSize)
				end :: any,
			} :: RobloxTypes.GuiButtonProperties,
			props
		),
		{
			UIListLayout = React.createElement(
				"UIListLayout",
				{
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 0),
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
					VerticalFlex = Enum.UIFlexAlignment.None,
					Wraps = false,
				} :: RobloxTypes.UIListLayoutProperties
			),
			Handle = React.createElement(
				"Frame",
				{
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 0, math.round(HANDLE_HEIGHT_DP * scale)),
				} :: RobloxTypes.FrameProperties,
				{
					UIGradient = React.createElement(
						"UIGradient",
						{
							Color = ColorSequence.new(actualFillColor3),
							Transparency = handleTransparencySequence,
						} :: RobloxTypes.UIGradientProperties
					),
					UIListLayout = React.createElement(
						"UIListLayout",
						{
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 0),
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							HorizontalFlex = Enum.UIFlexAlignment.Fill,
							ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
							VerticalFlex = Enum.UIFlexAlignment.None,
							Wraps = false,
						} :: RobloxTypes.UIListLayoutProperties
					),
					Bar = React.createElement(
						"Frame",
						{
							BackgroundColor3 = Color3.new(1, 1, 1),
							BorderSizePixel = 0,
							Size = UDim2.new(0, 0, 0, math.round(BAR_HEIGHT_DP * scale)),
						} :: RobloxTypes.FrameProperties,
						{
							UIListLayout = if snapCount
								then React.createElement(
									"UIListLayout",
									{
										SortOrder = Enum.SortOrder.LayoutOrder,
										FillDirection = Enum.FillDirection.Vertical,
										Padding = UDim.new(0, 0),
										VerticalAlignment = Enum.VerticalAlignment.Center,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										HorizontalFlex = Enum.UIFlexAlignment.Fill,
										ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
										VerticalFlex = Enum.UIFlexAlignment.None,
										Wraps = false,
									} :: RobloxTypes.UIListLayoutProperties
								)
								else nil,
							UIGradient = React.createElement(
								"UIGradient",
								{
									Color = barFillColorSequence,
									Transparency = barTransparencySequence,
								} :: RobloxTypes.UIGradientProperties
							),
							UICorner = React.createElement(
								"UICorner",
								{
									CornerRadius = UDim.new(0.5, 0),
								} :: RobloxTypes.UICornerProperties
							),
							DotContainer = if snapCount
								then React.createElement(
									"Frame",
									{
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.new(
											0,
											0,
											0,
											math.round(DOT_DIAMETER_DP * scale)
										),
									} :: RobloxTypes.FrameProperties,
									{
										UIListLayout = React.createElement(
											"UIListLayout",
											{
												SortOrder = Enum.SortOrder.LayoutOrder,
												FillDirection = Enum.FillDirection.Horizontal,
												Padding = UDim.new(0, 0),
												VerticalAlignment = Enum.VerticalAlignment.Center,
												HorizontalAlignment = Enum.HorizontalAlignment.Center,
												HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
												ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
												VerticalFlex = Enum.UIFlexAlignment.None,
												Wraps = false,
											} :: RobloxTypes.UIListLayoutProperties
										),
										Dots = React.createElement(
											React.Fragment,
											{},
											(function(): { [string]: React.ReactNode }
												local out: { [string]: React.ReactNode } =
													{
														UIPadding = React.createElement(
															"UIPadding",
															{
																PaddingLeft = UDim.new(
																	0,
																	padPx
																),
																PaddingRight = UDim.new(
																	0,
																	padPx
																),
															} :: RobloxTypes.UIPaddingProperties
														),
													}
												for i = 0, snapCount - 1 do
													local alpha = i / (snapCount - 1)
													local color = if alpha
															< handleAlpha1
														then actualOnFillColor3
														else actualOnContainerColor3

													out["Dot" .. i] = React.createElement(
														"Frame",
														{
															BackgroundColor3 = color,
															BackgroundTransparency = if math.abs(
																	handleAlpha1 - alpha
																)
																	< handleAlphaWidth1
																		* 0.5
																then 1
																else 0,
															BorderSizePixel = 0,
															LayoutOrder = i,
															Size = UDim2.new(
																0,
																math.ceil(
																	DOT_DIAMETER_DP
																		* scale
																),
																0,
																math.ceil(
																	DOT_DIAMETER_DP
																		* scale
																)
															),
														} :: RobloxTypes.FrameProperties,
														{
															UICorner = React.createElement(
																"UICorner",
																{
																	CornerRadius = UDim.new(
																		0.5,
																		0
																	),
																} :: RobloxTypes.UICornerProperties
															),
														}
													)
												end
												return out
											end)()
										),
									}
								)
								else nil,
						}
					),
				}
			),
		}
	)
end

return Library
