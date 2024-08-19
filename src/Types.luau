--!strict
-- Services
-- Packages
local CurveUtil = require("@wally/CurveUtil")
-- Modules
local Enums = require("@proj/Enums")
local Theme = require("@proj/Theme")
-- Types
export type AppearanceData = {
	Color3: Color3,
	Transparency: number,
}

export type ShadowData = {
	Offset: Vector2,
	Appearance: AppearanceData,
}

export type RenderData = {
	Scale: number,
	Border: AppearanceData?,
	Background: AppearanceData?,
	Sound: SoundData?,
	Image: ImageData?,
	Font: FontData?,
	Text: AppearanceData?,
	Shadow: ShadowData?,
}

export type ImageData = {
	Image: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
}

export type SoundData = {
	SoundId: string,
	Volume: number,
}

export type ButtonData = {
	Icon: ImageData?,
	Text: string?,
	Enabled: boolean,
	OnClick: () -> (),
}

export type OptionData = {
	Text: string,
	Icon: ImageData?,
	Disabled: boolean,
	IsInitiallySelected: boolean,
	SelectedText: string,
	SelectedIcon: ImageData?,
	OnSelect: (isSelected: boolean) -> (),
}

export type FontData = {
	Font: Font,
	Size: number,
	Tracking: number,
	LineHeight: number,
}

-- Constants
local FILL_HOVER_TRANS = 0.08
local FILL_DISABLED_TRANS = 0.12
local FILL_FOCUSPRESS_TRANS = 0.1
local LINE_HOVER_TRANS = 1 - FILL_HOVER_TRANS
local LINE_DISABLED_TRANS = 1 - 0.38
local LINE_FOCUSPRESS_TRANS = 1 - FILL_FOCUSPRESS_TRANS
-- Variables
-- References
-- Private Functions
-- Class
local Types = {}

Types.FontData = {}
function Types.FontData.new(
	font: Font,
	size: number,
	lineHeight: number?,
	tracking: number?
): FontData
	return table.freeze({
		Font = font,
		Size = size,
		Tracking = tracking or 0,
		LineHeight = lineHeight or size,
	})
end

Types.ButtonData = {}
function Types.ButtonData.new(
	onClick: () -> (),
	icon: ImageData?,
	text: string?,
	enabled: boolean?
): ButtonData
	return table.freeze({
		Icon = icon,
		Text = text,
		OnClick = onClick,
		Enabled = if enabled == nil then true else enabled,
	})
end

Types.OptionData = {}
function Types.OptionData.new(
	onSelect: (isSelected: boolean) -> (),
	disabled: boolean,
	isInitiallySelected: boolean,
	text: string?,
	icon: ImageData?,
	selectedText: string?,
	selectedIcon: ImageData?
): OptionData
	return table.freeze({
		Text = text or "",
		Icon = icon,
		Disabled = disabled,
		SelectedText = selectedText or text or "",
		SelectedIcon = selectedIcon or icon,
		IsInitiallySelected = isInitiallySelected,
		OnSelect = onSelect,
	})
end

Types._SoundData = {}
function Types._SoundData.new(soundId: string, volume: number?): SoundData
	return table.freeze({
		SoundId = soundId,
		Volume = volume or 1,
	})
end

Types._ShadowData = {}
function Types._ShadowData.new(appearance: AppearanceData, offset: Vector2): ShadowData
	return table.freeze({
		Appearance = appearance,
		Offset = offset,
	})
end

Types._AppearanceData = {}
function Types._AppearanceData.new(color3: Color3, transparency: number?): AppearanceData
	return table.freeze({
		Color3 = color3,
		Transparency = transparency or 0,
	})
end
function Types._AppearanceData.lerp(
	a: AppearanceData,
	b: AppearanceData,
	alpha: number
): AppearanceData
	return Types._AppearanceData.new(
		CurveUtil.lerp(a.Color3, b.Color3, alpha),
		CurveUtil.lerp(a.Transparency, b.Transparency, alpha)
	)
end

Types.ImageData = {}
function Types.ImageData.new(
	image: string,
	rectOffset: Vector2?,
	rectSize: Vector2?
): ImageData
	return table.freeze({
		Image = image,
		ImageRectOffset = rectOffset or Vector2.zero,
		ImageRectSize = rectSize or Vector2.zero,
	})
end

Types._RenderData = {}
function Types._RenderData.new(
	scale: number,
	border: AppearanceData?,
	background: AppearanceData?,
	text: AppearanceData?,
	font: FontData?,
	image: ImageData?,
	sound: SoundData?,
	shadow: ShadowData?
): RenderData
	return table.freeze({
		Scale = scale,
		Border = border,
		Background = background,
		Sound = sound,
		Image = image,
		Font = font,
		Text = text,
		Shadow = shadow,
	})
end

function Types._RenderData.getButtonState(
	isHovered: boolean,
	isPressed: boolean,
	isFocused: boolean?,
	isEnabled: boolean?
): Enums.ButtonStateType
	isEnabled = if isEnabled ~= nil then isEnabled else true
	isFocused = if isFocused ~= nil then isFocused else false

	if isEnabled then
		if isPressed then
			return Enums.ButtonStateType.Pressed
		elseif isHovered then
			return Enums.ButtonStateType.Hovered
		elseif isFocused then
			return Enums.ButtonStateType.Focused
		else
			return Enums.ButtonStateType.Enabled
		end
	else
		return Enums.ButtonStateType.Disabled
	end
end

function Types._RenderData.solveButton(
	renderType: Enums.ButtonRenderType,
	state: Enums.ButtonStateType,
	scale: number,
	schemeType: Enums.SchemeType,
	elevation: number,
	textColor: Color3,
	fillColor: Color3?,
	borderColor: Color3?,
	disabledFillColor: Color3?,
	disabledBorderColor: Color3?,
	disabledTextColor: Color3?
): RenderData
	local borderData: AppearanceData?
	local backgroundData: AppearanceData?
	local textData: AppearanceData?

	-- set background
	if renderType == Enums.ButtonRenderType.Filled then
		assert(fillColor, "Filled buttons require a fillColor")
		assert(textColor, "Filled buttons require an textColor")

		if state ~= Enums.ButtonStateType.Disabled then
			if state == Enums.ButtonStateType.Enabled then
				backgroundData = Types._AppearanceData.new(
					Theme.getElevatedColor(fillColor, elevation, schemeType),
					0
				)
			elseif state == Enums.ButtonStateType.Hovered then
				backgroundData = Types._AppearanceData.new(
					Theme.getElevatedColor(fillColor, elevation + 1, schemeType),
					FILL_HOVER_TRANS
				)
			elseif state == Enums.ButtonStateType.Focused then
				backgroundData = Types._AppearanceData.new(
					Theme.getElevatedColor(fillColor, elevation, schemeType),
					FILL_FOCUSPRESS_TRANS
				)
			elseif state == Enums.ButtonStateType.Pressed then
				backgroundData = Types._AppearanceData.new(
					Theme.getElevatedColor(
						fillColor,
						math.max(elevation - 1, 0),
						schemeType
					),
					FILL_FOCUSPRESS_TRANS
				)
			else
				error(`invalid state: {state}`)
			end
		else
			assert(
				disabledFillColor,
				"disabled filled button requires a disabledFillColor"
			)

			backgroundData = Types._AppearanceData.new(
				Theme.getElevatedColor(disabledFillColor, elevation, schemeType),
				FILL_DISABLED_TRANS
			)
		end
	end

	-- set border
	if renderType == Enums.ButtonRenderType.Outlined then
		assert(borderColor, "Outlined buttons require a borderColor")
		if state ~= Enums.ButtonStateType.Disabled then
			if state == Enums.ButtonStateType.Enabled then
				borderData = Types._AppearanceData.new(
					Theme.getElevatedColor(borderColor, elevation, schemeType),
					0
				)
			elseif state == Enums.ButtonStateType.Hovered then
				borderData = Types._AppearanceData.new(
					Theme.getElevatedColor(borderColor, elevation, schemeType),
					LINE_HOVER_TRANS
				)
				backgroundData = borderData
			elseif state == Enums.ButtonStateType.Focused then
				borderData = Types._AppearanceData.new(
					Theme.getElevatedColor(borderColor, elevation, schemeType),
					LINE_FOCUSPRESS_TRANS
				)
				backgroundData = borderData
			elseif state == Enums.ButtonStateType.Pressed then
				borderData = Types._AppearanceData.new(
					Theme.getElevatedColor(borderColor, elevation, schemeType),
					LINE_FOCUSPRESS_TRANS
				)
			else
				error(`invalid state: {state}`)
			end
		else
			assert(
				disabledBorderColor,
				"disabled outlined buttons require a disabledBorderColor"
			)

			borderData = Types._AppearanceData.new(
				Theme.getElevatedColor(disabledBorderColor, elevation, schemeType),
				LINE_DISABLED_TRANS
			)
		end
	end

	-- set text / icon
	do
		assert(textColor, "Buttons require a textColor")
		if state ~= Enums.ButtonStateType.Disabled then
			if state == Enums.ButtonStateType.Enabled then
				textData = Types._AppearanceData.new(
					Theme.getElevatedColor(textColor, elevation, schemeType),
					0
				)
			elseif state == Enums.ButtonStateType.Hovered then
				textData = Types._AppearanceData.new(
					Theme.getElevatedColor(textColor, elevation + 1, schemeType),
					if renderType == Enums.ButtonRenderType.Filled
						then FILL_HOVER_TRANS
						else LINE_HOVER_TRANS
				)
			elseif state == Enums.ButtonStateType.Focused then
				textData = Types._AppearanceData.new(
					Theme.getElevatedColor(textColor, elevation, schemeType),
					if renderType == Enums.ButtonRenderType.Filled
						then FILL_FOCUSPRESS_TRANS
						else LINE_FOCUSPRESS_TRANS
				)
			elseif state == Enums.ButtonStateType.Pressed then
				textData = Types._AppearanceData.new(
					Theme.getElevatedColor(
						textColor,
						math.max(elevation - 1, 0),
						schemeType
					),
					if renderType == Enums.ButtonRenderType.Filled
						then FILL_FOCUSPRESS_TRANS
						else LINE_FOCUSPRESS_TRANS
				)
			else
				error(`invalid state: {state}`)
			end
		else
			assert(disabledTextColor, "diabled button requires a disabledTextColor")

			textData = Types._AppearanceData.new(
				Theme.getElevatedColor(disabledTextColor, elevation, schemeType),
				if renderType == Enums.ButtonRenderType.Filled
					then FILL_DISABLED_TRANS
					else LINE_DISABLED_TRANS
			)
		end
	end

	return Types._RenderData.new(
		scale,
		borderData,
		backgroundData,
		textData,
		nil,
		nil,
		nil,
		nil
	)
end

return Types
