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
local Types = require("@proj/Types")
-- Types
export type BaseSliderProperties = RobloxTypes.GuiObjectProperties & {
	Range: NumberRange,
	Value: number | NumberRange,
	OnChange: (value: number | NumberRange) -> (),
	SnapCount: number?,
	IsPopUpEnabled: boolean?,
	IsEnabled: boolean?,
	Elevation: number?,
}
export type SliderProperties = BaseSliderProperties & {
	FillColor3: Color3,
	BackgroundColor3: Color3,
	PopUpBackgroundColor3: Color3,
	PopUpTextColor3: Color3,
	PopUpFontData: Types.FontData,
}
-- Constants
local BAR_HEIGHT_DP = 16
local HANDLE_HEIGHT_DP = 44
local HANDLE_WIDTH_DP = 6
local DOT_DIAMETER_DP = 4

-- Variables
-- References
-- Private Functions
-- Class
local Library = {}
Library.Full = function(props: SliderProperties): React.ReactNode
	return React.createElement(
		"Frame",
		PropUtil.mergeGuiObject({} :: RobloxTypes.GuiObjectProperties, props)
	)
end

return Library
