
module ennoia::vector;
import std::math;
import std::io;
import ennoia::color;
import ennoia::matrix;


<* Vector2 *>
struct Vector2 {
	float x;
	float y;
}

<* == Overload *>
fn bool Vector2.equals(self, Vector2 rhs) @operator(==) {
	return (self.x == rhs.x && self.y == rhs.y);
}
<* + Overload *>
fn Vector2 Vector2.add(self, Vector2 rhs) @operator(+) {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
	};
}
<* + Overload with float *>
fn Vector2 Vector2.pos_offset(&self, float rhs) @operator_s(+) {
	return {
		self.x + rhs,
		self.y + rhs,
	};
}
<* - Overload *>
fn Vector2 Vector2.sub(self, Vector2 rhs) @operator(-) {
	return {
		self.x - rhs.x,
		self.x - rhs.y,
	};
}
<* - Overload with float *>
fn Vector2 Vector2.neg_offset(&self, float rhs) @operator_s(-) {
	return {
		self.x - rhs,
		self.y - rhs,
	};
}
<* * Overload *>
fn Vector2 Vector2.mul(self, Vector2 rhs) @operator(*) {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
	};
}
<* * Overload with float *>
fn Vector2 Vector2.scale(&self, float rhs) @operator_s(*) {
	return {
		self.x * rhs,
		self.y * rhs,
	};
}
<* / Overload *>
fn Vector2 Vector2.div(self, Vector2 rhs) @operator(/) {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
	};
}
<* / Overload with float *>
fn Vector2 Vector2.inverse(&self, float rhs) @operator_s(/) {
	return {
		self.x / rhs,
		self.y / rhs,
	};
}

<* Converts v2 into v3 *>
fn Vector3 Vector2.v3(self) {
	return {self.x, self.y, 0};
}
<* Converts v2 into v4 *>
fn Vector4 Vector2.v4(self) {
	return {self.x, self.y, 0, 1};
}
<* Converts v2 into Quaternion *>
fn Quaternion Vector2.q(self) {
	return {self.x, self.y, 0, 0};
}

<* Calculate vector length *>
fn float Vector2.length(self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2));
}
<* Calculate vector square length *>
fn float Vector2.length_sqr(self) {
	return self.x.pow(2) + self.y.pow(2);
}
<* Calculate the dot product of two vectors *>
fn float Vector2.dot_product(self, Vector2 v2) {
	return (self.x * v2.x) + (self.y * v2.y);
}
<* Calculate distance between two vectors *>
fn float Vector2.distance(self, Vector2 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector2.distance_sqr(self, Vector2 v2){
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2);
}
<* Calculate angle between two vectors in Radians *>
fn float Vector2.angle_rad(self, Vector2 v2) {
	Vector2 new = v2 - self;
	return math::atan2(new.y, new.x);
}
<* Calculate angle between two vectors in Degrees *>
fn float Vector2.angle_deg(self, Vector2 v2) {
	Vector2 new = v2 - self;
	return math::atan2(new.y, new.x) * (180 / math::PI);
}
<* Normalize provided vector *>
fn Vector2 Vector2.normalize(self) {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Transform a Vector2 by a given Matrix *>
fn Vector2 Vector2.transform(self, Matrix mat) {
	return (self.v4() * mat).v2();
}
<* Calculate linear interpolation between two vectors *>
fn Vector2 Vector2.lerp(self, Vector2 v2, float amount) {
	return self + ((v2 - self) * amount);
}
<* Calculate reflected vector to normal *>
fn Vector2 Vector2.reflect(self, Vector2 normal) {
	return (self - (2*(self * normal)) * normal);
}
<* Rotate vector by radians *>
fn Vector2 Vector2.rotate_rad(self, float angle) {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Rotate vector by degrees *>
fn Vector2 Vector2.rotate_deg(self, float angle) {
	float cosres = math::cos(angle / (180 / (float)math::PI));
	float sinres = math::sin(angle / (180 / (float)math::PI));

	return {
		(self.x * cosres) - (self.y * sinres),
		(self.x * sinres) + (self.y * cosres),
	};
}
<* Move vector towards target *>
fn Vector2 Vector2.move_towards(self, Vector2 target, float max_distance) {
	Vector2 d = target - self;
	float value = d.length_sqr();

	if (value == 0 || (max_distance >= 0 && value <= max_distance.pow(2))) { return target; }
	float dist = self.distance(target);

	return self + ((d / dist) * max_distance);
}
<* Invert given vector *>
fn Vector2 Vector2.invert(self) {
	return {
		1 / self.x,
		1 / self.y,
	};
}
<* Clamp the components of the vector between min and max values specified by the given vectors
	@require min.x < max.x && min.y < max.y
 *>
fn Vector2 Vector2.clamp(self, Vector2 min, Vector2 max) {
	return {
		math::clamp(self.x, min.x, max.x),
		math::clamp(self.y, min.y, max.y),
	};
}
<* Clamp the magnitude of the vector between two min and max values
  @require min < max
 *>
fn Vector2 Vector2.clamp_mag(self, float min, float max) {
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



<* Vector3 *>
struct Vector3 {
	float x;
	float y;
	float z;
}

<* == Overload *>
fn bool Vector3.equals(self, Vector3 rhs) @operator(==) {
	return (self.x == rhs.x && self.y == rhs.y && self.z == rhs.z);
}
<* + Overload *>
fn Vector3 Vector3.add(self, Vector3 rhs) @operator(+) {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.z + rhs.z,
	};
}
<* + Overload with float *>
fn Vector3 Vector3.pos_offset(self, float rhs) @operator_s(+) {
	return {
		self.x + rhs,
		self.y + rhs,
		self.z + rhs,
	};
}
<* - Overload *>
fn Vector3 Vector3.sub(self, Vector3 rhs) @operator(-) {
	return {
		self.x - rhs.x,
		self.y - rhs.y,
		self.z - rhs.z,
	};
}
<* - Overload with float *>
fn Vector3 Vector3.neg_offset(self, float rhs) @operator_s(-) {
	return {
		self.x - rhs,
		self.y - rhs,
		self.z - rhs,
	};
}
<* * Overload *>
fn Vector3 Vector3.mul(self, Vector3 rhs) @operator(*) {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.z * rhs.z,
	};
}
<* * Overload with float *>
fn Vector3 Vector3.scale(self, float rhs) @operator_s(*) {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
	};
}
<* / Overload *>
fn Vector3 Vector3.div(self, Vector3 rhs) @operator(/) {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.z / rhs.z,
	};
}
<* / Overload with float *>
fn Vector3 Vector3.inverse(self, float rhs) @operator_s(/) {
	return {
		self.x / rhs,
		self.y / rhs,
		self.z / rhs,
	};
}

<* Converts v3 into v2 *>
fn Vector2 Vector3.v2(self) {
	return {self.x, self.y};
}
<* Converts v3 into v4 *>
fn Vector4 Vector3.v4(self) {
	return {self.x, self.y, self.z, 1};
}
<* Converts v3 into Quaternion *>
fn Quaternion Vector3.q(self) {
	return {self.x, self.y, self.z, 0};
}
<* Convert Vector3 to allocated float array *>
fn float[3] Vector3.to_array(self) {
	return {self.x, self.y, self.z};
}
<* Convert Vector3 to int array *>
fn int[3] Vector3.to_int_array(self) {
	return {(int)self.x, (int)self.y, (int)self.z};
}

<* Calculate two vectors cross product *>
fn Vector3 Vector3.cross_product(self, Vector3 v2) {
	return {
		self.y * v2.z - self.z * v2.y,
		self.z * v2.x - self.x * v2.z,
		self.x * v2.y - self.y * v2.x,
	};
}
<* Calculate a vector perpendicular to input *>
fn Vector3 Vector3.perpendicular(self) {
	float min = math::abs(self.x);
	Vector3 cardinal_axis = {1, 0, 0};

	if (math::abs(self.y) < min) {
		min = math::abs(self.y);
		cardinal_axis = {0, 1, 0};
	}
	if (math::abs(self.z) < min) {
		cardinal_axis = {0, 1, 0};
	}

	return self.cross_product(cardinal_axis);
}
<* Calculate vector length *>
fn float Vector3.length(self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
<* Calculate vector square length *>
fn float Vector3.length_sqr(self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector3.dot_product(self, Vector3 v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
}
<* Calculate distance between two vectors *>
fn float Vector3.distance(self, Vector3 v2) {
	return (v2 - self).length();
}
<* Calculate square distance between two vectors *>
fn float Vector3.distance_sqr(self, Vector3 v2) {
	return (v2 - self).length_sqr();
}
<* Calculate angle between two vectors in radians *>
fn float Vector3.angle_rad(self, Vector3 v2) {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

  return math::atan2(len, dot);
}
<* Calculate angle between two vectors in degrees *>
fn float Vector3.angle_deg(self, Vector3 v2) {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

	return math::atan2(len, dot) * (180 / math::PI);
}
<* Normalize provided vector *>
fn Vector3 Vector3.normalize(self) {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Calculate the projection of the vector v1 on to v2 *>
fn Vector3 Vector3.project(self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return v2 * mag;
}
<* Calculate the rejection of the vector v1 on to v2 *>
fn Vector3 Vector3.reject(self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return self - (v2 * mag);
}
<* Orthonormalize provided vectors. Makes vectors normalized and orthogonal to each other. Gram-Schmidt function implementation *>
fn void Vector3.orthonormalize(&self, Vector3* v2) {
	float len;
	float ilen;

	*self = self.normalize();
	Vector3 vn1 = self.cross_product(*v2);

	vn1 = vn1.normalize();
	Vector3 vn2 = vn1.cross_product(*self);

	*v2 = vn2;
}
<* Transforms a Vector3 by a given Matrix *>
fn Vector3 Vector3.transform(self, Matrix mat) {
	return (self.v4() * mat).v3();
}
<* Transform a vector by quaternion rotation *>
fn Vector3 Vector3.rotate_quaternion(self, Quaternion q) {
	Quaternion normed = q.normalize();
	Quaternion new = self.q();
	Quaternion normedNeg = {-normed.x, -normed.y, -normed.z, normed.w};

	return (normed * new * normedNeg).v3();
}
<* Returns point rotated at input distance from self
	@param dist
	@param rot
	@return "Point"
 *>
fn Vector3 Vector3.rotate(self, Vector3 dist, float rot) @export("vector3_rotate") {
	Vector3 position;

	position.x = dist.x * (float)math::cos(rot / 57.3) - dist.z * (float)math::sin(rot / 57.3);
	position.z = dist.x * (float)math::sin(rot / 57.3) + dist.z * (float)math::cos(rot / 57.3);

	position.x += self.x;
	position.y  = self.y + dist.y;
	position.z += self.z;

	return position;
}
<* Rotates a vector around an axis Using Euler-Rodrigues Formula *>
fn Vector3 Vector3.rotate_axis(self, Vector3 axis, float angle) @export("vector3_rotateaxis") {
	//* normalize
	float len = axis.length();
	if (len == 0) len = 1;
	float ilen = 1 / len;
	Vector3 new_axis = {
		.x = axis.x * ilen,
		.y = axis.y * ilen,
		.z = axis.z * ilen,
	};
	float new_angle = angle / 2;
	float a = math::sin(new_angle);
	float b = new_axis.x * a;
	float c = new_axis.y * a;
	float d = new_axis.z * a;
	a = math::cos(angle);
	Vector3 w = {.x = b, .y = c, .z = d };

	//* Cross product
	Vector3 wv = w.cross_product(self);
	Vector3 wwv = w.cross_product(wv);

	//* Scale
	a *= 2;
	wv = {
		.x = wv.x * a,
		.y = wv.y * a,
		.z = wv.z * a,
	};
	wv = {
		.x = wv.x * 2,
		.y = wv.y * 2,
		.z = wv.z * 2,
	};

	return {
		.x = self.x + wv.x + wwv.x,
		.y = self.y + wv.y + wwv.y,
		.z = self.z + wv.z + wwv.z,
	};
}
<* Move Vector towards target *>
fn Vector3 Vector3.move_towards(self, Vector3 target, float max_distance) @export("vector3_movetowards") {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector3 Vector3.lerp(self, Vector3 target, float amount) @export("vector3_lerp") {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
	};
}
<* Calculate reflected vector to normal *>
fn Vector3 Vector3.reflect(self, Vector3 normal) @export("vector3_reflect") {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2.0 * normal.x) * dot,
		.y = self.y - (2.0 * normal.y) * dot,
		.z = self.z - (2.0 * normal.z) * dot,
	};
}
<* Get min value for each pair of components *>
fn Vector3 Vector3.min(self, Vector3 v2) @export("vector3_min") {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
	};
}
<* Get max value for each pair of components *>
fn Vector3 Vector3.max(self, Vector3 v2) @export("vector3_max") {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
	};
}
<* Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c) *>
fn Vector3 Vector3.barycenter(self, Vector3 a, Vector3 b, Vector3 c) @export("vector3_barycenter") {
	Vector3 v0 = {
		.x = b.x - a.x,
		.y = b.y - a.y,
		.z = b.z - a.z,
	};
	Vector3 v1 = {
		.x = c.x - a.x,
		.y = c.y - a.y,
		.z = c.z - a.z,
	};
	Vector3 v2 = {
		.x = self.x - a.x,
		.y = self.y - a.y,
		.z = self.z - a.z,
	};
	float d00 = v0.dot_product(v0);
	float d01 = v0.dot_product(v1);
	float d11 = v1.dot_product(v1);
	float d20 = v2.dot_product(v0);
	float d21 = v2.dot_product(v1);

	float denom = d00 * d11 - d01.pow(2);

	float z = (d00 * d21 - d01 * d20) / denom;
	float y = (d11 * d20 - d01 * d21) / denom;

	return {
		.x = 1.0 - (double)(z + y),
		.y = y,
		.z = z,
	};
}
<* Projects a Vector3 from screen space into object space *>
fn Vector3 Vector3.unproject(self, Matrix projection, Matrix view) @export("vector3_unproject") {
	//* Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
	Matrix mat_view_proj = {
		.m0  = view.m0  * projection.m0 + view.m1  * projection.m4 + view.m2  * projection.m8  + view.m3  * projection.m12,
		.m1  = view.m0  * projection.m1 + view.m1  * projection.m5 + view.m2  * projection.m9  + view.m3  * projection.m13,
		.m2  = view.m0  * projection.m2 + view.m1  * projection.m6 + view.m2  * projection.m10 + view.m3  * projection.m14,
		.m3  = view.m0  * projection.m3 + view.m1  * projection.m7 + view.m2  * projection.m11 + view.m3  * projection.m15,
		.m4  = view.m4  * projection.m0 + view.m5  * projection.m4 + view.m6  * projection.m8  + view.m7  * projection.m12,
		.m5  = view.m4  * projection.m1 + view.m5  * projection.m5 + view.m6  * projection.m9  + view.m7  * projection.m13,
		.m6  = view.m4  * projection.m2 + view.m5  * projection.m6 + view.m6  * projection.m10 + view.m7  * projection.m14,
		.m7  = view.m4  * projection.m3 + view.m5  * projection.m7 + view.m6  * projection.m11 + view.m7  * projection.m15,
		.m8  = view.m8  * projection.m0 + view.m9  * projection.m4 + view.m10 * projection.m8  + view.m11 * projection.m12,
		.m9  = view.m8  * projection.m1 + view.m9  * projection.m5 + view.m10 * projection.m9  + view.m11 * projection.m13,
		.m10 = view.m8  * projection.m2 + view.m9  * projection.m6 + view.m10 * projection.m10 + view.m11 * projection.m14,
		.m11 = view.m8  * projection.m3 + view.m9  * projection.m7 + view.m10 * projection.m11 + view.m11 * projection.m15,
		.m12 = view.m12 * projection.m0 + view.m13 * projection.m4 + view.m14 * projection.m8  + view.m15 * projection.m12,
		.m13 = view.m12 * projection.m1 + view.m13 * projection.m5 + view.m14 * projection.m9  + view.m15 * projection.m13,
		.m14 = view.m12 * projection.m2 + view.m13 * projection.m6 + view.m14 * projection.m10 + view.m15 * projection.m14,
		.m15 = view.m12 * projection.m3 + view.m13 * projection.m7 + view.m14 * projection.m11 + view.m15 * projection.m1,
	};

	//* Calculate inverted matrix -> MatrixInvert(matViewProj)
	float b00 = mat_view_proj.m0  * mat_view_proj.m5  - mat_view_proj.m1  * mat_view_proj.m4;
	float b01 = mat_view_proj.m0  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m4;
	float b02 = mat_view_proj.m0  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m4;
	float b03 = mat_view_proj.m1  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m5;
	float b04 = mat_view_proj.m1  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m5;
	float b05 = mat_view_proj.m2  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m6;
	float b06 = mat_view_proj.m8  * mat_view_proj.m13 - mat_view_proj.m9  * mat_view_proj.m12;
	float b07 = mat_view_proj.m8  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m12;
	float b08 = mat_view_proj.m8  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m12;
	float b09 = mat_view_proj.m9  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m13;
	float b10 = mat_view_proj.m9  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m13;
	float b11 = mat_view_proj.m10 * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m14;

	//* Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / ((b00 * b11) - (b01 * b10) + (b02 * b09) + (b03 * b08) - (b04 * b07) + (b05 * b06));

	Matrix mat_view_proj_inv = {
		.m0  = (( mat_view_proj.m5  * b11) - (mat_view_proj.m6  * b10) + (mat_view_proj.m7  * b09)) * inv_det,
		.m1  = ((-mat_view_proj.m1  * b11) - (mat_view_proj.m2  * b10) + (mat_view_proj.m3  * b09)) * inv_det,
		.m2  = (( mat_view_proj.m13 * b05) - (mat_view_proj.m14 * b04) + (mat_view_proj.m15 * b03)) * inv_det,
		.m3  = ((-mat_view_proj.m9  * b05) + (mat_view_proj.m10 * b04) - (mat_view_proj.m11 * b03)) * inv_det,
		.m4  = ((-mat_view_proj.m4  * b11) + (mat_view_proj.m6  * b08) - (mat_view_proj.m7  * b07)) * inv_det,
		.m5  = (( mat_view_proj.m0  * b11) - (mat_view_proj.m2  * b08) + (mat_view_proj.m3  * b07)) * inv_det,
		.m6  = ((-mat_view_proj.m12 * b05) + (mat_view_proj.m14 * b02) - (mat_view_proj.m15 * b01)) * inv_det,
		.m7  = (( mat_view_proj.m8  * b05) - (mat_view_proj.m10 * b02) + (mat_view_proj.m11 * b01)) * inv_det,
		.m8  = (( mat_view_proj.m4  * b10) - (mat_view_proj.m5  * b08) + (mat_view_proj.m7  * b06)) * inv_det,
		.m9  = ((-mat_view_proj.m0  * b10) + (mat_view_proj.m1  * b08) - (mat_view_proj.m3  * b06)) * inv_det,
		.m10 = (( mat_view_proj.m12 * b04) - (mat_view_proj.m13 * b02) + (mat_view_proj.m15 * b00)) * inv_det,
		.m11 = ((-mat_view_proj.m8  * b04) + (mat_view_proj.m9  * b02) - (mat_view_proj.m11 * b00)) * inv_det,
		.m12 = ((-mat_view_proj.m4  * b09) + (mat_view_proj.m5  * b07) - (mat_view_proj.m6  * b06)) * inv_det,
		.m13 = (( mat_view_proj.m0  * b09) - (mat_view_proj.m1  * b07) + (mat_view_proj.m2  * b06)) * inv_det,
		.m14 = ((-mat_view_proj.m12 * b03) + (mat_view_proj.m13 * b01) - (mat_view_proj.m14 * b00)) * inv_det,
		.m15 = (( mat_view_proj.m8  * b03) - (mat_view_proj.m9  * b01) + (mat_view_proj.m10 * b00)) * inv_det,
	};

	//* Create quaternion from source point
	Quaternion quat = { .x = self.x, .y = self.y, .z = self.z, .w = 1 };

	//* Multiply quat point by unprojected matrix
	Vector4 q_tranformed = mat_view_proj_inv.quaternion_transform(quat);

	//* Normalized world points in vectors
	return {
		.x = q_tranformed.x / q_tranformed.w,
		.y = q_tranformed.y / q_tranformed.w,
		.z = q_tranformed.z / q_tranformed.w,
	};
}
<* Invert the given vector *>
fn Vector3 Vector3.invert(self) @export("vector3_invert") {
	return {.x = 1 / self.x, .y = 1 / self.y, .z = 1 / self.z };
}
<* Clamp the components of the vector between min and max values specified by the given vectors *>
fn Vector3 Vector3.clamp(self, Vector3 min, Vector3 max) @export("vector3_clamp") {
	return {
		.x = math::min(max.x, math::max(min.x, self.x)),
		.y = math::min(max.y, math::max(min.y, self.y)),
		.z = math::min(max.z, math::max(min.z, self.z)),
	};
}
<* Clamp the magnitude of the vector between two values *>
fn Vector3 Vector3.clamp_value(self, float min, float max) @export("vector3_clampvalue") {
	Vector3 result = self;

	float len = self.length_sqr();
	if (len > 0) {
		len = math::sqrt(len);

		float scale;
		if (len < min) { scale = min / len; }
		else if (len > max) { scale = max / len; }
		else { scale = 1; };

		result = {
			.x = self.x * scale,
			.y = self.y * scale,
			.z = self.z * scale,
		};
	}

	return {
		.x = result.x,
		.y = result.y,
		.z = result.z,
	};
}
<* Compute the direction of a refracted ray *>
fn Vector3 Vector3.refract(Vector3 v, Vector3 n, float r) @export("vector3_refract") {
	Vector3 result = {};

	float dot = v.dot_product(n);
	float d = 1 - r.pow(2) * (1 - dot.pow(2));

	if (d >= 0) {
		d = math::sqrt(d);

		result = {
			.x = r * v.x - (r * dot + d) * n.x,
			.y = r * v.y - (r * dot + d) * n.y,
			.z = r * v.z - (r * dot + d) * n.z,
		};
	}

	return result;
}
<* Converts input HSV into  it's equivalent color *>
fn Color Vector3.to_color(self) @export("vector3_tocolor") {
	Color result = {
		.r = 0,
		.g = 0,
		.b = 0,
		.a = 255,
	};

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
<* Returns true of two floats are within amount of each other *>
fn bool float.close(&self, float f2, float amount) {
	return *self + amount > f2 && *self - amount < f2;
}
<* Returns true if xyz all are close to v2 *>
fn bool Vector3.close(&self, Vector3 v2, float amount) {
	return self.x.close(v2.x, amount) &&
				 self.y.close(v2.y, amount) &&
				 self.z.close(v2.z, amount);
}
<* Prints vector3 *>
fn void Vector3.print(self) @export("vector3_print") {
	io::printfn("[%f,%f,%f]", self.x, self.y, self.z);
}



<* Vector4 *>
struct Vector4 {
	float x, y, z, w;
}
<* Equals *>
fn bool Vector4.equals(self, Vector4 rhs) @operator(==) @export("vector4_equals") {
	return (self.x == rhs.x && self.y == rhs.y && self.z == rhs.z && self.w == rhs.w);
}
<* Addition *>
fn Vector4 Vector4.add(self, Vector4 rhs) @operator(+) @export("vector4_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.z + rhs.z,
		self.w + rhs.w,
	};
}
<* Subtraction *>
fn Vector4 Vector4.sub(self, Vector4 rhs) @operator(-) @export("vector4_sub") {
	return {
		self.x - rhs.x,
		self.y - rhs.y,
		self.z - rhs.z,
		self.w - rhs.w,
	};
}
<* Multiplication *>
fn Vector4 Vector4.mul(self, Vector4 rhs) @operator(*) @export("vector4_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.z * rhs.z,
		self.w * rhs.w,
	};
}
<* * Overload with Matrix *>
fn Vector4 Vector4.mul_mat(self, Matrix rhs) @operator_s(*) {
	return {
		(rhs.m0  * self.x) + (rhs.m1  * self.y) + (rhs.m2  * self.z) + (rhs.m3  * self.w),
		(rhs.m4  * self.x) + (rhs.m5  * self.y) + (rhs.m6  * self.z) + (rhs.m7  * self.w),
		(rhs.m8  * self.x) + (rhs.m9  * self.y) + (rhs.m10 * self.z) + (rhs.m11 * self.w),
		(rhs.m12 * self.x) + (rhs.m13 * self.y) + (rhs.m14 * self.z) + (rhs.m15 * self.w),
	};
}
<* Division *>
fn Vector4 Vector4.div(self, Vector4 rhs) @operator(/) @export("vector4_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.z / rhs.z,
		self.w / rhs.w,
	};
}
<* Add and assign *>
fn void Vector4.add_assign(&self, Vector4 rhs) @operator(+=) @export("vector4_addassign") {
	self.x += rhs.x;
	self.y += rhs.y;
	self.z += rhs.z;
	self.w += rhs.w;
}
<* Subtract and assign *>
fn void Vector4.sub_assign(&self, Vector4 rhs) @operator(-=) @export("vector4_subassign") {
	self.x -= rhs.x;
	self.y -= rhs.y;
	self.z -= rhs.z;
	self.w -= rhs.w;
}
<* Multiply and assign *>
fn void Vector4.mul_assign(&self, Vector4 rhs) @operator(*=) @export("vector4_mulassign") {
	self.x *= rhs.x;
	self.y *= rhs.y;
	self.z *= rhs.z;
	self.w *= rhs.w;
}
<* Divide and assign *>
fn void Vector4.div_assign(&self, Vector4 rhs) @operator(/=) @export("vector4_divassign") {
	self.x /= rhs.x;
	self.y /= rhs.y;
	self.z /= rhs.z;
	self.w /= rhs.w;
}
<* Add to with float *>
fn Vector4 Vector4.pos_offset(self, float rhs) @operator_s(+) @export("vector4_posoffset") {
	return {
		self.x + rhs,
		self.y + rhs,
		self.z + rhs,
		self.w + rhs,
	};
}
<* Subtract from with float *>
fn Vector4 Vector4.neg_offset(self, float rhs) @operator_s(-) @export("vector4_negoffset") {
	return {
		self.x - rhs,
		self.y - rhs,
		self.z - rhs,
		self.w - rhs,
	};
}
<* Multiply by float *>
fn Vector4 Vector4.scale(self, float rhs) @operator_s(*) @export("vector4_scale") {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
		self.w * rhs,
	};
}
<* Divide by float *>
fn Vector4 Vector4.inverse(self, float rhs) @operator_s(/) @export("vector4_inverse") {
	return {
		self.x / rhs,
		self.y / rhs,
		self.z / rhs,
		self.w / rhs,
	};
}

<* Converts v4 into v2 *>
fn Vector2 Vector4.v2(&self) {
	return {self.x, self.y};
}
<* Converts v4 into v3 *>
fn Vector3 Vector4.v3(&self) {
	return {self.x, self.y, self.z};
}
<* Converts v4 into Quaternion *>
fn Quaternion Vector4.q(self) {
	return {self.x, self.y, self.z, self.w};
}

<* Calculate vector length *>
fn float Vector4.length(self) @export("vector4_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
<* Calculate vector square length *>
fn float Vector4.length_sqr(self) @export("vector4_lengthsqr") {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector4.dot_product(self, Vector4 v2) @export("vector4_dotproduct") {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
<* Calculate distance between two vectors *>
fn float Vector4.distance(self, Vector4 v2) @export("vector4_distance") {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector4.distance_sqr(self, Vector4 v2) @export("vector4_distancesqr") {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2);
}
<* Normalize provided vector *>
fn Vector4 Vector4.normalize(self) @export("vector4_normalize") {
	Vector4 result = {};

	float len = self.length();
	if (len > 0) {
		float ilen = 1 / len;
		result = {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
			.w = self.w * ilen,
		};
	}

	return result;
}
<* Get min value for each pair of components *>
fn Vector4 Vector4.min(self, Vector4 v2) @export("vector4_min") {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
		.w = math::min(self.w, v2.w),
	};
}
<* Get max value for each pair of components *>
fn Vector4 Vector4.max(self, Vector4 v2) @export("vector4_max") {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
		.w = math::max(self.w, v2.w),
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector4 Vector4.lerp(self, Vector4 target, float amount) @export("vector4_lerp") {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
<* Move Vector towards target *>
fn Vector4 Vector4.move_towards(self, Vector4 target, float max_distance) @export("vector4_movetowards") {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float dw = target.w - self.w;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2) + dw.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
		.w = self.w + dw / dist * max_distance,
	};
}
<* Invert the given vector *>
fn Vector4 Vector4.invert(self) @export("vector4_invert") {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
<* Converts normaized Vector4 into a color. *>
fn Color Vector4.to_color(self) @export("vector4_tocolor") {
	return {
		.r = (char)(self.x * 255),
		.g = (char)(self.y * 255),
		.b = (char)(self.z * 255),
		.a = (char)(self.w * 255),
	};
}



const float EPSILON = 1.1920929E-7;

<* Quaternion *>
struct Quaternion {
	float x, y, z, w;
}

<* Axis and Angle tuple *>
struct AxisAngle {
	Vector3 axis;
	float angle;
}

<* == Overload *>
fn bool Quaternion.equals(self, Quaternion rhs) @operator(==) {
	return (self.x == rhs.x) && (self.y == rhs.y) && (self.z == rhs.z) && (self.w == rhs.w);
}
<* * Overload *>
fn Quaternion Quaternion.mul(self, Quaternion rhs) @operator(*) {
	return {
		(self.w * rhs.x) + (self.x * rhs.w) + (self.y * rhs.z) - (self.z * rhs.y),
		(self.w * rhs.y) - (self.x * rhs.z) + (self.y * rhs.w) + (self.z * rhs.x),
		(self.w * rhs.z) + (self.x * rhs.y) - (self.y * rhs.x) + (self.z * rhs.w),
		(self.w * rhs.w) - (self.x * rhs.x) - (self.y * rhs.y) - (self.z * rhs.z),
	};
}
<* * Overload with float *>
fn Quaternion Quaternion.mul_f(self, float rhs) @operator_s(*) {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
		self.w * rhs,
	};
}

<* Converts quaternion into v2 *>
fn Vector2 Quaternion.v2(self) {
	return {self.x, self.y};
}
<* Converts quaternion into v2 *>
fn Vector3 Quaternion.v3(self) {
	return {self.x, self.y, self.z};
}
<* Converts quaternion into v4 *>
fn Vector4 Quaternion.v4(self) {
	return {self.x, self.y, self.z, self.w};
}

<* Calculate vector length *>
fn float Quaternion.length(self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
<* Calculate vector length squared *>
fn float Quaternion.length_sqr(self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
<* Calculate two vectors dot product *>
fn float Quaternion.dot_product(self, Quaternion v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
<* Normalize provided vector *>
fn Quaternion Quaternion.normalize(self) {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Calculate slerp-optimized interpolation between two quaternions *>
fn Quaternion Quaternion.n_lerp(self, Quaternion target, float amount) @export("quaternion_nlerp") {
	Quaternion result = {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};

	float len = result.length();
	if (len == 0) { len = 1; };
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
<* Calculates spherical linear interpolation between two quaternions *>
fn Quaternion Quaternion.slerp(self, Quaternion target, float amount) @export("quaternion_slerp") {
	Quaternion result;

	float cos_half_theta = self.dot_product(target);
	Quaternion new_target = target;
	if (cos_half_theta < 0) {
		new_target.x = -target.x;
		new_target.y = -target.y;
		new_target.z = -target.z;
		new_target.w = -target.w;
		cos_half_theta = -cos_half_theta;
	}

	if (math::abs(cos_half_theta) >= 1) { result = self; }
	else if (cos_half_theta > 0.95) { result = self.n_lerp(target, amount); }
	else {
		float half_theta = math::acos(cos_half_theta);
		float sin_half_theta = math::sqrt(1 - cos_half_theta.pow(2));

		if (math::abs(sin_half_theta) < math::E) {
			result = {
				.x = (self.x * 0.5 + target.x * 0.5),
				.y = (self.y * 0.5 + target.y * 0.5),
				.z = (self.z * 0.5 + target.z * 0.5),
				.w = (self.w * 0.5 + target.w * 0.5),
			};
		} else {
			float ratio_a = math::sin((1 - amount) * half_theta) / sin_half_theta;
			float ratio_b = math::sin(amount * half_theta) / sin_half_theta;

			result = {
				.x = (self.x * ratio_a + target.x * ratio_b),
				.y = (self.y * ratio_a + target.y * ratio_b),
				.z = (self.z * ratio_a + target.z * ratio_b),
				.w = (self.w * ratio_a + target.w * ratio_b),
			};
		}
	}

	return result;
}
<* Get the rotation angle and axis for a given quaternion *>
fn AxisAngle Quaternion.to_axis_angle(self) @export("quaternion_toaxisangle") {
	Quaternion new_quat = self;

	if (math::abs(self.w) > 1) {
		float len = self.length();
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		new_quat.x = self.x * ilen;
		new_quat.y = self.y * ilen;
		new_quat.z = self.z * ilen;
		new_quat.w = self.w * ilen;
	}

	Vector3 res_axis = {};
	float res_angle = 2 * math::acos(self.w);
	float den = (1 - math::sqrt(self.w.pow(2)));

	if (den > EPSILON) {
		res_axis.x = self.x / den;
		res_axis.y = self.y / den;
		res_axis.z = self.z / den;
	} else {
		res_axis.x = 1.0;
	}

	return { .axis = res_axis, .angle = res_angle };
}
<* Get the Euler angles equivalent to quaternion (roll, pitch, yaw) *>
fn Vector3 Quaternion.to_euler(self) @export("quaternion_toeuler") {
	float pitch;
	float yaw;
	float roll;

	//* Roll
	float x0 = 2 * (self.w * self.x + self.y * self.z);
	float x1 = 1 - (2 * (self.x.pow(2) + self.y.pow(2)));
	roll = math::atan2(x0, x1);

	//* Pitch
	float y0 = 2 * (self.w * self.y - self.z * self.x);
	if (y0 >  1) { y0 =  1; }
	if (y0 < -1) { y0 = -1; }
	pitch = math::asin(y0);

	//* Yaw
	float z0 = 2 * (self.w * self.z + self.x * self.y);
	float z1 = 1 - 2 * (self.y.pow(2) + self.z.pow(2));
	yaw = math::atan2(z0, z1);

	return { .x = pitch, .y = yaw, .z = roll };
}
<* Transform a quaternion given a transformation matrix *>
fn Quaternion Quaternion.transform(self, Matrix mat) @export("quaternion_transform") {
	return {
		.x = mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12 * self.w,
		.y = mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13 * self.w,
		.z = mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14 * self.w,
		.w = mat.m3 * self.x + mat.m7 * self.y + mat.m11 * self.z + mat.m15 * self.w,
	};
}

<* Calculate quaternion based on the rotation from one vector to another *>
fn Quaternion from_v3_to_v3(Vector3 from, Vector3 to) @export("quaternion_fromv3tov3") {
	Quaternion result;

	float cos2_theta = from.dot_product(to);
	Vector3 cross = from.cross_product(to);

	result = {
		.x = cross.x,
		.y = cross.y,
		.z = cross.z,
		.w = 1 + cos2_theta,
	};

	float len = result.length();
	if (len == 0) { len = 1; }
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
<* Get rotation quaternion for an angle and axis *>
fn Quaternion from_axis_angle(Vector3 axis, float angle) @export("quaternion_fromaxisangle") {
	Quaternion result;

	float axis_len = axis.length();

	if (axis_len != 0) {
		float new_angle = angle * 0.5;

		float len = axis_len;
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		Vector3 new_axis = {
			.x = axis.x * ilen,
			.y = axis.y * ilen,
			.z = axis.z * ilen,
		};

		float sinres = math::sin(new_angle);
		float cosres = math::cos(new_angle);

		result.x = new_axis.x * sinres;
		result.y = new_axis.y * sinres;
		result.z = new_axis.z * sinres;
		result.w = cosres;

		len = result.length();
		if (len == 0) { len = 1; }
		ilen = 1 / len;

		result.x = result.x * ilen;
		result.y = result.y * ilen;
		result.z = result.z * ilen;
		result.w = result.w * ilen;
	}

	return result;
}
<* Get the quaternion equivalent to Euler angles *>
fn Quaternion from_euler(float pitch, float yaw, float roll) @export("quaternion_fromeuler") {
	Quaternion result;

	float x0 = math::cos((float)(pitch * 0.5));
	float x1 = math::sin((float)(pitch * 0.5));
	float y0 = math::cos((float)(yaw   * 0.5));
	float y1 = math::sin((float)(yaw   * 0.5));
	float z0 = math::cos((float)(roll  * 0.5));
	float z1 = math::sin((float)(roll  * 0.5));

	result.x = x1 * y0 * z0 - x0 * y1 * z1;
	result.y = x0 * y1 * z0 - x1 * y0 * z1;
	result.z = x0 * y0 * z1 - x1 * y1 * z0;
	result.w = x0 * y0 * z0 - x1 * y1 * z1;

	return result;
}


