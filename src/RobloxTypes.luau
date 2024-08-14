export type InstanceProperties = {
	Archivable: boolean?,
	Name: string?,
	Parent: Instance?,
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
export type PluginGuiProperties = LayerCollectorProperties & {
	Title: string?,
}
export type DockWidgetPluginGuiProperties = PluginGuiProperties
export type QWidgetPluginGuiProperties = PluginGuiProperties
export type ScreenGuiProperties = LayerCollectorProperties & {
	ClipToDeviceSafeArea: boolean?,
	DisplayOrder: number?,
	IgnoreGuiInset: boolean?,
	SafeAreaCompatibility: Enum.SafeAreaCompatibility?,
	ScreenInsets: Enum.ScreenInsets?,
}
export type GuiMainProperties = ScreenGuiProperties
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
export type FloorWireProperties = GuiBase3dProperties & {
	CycleOffset: number?,
	From: BasePart?,
	StudsBetweenTextures: number?,
	Texture: string?,
	TextureSize: Vector2?,
	To: BasePart?,
	Velocity: number?,
	WireRadius: number?,
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
export type SelectionLassoProperties = GuiBase3dProperties & {
	Humanoid: Humanoid?,
}
export type SelectionPartLassoProperties = SelectionLassoProperties & {
	Part: BasePart?,
}
export type SelectionPointLassoProperties = SelectionLassoProperties & {
	Point: Vector3?,
}
export type Path2DProperties = GuiBaseProperties & {
	Closed: boolean?,
	Color3: Color3?,
	Thickness: number?,
	Visible: boolean?,
	ZIndex: number?,
}
return {}
