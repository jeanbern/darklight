module darklight.parse;
import std.traits : isSomeString;
import std.algorithm : canFind;
import std.string : strip;
import std.array : replace;

pure @safe nothrow bool isNullOrEmpty(T)(T text) if(isSomeString!T) {
	return "" == text || text is null;
}

enum string[] _binderVal = [`vm`, `staticVM`];
enum string[string] _binderDefVal = [`vm`:`viewModel`, `staticVM`:`staticModel`];

string assignstringPlus(string content, string binder, string binderDefault)
{
	string[string] cop = _binderDefVal;
	cop[binder] = binderDefault;
	return assignstringX(content, _binderVal~binder, cop)[0];
}

string assignstring(string content)
{
	return assignstringX(content)[0];
}

string reverseassign(string content)
{
	return assignstringX(content)[1];
}
string reverseassignPlus(string content, string binder, string binderDefault)
{
	string[string] cop = _binderDefVal;
	cop[binder] = binderDefault;
	return assignstringX(content, _binderVal~binder, cop)[1];
}

string[] assignstringX(string content, string[] binder=_binderVal, string[string] binderDefault=_binderDefVal) {
	content = " "~content~"  ";
	string ret = "";
	string ret2 = "";
	
	int memberStart, equalPos, leftDelim;
	bool twoway = false;
	bool quot = false;
	
	bool[string] bound;
	foreach(str; binder) 
	{
		bound[str] = false;
	}
	
	pure bool isformatchar(char a) 
	{
		return (a == ' ' || a == '\n' || a=='\t' || a=='<' || a=='>' || a=='/' || a=='\\');
	}
	
	for(int i = 0; i < content.length; i++)
	{
		if (!memberStart && !isformatchar(content[i]))
		{
			memberStart = i;
		}
		else if (memberStart && !equalPos && content[i..i+2] == ":=")
		{
			equalPos = i; ++i; twoway = true;
		}
		else if (memberStart && !equalPos && content[i] == '=')
		{
			equalPos = i;
		}
		else if (memberStart && equalPos && !leftDelim && ( content[i] == '"' || content[i-2..i] == `{{`))
		{
			if (content[i] == '"')
			{
				quot = true;
			}
			leftDelim = i;
		}
		else if (memberStart && equalPos && leftDelim && ((quot && content[i] == '"') || content[i+1..i+3] == `}}`))
		{
			string member = strip(content[memberStart..equalPos]);
			string assignment = strip(content[leftDelim..i+1]);
			
			assignment = assignment.replace("&&lt;","<");
			assignment = assignment.replace("&&gt;",">");
			
			memberStart = 0;	equalPos = 0;	leftDelim = 0;
			
			if (binder.canFind(member)) 
			{
				bound[member] = true;
				ret = `auto `~member~` = `~assignment~";\n"~ret;
				//if (twoway)
				//{
					ret2 = `auto `~member~` = `~assignment~";\n"~ret2;
				//}
			} 
			else 
			{
				ret ~= `self.`~member~` = `~assignment~";\n";
				if (twoway)
				{
					ret2 ~= assignment~` = self.`~member~".get!string();\n";
				}
			}
			
			twoway = false;
			quot = false;
			i = content[i+1..i+3] == `}}` ? i+2 : i;
		}
	}
	
	foreach(str; binder) 
	{
		if (bound[str] == false) 
		{
			ret = "auto "~str~" = "~binderDefault[str]~";\n" ~ ret;
			ret2 = "auto "~str~" = "~binderDefault[str]~";\n" ~ ret2;
		}
	}
	
	return [ret, ret2];
}

string parse_tag(string xml) {
	return parsexml(xml)[0];
}
string parse_attr(string xml) {
	return parsexml(xml)[1];
}
string parse_inner(string xml) {
	return parsexml(xml)[2];
}
string parse_rem(string xml) {
	return parsexml(xml)[3];
}
string parse_elem(string xml) {
	return parsexml(xml)[4];
}
string[] parsexml(string xml) {
	if (xml is null || xml == ``) { return [``,``,``,``,``]; }
	//tag, attr, inner, remainder, elem
	int b[5]; //|<jkh|  |>  |</jkh|>
	int open;
	int i = -1;

	while(++i < xml.length) {
		if (xml[i] == '<') {
			b[0] = i;
			open = 1;
			break;
		}
	}
	while(++i < xml.length) {
		if ((xml[i] == ' ' || xml[i] == '\n' || xml[i] == '\t') && b[1] == 0) {
			b[1] = i;
		}
		if (xml[i] == '>') {
			break;
		}
		if (open == 1 && xml[i] == '/' && xml[i+1] == '>') {
			--open;
			b[3] = i;
			b[4] = i+1;
			break;
		}
	}
	b[1] = b[1] == 0 ? i : b[1];
	b[2] = i;
	while(open > 0 && ++i < xml.length-1) {
		if (xml[i] == '<') {
			open += xml[i+1]=='/' ? -1 : 1;
		}
		if (xml[i] == '/' && xml[i+1] == '>') {
			--open;
		}
	}
	b[3] = b[3] == 0 ? i : b[3];
	while (b[4] == 0 && ++i < xml.length) {
		if (xml[i] == '>') {
			break;
		}
	}
	b[4] = b[4] == 0 ? i : b[4];
	
	//|<jkh|  |>  |</jkh|>
	string ret[]; //tag, attr, inner, remainder, elem
	ret ~= xml[b[0]+1..b[1]];
	ret ~= xml[b[1]..b[2]];
	ret ~= ((b[2]==b[3]) ? `` : xml[b[2]+1..b[3]]);
	ret ~= xml[b[4]+1..$];
	ret ~= xml[b[0]..b[4]+1];
	if (b[2] != b[3]) {
		assert(ret[0] == xml[b[3]+2..b[3]+(b[1]-b[0])+1], `Opening and closing names do not match in xml`);
	}
	
	return ret;
}

pure string[] subparse(string xml)
{
	string[] ret;
	int level = 0;
	int startInd = -1;
	bool found = false;
	
	for(int x = 0; x < xml.length-1; x++)
	{
		if (xml[x] == '<' && xml[x+1] != '/')
		{
			++level;
			if (level == 1)
			{
				startInd = x;
			}
		}
		else if (xml[x..x+2] == "/>")
		{
			--level;
			if (level == 0)
			{
				ret ~= xml[startInd..x+2];
			}
		}
		else if (xml[x..x+2] == "</")
		{
			--level;
			if (level == 0)
			{
				found = true;
			}
		}
		else if (found == true && xml[x+1] == '>')
		{
			ret ~= xml[startInd..x+2];
			found = false;
		}
	}
	
	return ret;
}