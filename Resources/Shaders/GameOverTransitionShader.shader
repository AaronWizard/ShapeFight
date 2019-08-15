shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

void fragment()
{
	float redrange = 0.1;

	float value = texture(mask, UV).r;
	
	if (value < cutoff)
	{
		if ((cutoff < (1.0 - redrange)) && (value > (cutoff - redrange)))
		{
			COLOR = vec4(1.0, 0.0, 0.0, 1.0);
		}
		else
		{
			COLOR = vec4(0.0, 0.0, 0.0, 1.0);
		}
	}
	else
	{
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}