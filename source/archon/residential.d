module archon.residential;
import vibe.d;
import darklight.d;
import archon.arcbase;

void archonResidential(alias Factory)(HttpServerRequest req, HttpServerResponse res)
{
	enum content = `
<StackPanel containerTag="body" extraAttr="data-spy='scroll' data-twttr-rendered='true'">
	<ArchonNav live="servicesnav"/>
	<StackPanel clss="jumbotron subhead" containerTag="header">
		<StackPanel clss="container">
			<h1>Residential Services</h1>
			<p clss="lead">Helping home-owners reach their energy efficiency goals.</p>
		</StackPanel>
	</StackPanel>
	<StackPanel clss="container">
		<StackPanel clss="row">
			<StackPanel clss="span3">
				<img src="assets/img/preview.png"/>
			</StackPanel>
			<StackPanel clss="span9">
				<h2>Our staff</h2>
				<p>Our friendly H.E.R.S rating technicians are friendly, courteous, and always prepared. They speicalize in handling any residential application and will be glad to answer any questions you may have as they go about their job.</p>
			</StackPanel>
		</StackPanel>
		<StackPanel clss="row">
			<StackPanel clss="span9">
				<h2>Our policies</h2>
				<p>We take no risks when it comes to your home and safety. To that end, each of our inspectors wears a clean uniform and an identification badge. We require all of our staff to come prepared and to show the utmost respect for you and your family.</p>
			</StackPanel>
			<StackPanel clss="span3">
				<img src="assets/img/preview2.png"/>
			</StackPanel>
		</StackPanel>
		<StackPanel clss="row">
			<StackPanel clss="span3">
				<img src="assets/img/preview3.png"/>
			</StackPanel>
			<StackPanel clss="span9">
				<h2>Our records</h2>
				<p>We keep meticulous records of every step and every test, in order to ensure our results are accurate. Documentation is thorough and available in case of an audit or inspection.</p>
			</StackPanel>
		</StackPanel>
		<StackPanel clss="row">
			<StackPanel clss="span9">
				<h2>Your peace of mind</h2>
				<p>Our work is done with you in mind. We use only the best tools and equipment, ensuring unintrusive testing and flawless results. Our goal is to get your home certified and work with you to obtain government rebates.</p>
			</StackPanel>
			<StackPanel clss="span3">
				<img src="assets/img/preview2.png"/>
			</StackPanel>
		</StackPanel>
	</StackPanel>
	<ArchonFooter/>
</StackPanel>`;
	
	string html = Factory.Extract!(content)("", "").toString();
	string site = makeSite("Archon Home Energy Solutions - News", html);
	res.writeBody(site, "text/html; charset=UTF-8");
}