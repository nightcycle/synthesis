--!strict
-- Services
-- Packages
-- Modules
local Types = require("./Types")
local Style = require("./Style")
local Enums = require("./Enums")

-- Components
local Button = require("@comp/Button")
local ButtonContainer = require("@comp/ButtonContainer")
local Checkbox = require("@comp/Checkbox")
local Container = require("@comp/Container")
local IconDisplay = require("@comp/IconDisplay")
local Menu = require("@comp/Menu")
local Padding = require("@comp/Padding")
local PopUp = require("@comp/PopUp")
local PopUpContainer = require("@comp/PopUpContainer")
local ProgressIndicatorCircular = require("@comp/ProgressIndicator/Circular")
local ScrollingContainer = require("@comp/ScrollingContainer")
local ShadowFrame = require("@comp/ShadowFrame")
local Slider = require("@comp/Slider")
local Switch = require("@comp/Switch")
local RadioButton = require("@comp/RadioButton")
local TextDisplay = require("@comp/TextDisplay")
local TextField = require("@comp/TextField")

-- Types
export type ImageData = Types.ImageData
export type ButtonData = Types.ButtonData
export type FontData = Types.FontData
export type Style = Style.Style
export type Typography = Style.Typography
export type Theme = Style.Theme
export type SoundType = Enums.SoundType
export type FontType = Enums.FontType
export type ButtonStateType = Enums.ButtonStateType
export type SchemeType = Enums.SchemeType
export type CustomColorType = Enums.CustomColorType
export type SelectionState = Enums.SelectionState
export type ColorRoleType = Enums.ColorRoleType
export type PaletteType = Enums.PaletteType
export type TransitionType = Enums.TransitionType

export type ButtonProperties = Button.ButtonProperties
export type StyleButtonProperties = Button.StyleButtonProperties
export type ButtonContainerContentProperties =
	ButtonContainer.ButtonContainerContentProperties
export type ButtonContainerProperties = ButtonContainer.ButtonContainerProperties
export type CheckboxProperties = Checkbox.CheckboxProperties
export type StyleCheckboxProperties = Checkbox.StyleCheckboxProperties
export type IconDisplayProperties = IconDisplay.IconDisplayProperties
export type MenuProperties = Menu.MenuProperties
export type StylePaddingProperties = Padding.StylePaddingProperties
export type StylePaddingSimpleProperties = Padding.StylePaddingSimpleProperties
export type PopUpProperties = PopUp.PopUpProperties
export type PopUpContainerProperties = PopUpContainer.PopUpContainerProperties
export type ProgressIndicatorCircularProperties =
	ProgressIndicatorCircular.ProgressIndicatorCircularProperties
export type ShadowFrameProperties = ShadowFrame.ShadowFrameProperties
export type SliderProperties = Slider.SliderProperties
export type StyleSliderProperties = Slider.StyleSliderProperties
export type SwitchProperties = Switch.SwitchProperties
export type StyleSwitchProperties = Switch.StyleSwitchProperties
export type RadioButtonProperties = RadioButton.RadioButtonProperties
export type StyleRadioButtonProperties = RadioButton.StyleRadioButtonProperties
export type TextDisplayProperties = TextDisplay.TextDisplayProperties
export type StyleTextDisplayProperties = TextDisplay.StyleTextDisplayProperties
export type TextFieldProperties = TextField.TextFieldProperties
export type StyleTextFieldProperties = TextField.StyleTextFieldProperties
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Synthetic = {}

Synthetic.Enums = Enums
Synthetic.Sounds = require("./Sounds")

Synthetic.Transition = require("./Transition")
Synthetic.Types = Types
Synthetic.Style = Style
Synthetic.Theme = require("./Theme")
Synthetic.Typography = require("./Typography")
Synthetic.Hook = require("./Hook")
Synthetic.Component = {
	Button = Button,
	ButtonContainer = ButtonContainer,
	Checkbox = Checkbox,
	Container = Container,
	IconDisplay = IconDisplay,
	Menu = Menu,
	Padding = Padding,
	PopUp = PopUp,
	PopUpContainer = PopUpContainer,
	ProgressIndicator = {
		Circular = ProgressIndicatorCircular,
	},
	ScrollingContainer = ScrollingContainer,
	ShadowFrame = ShadowFrame,
	Slider = Slider,
	Switch = Switch,
	RadioButton = RadioButton,
	TextDisplay = TextDisplay,
	TextField = TextField,
}

return Synthetic
