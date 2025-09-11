
module ennoia::color;
import std::math;
import ennoia::vector;


struct Color {
  char r, g, b, a;
}

<* == Overload *>
fn bool Color.equals(self, Color rhs) @operator(==) @export("color_equals") {
	return (self.r == rhs.r && self.g == rhs.g && self.b == rhs.b && self.a == self.a);
}
<* Multiply *>
fn Color Color.multiply(self, float factor) @operator_s(*) @export("color_multiply") {
	Color output = self;

	output.r = (char)(output.r * factor);
	output.g = (char)(output.g * factor);
	output.b = (char)(output.b * factor);

	return output;
}

<* Converts color to hexadecimal representation *>
fn uint Color.to_int(self) @export("color_toint") {
	return self.r << 24 | self.g << 16 | self.b << 8 | self.a;
}
<* Converts hexadecimal to color *>
fn Color uint.to_color(self) @export("color_fromint") {
	return {
		(char)(self >> 24),
		(char)(self >> 16),
		(char)(self >>  8),
		(char)(self >>  0),
	};
}
<* Converts color into HSV *>
fn Vector3 Color.to_hsv(self) @export("color_tohsv") {
	float r = (float)self.r / 255;
	float g = (float)self.g / 255;
	float b = (float)self.b / 255;
	float cmax = math::max(r, math::max(g, b));
	float cmin = math::min(r, math::min(g, b));
	float delta = cmax - cmin;

	float hue;
	if (delta == 0.0) { hue = 0; }
	else if (cmax == r) { hue = (60 * (((g - b) / delta) + 360)) % 360; }
	else if (cmax == g) { hue = (60 * (((b - r) / delta) + 120)) % 360; }
	else if (cmax == b) { hue = (60 * (((r - g) / delta) + 240)) % 360; }
	else { hue = -1; };

	float sat = (cmax == 0 ? 0 : delta / cmax);

	return {hue,sat,cmax};
}
<* Converts HSV to color *>
fn Color Vector3.to_color(self) @export("color_fromhsv") {
	float c = self.z * self.y;
	float x = c * (1 - math::abs(((self.x / 60) % 2) - 1));
	float m = self.y - c;

	Vector3 col;
	if      (  0 <= self.x && self.x <  60) { col = {c,x,0}; }
	else if ( 60 <= self.x && self.x < 120) { col = {x,c,0}; }
	else if (120 <= self.x && self.x < 180) { col = {0,c,x}; }
	else if (180 <= self.x && self.x < 240) { col = {0,x,c}; }
	else if (240 <= self.x && self.x < 300) { col = {x,0,c}; }
	else if (300 <= self.x && self.x < 360) { col = {c,0,x}; }

	return {
		(char)((col.x + m) * 255),
		(char)((col.y + m) * 255),
		(char)((col.z + m) * 255),
		255,
	};
}
<* Converts color into Vector4 representation *>
fn Vector4 Color.normalize(self) @export("color_normalize") {
	return {
		(float)self.r / 255,
		(float)self.g / 255,
		(float)self.b / 255,
		(float)self.a / 255,
	};
}

<* Apply alpha to color
  @param alpha: "Value to change alpha to"
  @require alpha <= 1, alpha >= 0 : "Alpha not within proper range of 0 -> 1"
 *>
fn Color Color.fade(self, float alpha) @export("color_fade") {
	return {
		self.r,
		self.g,
		self.b,
	  (char)(255 * alpha),
	};
}
<* Multiplies color by input *>
fn Color Color.tint(self, Color tint) @operator(*) {
	Color result = self;

	Vector4 norm = tint.normalize();
	Vector4 col  = self.normalize();

	return ((col / 255 * norm) * 255).to_color();
}
<* Corrects color for brightness
  @param factor: "Percentage to increase brightness"
  @require factor <= 1, factor >= -1 : "Brightness factor not within range"
 *>
fn Color Color.brightness(self, float factor) @export("color_brightness") {
	Vector4 new = self.normalize();

	if (factor < 0) {
		factor	 = 1 + factor;
		new *= factor;
		new.w = (float)self.a / 255;
	} else {
		new = {
			(255 - new.x) * factor + new.x,
			(255 - new.y) * factor + new.y,
			(255 - new.z) * factor + new.z,
			(float)self.a / 255,
		};
	}

	return new.to_color();
}
<* Corrects color for contrast
  @param contrast: "Percentage to change contrast"
  @require contrast <= 1, contrast >= -1 : "Contrast not within proper range"
 *>
fn Color Color.contrast(self, float contrast) @export("color_contrast") {
	Color result = self;

	contrast += 1;
	contrast *= contrast;

	Vector4 norm = self.normalize();
	norm.x = (float)((((norm.x - 0.5) * contrast) + 0.5) * 255).clamp(0,255);
	norm.y = (float)((((norm.y - 0.5) * contrast) + 0.5) * 255).clamp(0,255);
	norm.z = (float)((((norm.z - 0.5) * contrast) + 0.5) * 255).clamp(0,255);

	return {(char)norm.x,(char)norm.y,(char)norm.z,self.a};
}
<* Get color with alpha applied
  @param alpha: "Alpha to apply to color"
  @require alpha >= 0, alpha <= 1 : "Alpha not within proper range"
 *>
fn Color Color.alpha(self, float alpha) @export("color_alpha") {
	return {self.r, self.g, self.b, (char)(255 * alpha)};
}

// TODO: Fix this
//<* Get src alpha-blended into dst color with tint
//  @param src
//  @param tint
// *>
//fn Color Color.alpha_blend(self, Color src, Color tint) @export("color_alphablend") {
//	return raylib::color_alpha_blend(self, src, tint);
//}

