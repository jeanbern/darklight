module darklight.d;

public import darklight.control;
public import darklight.bootstrap;
public import darklight.composer;
public import darklight.parse;

string makeSite(string title, string html)
{
	return format(
`<!DOCTYPE html>
<html lang="en">
	<head>
		<title>%s</title>
		
		<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
		  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		
		<style type="text/css">%s</style>
		<link href="/assets/css/bootstrap.css" rel="stylesheet">
		<link href="/assets/css/bootstrap-responsive.css" rel="stylesheet">
		<link href="/assets/css/docs.css" rel="stylesheet">
	</head>
	%s
	<script src="/assets/js/jquery.js"></script>
	<!--<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>-->
	<script type="text/javascript">
	function callMe(j)
	{
		$.get('id/'+$('#xid').val()+'/value/'+j, function(data) {
			$('.result').html(data);
				alert('Load was performed.');
				//alert(data.ToString());
			});
	}
	</script>
    <script src="/assets/js/bootstrap.js"></script>
    <!--<script src="/assets/js/envision.js"></script>-->
	<script> // NOTICE!! DO NOT USE ANY OF THIS JAVASCRIPT
// IT'S ALL JUST JUNK FOR OUR DOCS!

!function ($) {

  $(function(){

    var $window = $(window)
    // side bar
    $('.bs-docs-sidenav').affix({
      offset: {
        top: function () { return $window.width() <= 980 ? 290 : 210 }
      , bottom: 270
      }
    })
  })
}(window.jQuery)</script>
</html>`, title, "", html);
}

abstract class DummyLeaf(string tag) : Control
{
	override string toString()
	{
		return "<"~tag~" "~this.tagAttr()~">"~this.content~"</"~tag~">";
	}
}
abstract class DummyNode(int I, string tag) : IStackable!(I)
{
	override @property string containerTag() { return tag; }
}
class h1 : DummyLeaf!("h1") { }
class h2 : DummyLeaf!("h2") { }
class h3 : DummyLeaf!("h3") { }
class p : DummyLeaf!("p") { }
class b : DummyLeaf!("b") { }

class li : DummyNode!(0, "li") { }
class ul : DummyNode!(0, "ul") { }
class pNode : DummyNode!(0, "p") { }
class Section : DummyNode!(0, "section") { }
class div : StackPanel { }
class img : Control
{
	string src;
	override string toString()
	{
		return `<img src="`~this.src~`" `~this.tagAttr()~`/>`;
	}
}
class magic : Control { override string toString() { return this.content; } }
