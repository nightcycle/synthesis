--!strict
-- Services
-- Packages
-- Modules
local Types = require("./Types")
local Style = require("./Style")
local Enums = require("./Enums")
-- Types
export type ImageData = Types.ImageData
export type OptionData = Types.OptionData
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

-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Synthetic = {}

Synthetic.Enums = Enums
Synthetic.Sounds = require("Sounds")
Synthetic.Util = {
	Container = require("Util/Container"),
	Padding = require("Util/Padding"),
	TextLabel = require("Util/TextLabel"),
	ImageLabel = require("Util/ImageLabel"),
	PopUp = require("Util/PopUp"),
	ScrollingContainer = require("Util/ScrollingContainer"),
}
Synthetic.Transition = require("Transition")
Synthetic.Types = Types
Synthetic.Style = Style
Synthetic.Theme = require("Theme")
Synthetic.Typography = require("Typography")
Synthetic.Component = {
	Dialog = require("Component/Dialog"),
	Menu = {
		Row = {
			Tabs = nil,
			Segmented = require("Component/Menu/Row/Segmented"),
			Bar = {
				Bottom = require("Menu/Row/Bar/Bottom"),
				Top = {
					Center = require("Component/Menu/Row/Bar/Top/Center"),
					Large = require("Component/Menu/Row/Bar/Top/Large"),
					Medium = require("Component/Menu/Row/Bar/Top/Medium"),
					Small = require("Component/Menu/Row/Bar/Top/Small"),
				},
			},
		},
		Column = {
			Drawer = nil,
			Rail = nil,
			PopUp = nil,
		},
	},
	ProgressIndicator = {
		Circular = require("Component/ProgressIndicator/Circular"),
		Linear = nil,
	},
	Button = {
		Badge = require("Component/Button/Badge"),
		ElevatedButton = require("Component/Button/ElevatedButton"),
		ExtendedFAB = require("Component/Button/ExtendedFAB"),
		FAB = require("Component/Button/FAB"),
		FilledButton = require("Component/Button/FilledButton"),
		FilledIconButton = require("Component/Button/FilledIconButton"),
		IconButton = require("Component/Button/IconButton"),
		Outlined = require("Component/Button/Outlined"),
		OutlinedIcon = require("Component/Button/OutlinedIcon"),
		Text = require("Component/Button/Text"),
		Chip = {
			Filter = require("Component/Button/Chip/Filter"),
			Assist = require("Component/Button/Chip/Assist"),
		},
	},
	Snackbar = {
		Large = require("Component/Snackbar/Large"),
		Small = require("Component/Snackbar/Small"),
	},
	Search = {
		Filled = require("Component/Search/Filled"),
		Text = require("Component/Search/Text"),
	},
	Checkbox = require("Component/Checkbox"),
	RadioButton = require("Component/RadioButton"),
	Switch = require("Component/Switch"),
	Slider = require("Component/Slider"),
	TextField = {
		Filled = require("Component/TextField/Filled"),
		Outlined = require("Component/TextField/Outlined"),
	},
}

return Synthetic
