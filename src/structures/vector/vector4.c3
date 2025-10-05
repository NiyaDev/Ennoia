
module ennoia::vector;
import std::math;
import ennoia::color;


alias Vec4f = float[<4>];
alias Vec4i = int[<4>];

<* Converts normaized Vector4 into a color. *>
fn Color Vec4f.to_color(self) @export("vector4_color") {
	return {
		(char)(self.x * 255),
		(char)(self.y * 255),
		(char)(self.z * 255),
		(char)(self.w * 255),
	};
}
<* Get min value for each pair of components *>
fn Vec4f Vec4f.min(self, Vec4f v2) @export("vector4_min") {
	return {
		math::min(self.x, v2.x),
		math::min(self.y, v2.y),
		math::min(self.z, v2.z),
		math::min(self.w, v2.w),
	};
}
<* Get max value for each pair of components *>
fn Vec4f Vec4f.max(self, Vec4f v2) @export("vector4_max") {
	return {
		math::max(self.x, v2.x),
		math::max(self.y, v2.y),
		math::max(self.z, v2.z),
		math::max(self.w, v2.w),
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vec4f Vec4f.lerp(self, Vec4f target, float amount) @export("vector4_lerp") {
	return {
		self.x + amount * (target.x - self.x),
		self.y + amount * (target.y - self.y),
		self.z + amount * (target.z - self.z),
		self.w + amount * (target.w - self.w),
	};
}
<* Move Vector towards target *>
fn Vec4f Vec4f.move_towards(self, Vec4f target, float max_distance) @export("vector4_move_towards") {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float dw = target.w - self.w;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2) + dw.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		self.x + dx / dist * max_distance,
		self.y + dy / dist * max_distance,
		self.z + dz / dist * max_distance,
		self.w + dw / dist * max_distance,
	};
}
<* Invert the given vector *>
fn Vec4f Vec4f.invert(self) @export("vector4_invert") {
	return {
		1 / self.x,
		1 / self.y,
		1 / self.z,
		1 / self.w,
	};
}

