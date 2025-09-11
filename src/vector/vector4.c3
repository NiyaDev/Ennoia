
module ennoia::vector;
import std::math;
import ennoia::matrix;
import ennoia::color;


struct Vector4 {
  float x, y, z, w;
}

<* == Overload *>
fn bool Vector4.equals(self, Vector4 rhs) @operator(==) @export("vector4_equals") {
	return (self.x == rhs.x && self.y == rhs.y && self.z == rhs.z && self.w == rhs.w);
}
<* + Overload *>
fn Vector4 Vector4.add(self, Vector4 rhs) @operator(+) @export("vector4_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.z + rhs.z,
		self.w + rhs.w,
	};
}
<*  Overload with float *>
fn Vector4 Vector4.pos_offset(self, float rhs) @operator_s(+) @export("vector4_pos_offset") {
	return {
		self.x + rhs,
		self.y + rhs,
		self.z + rhs,
		self.w + rhs,
	};
}
<* - Overload *>
fn Vector4 Vector4.sub(self, Vector4 rhs) @operator(-) @export("vector4_sub") {
	return {
		self.x - rhs.x,
		self.y - rhs.y,
		self.z - rhs.z,
		self.w - rhs.w,
	};
}
<*  Overload with float *>
fn Vector4 Vector4.neg_offset(self, float rhs) @operator_s(-) @export("vector4_neg_offset") {
	return {
		self.x - rhs,
		self.y - rhs,
		self.z - rhs,
		self.w - rhs,
	};
}
<* * Overload *>
fn Vector4 Vector4.mul(self, Vector4 rhs) @operator(*) @export("vector4_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.z * rhs.z,
		self.w * rhs.w,
	};
}
<*  Overload with float *>
fn Vector4 Vector4.scale(self, float rhs) @operator_s(*) @export("vector4_scale") {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
		self.w * rhs,
	};
}
<* * Overload with Matrix *>
fn Vector4 Vector4.mul_mat(self, Matrix rhs) @operator_s(*) @export("vector4_mulmat") {
	return {
		(rhs.m0  * self.x) + (rhs.m1  * self.y) + (rhs.m2  * self.z) + (rhs.m3  * self.w),
		(rhs.m4  * self.x) + (rhs.m5  * self.y) + (rhs.m6  * self.z) + (rhs.m7  * self.w),
		(rhs.m8  * self.x) + (rhs.m9  * self.y) + (rhs.m10 * self.z) + (rhs.m11 * self.w),
		(rhs.m12 * self.x) + (rhs.m13 * self.y) + (rhs.m14 * self.z) + (rhs.m15 * self.w),
	};
}
<* / Overload *>
fn Vector4 Vector4.div(self, Vector4 rhs) @operator(/) @export("vector4_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.z / rhs.z,
		self.w / rhs.w,
	};
}
<* / Overload with float *>
fn Vector4 Vector4.inverse(self, float rhs) @operator_s(/) @export("vector4_inverse") {
	return {
		self.x / rhs,
		self.y / rhs,
		self.z / rhs,
		self.w / rhs,
	};
}

<* Converts v4 into v2 *>
fn Vector2 Vector4.v2(&self) @export("vector4_v2") {
	return {self.x, self.y};
}
<* Converts v4 into v3 *>
fn Vector3 Vector4.v3(&self) @export("vector4_v3") {
	return {self.x, self.y, self.z};
}
<* Converts v4 into Quaternion *>
fn Quaternion Vector4.q(self) @export("vector4_q") {
	return {self.x, self.y, self.z, self.w};
}
<* Converts normaized Vector4 into a color. *>
fn Color Vector4.to_color(self) @export("vector4_color") {
	return {
		(char)(self.x * 255),
		(char)(self.y * 255),
		(char)(self.z * 255),
		(char)(self.w * 255),
	};
}

<* Calculate vector length *>
fn float Vector4.length(self) @export("vector4_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
<* Calculate vector square length *>
fn float Vector4.length_sqr(self) @export("vector4_length_sqr") {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector4.dot_product(self, Vector4 v2) @export("vector4_dot_product") {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
<* Calculate distance between two vectors *>
fn float Vector4.distance(self, Vector4 v2) @export("vector4_distance") {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector4.distance_sqr(self, Vector4 v2) @export("vector4_distance_sqr") {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2);
}
<* Normalize provided vector *>
fn Vector4 Vector4.normalize(self) @export("vector4_normalize") {
	float len = self.length();

	if (len > 0) {
		float ilen = 1 / len;
		return self * ilen;
	}

	return self;
}
<* Get min value for each pair of components *>
fn Vector4 Vector4.min(self, Vector4 v2) @export("vector4_min") {
	return {
		math::min(self.x, v2.x),
		math::min(self.y, v2.y),
		math::min(self.z, v2.z),
		math::min(self.w, v2.w),
	};
}
<* Get max value for each pair of components *>
fn Vector4 Vector4.max(self, Vector4 v2) @export("vector4_max") {
	return {
		math::max(self.x, v2.x),
		math::max(self.y, v2.y),
		math::max(self.z, v2.z),
		math::max(self.w, v2.w),
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector4 Vector4.lerp(self, Vector4 target, float amount) @export("vector4_lerp") {
	return {
		self.x + amount * (target.x - self.x),
		self.y + amount * (target.y - self.y),
		self.z + amount * (target.z - self.z),
		self.w + amount * (target.w - self.w),
	};
}
<* Move Vector towards target *>
fn Vector4 Vector4.move_towards(self, Vector4 target, float max_distance) @export("vector4_move_towards") {
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
fn Vector4 Vector4.invert(self) @export("vector4_invert") {
	return {
		1 / self.x,
		1 / self.y,
		1 / self.z,
		1 / self.w,
	};
}

