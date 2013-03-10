module archon.services;
import vibe.d;
import darklight.d;
import archon.arcbase;

void archonServices(alias Factory)(HttpServerRequest req, HttpServerResponse res)
{
	enum content = `
<StackPanel containerTag="body" extraAttr="data-spy='scroll' data-twttr-rendered='true'">
	<ArchonNav live="servicesnav"/>
	<StackPanel clss="jumbotron masthead">
		<StackPanel clss="container">
			<h1 style="font-size: 80px" content="Archon Energy Solutions"/>
			<p content="Custom, affordable, top-of-the-line home-energy-efficiency solutions and certification."/>
			<pNode>
				<HRef clss="btn btn-primary btn-large" content="Learn About Home Energy Efficiency" link="./benefits.html"/>
			</pNode>
			<ul clss="masthead-links">
				<li><HRef content="Partners" link="./partners.html"/></li>
				<li><HRef content="Affiliates" link="./affiliates.html"/></li>
				<li><HRef content="Rebates" link="./rebates.html"/></li>
			</ul>
		</StackPanel>
	</StackPanel>
	<StackPanel clss="container">
		<StackPanel clss="marketing">
			<h1 content="Introducing Archon Energy Services."/>
			<p clss="marketing-byline" content="Need reasons to love home energy efficiency? Look no further."/>
			<StackPanel clss="row-fluid">
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-twitter-github.png"/>
					<h2 content="Save money, save the environment."/>
					<p>When it comes to energy, your home is a system with many components - insulation, ducting, windows, furnaces, and air-conditioning - working together to contribute to the big picture. Increased efficiency minimizes the amount of power required to heat or cool your home and reduces your bill while reducing your carbon footprint.</p>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-responsive-illustrations.png"/>
					<h2>Increase Comfort and Air Quality.</h2>
					<p content="Placeholder text."/>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
					<h2>Take advantage of incentives and rebates!</h2>
					<p>Some content will go in here.</p>
				</StackPanel>
			</StackPanel>
			<soften/>
			<h1>Serviced by Archon.</h1>
			<p clss="marketing-byline">Some examples of how we can help you achieve home energy efficiency.</p>
			<StackPanel clss="row-fluid">
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
			</StackPanel>
			<StackPanel clss="row-fluid">
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
				<StackPanel clss="span4">
					<img src="assets/img/bs-docs-bootstrap-features.png"/>
				</StackPanel>
			</StackPanel>
		</StackPanel>
	</StackPanel>
	<ArchonFooter/>
</StackPanel>
`;

	string html = Factory.Extract!(content)("", "").toString();
	string site = makeSite("Archon Home Energy Solutions - Home", html);
	res.writeBody(site, "text/html; charset=UTF-8");
}