module archon.arcbase;

import vibe.d;
import darklight.d;

class ArchonNav : NavBar
{
	string live;
	enum string _xaml = `
<NavBar brand="Archon" inverted={{true}} responsive={{true}}>
	<HRef id="homenav" content="Home" link="./index.html"/>
	<HRef id="newsnav" content="News" link="./news.html"/>
	<DropDown id="servicesnav">
		<HRef content="Services &&lt;b class='caret'&&gt;&&lt;/b&&gt;"/>
		<HRef content="Residential" link="./residential.html"/>
		<HRef content="Whole-House Home Energy Ratings" link="./ratings.html"/>
	</DropDown>
	<HRef id="pricingnav" content="Pricing" link="./pricing.html"/>
	<HRef id="aboutnav" content="About Us" link="./about.html"/>
	<HRef id="formnav" content="Forms" link="./forms.html" />
	<HRef id="contactnav" link="./contact.html">Contact Us</HRef>
	<SearchBar/>
</NavBar>`;
	
	mixin compose!(_xaml, NavBar);
	
	override string toString()
	{
		foreach(control; this.controls)
		{
			if (control.id == this.live)
			{
				control.active = true;
			}
		}
		
		return super.toString();
	}
}

class ArchonFooter : StackPanel
{
	enum string _xaml = `
<StackPanel clss="footer" containerTag="footer">
	<StackPanel clss="container">
		<pNode clss="pull-right">
			<HRef link="#">Back to top</HRef>
		</pNode>
		<p>Designed and assembled by Jean-Bernard Pellerin</p>
		<pNode>
			<magic>Built with </magic>
			<HRef link="http://twitter.github.com/bootstrap/index.html">Bootstrap</HRef>
			<magic> and </magic>
			<HRef link="http://vibed.org">vibe.d</HRef>
		</pNode>
		<ul clss="footer-links">
			<li><magic>(c)2012 Archon Energy Solutions and Jean-Bernard Pellerin</magic></li>
		</ul>
	</StackPanel>
</StackPanel>`;
	
	mixin compose!(_xaml, StackPanel);
}