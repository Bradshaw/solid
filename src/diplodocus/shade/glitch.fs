extern float time;
extern float shimmer;
extern float sw;
extern float sh;
extern float cw;
extern float ch;
uniform float flip = 0;
uniform float miamitime = 0;
uniform float bqlevel = 3;
uniform float distort = 0.1;
uniform float datatheft = 0.0;

extern vec4 colors[15];
extern float rseed;
extern float ditherAmt;

float M_PI = 3.14159265;


 float hue2rgb(float p, float q, float t){
    if(t < 0) t += 1.0;
    if(t > 1) t -= 1.0;
    if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if(t < 1.0/2.0) return q;
    if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec4 hslToRgb(vec4 col){
    float r, g, b;
    float h, s, l;
    h = col.r;
    s = col.g;
    l = col.b;


    if(s == 0){
        r = g = b = l; // achromatic
    }else{

        float q = (l < 0.5 ? l * (1.0 + s) : l + s - l * s);
        float p = 2.0 * l - q;
        r = hue2rgb(p, q, h + 1.0/3.0);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1.0/3.0);
    }

    return vec4(r,g,b,1);
}

vec4 rgbToHsl(vec4 col){
    float r,g,b;
    r = col.r;
    g = col.g;
    b = col.b;
    float max = max(r, max(g, b));
    float min = min(r, min(g, b));
    float h, s, l = (max + min) / 2;

    if(max == min){
        h = s = 0.0; // achromatic
    }else{
        float d = max - min;
        s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min);
        
        if (max==r)
        	h = (g - b) / d + (g < b ? 6.0 : 0.0);
        if (max==g)
        	h = (b - r) / d + 2.0;
        if (max==b)
         	h = (r - g) / d + 4.0;
        h /= 6.0;
    }

    return vec4(h,s,l,1);
}

vec4 inv(vec4 c)
{

	vec4 hsl = rgbToHsl(vec4(c));
	hsl.g *=1.2;
	hsl.b = 1-hsl.b;

	return hslToRgb(hsl);
}

vec4 correct(vec4 c){
	vec4 hsl = rgbToHsl(vec4(c));
	hsl.g *=1.2;
	hsl.b = min(1,(-cos(hsl.b*M_PI)*0.5+0.5));
	return hslToRgb(hsl);	
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float clamp01(float v){
	return mod(v,1);
}

vec2 clamp012(vec2 v){
	return vec2(clamp01(v.x),clamp01(v.y));
}

float gauss(float fx, float fy, float sigma)
{
	return exp(-(fx*fx + fy*fy) / (2.0 * sigma * sigma)) / (2.0 * M_PI * sigma * sigma);
}

float distFromCenter(float x, float y)
{
	x = (x*2)-1;
	y = (y*2)-1;
	return sqrt(x*x+y*y);
}


float lerp(float a, float b, float n){
	return (b*n)+(a*(1-n));
}

float stepify(float v, float steps)
{
	return floor(v*steps)/steps;
}

vec2 stepify2(vec2 v, float steps)
{
	return vec2(stepify(v.x, steps), stepify(v.y, steps));
}

vec4 Texely(Image tex, vec2 sample)
{
	vec4 t = Texel(tex, sample);
	if (bqlevel>1) {
		if (datatheft>0.5)
		{
			
		} else {
			t.r += sin(sample.y*(sh/2)*M_PI)*0.07;
			t.b += cos(sample.y*(sh/2)*M_PI)*0.07;
		}
	}
	return t;
}

vec4 lolsamp(Image tex, vec2 sample, float mult)
{
	float ymult = mult;
	float xmult = mult*100;
	vec4 t = Texel(tex, stepify2(sample+vec2(
		1*(xmult*(0.5-rand(sample*time*0.001))),
		1*(ymult*(0.5-rand(sample*time*0.0011)))
		) , 1000 )  );

	t.r += sin(sample.y*(sh/2)*M_PI)*0.07;
	t.b += cos(sample.y*(sh/2)*M_PI)*0.07;
	return t;
}

float smthstep(float x)
{
	return  (x*x * (3 - x*3));
}

float dist32(vec4 a, vec4 b)
{
	vec4 d = b-a;
	return (d.r*d.r + d.g*d.g + d.b*d.b);
}

float dist3(vec4 a, vec4 b)
{
	return sqrt(dist32(a,b));
}

int getClosest(vec4 c, vec2 coord){
	int res = 4;
	float mindist = 10000;
	int i;
	for (i = 0; i < 15; ++i)
	{
		float dist = dist32(c, colors[i]);
		if (dist+ditherAmt*rand(coord+rseed)<mindist+ditherAmt*rand(coord+rseed+1))
		{
			mindist = dist;
			res = i;
		}
	}
	return res;
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{

	float bl = 0;
	vec2 btc = texture_coords;
	vec2 scc = screen_coords/vec2(sw,sh)-vec2(0.5,0.5);
    scc.y = mix(scc.y,-scc.y,(1/flip)*0.5+0.5);

	float f = 0;//2+length(scc)*2;
	float dfc = length(scc)*2;
	float d = 1-(dfc*dfc*dfc*dfc*dfc)/10;
	dfc = dfc*dfc*dfc*dfc*dfc;

	scc*=((1-distort)+dfc*distort);

	scc += vec2(0.5,0.5);
	scc*=vec2(sw,sh);

	
	vec2 sc_a = scc+vec2(0,ch-sh);
	//sc_a.y = sc_a.y+(1024-768);
	texture_coords = sc_a/vec2(cw,ch);
	
	{
		vec2 dd = abs(texture_coords-0.5)*2;
		dd = dd*dd;
		bl = smoothstep(0.98,1.02,max(dd.x, dd.y));
	}


	vec4 texcolor;

	if (bqlevel>1) {
		texcolor = lolsamp(
			texture,
			stepify2(
				texture_coords,
				1000 + rand(texture_coords)*0.01
			),
			0.01
		);
	} else {
		texcolor = Texel(
			texture,
			texture_coords
		);
	}


	vec2 glitch_coords = texture_coords;

	glitch_coords.x += cos(sin(stepify(glitch_coords.y*10, sin(stepify(glitch_coords.y+time, 10)))+time*2)*5)*0.1*shimmer;
	if (datatheft>0.5) {
		glitch_coords.y += sin(cos(stepify(glitch_coords.x*10, cos(stepify(glitch_coords.x+time, 10)))+time*2)*5)*0.1*shimmer;
	} else {
		glitch_coords.y += cos(sin(glitch_coords.y+time*2)*5)*0.01*shimmer;
	}

	//texcolor = blur(texture, texture_coords, screen_coords, f*0.0005, 0, 0.5);
	//texture_coords = stepify2(texture_coords,sw/4);
	//glitch_coords = stepify2(glitch_coords,sw/2);
	vec4 blurred = Texely(texture, glitch_coords)*1.1;

	
	float r = 0;//0.5;//rand( stepify2( texture_coords, 1000)*time+1 );
	float g = lerp(1,0.6,datatheft)*rand( stepify2( texture_coords, 1000)*time+2 );
	float b = 0;//0.5;//rand( stepify2( texture_coords, 10000)*time+3 );


	
	blurred.r = lerp(blurred.r,r,max(0.1,shimmer*(1-datatheft)));
	blurred.g = lerp(blurred.g,g,max(0.1,shimmer*(1-datatheft)));
	blurred.b = lerp(blurred.b,b,max(0.1,shimmer*(1-datatheft)));	

	texcolor = (blurred+ (shimmer*shimmer*10*(1-datatheft))*texcolor*3) * mix(0.2,1,d);

	//texcolor = vec4(1,1,1,texcolor.a);
    return texcolor;
}

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
	return transform_projection * vertex_position;
}