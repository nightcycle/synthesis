export type InstanceProperties = {
	Archivable: boolean?,
	Name: string?,
	Parent: Instance?,
}
export type AccessoryDescriptionProperties = InstanceProperties & {
	AccessoryType: Enum.AccessoryType?,
	AssetId: number?,
	Instance: Instance?,
	IsLayered: boolean?,
	Order: number?,
	Position: Vector3?,
	Puffiness: number?,
	Rotation: Vector3?,
	Scale: Vector3?,
}
export type AccoutrementProperties = InstanceProperties & {
	AttachmentForward: Vector3?,
	AttachmentPoint: CFrame?,
	AttachmentPos: Vector3?,
	AttachmentRight: Vector3?,
	AttachmentUp: Vector3?,
}
export type AccessoryProperties = AccoutrementProperties & {
	AccessoryType: Enum.AccessoryType?,
}
export type AdPortalProperties = InstanceProperties
export type AdvancedDraggerProperties = InstanceProperties
export type AnimationProperties = InstanceProperties & {
	AnimationId: string?,
}
export type AnimationClipProperties = InstanceProperties & {
	Loop: boolean?,
	Priority: Enum.AnimationPriority?,
}
export type CurveAnimationProperties = AnimationClipProperties
export type KeyframeSequenceProperties = AnimationClipProperties
export type AnimationControllerProperties = InstanceProperties
export type AnimationRigDataProperties = InstanceProperties
export type AnimatorProperties = InstanceProperties & {
	PreferLodEnabled: boolean?,
}
export type AnnotationProperties = InstanceProperties
export type WorkspaceAnnotationProperties = AnnotationProperties
export type AtmosphereProperties = InstanceProperties & {
	Color: Color3?,
	Decay: Color3?,
	Density: number?,
	Glare: number?,
	Haze: number?,
	Offset: number?,
}
export type AttachmentProperties = InstanceProperties & {
	Axis: Vector3?,
	CFrame: CFrame?,
	Orientation: Vector3?,
	Position: Vector3?,
	SecondaryAxis: Vector3?,
	Visible: boolean?,
	WorldAxis: Vector3?,
	WorldCFrame: CFrame?,
	WorldOrientation: Vector3?,
	WorldPosition: Vector3?,
	WorldSecondaryAxis: Vector3?,
}
export type BoneProperties = AttachmentProperties & {
	Transform: CFrame?,
}
export type AudioAnalyzerProperties = InstanceProperties & {
	SpectrumEnabled: boolean?,
}
export type AudioChorusProperties = InstanceProperties & {
	Bypass: boolean?,
	Depth: number?,
	Mix: number?,
	Rate: number?,
}
export type AudioCompressorProperties = InstanceProperties & {
	Attack: number?,
	Bypass: boolean?,
	MakeupGain: number?,
	Ratio: number?,
	Release: number?,
	Threshold: number?,
}
export type AudioDeviceInputProperties = InstanceProperties & {
	AccessType: Enum.AccessModifierType?,
	Muted: boolean?,
	Player: Player?,
	Volume: number?,
}
export type AudioDeviceOutputProperties = InstanceProperties & {
	Player: Player?,
}
export type AudioDistortionProperties = InstanceProperties & {
	Bypass: boolean?,
	Level: number?,
}
export type AudioEchoProperties = InstanceProperties & {
	Bypass: boolean?,
	DelayTime: number?,
	DryLevel: number?,
	Feedback: number?,
	WetLevel: number?,
}
export type AudioEmitterProperties = InstanceProperties & {
	AudioInteractionGroup: string?,
}
export type AudioEqualizerProperties = InstanceProperties & {
	Bypass: boolean?,
	HighGain: number?,
	LowGain: number?,
	MidGain: number?,
	MidRange: NumberRange?,
}
export type AudioFaderProperties = InstanceProperties & {
	Bypass: boolean?,
	Volume: number?,
}
export type AudioFilterProperties = InstanceProperties & {
	Bypass: boolean?,
	FilterType: Enum.AudioFilterType?,
	Frequency: number?,
	Gain: number?,
	Q: number?,
}
export type AudioFlangerProperties = InstanceProperties & {
	Bypass: boolean?,
	Depth: number?,
	Mix: number?,
	Rate: number?,
}
export type AudioListenerProperties = InstanceProperties & {
	AudioInteractionGroup: string?,
}
export type AudioPitchShifterProperties = InstanceProperties & {
	Bypass: boolean?,
	Pitch: number?,
}
export type AudioPlayerProperties = InstanceProperties & {
	AssetId: string?,
	AutoLoad: boolean?,
	LoopRegion: NumberRange?,
	Looping: boolean?,
	PlaybackRegion: NumberRange?,
	PlaybackSpeed: number?,
	TimePosition: number?,
	Volume: number?,
}
export type AudioReverbProperties = InstanceProperties & {
	Bypass: boolean?,
	DecayRatio: number?,
	DecayTime: number?,
	Density: number?,
	Diffusion: number?,
	DryLevel: number?,
	EarlyDelayTime: number?,
	HighCutFrequency: number?,
	LateDelayTime: number?,
	LowShelfFrequency: number?,
	LowShelfGain: number?,
	ReferenceFrequency: number?,
	WetLevel: number?,
}
export type AudioSearchParamsProperties = InstanceProperties & {
	Album: string?,
	Artist: string?,
	AudioSubType: Enum.AudioSubType?,
	MaxDuration: number?,
	MinDuration: number?,
	SearchKeyword: string?,
	Tag: string?,
	Title: string?,
}
export type BackpackProperties = InstanceProperties
export type BasePlayerGuiProperties = InstanceProperties
export type StarterGuiProperties = BasePlayerGuiProperties & {
	ScreenOrientation: Enum.ScreenOrientation?,
	ShowDevelopmentGui: boolean?,
}
export type BaseRemoteEventProperties = InstanceProperties
export type RemoteEventProperties = BaseRemoteEventProperties
export type UnreliableRemoteEventProperties = BaseRemoteEventProperties
export type BaseWrapProperties = InstanceProperties
export type WrapDeformerProperties = BaseWrapProperties & {
	Enabled: boolean?,
}
export type WrapLayerProperties = BaseWrapProperties & {
	AutoSkin: Enum.WrapLayerAutoSkin?,
	Enabled: boolean?,
	Order: number?,
	Puffiness: number?,
}
export type WrapTargetProperties = BaseWrapProperties
export type BeamProperties = InstanceProperties & {
	Attachment0: Attachment?,
	Attachment1: Attachment?,
	Brightness: number?,
	Color: ColorSequence?,
	CurveSize0: number?,
	CurveSize1: number?,
	Enabled: boolean?,
	FaceCamera: boolean?,
	LightEmission: number?,
	LightInfluence: number?,
	LocalTransparencyModifier: number?,
	Segments: number?,
	Texture: string?,
	TextureLength: number?,
	TextureMode: Enum.TextureMode?,
	TextureSpeed: number?,
	Transparency: NumberSequence?,
	Width0: number?,
	Width1: number?,
	ZOffset: number?,
}
export type BindableEventProperties = InstanceProperties
export type BindableFunctionProperties = InstanceProperties
export type BodyMoverProperties = InstanceProperties
export type BodyAngularVelocityProperties = BodyMoverProperties & {
	AngularVelocity: Vector3?,
	MaxTorque: Vector3?,
	P: number?,
}
export type BodyForceProperties = BodyMoverProperties & {
	Force: Vector3?,
}
export type BodyGyroProperties = BodyMoverProperties & {
	CFrame: CFrame?,
	D: number?,
	MaxTorque: Vector3?,
	P: number?,
}
export type BodyPositionProperties = BodyMoverProperties & {
	D: number?,
	MaxForce: Vector3?,
	P: number?,
	Position: Vector3?,
}
export type BodyThrustProperties = BodyMoverProperties & {
	Force: Vector3?,
	Location: Vector3?,
}
export type BodyVelocityProperties = BodyMoverProperties & {
	MaxForce: Vector3?,
	P: number?,
	Velocity: Vector3?,
}
export type BodyPartDescriptionProperties = InstanceProperties & {
	AssetId: number?,
	BodyPart: Enum.BodyPart?,
	Color: Color3?,
	Instance: Instance?,
}
export type BubbleChatMessagePropertiesProperties = InstanceProperties & {
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	FontFace: Font?,
	TailVisible: boolean?,
	TextColor3: Color3?,
	TextSize: number?,
}
export type CameraProperties = InstanceProperties & {
	CFrame: CFrame?,
	CameraSubject: Instance?,
	CameraType: Enum.CameraType?,
	DiagonalFieldOfView: number?,
	FieldOfView: number?,
	FieldOfViewMode: Enum.FieldOfViewMode?,
	Focus: CFrame?,
	HeadLocked: boolean?,
	HeadScale: number?,
	MaxAxisFieldOfView: number?,
	VRTiltAndRollEnabled: boolean?,
}
export type CharacterAppearanceProperties = InstanceProperties
export type BodyColorsProperties = CharacterAppearanceProperties & {
	HeadColor: BrickColor?,
	HeadColor3: Color3?,
	LeftArmColor: BrickColor?,
	LeftArmColor3: Color3?,
	LeftLegColor: BrickColor?,
	LeftLegColor3: Color3?,
	RightArmColor: BrickColor?,
	RightArmColor3: Color3?,
	RightLegColor: BrickColor?,
	RightLegColor3: Color3?,
	TorsoColor: BrickColor?,
	TorsoColor3: Color3?,
}
export type ClothingProperties = CharacterAppearanceProperties & {
	Color3: Color3?,
}
export type PantsProperties = ClothingProperties & {
	PantsTemplate: string?,
}
export type ShirtProperties = ClothingProperties & {
	ShirtTemplate: string?,
}
export type ShirtGraphicProperties = CharacterAppearanceProperties & {
	Color3: Color3?,
	Graphic: string?,
}
export type ClickDetectorProperties = InstanceProperties & {
	CursorIcon: string?,
	MaxActivationDistance: number?,
}
export type DragDetectorProperties = ClickDetectorProperties & {
	ActivatedCursorIcon: string?,
	ApplyAtCenterOfMass: boolean?,
	Axis: Vector3?,
	DragFrame: CFrame?,
	DragStyle: Enum.DragDetectorDragStyle?,
	Enabled: boolean?,
	GamepadModeSwitchKeyCode: Enum.KeyCode?,
	KeyboardModeSwitchKeyCode: Enum.KeyCode?,
	MaxDragAngle: number?,
	MaxDragTranslation: Vector3?,
	MaxForce: number?,
	MaxTorque: number?,
	MinDragAngle: number?,
	MinDragTranslation: Vector3?,
	Orientation: Vector3?,
	PermissionPolicy: Enum.DragDetectorPermissionPolicy?,
	ReferenceInstance: Instance?,
	ResponseStyle: Enum.DragDetectorResponseStyle?,
	Responsiveness: number?,
	RunLocally: boolean?,
	SecondaryAxis: Vector3?,
	TrackballRadialPullFactor: number?,
	TrackballRollFactor: number?,
	VRSwitchKeyCode: Enum.KeyCode?,
	WorldAxis: Vector3?,
	WorldSecondaryAxis: Vector3?,
}
export type CloudsProperties = InstanceProperties & {
	Color: Color3?,
	Cover: number?,
	Density: number?,
	Enabled: boolean?,
}
export type ConfigurationProperties = InstanceProperties
export type ConstraintProperties = InstanceProperties & {
	Attachment0: Attachment?,
	Attachment1: Attachment?,
	Color: BrickColor?,
	Enabled: boolean?,
	Visible: boolean?,
}
export type AlignOrientationProperties = ConstraintProperties & {
	AlignType: Enum.AlignType?,
	CFrame: CFrame?,
	LookAtPosition: Vector3?,
	MaxAngularVelocity: number?,
	MaxTorque: number?,
	Mode: Enum.OrientationAlignmentMode?,
	PrimaryAxis: Vector3?,
	PrimaryAxisOnly: boolean?,
	ReactionTorqueEnabled: boolean?,
	Responsiveness: number?,
	RigidityEnabled: boolean?,
	SecondaryAxis: Vector3?,
}
export type AlignPositionProperties = ConstraintProperties & {
	ApplyAtCenterOfMass: boolean?,
	ForceLimitMode: Enum.ForceLimitMode?,
	ForceRelativeTo: Enum.ActuatorRelativeTo?,
	MaxAxesForce: Vector3?,
	MaxForce: number?,
	MaxVelocity: number?,
	Mode: Enum.PositionAlignmentMode?,
	Position: Vector3?,
	ReactionForceEnabled: boolean?,
	Responsiveness: number?,
	RigidityEnabled: boolean?,
}
export type AngularVelocityProperties = ConstraintProperties & {
	AngularVelocity: Vector3?,
	MaxTorque: number?,
	ReactionTorqueEnabled: boolean?,
	RelativeTo: Enum.ActuatorRelativeTo?,
}
export type AnimationConstraintProperties = ConstraintProperties & {
	IsKinematic: boolean?,
	MaxForce: number?,
	MaxTorque: number?,
	Transform: CFrame?,
}
export type BallSocketConstraintProperties = ConstraintProperties & {
	LimitsEnabled: boolean?,
	MaxFrictionTorque: number?,
	Radius: number?,
	Restitution: number?,
	TwistLimitsEnabled: boolean?,
	TwistLowerAngle: number?,
	TwistUpperAngle: number?,
	UpperAngle: number?,
}
export type HingeConstraintProperties = ConstraintProperties & {
	ActuatorType: Enum.ActuatorType?,
	AngularResponsiveness: number?,
	AngularSpeed: number?,
	AngularVelocity: number?,
	LimitsEnabled: boolean?,
	LowerAngle: number?,
	MotorMaxAcceleration: number?,
	MotorMaxTorque: number?,
	Radius: number?,
	Restitution: number?,
	ServoMaxTorque: number?,
	TargetAngle: number?,
	UpperAngle: number?,
}
export type LineForceProperties = ConstraintProperties & {
	ApplyAtCenterOfMass: boolean?,
	InverseSquareLaw: boolean?,
	Magnitude: number?,
	MaxForce: number?,
	ReactionForceEnabled: boolean?,
}
export type LinearVelocityProperties = ConstraintProperties & {
	ForceLimitMode: Enum.ForceLimitMode?,
	ForceLimitsEnabled: boolean?,
	LineDirection: Vector3?,
	LineVelocity: number?,
	MaxAxesForce: Vector3?,
	MaxForce: number?,
	MaxPlanarAxesForce: Vector2?,
	PlaneVelocity: Vector2?,
	PrimaryTangentAxis: Vector3?,
	RelativeTo: Enum.ActuatorRelativeTo?,
	SecondaryTangentAxis: Vector3?,
	VectorVelocity: Vector3?,
	VelocityConstraintMode: Enum.VelocityConstraintMode?,
}
export type PlaneConstraintProperties = ConstraintProperties
export type RigidConstraintProperties = ConstraintProperties
export type RodConstraintProperties = ConstraintProperties & {
	Length: number?,
	LimitAngle0: number?,
	LimitAngle1: number?,
	LimitsEnabled: boolean?,
	Thickness: number?,
}
export type RopeConstraintProperties = ConstraintProperties & {
	Length: number?,
	Restitution: number?,
	Thickness: number?,
	WinchEnabled: boolean?,
	WinchForce: number?,
	WinchResponsiveness: number?,
	WinchSpeed: number?,
	WinchTarget: number?,
}
export type SlidingBallConstraintProperties = ConstraintProperties & {
	ActuatorType: Enum.ActuatorType?,
	LimitsEnabled: boolean?,
	LinearResponsiveness: number?,
	LowerLimit: number?,
	MotorMaxAcceleration: number?,
	MotorMaxForce: number?,
	Restitution: number?,
	ServoMaxForce: number?,
	Size: number?,
	Speed: number?,
	TargetPosition: number?,
	UpperLimit: number?,
	Velocity: number?,
}
export type CylindricalConstraintProperties = SlidingBallConstraintProperties & {
	AngularActuatorType: Enum.ActuatorType?,
	AngularLimitsEnabled: boolean?,
	AngularResponsiveness: number?,
	AngularRestitution: number?,
	AngularSpeed: number?,
	AngularVelocity: number?,
	InclinationAngle: number?,
	LowerAngle: number?,
	MotorMaxAngularAcceleration: number?,
	MotorMaxTorque: number?,
	RotationAxisVisible: boolean?,
	ServoMaxTorque: number?,
	TargetAngle: number?,
	UpperAngle: number?,
}
export type PrismaticConstraintProperties = SlidingBallConstraintProperties
export type SpringConstraintProperties = ConstraintProperties & {
	Coils: number?,
	Damping: number?,
	FreeLength: number?,
	LimitsEnabled: boolean?,
	MaxForce: number?,
	MaxLength: number?,
	MinLength: number?,
	Radius: number?,
	Stiffness: number?,
	Thickness: number?,
}
export type TorqueProperties = ConstraintProperties & {
	RelativeTo: Enum.ActuatorRelativeTo?,
	Torque: Vector3?,
}
export type TorsionSpringConstraintProperties = ConstraintProperties & {
	Coils: number?,
	Damping: number?,
	LimitsEnabled: boolean?,
	MaxAngle: number?,
	MaxTorque: number?,
	Radius: number?,
	Restitution: number?,
	Stiffness: number?,
}
export type UniversalConstraintProperties = ConstraintProperties & {
	LimitsEnabled: boolean?,
	MaxAngle: number?,
	Radius: number?,
	Restitution: number?,
}
export type VectorForceProperties = ConstraintProperties & {
	ApplyAtCenterOfMass: boolean?,
	Force: Vector3?,
	RelativeTo: Enum.ActuatorRelativeTo?,
}
export type DataModelMeshProperties = InstanceProperties & {
	Offset: Vector3?,
	Scale: Vector3?,
	VertexColor: Vector3?,
}
export type EditableMeshProperties = DataModelMeshProperties & {
	SkinningEnabled: boolean?,
}
export type RobloxEditableMeshProperties = EditableMeshProperties
export type FileMeshProperties = DataModelMeshProperties & {
	MeshId: string?,
	TextureId: string?,
}
export type SpecialMeshProperties = FileMeshProperties & {
	MeshType: Enum.MeshType?,
}
export type DataStoreGetOptionsProperties = InstanceProperties & {
	UseCache: boolean?,
}
export type DialogProperties = InstanceProperties & {
	BehaviorType: Enum.DialogBehaviorType?,
	ConversationDistance: number?,
	GoodbyeChoiceActive: boolean?,
	GoodbyeDialog: string?,
	InUse: boolean?,
	InitialPrompt: string?,
	Purpose: Enum.DialogPurpose?,
	Tone: Enum.DialogTone?,
	TriggerDistance: number?,
	TriggerOffset: Vector3?,
}
export type DialogChoiceProperties = InstanceProperties & {
	GoodbyeChoiceActive: boolean?,
	GoodbyeDialog: string?,
	ResponseDialog: string?,
	UserDialog: string?,
}
export type DraggerProperties = InstanceProperties
export type EditableImageProperties = InstanceProperties & {
	Size: Vector2?,
}
export type RobloxEditableImageProperties = EditableImageProperties
export type ExperienceInviteOptionsProperties = InstanceProperties & {
	InviteMessageId: string?,
	InviteUser: number?,
	LaunchData: string?,
	PromptMessage: string?,
}
export type ExplosionProperties = InstanceProperties & {
	BlastPressure: number?,
	BlastRadius: number?,
	DestroyJointRadiusPercent: number?,
	ExplosionType: Enum.ExplosionType?,
	LocalTransparencyModifier: number?,
	Position: Vector3?,
	TimeScale: number?,
	Visible: boolean?,
}
export type FaceControlsProperties = InstanceProperties
export type FaceInstanceProperties = InstanceProperties & {
	Face: Enum.NormalId?,
}
export type DecalProperties = FaceInstanceProperties & {
	Color3: Color3?,
	LocalTransparencyModifier: number?,
	Texture: string?,
	Transparency: number?,
	ZIndex: number?,
}
export type TextureProperties = DecalProperties & {
	OffsetStudsU: number?,
	OffsetStudsV: number?,
	StudsPerTileU: number?,
	StudsPerTileV: number?,
}
export type FireProperties = InstanceProperties & {
	Color: Color3?,
	Enabled: boolean?,
	Heat: number?,
	LocalTransparencyModifier: number?,
	SecondaryColor: Color3?,
	Size: number?,
	TimeScale: number?,
}
export type FolderProperties = InstanceProperties
export type ForceFieldProperties = InstanceProperties & {
	Visible: boolean?,
}
export type GuiBaseProperties = InstanceProperties
export type GuiBase2dProperties = GuiBaseProperties & {
	AutoLocalize: boolean?,
	RootLocalizationTable: LocalizationTable?,
	SelectionBehaviorDown: Enum.SelectionBehavior?,
	SelectionBehaviorLeft: Enum.SelectionBehavior?,
	SelectionBehaviorRight: Enum.SelectionBehavior?,
	SelectionBehaviorUp: Enum.SelectionBehavior?,
	SelectionGroup: boolean?,
}
export type GuiObjectProperties = GuiBase2dProperties & {
	Active: boolean?,
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	BorderColor3: Color3?,
	BorderMode: Enum.BorderMode?,
	BorderSizePixel: number?,
	ClipsDescendants: boolean?,
	Interactable: boolean?,
	LayoutOrder: number?,
	NextSelectionDown: GuiObject?,
	NextSelectionLeft: GuiObject?,
	NextSelectionRight: GuiObject?,
	NextSelectionUp: GuiObject?,
	Position: UDim2?,
	Rotation: number?,
	Selectable: boolean?,
	SelectionImageObject: GuiObject?,
	SelectionOrder: number?,
	Size: UDim2?,
	SizeConstraint: Enum.SizeConstraint?,
	Transparency: number?,
	Visible: boolean?,
	ZIndex: number?,
}
export type CanvasGroupProperties = GuiObjectProperties & {
	GroupColor3: Color3?,
	GroupTransparency: number?,
}
export type FrameProperties = GuiObjectProperties & {
	Style: Enum.FrameStyle?,
}
export type GuiButtonProperties = GuiObjectProperties & {
	AutoButtonColor: boolean?,
	Modal: boolean?,
	Selected: boolean?,
	Style: Enum.ButtonStyle?,
}
export type ImageButtonProperties = GuiButtonProperties & {
	HoverImage: string?,
	Image: string?,
	ImageColor3: Color3?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	ImageTransparency: number?,
	PressedImage: string?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
}
export type TextButtonProperties = GuiButtonProperties & {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	OpenTypeFeatures: string?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type GuiLabelProperties = GuiObjectProperties
export type ImageLabelProperties = GuiLabelProperties & {
	Image: string?,
	ImageColor3: Color3?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	ImageTransparency: number?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
}
export type TextLabelProperties = GuiLabelProperties & {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	OpenTypeFeatures: string?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type ScrollingFrameProperties = GuiObjectProperties & {
	AutomaticCanvasSize: Enum.AutomaticSize?,
	BottomImage: string?,
	CanvasPosition: Vector2?,
	CanvasSize: UDim2?,
	ElasticBehavior: Enum.ElasticBehavior?,
	HorizontalScrollBarInset: Enum.ScrollBarInset?,
	MidImage: string?,
	ScrollBarImageColor3: Color3?,
	ScrollBarImageTransparency: number?,
	ScrollBarThickness: number?,
	ScrollingDirection: Enum.ScrollingDirection?,
	ScrollingEnabled: boolean?,
	TopImage: string?,
	VerticalScrollBarInset: Enum.ScrollBarInset?,
	VerticalScrollBarPosition: Enum.VerticalScrollBarPosition?,
}
export type TextBoxProperties = GuiObjectProperties & {
	ClearTextOnFocus: boolean?,
	CursorPosition: number?,
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	MultiLine: boolean?,
	OpenTypeFeatures: string?,
	PlaceholderColor3: Color3?,
	PlaceholderText: string?,
	RichText: boolean?,
	SelectionStart: number?,
	ShowNativeInput: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextEditable: boolean?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type VideoFrameProperties = GuiObjectProperties & {
	Looped: boolean?,
	Playing: boolean?,
	TimePosition: number?,
	Video: string?,
	Volume: number?,
}
export type ViewportFrameProperties = GuiObjectProperties & {
	Ambient: Color3?,
	CurrentCamera: Camera?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	LightColor: Color3?,
	LightDirection: Vector3?,
}
export type LayerCollectorProperties = GuiBase2dProperties & {
	Enabled: boolean?,
	ResetOnSpawn: boolean?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
}
export type BillboardGuiProperties = LayerCollectorProperties & {
	Active: boolean?,
	Adornee: Instance?,
	AlwaysOnTop: boolean?,
	Brightness: number?,
	ClipsDescendants: boolean?,
	DistanceLowerLimit: number?,
	DistanceStep: number?,
	DistanceUpperLimit: number?,
	ExtentsOffset: Vector3?,
	ExtentsOffsetWorldSpace: Vector3?,
	LightInfluence: number?,
	MaxDistance: number?,
	PlayerToHideFrom: Instance?,
	Size: UDim2?,
	SizeOffset: Vector2?,
	StudsOffset: Vector3?,
	StudsOffsetWorldSpace: Vector3?,
}
export type ScreenGuiProperties = LayerCollectorProperties & {
	ClipToDeviceSafeArea: boolean?,
	DisplayOrder: number?,
	IgnoreGuiInset: boolean?,
	SafeAreaCompatibility: Enum.SafeAreaCompatibility?,
	ScreenInsets: Enum.ScreenInsets?,
}
export type SurfaceGuiBaseProperties = LayerCollectorProperties & {
	Active: boolean?,
	Adornee: Instance?,
	Face: Enum.NormalId?,
}
export type AdGuiProperties = SurfaceGuiBaseProperties & {
	AdShape: Enum.AdShape?,
	EnableVideoAds: boolean?,
	FallbackImage: string?,
}
export type SurfaceGuiProperties = SurfaceGuiBaseProperties & {
	AlwaysOnTop: boolean?,
	Brightness: number?,
	CanvasSize: Vector2?,
	ClipsDescendants: boolean?,
	LightInfluence: number?,
	MaxDistance: number?,
	PixelsPerStud: number?,
	SizingMode: Enum.SurfaceGuiSizingMode?,
	ToolPunchThroughDistance: number?,
	ZOffset: number?,
}
export type GuiBase3dProperties = GuiBaseProperties & {
	Color3: Color3?,
	Transparency: number?,
	Visible: boolean?,
}
export type InstanceAdornmentProperties = GuiBase3dProperties & {
	Adornee: Instance?,
}
export type SelectionBoxProperties = InstanceAdornmentProperties & {
	LineThickness: number?,
	SurfaceColor3: Color3?,
	SurfaceTransparency: number?,
}
export type PVAdornmentProperties = GuiBase3dProperties & {
	Adornee: PVInstance?,
}
export type HandleAdornmentProperties = PVAdornmentProperties & {
	AdornCullingMode: Enum.AdornCullingMode?,
	AlwaysOnTop: boolean?,
	CFrame: CFrame?,
	SizeRelativeOffset: Vector3?,
	ZIndex: number?,
}
export type BoxHandleAdornmentProperties = HandleAdornmentProperties & {
	Size: Vector3?,
}
export type ConeHandleAdornmentProperties = HandleAdornmentProperties & {
	Height: number?,
	Radius: number?,
}
export type CylinderHandleAdornmentProperties = HandleAdornmentProperties & {
	Angle: number?,
	Height: number?,
	InnerRadius: number?,
	Radius: number?,
}
export type ImageHandleAdornmentProperties = HandleAdornmentProperties & {
	Image: string?,
	Size: Vector2?,
}
export type LineHandleAdornmentProperties = HandleAdornmentProperties & {
	Length: number?,
	Thickness: number?,
}
export type SphereHandleAdornmentProperties = HandleAdornmentProperties & {
	Radius: number?,
}
export type WireframeHandleAdornmentProperties = HandleAdornmentProperties & {
	Scale: Vector3?,
}
export type ParabolaAdornmentProperties = PVAdornmentProperties
export type SelectionSphereProperties = PVAdornmentProperties & {
	SurfaceColor3: Color3?,
	SurfaceTransparency: number?,
}
export type PartAdornmentProperties = GuiBase3dProperties & {
	Adornee: BasePart?,
}
export type HandlesBaseProperties = PartAdornmentProperties
export type ArcHandlesProperties = HandlesBaseProperties & {
	Axes: Axes?,
}
export type HandlesProperties = HandlesBaseProperties & {
	Faces: Faces?,
	Style: Enum.HandlesStyle?,
}
export type SurfaceSelectionProperties = PartAdornmentProperties & {
	TargetSurface: Enum.NormalId?,
}
export type Path2DProperties = GuiBaseProperties & {
	Closed: boolean?,
	Color3: Color3?,
	Thickness: number?,
	Visible: boolean?,
	ZIndex: number?,
}
export type HiddenSurfaceRemovalAssetProperties = InstanceProperties
export type HighlightProperties = InstanceProperties & {
	Adornee: Instance?,
	DepthMode: Enum.HighlightDepthMode?,
	Enabled: boolean?,
	FillColor: Color3?,
	FillTransparency: number?,
	OutlineColor: Color3?,
	OutlineTransparency: number?,
}
export type HumanoidProperties = InstanceProperties & {
	AutoJumpEnabled: boolean?,
	AutoRotate: boolean?,
	AutomaticScalingEnabled: boolean?,
	BreakJointsOnDeath: boolean?,
	CameraOffset: Vector3?,
	DisplayDistanceType: Enum.HumanoidDisplayDistanceType?,
	DisplayName: string?,
	EvaluateStateMachine: boolean?,
	Health: number?,
	HealthDisplayDistance: number?,
	HealthDisplayType: Enum.HumanoidHealthDisplayType?,
	HipHeight: number?,
	Jump: boolean?,
	JumpHeight: number?,
	JumpPower: number?,
	MaxHealth: number?,
	MaxSlopeAngle: number?,
	NameDisplayDistance: number?,
	NameOcclusion: Enum.NameOcclusion?,
	PlatformStand: boolean?,
	RequiresNeck: boolean?,
	RigType: Enum.HumanoidRigType?,
	Sit: boolean?,
	TargetPoint: Vector3?,
	UseJumpPower: boolean?,
	WalkSpeed: number?,
	WalkToPart: BasePart?,
	WalkToPoint: Vector3?,
}
export type HumanoidDescriptionProperties = InstanceProperties & {
	BackAccessory: string?,
	BodyTypeScale: number?,
	ClimbAnimation: number?,
	DepthScale: number?,
	Face: number?,
	FaceAccessory: string?,
	FallAnimation: number?,
	FrontAccessory: string?,
	GraphicTShirt: number?,
	HairAccessory: string?,
	HatAccessory: string?,
	Head: number?,
	HeadColor: Color3?,
	HeadScale: number?,
	HeightScale: number?,
	IdleAnimation: number?,
	JumpAnimation: number?,
	LeftArm: number?,
	LeftArmColor: Color3?,
	LeftLeg: number?,
	LeftLegColor: Color3?,
	MoodAnimation: number?,
	NeckAccessory: string?,
	Pants: number?,
	ProportionScale: number?,
	RightArm: number?,
	RightArmColor: Color3?,
	RightLeg: number?,
	RightLegColor: Color3?,
	RunAnimation: number?,
	Shirt: number?,
	ShouldersAccessory: string?,
	SwimAnimation: number?,
	Torso: number?,
	TorsoColor: Color3?,
	WaistAccessory: string?,
	WalkAnimation: number?,
	WidthScale: number?,
}
export type IKControlProperties = InstanceProperties & {
	ChainRoot: Instance?,
	Enabled: boolean?,
	EndEffector: Instance?,
	EndEffectorOffset: CFrame?,
	Offset: CFrame?,
	Pole: Instance?,
	Priority: number?,
	SmoothTime: number?,
	Target: Instance?,
	Type: Enum.IKControlType?,
	Weight: number?,
}
export type JointInstanceProperties = InstanceProperties & {
	C0: CFrame?,
	C1: CFrame?,
	Enabled: boolean?,
	Part0: BasePart?,
	Part1: BasePart?,
}
export type MotorProperties = JointInstanceProperties & {
	CurrentAngle: number?,
	DesiredAngle: number?,
	MaxVelocity: number?,
}
export type Motor6DProperties = MotorProperties & {
	Transform: CFrame?,
}
export type VelocityMotorProperties = JointInstanceProperties & {
	CurrentAngle: number?,
	DesiredAngle: number?,
	MaxVelocity: number?,
}
export type WeldProperties = JointInstanceProperties
export type LightProperties = InstanceProperties & {
	Brightness: number?,
	Color: Color3?,
	Enabled: boolean?,
	Shadows: boolean?,
}
export type PointLightProperties = LightProperties & {
	Range: number?,
}
export type SpotLightProperties = LightProperties & {
	Angle: number?,
	Face: Enum.NormalId?,
	Range: number?,
}
export type SurfaceLightProperties = LightProperties & {
	Angle: number?,
	Face: Enum.NormalId?,
	Range: number?,
}
export type LightingProperties = InstanceProperties & {
	Ambient: Color3?,
	Brightness: number?,
	ClockTime: number?,
	ColorShift_Bottom: Color3?,
	ColorShift_Top: Color3?,
	EnvironmentDiffuseScale: number?,
	EnvironmentSpecularScale: number?,
	ExposureCompensation: number?,
	FogColor: Color3?,
	FogEnd: number?,
	FogStart: number?,
	GeographicLatitude: number?,
	GlobalShadows: boolean?,
	OutdoorAmbient: Color3?,
	ShadowSoftness: number?,
	TimeOfDay: string?,
}
export type MaterialServiceProperties = InstanceProperties
export type MaterialVariantProperties = InstanceProperties & {
	CustomPhysicalProperties: PhysicalProperties?,
	MaterialPattern: Enum.MaterialPattern?,
	StudsPerTile: number?,
}
export type NoCollisionConstraintProperties = InstanceProperties & {
	Enabled: boolean?,
	Part0: BasePart?,
	Part1: BasePart?,
}
export type NoiseProperties = InstanceProperties
export type OperationGraphProperties = InstanceProperties
export type PVInstanceProperties = InstanceProperties
export type BasePartProperties = PVInstanceProperties & {
	Anchored: boolean?,
	AssemblyAngularVelocity: Vector3?,
	AssemblyLinearVelocity: Vector3?,
	BackSurface: Enum.SurfaceType?,
	BottomSurface: Enum.SurfaceType?,
	BrickColor: BrickColor?,
	CFrame: CFrame?,
	CanCollide: boolean?,
	CanQuery: boolean?,
	CanTouch: boolean?,
	CastShadow: boolean?,
	CollisionGroup: string?,
	Color: Color3?,
	CustomPhysicalProperties: PhysicalProperties?,
	EnableFluidForces: boolean?,
	FrontSurface: Enum.SurfaceType?,
	LeftSurface: Enum.SurfaceType?,
	LocalTransparencyModifier: number?,
	Locked: boolean?,
	Massless: boolean?,
	Material: Enum.Material?,
	MaterialVariant: string?,
	Orientation: Vector3?,
	PivotOffset: CFrame?,
	Position: Vector3?,
	Reflectance: number?,
	RightSurface: Enum.SurfaceType?,
	RootPriority: number?,
	Rotation: Vector3?,
	Size: Vector3?,
	TopSurface: Enum.SurfaceType?,
	Transparency: number?,
}
export type CornerWedgePartProperties = BasePartProperties
export type FormFactorPartProperties = BasePartProperties
export type PartProperties = FormFactorPartProperties & {
	Shape: Enum.PartType?,
}
export type SeatProperties = PartProperties & {
	Disabled: boolean?,
}
export type SpawnLocationProperties = PartProperties & {
	AllowTeamChangeOnTouch: boolean?,
	Duration: number?,
	Enabled: boolean?,
	Neutral: boolean?,
	TeamColor: BrickColor?,
}
export type WedgePartProperties = FormFactorPartProperties
export type TriangleMeshPartProperties = BasePartProperties
export type MeshPartProperties = TriangleMeshPartProperties & {
	TextureID: string?,
}
export type PartOperationProperties = TriangleMeshPartProperties & {
	UsePartColor: boolean?,
}
export type IntersectOperationProperties = PartOperationProperties
export type NegateOperationProperties = PartOperationProperties
export type UnionOperationProperties = PartOperationProperties
export type TrussPartProperties = BasePartProperties & {
	Style: Enum.Style?,
}
export type VehicleSeatProperties = BasePartProperties & {
	Disabled: boolean?,
	HeadsUpDisplay: boolean?,
	MaxSpeed: number?,
	Steer: number?,
	SteerFloat: number?,
	Throttle: number?,
	ThrottleFloat: number?,
	Torque: number?,
	TurnSpeed: number?,
}
export type ModelProperties = PVInstanceProperties & {
	ModelStreamingMode: Enum.ModelStreamingMode?,
	PrimaryPart: BasePart?,
	WorldPivot: CFrame?,
}
export type ActorProperties = ModelProperties
export type BackpackItemProperties = ModelProperties & {
	TextureId: string?,
}
export type ToolProperties = BackpackItemProperties & {
	CanBeDropped: boolean?,
	Enabled: boolean?,
	Grip: CFrame?,
	GripForward: Vector3?,
	GripPos: Vector3?,
	GripRight: Vector3?,
	GripUp: Vector3?,
	ManualActivationOnly: boolean?,
	RequiresHandle: boolean?,
	ToolTip: string?,
}
export type WorldRootProperties = ModelProperties
export type WorldModelProperties = WorldRootProperties
export type ParticleEmitterProperties = InstanceProperties & {
	Acceleration: Vector3?,
	Brightness: number?,
	Color: ColorSequence?,
	Drag: number?,
	EmissionDirection: Enum.NormalId?,
	Enabled: boolean?,
	FlipbookFramerate: NumberRange?,
	FlipbookIncompatible: string?,
	FlipbookLayout: Enum.ParticleFlipbookLayout?,
	FlipbookMode: Enum.ParticleFlipbookMode?,
	FlipbookStartRandom: boolean?,
	Lifetime: NumberRange?,
	LightEmission: number?,
	LightInfluence: number?,
	LocalTransparencyModifier: number?,
	LockedToPart: boolean?,
	Orientation: Enum.ParticleOrientation?,
	Rate: number?,
	RotSpeed: NumberRange?,
	Rotation: NumberRange?,
	Shape: Enum.ParticleEmitterShape?,
	ShapeInOut: Enum.ParticleEmitterShapeInOut?,
	ShapePartial: number?,
	ShapeStyle: Enum.ParticleEmitterShapeStyle?,
	Size: NumberSequence?,
	Speed: NumberRange?,
	SpreadAngle: Vector2?,
	Squash: NumberSequence?,
	Texture: string?,
	TimeScale: number?,
	Transparency: NumberSequence?,
	VelocityInheritance: number?,
	WindAffectsDrag: boolean?,
	ZOffset: number?,
}
export type PathfindingLinkProperties = InstanceProperties & {
	Attachment0: Attachment?,
	Attachment1: Attachment?,
	IsBidirectional: boolean?,
	Label: string?,
}
export type PathfindingModifierProperties = InstanceProperties & {
	Label: string?,
	PassThrough: boolean?,
}
export type PlayerProperties = InstanceProperties & {
	AutoJumpEnabled: boolean?,
	CameraMaxZoomDistance: number?,
	CameraMinZoomDistance: number?,
	CameraMode: Enum.CameraMode?,
	CanLoadCharacterAppearance: boolean?,
	Character: Model?,
	CharacterAppearanceId: number?,
	DevCameraOcclusionMode: Enum.DevCameraOcclusionMode?,
	DevComputerCameraMode: Enum.DevComputerCameraMovementMode?,
	DevComputerMovementMode: Enum.DevComputerMovementMode?,
	DevEnableMouseLock: boolean?,
	DevTouchCameraMode: Enum.DevTouchCameraMovementMode?,
	DevTouchMovementMode: Enum.DevTouchMovementMode?,
	DisplayName: string?,
	HasVerifiedBadge: boolean?,
	HealthDisplayDistance: number?,
	NameDisplayDistance: number?,
	Neutral: boolean?,
	ReplicationFocus: Instance?,
	RespawnLocation: SpawnLocation?,
	Team: Team?,
	TeamColor: BrickColor?,
	UserId: number?,
}
export type PlayersProperties = InstanceProperties & {
	CharacterAutoLoads: boolean?,
	RespawnTime: number?,
}
export type PluginCapabilitiesProperties = InstanceProperties
export type PostEffectProperties = InstanceProperties & {
	Enabled: boolean?,
}
export type BloomEffectProperties = PostEffectProperties & {
	Intensity: number?,
	Size: number?,
	Threshold: number?,
}
export type BlurEffectProperties = PostEffectProperties & {
	Size: number?,
}
export type ColorCorrectionEffectProperties = PostEffectProperties & {
	Brightness: number?,
	Contrast: number?,
	Saturation: number?,
	TintColor: Color3?,
}
export type ColorGradingEffectProperties = PostEffectProperties & {
	TonemapperPreset: Enum.TonemapperPreset?,
}
export type DepthOfFieldEffectProperties = PostEffectProperties & {
	FarIntensity: number?,
	FocusDistance: number?,
	InFocusRadius: number?,
	NearIntensity: number?,
}
export type SunRaysEffectProperties = PostEffectProperties & {
	Intensity: number?,
	Spread: number?,
}
export type ProximityPromptProperties = InstanceProperties & {
	ActionText: string?,
	AutoLocalize: boolean?,
	ClickablePrompt: boolean?,
	Enabled: boolean?,
	Exclusivity: Enum.ProximityPromptExclusivity?,
	GamepadKeyCode: Enum.KeyCode?,
	HoldDuration: number?,
	KeyboardKeyCode: Enum.KeyCode?,
	MaxActivationDistance: number?,
	ObjectText: string?,
	RequiresLineOfSight: boolean?,
	RootLocalizationTable: LocalizationTable?,
	Style: Enum.ProximityPromptStyle?,
	UIOffset: Vector2?,
}
export type RTAnimationTrackerProperties = InstanceProperties & {
	Active: boolean?,
	EnableFallbackAudioInput: boolean?,
	SessionName: string?,
	TrackerType: Enum.TrackerType?,
}
export type RemoteFunctionProperties = InstanceProperties
export type RotationCurveProperties = InstanceProperties
export type SensorBaseProperties = InstanceProperties & {
	UpdateType: Enum.SensorUpdateType?,
}
export type AtmosphereSensorProperties = SensorBaseProperties
export type BuoyancySensorProperties = SensorBaseProperties & {
	FullySubmerged: boolean?,
	TouchingSurface: boolean?,
}
export type ControllerSensorProperties = SensorBaseProperties
export type ControllerPartSensorProperties = ControllerSensorProperties & {
	HitFrame: CFrame?,
	HitNormal: Vector3?,
	SearchDistance: number?,
	SensedPart: BasePart?,
	SensorMode: Enum.SensorMode?,
}
export type SkyProperties = InstanceProperties & {
	CelestialBodiesShown: boolean?,
	MoonAngularSize: number?,
	MoonTextureId: string?,
	SkyboxBk: string?,
	SkyboxDn: string?,
	SkyboxFt: string?,
	SkyboxLf: string?,
	SkyboxRt: string?,
	SkyboxUp: string?,
	StarCount: number?,
	SunAngularSize: number?,
	SunTextureId: string?,
}
export type SmokeProperties = InstanceProperties & {
	Color: Color3?,
	Enabled: boolean?,
	LocalTransparencyModifier: number?,
	Opacity: number?,
	RiseVelocity: number?,
	Size: number?,
	TimeScale: number?,
}
export type SoundProperties = InstanceProperties & {
	LoopRegion: NumberRange?,
	Looped: boolean?,
	PlayOnRemove: boolean?,
	PlaybackRegion: NumberRange?,
	PlaybackRegionsEnabled: boolean?,
	PlaybackSpeed: number?,
	Playing: boolean?,
	RollOffMaxDistance: number?,
	RollOffMinDistance: number?,
	RollOffMode: Enum.RollOffMode?,
	SoundGroup: SoundGroup?,
	SoundId: string?,
	TimePosition: number?,
	Volume: number?,
}
export type SoundEffectProperties = InstanceProperties & {
	Enabled: boolean?,
	Priority: number?,
}
export type ChorusSoundEffectProperties = SoundEffectProperties & {
	Depth: number?,
	Mix: number?,
	Rate: number?,
}
export type CompressorSoundEffectProperties = SoundEffectProperties & {
	Attack: number?,
	GainMakeup: number?,
	Ratio: number?,
	Release: number?,
	SideChain: Instance?,
	Threshold: number?,
}
export type DistortionSoundEffectProperties = SoundEffectProperties & {
	Level: number?,
}
export type EchoSoundEffectProperties = SoundEffectProperties & {
	Delay: number?,
	DryLevel: number?,
	Feedback: number?,
	WetLevel: number?,
}
export type EqualizerSoundEffectProperties = SoundEffectProperties & {
	HighGain: number?,
	LowGain: number?,
	MidGain: number?,
}
export type FlangeSoundEffectProperties = SoundEffectProperties & {
	Depth: number?,
	Mix: number?,
	Rate: number?,
}
export type PitchShiftSoundEffectProperties = SoundEffectProperties & {
	Octave: number?,
}
export type ReverbSoundEffectProperties = SoundEffectProperties & {
	DecayTime: number?,
	Density: number?,
	Diffusion: number?,
	DryLevel: number?,
	WetLevel: number?,
}
export type TremoloSoundEffectProperties = SoundEffectProperties & {
	Depth: number?,
	Duty: number?,
	Frequency: number?,
}
export type SoundGroupProperties = InstanceProperties & {
	Volume: number?,
}
export type SoundServiceProperties = InstanceProperties & {
	AmbientReverb: Enum.ReverbType?,
	DistanceFactor: number?,
	DopplerScale: number?,
	RespectFilteringEnabled: boolean?,
	RolloffScale: number?,
}
export type SparklesProperties = InstanceProperties & {
	Color: Color3?,
	Enabled: boolean?,
	LocalTransparencyModifier: number?,
	SparkleColor: Color3?,
	TimeScale: number?,
}
export type StarterGearProperties = InstanceProperties
export type StarterPackProperties = InstanceProperties
export type StudioAttachmentProperties = InstanceProperties & {
	AutoHideParent: boolean?,
	IsArrowVisible: boolean?,
	Offset: Vector2?,
	SourceAnchorPoint: Vector2?,
	TargetAnchorPoint: Vector2?,
}
export type StudioCalloutProperties = InstanceProperties
export type StyleBaseProperties = InstanceProperties
export type StyleRuleProperties = StyleBaseProperties & {
	Selector: string?,
}
export type StyleSheetProperties = StyleBaseProperties
export type StyleDeriveProperties = InstanceProperties & {
	StyleSheet: StyleSheet?,
}
export type StyleLinkProperties = InstanceProperties & {
	StyleSheet: StyleSheet?,
}
export type SurfaceAppearanceProperties = InstanceProperties & {
	Color: Color3?,
}
export type TeamProperties = InstanceProperties & {
	AutoAssignable: boolean?,
	TeamColor: BrickColor?,
}
export type TextChannelProperties = InstanceProperties
export type TrackerStreamAnimationProperties = InstanceProperties
export type TrailProperties = InstanceProperties & {
	Attachment0: Attachment?,
	Attachment1: Attachment?,
	Brightness: number?,
	Color: ColorSequence?,
	Enabled: boolean?,
	FaceCamera: boolean?,
	Lifetime: number?,
	LightEmission: number?,
	LightInfluence: number?,
	LocalTransparencyModifier: number?,
	MaxLength: number?,
	MinLength: number?,
	Texture: string?,
	TextureLength: number?,
	TextureMode: Enum.TextureMode?,
	Transparency: NumberSequence?,
	WidthScale: NumberSequence?,
}
export type UIBaseProperties = InstanceProperties
export type UIComponentProperties = UIBaseProperties
export type UIConstraintProperties = UIComponentProperties
export type UIAspectRatioConstraintProperties = UIConstraintProperties & {
	AspectRatio: number?,
	AspectType: Enum.AspectType?,
	DominantAxis: Enum.DominantAxis?,
}
export type UISizeConstraintProperties = UIConstraintProperties & {
	MaxSize: Vector2?,
	MinSize: Vector2?,
}
export type UITextSizeConstraintProperties = UIConstraintProperties & {
	MaxTextSize: number?,
	MinTextSize: number?,
}
export type UICornerProperties = UIComponentProperties & {
	CornerRadius: UDim?,
}
export type UIDragDetectorProperties = UIComponentProperties & {
	ActivatedCursorIcon: string?,
	BoundingBehavior: Enum.UIDragDetectorBoundingBehavior?,
	BoundingUI: GuiBase2d?,
	CursorIcon: string?,
	DragAxis: Vector2?,
	DragRelativity: Enum.UIDragDetectorDragRelativity?,
	DragRotation: number?,
	DragSpace: Enum.UIDragDetectorDragSpace?,
	DragStyle: Enum.UIDragDetectorDragStyle?,
	DragUDim2: UDim2?,
	Enabled: boolean?,
	MaxDragAngle: number?,
	MaxDragTranslation: UDim2?,
	MinDragAngle: number?,
	MinDragTranslation: UDim2?,
	ReferenceUIInstance: GuiObject?,
	ResponseStyle: Enum.UIDragDetectorResponseStyle?,
}
export type UIFlexItemProperties = UIComponentProperties & {
	FlexMode: Enum.UIFlexMode?,
	GrowRatio: number?,
	ItemLineAlignment: Enum.ItemLineAlignment?,
	ShrinkRatio: number?,
}
export type UIGradientProperties = UIComponentProperties & {
	Color: ColorSequence?,
	Enabled: boolean?,
	Offset: Vector2?,
	Rotation: number?,
	Transparency: NumberSequence?,
}
export type UILayoutProperties = UIComponentProperties
export type UIGridStyleLayoutProperties = UILayoutProperties & {
	FillDirection: Enum.FillDirection?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	SortOrder: Enum.SortOrder?,
	VerticalAlignment: Enum.VerticalAlignment?,
}
export type UIGridLayoutProperties = UIGridStyleLayoutProperties & {
	CellPadding: UDim2?,
	CellSize: UDim2?,
	FillDirectionMaxCells: number?,
	StartCorner: Enum.StartCorner?,
}
export type UIListLayoutProperties = UIGridStyleLayoutProperties & {
	HorizontalFlex: Enum.UIFlexAlignment?,
	ItemLineAlignment: Enum.ItemLineAlignment?,
	Padding: UDim?,
	VerticalFlex: Enum.UIFlexAlignment?,
	Wraps: boolean?,
}
export type UIPageLayoutProperties = UIGridStyleLayoutProperties & {
	Animated: boolean?,
	Circular: boolean?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	GamepadInputEnabled: boolean?,
	Padding: UDim?,
	ScrollWheelInputEnabled: boolean?,
	TouchInputEnabled: boolean?,
	TweenTime: number?,
}
export type UITableLayoutProperties = UIGridStyleLayoutProperties & {
	FillEmptySpaceColumns: boolean?,
	FillEmptySpaceRows: boolean?,
	MajorAxis: Enum.TableMajorAxis?,
	Padding: UDim2?,
}
export type UIPaddingProperties = UIComponentProperties & {
	PaddingBottom: UDim?,
	PaddingLeft: UDim?,
	PaddingRight: UDim?,
	PaddingTop: UDim?,
}
export type UIScaleProperties = UIComponentProperties & {
	Scale: number?,
}
export type UIStrokeProperties = UIComponentProperties & {
	ApplyStrokeMode: Enum.ApplyStrokeMode?,
	Color: Color3?,
	Enabled: boolean?,
	LineJoinMode: Enum.LineJoinMode?,
	Thickness: number?,
	Transparency: number?,
}
export type ValueBaseProperties = InstanceProperties
export type BoolValueProperties = ValueBaseProperties & {
	Value: boolean?,
}
export type BrickColorValueProperties = ValueBaseProperties & {
	Value: BrickColor?,
}
export type CFrameValueProperties = ValueBaseProperties & {
	Value: CFrame?,
}
export type Color3ValueProperties = ValueBaseProperties & {
	Value: Color3?,
}
export type IntValueProperties = ValueBaseProperties & {
	Value: number?,
}
export type NumberValueProperties = ValueBaseProperties & {
	Value: number?,
}
export type ObjectValueProperties = ValueBaseProperties & {
	Value: Instance?,
}
export type StringValueProperties = ValueBaseProperties & {
	Value: string?,
}
export type Vector3ValueProperties = ValueBaseProperties & {
	Value: Vector3?,
}
export type Vector3CurveProperties = InstanceProperties
export type VideoDeviceInputProperties = InstanceProperties & {
	Active: boolean?,
	CameraId: string?,
	CaptureQuality: Enum.VideoDeviceCaptureQuality?,
}
export type VisualizationModeProperties = InstanceProperties
export type VisualizationModeCategoryProperties = InstanceProperties
export type WeldConstraintProperties = InstanceProperties & {
	Enabled: boolean?,
	Part0: BasePart?,
	Part1: BasePart?,
}
export type WireProperties = InstanceProperties & {
	SourceInstance: Instance?,
	SourceName: string?,
	TargetInstance: Instance?,
	TargetName: string?,
}
return {}
