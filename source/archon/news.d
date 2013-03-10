module archon.news;
import vibe.d;
import darklight.d;
import archon.arcbase;

void archonNews(alias Factory)(HttpServerRequest req, HttpServerResponse res)
{
	enum content = `
<StackPanel containerTag="body" extraAttr="data-spy='scroll' data-twttr-rendered='true'">
	<ArchonNav live="newsnav"/>
	<StackPanel clss="jumbotron subhead" containerTag="header">
		<StackPanel clss="container">
			<h1>News</h1>
			<p clss="lead">Up to date events, product announcements, certification news and more.</p>
		</StackPanel>
	</StackPanel>
	<StackPanel clss="container">
		<StackPanel clss="page-header">
			<h1>Nothing yet, come back soon!</h1>
		</StackPanel>
	</StackPanel>
	<ArchonFooter/>
</StackPanel>`;
	
	string html = Factory.Extract!(content)("", "").toString();
	string site = makeSite("Archon Home Energy Solutions - News", html);
	res.writeBody(site, "text/html; charset=UTF-8");
}