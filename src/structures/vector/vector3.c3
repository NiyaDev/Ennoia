
module ennoia::vector;
import std::io;
import std::math;
import ennoia::color;


alias Vec3f = float[<3>];
alias Vec3i = int[<3>];

<* Converts input HSV into it's equivalent color *>
fn Color Vec3f.color(self) @export("vector3_color") {
	Color result = {0,0,0,255};

	//* Red channel
	float k = (5 + self.x / 60) % 6;
	float t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.r = (char)((self.z - self.z * self.y * k) * 255);

	//* Green channel
	k = (3 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.g = (char)((self.z - self.z * self.y * k) * 255);

	//* Blue channel
	k = (1 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.b = (char)((self.z - self.z * self.y * k) * 255);

	return result;
}

<* Calculate two vectors cross product *>
fn Vec3f Vec3f.cross_product(self, Vec3f v2) @export("vector3_cross_product") {
	return {
		self.y * v2.z - self.z * v2.y,
		self.z * v2.x - self.x * v2.z,
		self.x * v2.y - self.y * v2.x,
	};
}
<* Calculate angle between two vectors in radians *>
fn float Vec3f.angle_rad(self, Vec3f v2) @export("vector3_angle_rad") {
	Vec3f cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot(v2);

  return math::atan2(len, dot);
}
<* Calculate angle between two vectors in degrees *>
fn float Vec3f.angle_deg(self, Vec3f v2) @export("vector3_angle_deg") {
	Vec3f cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot(v2);

	return math::atan2(len, dot) * (180 / math::PI);
}
<* Normalize provided vector *>
fn Vec3f Vec3f.normalize(self) @export("vector3_normalize") {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Calculate the projection of the vector v1 on to v2 *>
fn Vec3f Vec3f.project(self, Vec3f v2) @export("vector3_project") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length().pow(2);

	float mag = v1dv2 / v2dv2;

	return v2 * mag;
}
<* Calculate the rejection of the vector v1 on to v2 *>
fn Vec3f Vec3f.reject(self, Vec3f v2) @export("vector3_reject") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length().pow(2);

	float mag = v1dv2 / v2dv2;

	return self - (v2 * mag);
}
<* Orthonormalize provided vectors. Makes vectors normalized and orthogonal to each other. Gram-Schmidt function implementation *>
fn void Vec3f.orthonormalize(&self, Vec3f* v2) @export("vector3_orthonormalize") {
	float len;
	float ilen;

	*self = self.normalize();
	Vec3f vn1 = self.cross_product(*v2);

	vn1 = vn1.normalize();
	Vec3f vn2 = vn1.cross_product(*self);

	*v2 = vn2;
}
<* Transform a vector by quaternion rotation *>
fn Vec3f Vec3f.rotate_quaternion(self, Quaternionf q) @export("vector3_rotate_q") {
	Quaternionf normed = q.normalize();
	Quaternionf new = {self.x, self.y, self.z, 1};
	Quaternionf normedNeg = {-normed.i, -normed.j, -normed.k, normed.l};

	return (normed * new * normedNeg).v.xyz;
	//return (normed * new * normedNeg).xyz;
}
<* Returns point rotated at input distance from self
	@param dist
	@param rot
	@return "Point"
 *>
fn Vec3f Vec3f.rotate(self, Vec3f dist, float rot) @export("vector3_rotate") {
	Vec3f position;

	position.x = dist.x * math::cos(rot / (180/(float)math::PI)) - dist.z * math::sin(rot / (180/(float)math::PI));
	position.z = dist.x * math::sin(rot / (180/(float)math::PI)) + dist.z * math::cos(rot / (180/(float)math::PI));

	position.x += self.x;
	position.y  = self.y + dist.y;
	position.z += self.z;

	return position;
}
<* Move Vector towards target *>
fn Vec3f Vec3f.move_towards(self, Vec3f target, float max_distance) @export("vector3_move_towards") {
	Vec3f d = target - self;
	float value = d.length().pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return self + d / dist * max_distance;
}
<* Calculate linear interpolation between two vectors *>
fn Vec3f Vec3f.lerp(self, Vec3f target, float amount) @export("vector3_lerp") {
	return self + amount * (target - self);
}
<* Calculate reflected vector to normal *>
fn Vec3f Vec3f.reflect(self, Vec3f normal) @export("vector3_reflect") {
	float dot = self.dot(normal);

	return self - (2 * normal) * dot;
}
<* Get min value for each pair of components *>
fn Vec3f Vec3f.min(self, Vec3f v2) @export("vector3_min") {
	return {
		math::min(self.x, v2.x),
		math::min(self.y, v2.y),
		math::min(self.z, v2.z),
	};
}
<* Get max value for each pair of components *>
fn Vec3f Vec3f.max(self, Vec3f v2) @export("vector3_max") {
	return {
		math::max(self.x, v2.x),
		math::max(self.y, v2.y),
		math::max(self.z, v2.z),
	};
}
<* Invert the given vector *>
fn Vec3f Vec3f.invert(self) @export("vector3_invert") {
	return {
		1 / self.x,
		1 / self.y,
		1 / self.z,
	};
}
<* Clamp the components of the vector between min and max values specified by the given vectors *>
fn Vec3f Vec3f.clamp(self, Vec3f min, Vec3f max) @export("vector3_clamp") {
	return {
		math::min(max.x, math::max(min.x, self.x)),
		math::min(max.y, math::max(min.y, self.y)),
		math::min(max.z, math::max(min.z, self.z)),
	};
}
<* Clamp the magnitude of the vector between two values *>
fn Vec3f Vec3f.clamp_mag(self, float min, float max) @export("vector3_clamp_mag") {
	Vec3f result = self;

	float len = self.length().pow(2);
	if (len > 0) {
		len = math::sqrt(len);

		float scale;
		if (len < min) { scale = min / len; }
		else if (len > max) { scale = max / len; }
		else { scale = 1; };

		result = self * scale;
	}

	return result;
}
<* Returns true of two floats are within amount of each other *>
fn bool float.close(&self, float f2, float amount) @export("float_close") {
	return *self + amount > f2 && *self - amount < f2;
}
<* Returns true if xyz all are close to v2 *>
fn bool Vec3f.close(&self, Vec3f v2, float amount) @export("vector3_close") {
	return self.x.close(v2.x, amount) &&
				 self.y.close(v2.y, amount) &&
				 self.z.close(v2.z, amount);
}

