vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{

	vec4 c = Texel(texture, texture_coords)*color;
	float av  = (c.r+c.g+c.b)/3.0;
	float vmax = max(c.r,max(c.g,c.b));
	float vmin = min(c.r,min(c.g,c.b));
	float vav = av > 0.5 ? 1 : 0;
	vmax = vmax > 0.5? 1 : 0;
	vmin = vmin > 0.5? 1 : 0;
	c.r = vmax;
	c.g = vav;
	c.b = vmin;
	return c;
}