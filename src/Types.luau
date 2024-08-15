--!strict
-- Services
-- Packages
local CurveUtil = require("@wally/CurveUtil")
-- Modules
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
	Border: AppearanceData,
	Background: AppearanceData,
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
	border: AppearanceData,
	background: AppearanceData,
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

return Types
