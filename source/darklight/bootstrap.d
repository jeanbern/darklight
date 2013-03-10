module darklight.bootstrap;
import darklight.control;
import darklight.parse;
import std.string : format;

bool isNullOrEmpty(string s) { return s is null || s == ""; }

enum Orientation {
	horizontal,
	vertical
}
enum NavOrientation {
	top,
	bottom,
	staticTop
}
enum NavListStyle {
	tabs,
	pills
}


class NavBar : StackPanel
{
	string brand;
	NavOrientation orientation = NavOrientation.top;
	bool responsive = false;
	bool inverted = false;
	bool useSpacers = false;
	
	override string toString()
	{
		string brandContent = ``;
		if (!isNullOrEmpty(this.brand))
		{
			brandContent ~= `<a class="brand" href="./index.html">`~this.brand~`</a>`;
		}
		
		this.setOrientation();
		this.setInversion();
		
		return format(this.responsiveFormat(), brandContent, this.subControls());
	}
		
	private void setOrientation()
	{
		final switch(this.orientation)
		{
			case NavOrientation.top :
				this.clss ~= " navbar-fixed-top";
				return;
			case NavOrientation.bottom :
				this.clss ~= " navbar-fixed-bottom";
				return;
			case NavOrientation.staticTop :
				this.clss ~= " navbar-static-top";
				return;
		}
	}
	
	private void setInversion()
	{
		if (this.inverted == true)
		{
			this.clss ~= " navbar-inverse";
		}
	}
	
	private string subControls()
	{
		string inners;
		bool inList = false;
		foreach(control; this.controls)
		{
			Nav nav = cast(Nav)(control);
			if (nav !is null)
			{
				if (inList)
				{
					if (this.useSpacers == true)
					{
						inners ~= `<li class="divider-vertical"></li>`;
					}
				}
				else
				{
					inList = true;
					inners ~= `<ul class="nav">`;
				}
				
				if (cast(Container)control is null)
				{
					string clssActive = control.active ? ` class="active"` : "";
					inners ~= `<li`~clssActive~`>`~control.toString()~`</li>`;
				}
				else
				{
					control.clss ~= control.active ? ` active` : "";
					(cast(Container)control).containerTag = "li";
					inners ~= control.toString();
					
				}
			}
			else
			{
				if (inList)
				{
					inners ~= `</ul>`;
					inList = false;
				}
				
				inners ~= control.toString();
			}
		}
		return inners;
	}
	
	private string responsiveFormat()
	{
		this.clss = "navbar " ~ this.clss;
		
		if (this.responsive == true)
		{
			return 
`<`~this.containerTag~` `~this.tagAttr()~`>
  <div class="navbar-inner">
    <div class="container">
 
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
 
      <!-- Be sure to leave the brand out there if you want it shown -->
      %s
 
      <!-- Everything you want hidden at 940px or less, place within here -->
	  <div class="nav-collapse collapse">
      %s
	  </div>
 
    </div>
  </div>
</`~this.containerTag~`>`;
		}
		else
		{
			return 
`<`~this.containerTag~` `~this.tagAttr()~`>
	<div class="navbar-inner">
		<!--brand-->
		%s
		<!--content-->
		%s
	</div>
</`~this.containerTag~`>`;
		}
	}
}

class NavList : StackPanel
{	
	NavListStyle listStyle = NavListStyle.tabs;
	Orientation orientation = Orientation.vertical;
	
	override string toString()
	{
		string content;
		foreach(control; this.controls)
		{
			if (cast(Container)control !is null)
			{
				(cast(Container)control).containerTag = "li";
				content ~= control.toString();
			}
			else
			{
				content ~= `<li`~control.tagAttr()~`>`~control.toString()~`</li>`;
			}
		}
		
		string css = " nav";
		css ~= this.listStyle == NavListStyle.tabs ? " nav-tabs" : " nav.pills";
		css ~= this.orientation == Orientation.horizontal ? " nav-stacked" : "";
		
		if (this.containerTag != containerTagDefault)
		{
			return `<`~this.containerTag~` `~this.tagAttr()~`><ul class="`~css~`">`~content~`</ul></`~this.tagAttr()~`>`;
		}
		
		
		return `<ul `~this.tagAttr()~`>`~content~`</ul>`;
	}
}

class SearchBar : Control
{
	override string toString()
	{
		this.clss ~= " navbar-search pull-right";
		return `
<form `~this.tagAttr()~` action>
	<input type="text" class="search-query span2" style="height:auto" placeholder="Search">
</form>`;
	}
}

interface Nav { }

class Divider : Control
{	
	override string toString()
	{
		this.clss ~= " divider";
		return `<li `~this.tagAttr()~`></li>`; 
	}
}

class DropDown : StackPanel, Nav
{
	bool sub = false;
	
	override string toString()
	{
		auto toggle = this.controls[0];
		toggle.clss ~= ` dropdown-toggle`;
		toggle.extraAttr ~= ` data-toggle="dropdown"`;
		toggle.forceId();
		
		string content = toggle.toString();
			
		content ~= `<ul class="dropdown-menu" role="menu" aria-labelledby="`~toggle.id~`">`;
		foreach(control; this.controls[1..$])
		{
			if (cast(Divider)control !is null)
			{
				content ~= control.toString();
				continue;
			}
			if (cast(DropDown)control !is null)
			{
				(cast(DropDown)control).sub = true;
			}
			
			if (cast(Container)control !is null)
			{
				(cast(Container)control).containerTag = "li";
				content ~= control.toString();
			}
			else
			{
				content ~= `<li>`~control.toString()~`</li>`;
			}
		}
		
		content = content ~ `</ul>`;
		if (sub)
		{
			this.clss ~= " dropdown-submenu";
		}
		else
		{
			this.clss ~= " dropdown";
		}
		
		return `<`~this.containerTag~` `~this.tagAttr()~`>`~content~`</`~this.containerTag~`>`;
	}
}

class HRef : Control, Nav
{
	string link = "#";
	
	override string toString()
	{
		return `<a `~this.tagAttr()~`href="`~this.link~`">`~this.content~`</a>`;
	}
}

class SideBar : StackPanel
{
	override string toString() 
	{
		this.clss ~= " bs-docs-sidebar";
		return `
<`~this.containerTag~` `~this.tagAttr()~`>
	<ul class="nav nav-list bs-docs-sidenav">`
		~reduce!("a ~ b.toString()")("", this.controls) 
	~`</ul>
</`~this.containerTag~`>`;
	}
}
class SideBarItem : HRef
{
	override string toString()
	{
		return `<li><a href="`~this.link~`"><i class="icon-chevron-right"></i>`~this.content~`</a></li>`;
	}
}

class soften : Control { override string toString() { return `<hr class="soften"/>`; } }
