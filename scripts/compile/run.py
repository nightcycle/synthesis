import os
import time
import sys
import json
from typing import TypedDict, Optional

SRC_DIR_PATH = "src"
HEADER_WARNING = "-- this script was generated by the build system, please do not make manual edits"

# functions
def camel_to_upper_snake(name: str) -> str:
	if (len(name) == 0):
		return ""
	return "".join(["_" + c.lower() if c.isupper() else c for c in name]).upper()

def camel_to_pascal(name: str) -> str:
	if (len(name) == 0):
		return ""
	return name[0].upper() + name[1:]

# Classes
class ParameterDefinition(TypedDict):
	name: str
	type: str
	default: str
	description: Optional[str]
	comment: Optional[str]

class FunctionDefinition(TypedDict):
	names: list[str]
	key: str
	parameters: list[ParameterDefinition]
	description: Optional[str]

class ComponentDefinition:
	path: str
	name: str
	display_name: str
	description: str
	functions: list[FunctionDefinition]

	# add constructor
	def __init__(self, path: str):
		with open(path, "r") as file:
			data = json.load(file)
			self.path = os.path.dirname(path)
			self.name = os.path.basename(self.path)
			self.display_name = data["name"]
			self.description = data["description"]
			self.functions = data["functions"]

	def get_header(self, include_source=True, include_translators=True) -> str:
		# get number of steps in the path
		steps = len(self.path.split(os.path.sep))
		# repeat the string "Parent" steps time, putting a . in between each one
		package_req_path: str =  ".".join(["Parent"] * steps)

		source_req = 'local Source = require(script.Parent:WaitForChild("ColdFusion"))\n'
		if not include_source:
			source_req = ""

		trans_req = 'local Translators = require(_Package:WaitForChild("Translators"))\n'
		if not include_translators:
			trans_req = ""
		return f"""--!strict
{HEADER_WARNING}
local _Package = script.{package_req_path}
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
{trans_req}
{source_req}
-- Types
type Maid = Maid.Maid
type Style = Style.Style
type FontData = Types.FontData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type ImageData = Types.ImageData
type CanBeState<V> = ColdFusion.CanBeState<V>"""

	def write_defaults(self) -> None:
		lines: list[str] = [
			self.get_header(include_source=False, include_translators=False),
			'\nreturn {',
		]

		for func in self.functions:
			for name in func["names"]:
				def_param_values: list[str] = []
				for param in func["parameters"]:
					if param['default'] != '':
						type_annotation = ""
						if param['default'] == "nil":
							type_annotation = " :: " + param["type"]

						def_param_values.append(camel_to_upper_snake(param['name']) + ' = ' + param['default'] + type_annotation)

				lines += [
					camel_to_upper_snake(name) + " = {",
					",".join(def_param_values),
					"},"
				]
		lines += [
			'}',
		]

		out_path = self.path + "/Defaults.luau"
		with open(out_path, "w") as file:
			file.write("\n".join(lines))

	def write_fusion(self) -> None:
		lines: list[str] = [
			self.get_header(),
			'type FusionCanBeState<V> = Translators.FusionCanBeState<V>\n',
			'-- Constants',
			'-- Variables',
			'-- References',
			'-- Private Functions',
			'-- Class',
			'local Interface = {}\n',
		]

		for func in self.functions:
			inner_params: list[str] = []
			passed_params: list[str] = []

			for param in func["parameters"]:
				inner_params.append(param["name"]+': FusionCanBeState<'+param["type"]+'>')
				passed_params.append("convert("+param["name"]+")")

			for name in func["names"]:
				function_lines = [
					f'\nfunction Interface.{name}(',
						",".join(inner_params),
						'): GuiObject',
						'local maid = Maid.new()',
						'local _fuse = ColdFusion.fuse(maid)',
						'local function convert<V>(value: FusionCanBeState<V>): CanBeState<V>',
							'return Translators.Fusion.toColdFusion(maid, _fuse, value)',
						'end',
						f'local inst = Source.{name}(',
						",".join(passed_params),
						')',
						'maid:GiveTask(inst.Destroying:Connect(function()',
							'maid:Destroy()',
						'end))',
						'return inst',
					'end',
				]

				lines += function_lines

		lines += [
			'\nreturn Interface',
		]

		out_path = self.path + "/Fusion.luau"
		with open(out_path, "w") as file:
			file.write("\n".join(lines))

	def write_wrapper(self) -> None:
		lines: list[str] = [
			self.get_header(),
			'type Wrapper<BaseInstance, Definition, ClassName> = Translators.Wrapper<BaseInstance, Definition, ClassName>\n',

		]

		for func in self.functions:
			key: str = camel_to_pascal(func['key'])
			type_lines: list[str] = [
				f'\nexport type {key}{self.name}WrapperDefinition = '+'{',

			]
			for param in func["parameters"]:
				type_lines.append(camel_to_pascal(param["name"]) + ": " + param["type"]+",")


			type_lines += [
				'}',
				f'export type {key}{self.name}Wrapper = Wrapper<GuiObject, {key}{self.name}WrapperDefinition, "{key}{self.name}">',

			]

			lines += type_lines


		lines += [
			'-- Constants',
			'-- Variables',
			'-- References',
			'-- Private Functions',
			'-- Interface',
			'local Interface = {}',
		]

		for func in self.functions:
			key = func['key']
			if key != "":
				for name in func["names"]:

					lines += [
						f'\nfunction Interface.{name}(): {camel_to_pascal(key)}{self.name}Wrapper',
							'local maid = Maid.new()',
							'local _fuse = ColdFusion.fuse(maid)',
							'local _Value = _fuse.Value',

							'local definition = {',
					]
					for param in func["parameters"]:
						lines.append(f'{camel_to_pascal(param["name"])} = _Value('+param["default"]+'),')

					lines += [
							'}',

							f'local inst: GuiObject = Source.{name}(',
					]
					def_params = []
					for param in func["parameters"]:
						def_params.append(f'definition.{camel_to_pascal(param["name"])}')

					lines += [
							",".join(def_params),
							')',

							'maid:GiveTask(inst.Destroying:Connect(function()',
								'maid:Destroy()',
							'end))',

							f'local wrapper, cleanUp = Translators.ColdFusion.toWrapper("{camel_to_pascal(key)}{self.name}", inst, definition)',
							'maid:GiveTask(cleanUp)',

							'return wrapper',
						'end',
					]

		lines += [
			'\nreturn Interface',
		]

		out_path = self.path + "/Wrapper.luau"
		with open(out_path, "w") as file:
			file.write("\n".join(lines))

	def write_init(self) -> None:
		lines: list[str] = [
			'--!strict',
			HEADER_WARNING,
			'return {'
				'ColdFusion = require(script:WaitForChild("ColdFusion")),',
				'Fusion = require(script:WaitForChild("Fusion")),',
				'Wrapper = require(script:WaitForChild("Wrapper")),',
			'}'
		]

		out_path = self.path + "/init.luau"
		with open(out_path, mode="w") as file:
			file.write("\n".join(lines))

	def write_md(self) -> None:
		lines: list[str] = [
			f"# {self.display_name}\n",
		]
		if (os.path.exists(self.path + "/preview.gif")):
			lines.append(f"![Preview](preview.gif)\n")
		lines.append(self.description)

		lines += [
			"# Constructors\n"
		]
		lines.append("")

		for func in self.functions:
			lines.append(f"## {' / '.join(func['names'])}")
			if func['key'] == "":
				lines.append("This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.")
			elif func['key'] == "styled":
				lines.append("This function is a style constructor, utilizing the \"Style\" type to reduce the number of parameters required for implementation.")

			if "description" in func:
				lines.append(func['description'])

			lines.append("\n### Parameters")

			for param in func['parameters']:
				description = ""
				if "description" in param:
					description = " = " + param["description"]
				lines.append(f"- **{param['name']}**: {param['type']}{description}")
			lines.append("")
		out_path = self.path + "/README.md"
		with open(out_path, mode="w") as file:
			file.write("\n".join(lines))

	def write_all(self) -> None:
		self.write_defaults()
		self.write_fusion()
		self.write_wrapper()
		self.write_init()
		self.write_md()

# iterate through tree under directory SRC_DIR_PATH, looking for files named "definition.json", then print the path
component_definitions: list[ComponentDefinition] = []

for root, dirs, files in os.walk(SRC_DIR_PATH):
	for file in files:
		if file == "definition.json":
			component_definitions.append(ComponentDefinition(os.path.join(root, file)))


for definition in component_definitions:
	for func in definition.functions:
		for param in func["parameters"]:

			if param["type"][-1] == "?":
				param["default"] = "nil"

	print(definition.path)
	definition.write_all()

