import vibe.d;
import std.array;
import std.file : read, getcwd, write;
import std.file;
import darklight.d;
import archon.d;

mixin FactoryGen;

static this()
{
	auto settings = new HttpServerSettings;
	settings.port = 8080;
	
	auto router = new UrlRouter;
	router.get("/index.html", &archonIndex!(ControlFactory));
	router.get("/news.html", &archonNews!(ControlFactory));
	router.get("/forms.html", &archonForms!(ControlFactory));
	router.get("/residential.html", &archonResidential!(ControlFactory));
	
	router.get("*", (&serveStaticFiles)("./public/"));
	
	listenHttp(settings, router);
}