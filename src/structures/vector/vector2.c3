
module ennoia::vector;
import ennoia::matrix;
import std::io;
import std::math;


alias Vec2f = float[<2>];
alias Vec2i = int[<2>];

<* Calculate angle between two vectors in Radians *>
fn float Vec2f.angle_rad(self, Vec2f v2) @export("vector2_angle_rad") {
	Vec2f new = v2 - self;
	return math::atan2(new.y, new.x);
}
<* Calculate angle between two vectors in Degrees *>
fn float Vec2f.angle_deg(self, Vec2f v2) @export("vector2_andgle_deg") {
	Vec2f new = v2 - self;
	return math::atan2(new.y, new.x) * (180 / math::PI);
}
<* Calculate linear interpolation between two vectors *>
fn Vec2f Vec2f.lerp(self, Vec2f v2, float amount) @export("vector2_lerp") {
	return self + ((v2 - self) * amount);
}
<* Calculate reflected vector to normal *>
fn Vec2f Vec2f.reflect(self, Vec2f normal) @export("vector2_reflect") {
	return (self - (2*(self * normal)) * normal);
}
<* Rotate vector by radians *>
fn Vec2f Vec2f.rotate_rad(self, float angle) @export("vector2_rotate_rad") {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Rotate vector by degrees *>
fn Vec2f Vec2f.rotate_deg(self, float angle) @export("vector2_rotate_deg") {
	float cosres = math::cos(angle / (180 / (float)math::PI));
	float sinres = math::sin(angle / (180 / (float)math::PI));

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Move vector towards target *>
fn Vec2f Vec2f.move_towards(self, Vec2f target, float max_distance) @export("vector2_move_toward") {
	Vec2f d = target - self;
	float value = d.length().pow(2);

	if (value == 0 || (max_distance >= 0 && value <= max_distance.pow(2))) { return target; }
	float dist = self.distance(target);

	return self + ((d / dist) * max_distance);
}
<* Invert given vector *>
fn Vec2f Vec2f.invert(self) @export("vector2_invert") {
	return {
		1 / self.x,
		1 / self.y,
	};
}
<* Clamp the components of the vector between min and max values specified by the given vectors
	@require min.x < max.x && min.y < max.y
 *>
fn Vec2f Vec2f.clamp(self, Vec2f min, Vec2f max) @export("vector2_clamp") {
	return {
		math::clamp(self.x, min.x, max.x),
		math::clamp(self.y, min.y, max.y),
	};
}
<* Clamp the magnitude of the vector between two min and max values
  @require min < max
 *>
fn Vec2f Vec2f.clamp_mag(self, float min, float max) @export("vector2_clamp_mag") {
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

