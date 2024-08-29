--!strict
--!native
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
local PropUtil = require("@proj/PropUtil")
local RobloxTypes = require("@proj/RobloxTypes")
local Theme = require("@proj/Theme")
local Enums = require("@proj/Enums")
-- Types

export type ShadowFrameProperties = RobloxTypes.ImageLabelProperties & {
	ShadowColor3: Color3?,
	ShadowTransparency: number?,
	ShadowCornerRadius: UDim?,
	Elevation: number?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
}
-- Constants
local IMAGE_SIZE = 500
local HALF_IMAGE_SIZE = IMAGE_SIZE / 2
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(props: ShadowFrameProperties): React.ReactNode
	local shadowColor3: Color3 = props.ShadowColor3 or Color3.new(0, 0, 0)
	local shadowCornerRadius: UDim = props.ShadowCornerRadius or UDim.new(0.5, 0)
	local shadowTransparency: number = props.ShadowTransparency or 0.1
	local elevation: number = props.Elevation or 0
	local schemeType: Enums.SchemeType = props.SchemeType or Enums.SchemeType.Light
	local scale: number = props.Scale or 1

	local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))

	local minDim = math.min(absoluteSize.X, absoluteSize.Y)
	local pxRadiusSize = math.clamp(
		math.round(shadowCornerRadius.Offset * scale + shadowCornerRadius.Scale * minDim),
		0,
		math.floor(minDim / 2)
	)

	return e(
		"ImageLabel",
		PropUtil.mergeImageLabel(
			{
				Image = if pxRadiusSize > 0 then "rbxassetid://15549395120" else "",
				ImageColor3 = Theme.getElevatedColor(shadowColor3, elevation, schemeType),
				BackgroundTransparency = if pxRadiusSize > 0 or minDim <= 0
					then 1
					else shadowTransparency,
				BackgroundColor3 = Theme.getElevatedColor(
					shadowColor3,
					elevation,
					schemeType
				),
				ImageTransparency = if pxRadiusSize > 0 then shadowTransparency else 1,
				ScaleType = Enum.ScaleType.Slice,
				AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.XY,
				BorderSizePixel = 0,
				SliceCenter = Rect.new(
					HALF_IMAGE_SIZE,
					HALF_IMAGE_SIZE,
					HALF_IMAGE_SIZE,
					HALF_IMAGE_SIZE
				),
				SliceScale = math.clamp(pxRadiusSize / (minDim * 0.5), 0, 1),
				[React.Change.AbsoluteSize] = function(inst: TextButton)
					setAbsoluteSize(inst.AbsoluteSize)
				end :: any,
			} :: RobloxTypes.ImageLabelProperties,
			props
		)
	)
end
