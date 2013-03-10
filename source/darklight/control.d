module darklight.control;

import std.metastrings : Format;
import std.array : join, replicate, appender;
import std.algorithm : reduce;
import std.string : format;
import std.conv : to;
import darklight.parse;
import vibe.data.json;

		import std.stdio : writeln;

mixin template FactoryGen() {
	import darklight.parse : parse_tag;
	struct ControlFactory
	{
		static auto Extract(string _xml, T, U)(T viewModel, U staticModel)
		{
			enum Ty = parse_tag(_xml);
			mixin("auto ret = "~Ty~".extract!(ControlFactory, _xml, "~Ty~")(viewModel, staticModel);");
			//mixin("ret.setSelf = "~Ty~".setVars!(parse_attr(_xml))(viewModel, staticModel);");
			return ret;
		}
	}
}


abstract class Control
{
	void delegate(Json json) setSelf;
	Control parent;
	string id;
	string forceId() { static int s_id; if (id is null || id == "") id = format("%s",s_id++); return id; }
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
	
	static auto extract(alias F, string _xml, ForwardRefT, T, U)(T viewModel, U staticModel)
	{
		ForwardRefT self = new ForwardRefT();
		self.content = parse_inner(_xml);
		mixin(assignstring(parse_attr(_xml)));
		return self;
	}
	
	/*static auto setVars(string _xml, T, U)(T viewModel, U staticModel)
	{
		void setRev(Json self)
		{
			pragma(msg, assignstring(_xml));
			pragma(msg, reverseassign(_xml));
			mixin(reverseassign(_xml));
			writeln("-- ", _xml);
			writeln("---", reverseassign(_xml));
			//self.content = dst.data();
		}
		
		return &setRev;
	}*/
}

interface Container
{
	//This member represents the ability to use a tag type it is given (ex: by the parent).
	//The lack of such a promise represents a guarantee that tagAttr() is not used and can freely be taken over by the parent.
	//K, so, those promises aren't really promises. Keep this class and behaviour in mind though.
	@property string containerTag();
	@property void containerTag(string tag);
}

abstract class IContainer(int I=0) : Control, Container
{
	enum containerTagDefault = "div";
	string m_containerTag = containerTagDefault;
	@property string containerTag() { return this.m_containerTag; }
	@property void containerTag(string value) { this.m_containerTag = value; }

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
			foreach(control; this.controls)
			{
				content ~= control.toString();
			}
		}
		
		return format(`
<`~this.containerTag~` %s>%s
</`~this.containerTag~`>`, this.tagAttr(), content);
	}
}

abstract class IStackable(int I=0) : IContainer!(I)
{
	static auto extract(alias F, string _xml, ForwardRefT, T, U)(T viewModel, U staticModel)
	{
		ForwardRefT self = new ForwardRefT();
		mixin(assignstring(parse_attr(_xml)));
		enum contents = subparse(parse_inner(_xml));
		static assert(I == 0 || contents.length == I);
		Chain!(F, contents)(self, vm, staticVM);
		return self;
	}
	
	static void Chain(alias F, alias inners, ForwardRefT, T, U)(ForwardRefT self, T viewModel, U staticModel)
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

class ListPanel : IContainer!(0)
{	
	static auto extract(alias F, string _xml, ForwardRefT, T, U)(T viewModel, U staticModel)
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

class StackPanel : IStackable!(0) { }

class Node : IStackable!(1) { }