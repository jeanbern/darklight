module darklight.composer;
import darklight.control;
import darklight.parse;

mixin template compose(string _xaml, Ty : Control)
{
	static auto extract(alias F, string _xml, ForwardRefT, T, U)(T viewModel, U staticModel)
	{
		auto self = Ty.extract!(F, _xaml, ForwardRefT)(viewModel, staticModel);
		mixin(assignstring(parse_attr(_xml)));
		return self;
	}
}