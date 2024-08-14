import io
import requests
import json
import sys
from typing import TypedDict

API_DUMP_URL = "https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json"

MAX_CONSTRUCTOR_LENGTH = 5
MAX_CONSTRUCTOR_LENGTH_GROUP = 2
BUILD_PATH = sys.argv[1]

# sending get request and saving the response as response object
api = requests.get(url=API_DUMP_URL, params={}).json()
api_str = '{"k1": "v1", "k2": "v2"}'  # "'"+str(api)+"'"
api_list = json.loads(api_str)

classes = api["Classes"]

class_list = []
for class_data in classes:
	class_list.append(class_data)

class_allow_registry = {
	"Instance": True,
	"Lighting": True,
	"Players": True,
	"SoundService": True,
	"MaterialService": True,
	"StarterGui": True,
	"StarterPack": True,
	"RocketPropulsion": False,
	"BlockMesh": False,
	"Breakpoint": False,
	"HumanoidController": False,
	"VehicleController": False,
	"SkateboardController": False,
	"AirController": False,
	"ClimbController": False,
	"GroundController": False,
	"SwimController": False,
	"ControllerManager": False,
	"DataStoreIncrementOptions": False,
	"DataStoreOptions": False,
	"DataStoreSetOptions": False,
	"DebuggerWatch": False,
	"EulerRotationCurve": False,
	"GetTextBoundsParams": False,
	"Keyframe": False,
	"KeyframeMarker": False,
	"LocalizationTable": False,
	"Script": False,
	"LocalScript": False,
	"ModuleScript": False,
	"MarkerCurve": False,
	"HapticEffect": False,
	"PartOperationAsset": False,
	"ReflectionMetadata": False,
	"ReflectionMetadataCallbacks": False,
	"ReflectionMetadataClasses": False,
	"ReflectionMetadataEnums": False,
	"ReflectionMetadataEvents": False,
	"ReflectionMetadataFunctions": False,
	"ReflectionMetadataClass": False,
	"ReflectionMetadataEnum": False,
	"ReflectionMetadataEnumItem": False,
	"ReflectionMetadataMember": False,
	"ReflectionMetadataProperties": False,
	"ReflectionMetadataYieldFunctions": False,
	"TerrainDetail": False,
	"TerrainRegion": False,
	"StandalonePluginScripts": False,
	"BinaryStringValue": False,
	"TextChatMessageProperties": False,
	"TextChatCommand": False,
	"TeleportOptions": False,
	"RayValue": False,
	"FloatCurve": False,
	"CharacterMesh": False,
	"RenderingTest": False,
	"Pose": False,
	"NumberPose": False,
	"PluginAction": False,
	"Tween": False,
	"ServerStorage": False,
	"ServerScriptService": False,
	"ServerScriptService": False,
	"PartOperation": False,
	"Motor": False,
	"Accoutrement": False,
	"Plane": False,
	"Skin": False,
	"RocketPropulsion": False,
	"HopperBin": False,
	"Flag": False,
	"Hat": False,
	"CustomEvent": False,
	"CustomEventReceiver": False,
	"BlockMesh": False,
	"CylinderMesh": False,
	"Hole": False,
	"MotorFeature": False,
	"FunctionalTest": False,
	"GuiMain": False,
	"FloorWire": False,
	"SelectionPartLasso": False,
	"SelectionPointLasso": False,
	"RotateP": False,
	"RotateV": False,
	"Glue": False,
	"ManualGlue": False,
	"Rotate": False,
	"Snap": False,
	"Message": False,
	"Hint": False,
	"FlagStand": False,
	"SkateboardPlatform": False,
	"DoubleConstrainedValue": False,
	"IntConstrainedValue": False,
	"Speaker": False,
	"ManualWeld": False,
	"Studio": False,
}

final_list = []

class_properties = {}

def get_if_valid_property(propertyMember):
	is_scriptable = True
	is_deprecated = False
	is_read_only = False
	if "Tags" in propertyMember:
		for tag in propertyMember["Tags"]:
			if tag == "Deprecated":
				is_deprecated = True
			elif tag == "NotScriptable":
				is_scriptable = False
			elif tag == "ReadOnly":
				is_read_only = (True,)

	if (
		is_scriptable
		and not is_deprecated
		and not is_read_only
		and propertyMember["MemberType"] == "Property"
		and propertyMember["Security"]["Write"] == "None"
	):
		return True
	else:
		return False


def set_class_properties(class_data):
	class_name = class_data["Name"]
	if not class_name == "Studio":
		super_class = class_data["Superclass"]
		is_service = False
		prop_count = 0
		is_creatable = True
		is_class_deprecated = False

		properties = {}

		for member in class_data["Members"]:
			if get_if_valid_property(member) == True:
				prop_count += 1

		if "Tags" in class_data:
			for tag in class_data["Tags"]:
				if tag == "Service":
					is_service = True
				elif tag == "NotCreatable":
					is_creatable = False
				elif tag == "Deprecated" and not super_class == "BodyMover":
					is_class_deprecated = True

		if (
			class_name in class_allow_registry
			and class_allow_registry[class_name] == True
		):
			is_service = False
			final_list.append(class_data)

		if is_creatable and not is_service:
			if (
				not class_name in class_allow_registry
				or class_allow_registry[class_name] != False
			):
				final_list.append(class_data)

		if prop_count > 0:
			for member in class_data["Members"]:
				is_scriptable = True
				is_deprecated = False
				is_read_only = False
				if "Tags" in member:
					for tag in member["Tags"]:
						if tag == "Deprecated":
							is_deprecated = True
						elif tag == "NotScriptable":
							is_scriptable = False
						elif tag == "ReadOnly":
							is_read_only = (True,)

				if (
					is_scriptable
					and not is_deprecated
					and not is_read_only
					and member["MemberType"] == "Property"
					and member["Security"]["Write"] == "None"
				):
					value_type = member["ValueType"]["Name"]
					if value_type == "bool":
						value_type = "boolean"
					elif value_type == "float":
						value_type = "number"
					elif (
						value_type == "int"
						or value_type == "int64"
						or value_type == "double"
					):
						value_type = "number"
					elif value_type == "Content":
						value_type = "string"

					if member["ValueType"]["Category"] == "Enum":
						value_type = "Enum." + value_type
					if not value_type == "Hole":
						properties[member["Name"]] = value_type

		class_properties[class_name] = properties
	

dependency_registry: dict[str, list[str]] = {}

for class_data in class_list:
	class_name = class_data["Name"]
	super_class = class_data["Superclass"]
	if not super_class in dependency_registry:
		dependency_registry[super_class] = []
	dependency_registry[super_class].append(class_name)
	set_class_properties(class_data)

content: list[str] = []
built_classes: list[str] = []

def format_type_name(class_name: str) -> str:
	return class_name.replace(" ", "")+"Properties"

def build_tree(class_name: str):
	if not class_name in class_properties:
		return 
	if class_name in built_classes:
		return
	built_classes.append(class_name)

	current_parent: None | str = None
	for parent_class in dependency_registry:
		if parent_class == "<<<ROOT>>>":
			continue
		child_classes = dependency_registry[parent_class]
		if class_name in child_classes:
			build_tree(parent_class)
			current_parent = parent_class
		if type(current_parent) == str:
			break
	
	props = class_properties[class_name]
	if len(props) == 0:
		if type(current_parent) == str:
			content.append("export type "+format_type_name(class_name)+" = "+format_type_name(current_parent))
	else:
		content.append("export type "+format_type_name(class_name)+" = ")
		if type(current_parent) == str:
			content.append(format_type_name(current_parent)+" & {")
		else:
			content.append("{")
		
		for prop in class_properties[class_name]:
			content.append(prop.replace(" ", "") +": "+class_properties[class_name][prop]+"?,")
		
		content.append("}")
# with open("type-test.json", "w") as file:
# 	file.write(json.dumps(final_list, indent=4))

# for class_data in final_list:
# 	build_tree(class_data["Name"])	

def plant_tree(root_class_name: str):
	build_tree(root_class_name)
	if not root_class_name in dependency_registry:	
		return
	
	for child_class in dependency_registry[root_class_name]:
		plant_tree(child_class)

plant_tree("UIBase")
plant_tree("GuiBase")

	
content.append("return {}")

with open(BUILD_PATH, "w") as out_file:
	out_file.write("\n".join(content))
