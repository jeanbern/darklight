/**
	Building blocks for base controls in darklight

	Copyright: © 2013 Jean-Bernard Pellerin
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
	Authors: Jean-Bernard Pellerin (JB)
*/
module darklight.control;

import std.algorithm : reduce;
import std.string : format;
import darklight.parse;

/** 
	Injectable Factory Creator
	
	Creates a Control Factory that will have access to all imports and controls.
	
	Passing this Factory along through control creation will allow a control to contain sub-controls
	that are at a higher level in the dependency chain without causing circular references.
*/
mixin template FactoryGen() {
	import darklight.parse : parse_tag;

	/// The injectable control factory.
	struct ControlFactory
	{
		/**
			Parses the xml to determine which object to create and requests construction and binding from the appropriate Control subclass.
			
			Params:
				_xml = The xml containing the controls and the binding information.
				viewModel = The ViewModel for the control.
				staticModel = Similar to the ViewModel but can be used to provide the top-level ViewModel to sub-controls.
			
			Example:
			---
			mixin FactoryGen;
			struct SampleVM
			{
				string someString;
			}
			
			enum _xml = `	<Node>
						<TextBlock text={{vm.someString}}/>
					</Node>`;
			SampleVM vm; vm.someString = "hello world";
			
			auto ctrl = ControlFactory.Extract(_xml, vm, "");
			writeln(ctrl.toString());
			---
		*/
		static auto Extract(string _xml, T, U)(T viewModel, U staticModel)
		{
			enum Ty = parse_tag(_xml);
			mixin("auto ret = "~Ty~".extract!(ControlFactory, _xml, "~Ty~")(viewModel, staticModel);");
			return ret;
		}
	}
}

/**
	Base Control class. Defines common attributes and a basic extraction method.
*/
abstract class Control
{
	string id;
	string forceId() { static int s_id; if (isNullOrEmpty(this.id)) id = format("%s",s_id++); return id; }
	string content;
	string style;
	string clss;
	string onclick;
	string extraAttr;
	bool active;
	@property void disabled(bool value)
	{
		if (value == true)
		{
			this.clss ~= " disabled";
		}
	}
	
	override abstract string toString();
	
	string tagAttr()
	{
		string ret;
		if (!isNullOrEmpty(this.id))
		{
			ret ~= ` id="`~this.id~`"`;
		}
		if (!isNullOrEmpty(this.clss))
		{
			ret ~= ` class="`~this.clss~`"`;
		}
		if (!isNullOrEmpty(this.style))
		{
			ret ~= ` style="`~this.style~`"`;
		}
		if (!isNullOrEmpty(this.onclick))
		{
			ret ~= ` onclick="`~this.onclick~`"`;
		}
		
		return ret~this.extraAttr;
	}
	
	/**
		Basic extraction method for Controls. Will perform bindings and return the contructed object.
		Not generally called by user code, necessary for the Factory to construct Controls.

		For custom behavior or subcontrols, replace this method.

		Binding is performed via attributes to the xml using constants, method calls, the viewModel, or the staticModel.
		The viewModel is accessible via $(D vm) or $(D viewModel), the former being passed to child controls.
		i.e. $(D <StackPanel vm={{viewModel.innerViewModel}}>...</StackPanel>) will result in the children seeing $(D innerViewModel) when accessing $(D viewModel) or $(D vm).
		There is a similar relationship between staticVM and staticModel, though these should rarely be assigned as they are designed to be static globals.
		For string constants use value="constant".
		Otherwise bindings are of the form value={{expression}}.
		
		Params:
			F = A ControlFactory type.
			_xml = The xml containing the controls and the binding information.
			ForwardRefT = The class to instantiate. This is necessary because template methods are not polymorphic.
			viewModel = The ViewModel for the control.
			staticModel = Similar to the ViewModel but can be used to provide the top-level ViewModel to sub-controls.
		
		Example:
		---
		mixin FactoryGen;
		struct SampleVM
		{
			string someString;
			string getID() { return "myID"; }
		}
		
		enum _xml = `<TextBlock text={{vm.someString}} id={{vm.getID()}}/>`;
		SampleVM vm; vm.someString = "hello world";
		
		auto ctrl = TextBlock.extract!(ControlFactory, TextBlock)(vm, "");
		writeln(ctrl.toString());
		---
	*/
	static auto extract(alias F, string _xml, ForwardRefT : Control, T, U)(T viewModel, U staticModel)
	{
		//Create the object. This might give problems if there is no public parameterless constructor
		ForwardRefT self = new ForwardRefT();
		
		//Assuming this object is a terminal leaf node, the xml contents will not be a further control.
		self.content = parse_inner(_xml);
		
		//Perform bindings. $(D <TextBlock text={{vm.someString}}/>) will result in $(D self.text = vm.someString;) being added for compilation.
		mixin(assignstring(parse_attr(_xml)));
		return self;
	}
}

interface Container
{
	@property string containerTag();
	@property void containerTag(string tag);
}

/**
	Base class for container controls. These are Controls that contain other controls.
	
	Params:
		I = Amount of subcontrols. 0 for variable.
*/
abstract class IContainer(int I=0) : Control, Container
{
	enum containerTagDefault = "div";
	string m_containerTag = containerTagDefault;
	@property string containerTag() { return this.m_containerTag; }
	@property void containerTag(string value) { this.m_containerTag = value; }

	// Allows for Container types with fixed or variable subcontrol sizes.
	static if (I == 0)
	{
		Control[] controls;
	}
	else
	{
		Control[I] controls;
	}
	
	override string toString()
	{
		string content;
		static if (I == 0)
		{
			content = reduce!("a~b.toString()")("",this.controls);
		}
		else
		{
			//For some reason was not able to reduce!() a statically sized array.
			foreach(control; this.controls)
			{
				content ~= control.toString();
			}
		}
		
		return `<`~this.containerTag~` `~this.tagAttr~`()>`~content~`</`~this.containerTag~`>`;
	}
}

/**
	Base class for Stackable controls. These are Controls that contain other controls which are defined sequentially in xml.
	
	Params:
		I = Amount of subcontrols. 0 for variable.
*/
abstract class IStackable(int I=0) : IContainer!(I)
{
	static auto extract(alias F, string _xml, ForwardRefT : Control, T, U)(T viewModel, U staticModel)
	{
		ForwardRefT self = new ForwardRefT();
		mixin(assignstring(parse_attr(_xml)));
		enum contents = subparse(parse_inner(_xml));
		static assert(I == 0 || contents.length == I);
		Chain!(F, contents)(self, vm, staticVM);
		return self;
	}
	
	static void Chain(alias F, alias inners, ForwardRefT : Control, T, U)(ForwardRefT self, T viewModel, U staticModel)
	{
		static if (inners.length > 0)
		{
			Control next = F.Extract!(inners[0])(viewModel, staticModel);
			static if (I == 0)
			{
				self.controls ~= next;
			}
			else
			{
				self.controls[I-inners.length] = next;
			}
			
			Chain!(F, inners[1..$])(self, viewModel, staticModel);
		}
	}
}

/**
	ListPanel Control class.
	This class expects one xml subcontrol, which will be repeated for each item in $(D list) which must be iterable with foreach.
	The subcontrols will each receive one such list item as their $(D vm).
	
	Example:
		---
		mixin FactoryGen;
		struct Person
		{
			string name;
		}
		struct SampleVM
		{
			Person[] people;
		}
		
		enum _xml = `	<ListPanel list={{vm.people}}>
					<TextBlock text={{vm.name}}/>
				</ListPanel>`;
		Person p1; p1.name = "JB";
		Person p2; p2.name =  "Chelsea";
		SampleVM viewModel; viewModel.people = { p1, p2 };
		
		auto ctrl = ControlFactory.Extract!(_xml)(viewModel, "");
		writeln(ctrl.toString());
		---
		
*/
class ListPanel : IContainer!(0)
{	
	static auto extract(alias F, string _xml, ForwardRefT : Control, T, U)(T viewModel, U staticModel)
	{
		ForwardRefT self = new ForwardRefT();
		mixin(assignstringPlus(parse_attr(_xml),"list","null"));
		enum contents = subparse(parse_inner(_xml));
		static assert(contents.length == 1);
		foreach(item; list)
		{
			self.controls ~= F.Extract!(contents[0])(item, staticVM);
		}
		
		return self;
	}
}

/**
	StackPanel Control class.
	This class expects any number of xml subcontrols. It will create and store them sequentially.
	
	Example:
		---
		mixin FactoryGen;
		struct Person
		{
			string name;
		}
		struct SampleVM
		{
			Person[] people;
			string someString;
		}
		
		enum _xml = `	<StackPanel list={{vm.people}}>
					<TextBlock text={{vm.someString}}/>
					<TextBlock vm={{viewModel.people[0]}} text={{vm.name}}/>
				</StackPanel>`;
		Person p1; p1.name = "JB";
		Person p2; p2.name =  "Chelsea";
		SampleVM viewM; viewM.people = { p1, p2 }; viewM.someString = "a string!";
		
		auto ctrl = ControlFactory.Extract!(_xml)(viewM, "");
		writeln(ctrl.toString());
		---
		
*/
class StackPanel : IStackable!(0) { }

class Node : IStackable!(1) { }
