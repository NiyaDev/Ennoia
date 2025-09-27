
module ennoia::vector;
import ennoia::matrix;
import std::io;
import std::math;


struct Vector2 {
  float x, y;
}

<* == Overload *>
fn bool Vector2.equals(self, Vector2 rhs) @operator(==) @export("vector2_equals") {
	return (self.x == rhs.x && self.y == rhs.y);
}
<* + Overload *>
fn Vector2 Vector2.add(self, Vector2 rhs) @operator(+) @export("vector2_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
	};
}
<* + Overload with float *>
fn Vector2 Vector2.pos_offset(&self, float rhs) @operator_s(+) @export("vector2_pos_offset") {
	return {
		self.x + rhs,
		self.y + rhs,
	};
}
<* - Overload *>
fn Vector2 Vector2.sub(self, Vector2 rhs) @operator(-) @export("vector2_sub") {
	return {
		self.x - rhs.x,
		self.x - rhs.y,
	};
}
<* - Overload with float *>
fn Vector2 Vector2.neg_offset(&self, float rhs) @operator_s(-) @export("vector2_nes_offset") {
	return {
		self.x - rhs,
		self.y - rhs,
	};
}
<* * Overload *>
fn Vector2 Vector2.mul(self, Vector2 rhs) @operator(*) @export("vector2_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
	};
}
<* * Overload with float *>
fn Vector2 Vector2.scale(&self, float rhs) @operator_s(*) @export("vector2_scale") {
	return {
		self.x * rhs,
		self.y * rhs,
	};
}
<* / Overload *>
fn Vector2 Vector2.div(self, Vector2 rhs) @operator(/) @export("vector2_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
	};
}
<* / Overload with float *>
fn Vector2 Vector2.inverse(&self, float rhs) @operator_s(/) @export("vector2_inverse") {
	return {
		self.x / rhs,
		self.y / rhs,
	};
}

<* Converts v2 into v3 *>
fn Vector3 Vector2.v3(self) @export("vector2_v3") {
	return {self.x, self.y, 0};
}
<* Converts v2 into v4 *>
fn Vector4 Vector2.v4(self) @export("vector2_v4") {
	return {self.x, self.y, 0, 1};
}
<* Converts v2 into Quaternion *>
fn Quaternion Vector2.q(self) @export("vector2_q") {
	return {self.x, self.y, 0, 0};
}

<* Calculate vector length *>
fn float Vector2.length(self) @export("vector2_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2));
}
<* Calculate vector square length *>
fn float Vector2.length_sqr(self) @export("vector2_kength_sqr") {
	return self.x.pow(2) + self.y.pow(2);
}
<* Calculate the dot product of two vectors *>
fn float Vector2.dot_product(self, Vector2 v2) @export("vector2_dot_product") {
	return (self.x * v2.x) + (self.y * v2.y);
}
<* Calculate distance between two vectors *>
fn float Vector2.distance(self, Vector2 v2) @export("vector2_distance") {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector2.distance_sqr(self, Vector2 v2) @export("vector2_distance_sqr") {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2);
}
<* Calculate angle between two vectors in Radians *>
fn float Vector2.angle_rad(self, Vector2 v2) @export("vector2_angle_rad") {
	Vector2 new = v2 - self;
	return math::atan2(new.y, new.x);
}
<* Calculate angle between two vectors in Degrees *>
fn float Vector2.angle_deg(self, Vector2 v2) @export("vector2_andgle_deg") {
	Vector2 new = v2 - self;
	return math::atan2(new.y, new.x) * (180 / math::PI);
}
<* Normalize provided vector *>
fn Vector2 Vector2.normalize(self) @export("vector2_normalize") {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Transform a Vector2 by a given Matrix *>
fn Vector2 Vector2.transform(self, Matrix mat) @export("vector2_transform") {
	return (self.v4() * mat).v2();
}
<* Calculate linear interpolation between two vectors *>
fn Vector2 Vector2.lerp(self, Vector2 v2, float amount) @export("vector2_lerp") {
	return self + ((v2 - self) * amount);
}
<* Calculate reflected vector to normal *>
fn Vector2 Vector2.reflect(self, Vector2 normal) @export("vector2_reflect") {
	return (self - (2*(self * normal)) * normal);
}
<* Rotate vector by radians *>
fn Vector2 Vector2.rotate_rad(self, float angle) @export("vector2_rotate_rad") {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Rotate vector by degrees *>
fn Vector2 Vector2.rotate_deg(self, float angle) @export("vector2_rotate_deg") {
	float cosres = math::cos(angle / (180 / (float)math::PI));
	float sinres = math::sin(angle / (180 / (float)math::PI));

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Move vector towards target *>
fn Vector2 Vector2.move_towards(self, Vector2 target, float max_distance) @export("vector2_move_toward") {
	Vector2 d = target - self;
	float value = d.length_sqr();

	if (value == 0 || (max_distance >= 0 && value <= max_distance.pow(2))) { return target; }
	float dist = self.distance(target);

	return self + ((d / dist) * max_distance);
}
<* Invert given vector *>
fn Vector2 Vector2.invert(self) @export("vector2_invert") {
	return {
		1 / self.x,
		1 / self.y,
	};
}
<* Clamp the components of the vector between min and max values specified by the given vectors
	@require min.x < max.x && min.y < max.y
 *>
fn Vector2 Vector2.clamp(self, Vector2 min, Vector2 max) @export("vector2_clamp") {
	return {
		math::clamp(self.x, min.x, max.x),
		math::clamp(self.y, min.y, max.y),
	};
}
<* Clamp the magnitude of the vector between two min and max values
  @require min < max
 *>
fn Vector2 Vector2.clamp_mag(self, float min, float max) @export("vector2_clamp_mag") {
	float length = self.length();

	if (length > 0) {
		length = math::sqrt(length);

		float scale = 1;
		if (length < min) {
			scale = min / length;
		} else if (length > max) {
			scale = max / length;
		}

		return self * scale;
	}

	return self;
}

<* Prints info *>
fn void Vector2.print(&self) {
	io::printfn("[%f,%f]", self.x, self.y);
}

