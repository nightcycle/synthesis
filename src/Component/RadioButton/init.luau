--!strict
-- Services
-- @Packages
local Maid = require("@wally/Maid")
local Icons = require("@wally/MaterialIcons")
local React = require("@wally/React")
-- Modules
local Types = require("@proj/Types")
local Style = require("@proj/Style")
local Enums = require("@proj/Enums")
local Sounds = require("@proj/Sounds")
local Theme = require("@proj/Theme")
local RobloxTypes = require("@proj/RobloxTypes")
local PropUtil = require("@proj/PropUtil")
local Defaults = require("./Defaults")
local Transition = require("@proj/Transition")
local PopUp = require("@comp/PopUp")
-- Types
type Maid = Maid.Maid
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type Style = Style.Style
type BaseRadioButtonProperties = RobloxTypes.GuiObjectProperties & {
	Value: boolean,
	OnChanged: (isSelected: boolean) -> (),
	IsEnabled: boolean?,
}

type RadioButtonProperties = BaseRadioButtonProperties & {
	IsAnimated: boolean?,
	SchemeType: Enums.SchemeType?,
	Scale: number?,
	OutlineColor3: Color3?,
	FillColor3: Color3?,
	IconColor3: Color3?,
	DisabledColor3: Color3?,
	Elevation: number?,
}

type ThemeRadioButtonProperties = BaseRadioButtonProperties & {
	Style: Style,
}
-- Constants
local LAYER_SIZE_DP = 40
local BUTTON_SIZE_DP = 18
local UNSELECT_OUTLINE_WIDTH_DP = 2
local TRANSITION_TYPE = Enums.TransitionType.Emphasized
local TRANSITION_DURATION = Enums.TransitionDuration.Long1
local ALPHA_RUNNER_KEY = "AlphaRunner"
local RIPPLE_ALPHA_RUNNER_KEY = "RippleAlphaRunner"
-- Variables
-- References
-- Private Functions
function getAlphaRunner(
	self: React.ComponentClass<RadioButtonProperties>
): Transition.TransitionRunner
	return self[ALPHA_RUNNER_KEY]
end
function getRippleAlphaRunner(
	self: React.ComponentClass<RadioButtonProperties>
): Transition.TransitionRunner
	return self[RIPPLE_ALPHA_RUNNER_KEY]
end
-- Class
local Component: React.ComponentClass<RadioButtonProperties> =
	React.Component:extend("RadioButton")

function Component:init(initialProps: RadioButtonProperties): ()
	self[ALPHA_RUNNER_KEY] = Transition.Runner(
		self,
		"Alpha",
		initialProps.Value and 1 or 0,
		TRANSITION_TYPE,
		TRANSITION_DURATION
	)
	self[RIPPLE_ALPHA_RUNNER_KEY] = Transition.Runner(
		self,
		"RippleAlpha",
		0,
		TRANSITION_TYPE,
		Enums.TransitionDuration.Medium4
	)
	self:setState({
		IsHovered = false,
		IsPressed = false,
		IsFocused = false,
		TargetValue = initialProps.Value,
		RippleAlpha = getRippleAlphaRunner(self):Get(),
		Alpha = getAlphaRunner(self):Get(),
		KnobAbsolutePosition = Vector2.new(0, 0),
		KnobAbsoluteSize = Vector2.new(0, 0),
	})
end

function Component:render(): React.ReactElement<
	RobloxTypes.GuiObjectProperties,
	"ImageButton"
>
	-- unpack state
	local isHovered: boolean = self.state.IsHovered
	local isPressed: boolean = self.state.IsPressed
	local isFocused: boolean = self.state.IsFocused

	-- unpack properties
	local value: boolean = self.props.Value
	local onChanged: (newValue: boolean) -> () = self.props.OnChanged
	local elevation: number = self.props.Elevation :: number? or Defaults.Elevation
	local schemeType: Enums.SchemeType = self.props.SchemeType :: Enums.SchemeType?
		or Defaults.SchemeType

	local disabledColor3: Color3 = self.props.DisabledColor3 :: Color3?
		or Defaults.DisabledColor3
	local fillColor3: Color3 = self.props.FillColor3 :: Color3? or Defaults.FillColor3
	local iconColor3: Color3 = self.props.IconColor3 :: Color3? or Defaults.IconColor3
	local outlineColor3: Color3 = self.props.OutlineColor3 :: Color3?
		or Defaults.OutlineColor3

	local scale = (self.props.Scale :: number?) or Defaults.Scale
	local isAnimated = if self.props.IsAnimated ~= nil
		then self.props.IsAnimated
		else Defaults.IsAnimated
	local isEnabled = if self.props.IsEnabled ~= nil
		then self.props.IsEnabled
		else Defaults.IsEnabled

	local state: Enums.ButtonStateType
	if isEnabled then
		if isPressed then
			state = Enums.ButtonStateType.Pressed
		elseif isHovered then
			state = Enums.ButtonStateType.Hovered
		elseif isFocused then
			state = Enums.ButtonStateType.Focused
		else
			state = Enums.ButtonStateType.Enabled
		end
	else
		state = Enums.ButtonStateType.Disabled
	end

	if not isAnimated then
		getAlphaRunner(self):Stop()
	else
		getAlphaRunner(self):Update(value)
	end
	local function playSound()
		local soundType = Enums.SoundType.navigation_forward_selection_minimal
		if value then
			soundType = Enums.SoundType.navigation_backward_selection_minimal
		end
		Sounds.play(soundType)
	end

	local isRippleEnabled = (isHovered or isPressed or isFocused)

	if isAnimated then
		getAlphaRunner(self):Set(value, playSound)
		getRippleAlphaRunner(self):Set(isRippleEnabled)
	else
		isRippleEnabled = false
	end

	local alpha = if isAnimated then getAlphaRunner(self):Get() elseif value then 1 else 0
	local rippleAlpha = if isAnimated then getRippleAlphaRunner(self):Get() else 0
end

function Component:willUnmount()
	getAlphaRunner(self):Disconnect()
	getRippleAlphaRunner(self):Disconnect()
end

return {
	Full = Component,
}
