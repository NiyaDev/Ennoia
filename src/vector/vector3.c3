
module ennoia::vector;
import std::io;
import std::math;
import ennoia::matrix;
import ennoia::color;


struct Vector3 {
  float x, y, z;
}


<* == Overload *>
fn bool Vector3.equals(self, Vector3 rhs) @operator(==) @export("vector3_equals") {
	return (self.x == rhs.x && self.y == rhs.y && self.z == rhs.z);
}
<* + Overload *>
fn Vector3 Vector3.add(self, Vector3 rhs) @operator(+) @export("vector3_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.z + rhs.z,
	};
}
<* + Overload with float *>
fn Vector3 Vector3.pos_offset(self, float rhs) @operator_s(+) @export("vector3_pos_offset") {
	return {
		self.x + rhs,
		self.y + rhs,
		self.z + rhs,
	};
}
<* - Overload *>
fn Vector3 Vector3.sub(self, Vector3 rhs) @operator(-) @export("vector3_sub") {
	return {
		self.x - rhs.x,
		self.y - rhs.y,
		self.z - rhs.z,
	};
}
<* - Overload with float *>
fn Vector3 Vector3.neg_offset(self, float rhs) @operator_s(-) @export("vector3_neg_offset") {
	return {
		self.x - rhs,
		self.y - rhs,
		self.z - rhs,
	};
}
<* * Overload *>
fn Vector3 Vector3.mul(self, Vector3 rhs) @operator(*) @export("vector3_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.z * rhs.z,
	};
}
<* * Overload with float *>
fn Vector3 Vector3.scale(self, float rhs) @operator_s(*) @export("vector3_scale") {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
	};
}
<* / Overload *>
fn Vector3 Vector3.div(self, Vector3 rhs) @operator(/) @export("vector3_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.z / rhs.z,
	};
}
<* / Overload with float *>
fn Vector3 Vector3.inverse(self, float rhs) @operator_s(/) @export("vector3_inverse") {
	return {
		self.x / rhs,
		self.y / rhs,
		self.z / rhs,
	};
}
<* % Overload *>
fn Vector3 Vector3.remainder(self, int rhs) @operator(%) @export("vector3_remainder") {
	return {
		(float)((int)self.x % rhs),
		(float)((int)self.y % rhs),
		(float)((int)self.z % rhs),
	};
}

<* Converts v3 into v2 *>
fn Vector2 Vector3.v2(self) @export("vector3_v2") {
	return {self.x, self.y};
}
<* Converts v3 into v4 *>
fn Vector4 Vector3.v4(self) @export("vector3_v4") {
	return {self.x, self.y, self.z, 1};
}
<* Converts v3 into Quaternion *>
fn Quaternion Vector3.q(self) @export("vector3_q") {
	return {self.x, self.y, self.z, 0};
}
<* Convert Vector3 to allocated float array *>
fn float[3] Vector3.to_array(self) @export("vector3_farr") {
	return {self.x, self.y, self.z};
}
<* Convert Vector3 to int array *>
fn int[3] Vector3.to_int_array(self) @export("vector3_iarr") {
	return {(int)self.x, (int)self.y, (int)self.z};
}
<* Convert from int array to Vector3 *>
fn Vector3 int[3].from_int_array(self) @export("intarray_v3") {
	return {(float)self[0], (float)self[1], (float)self[2]};
}
<* Converts input HSV into  it's equivalent color *>
fn Color Vector3.color(self) @export("vector3_color") {
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
fn Vector3 Vector3.cross_product(self, Vector3 v2) @export("vector3_cross_product") {
	return {
		self.y * v2.z - self.z * v2.y,
		self.z * v2.x - self.x * v2.z,
		self.x * v2.y - self.y * v2.x,
	};
}
<* Calculate a vector perpendicular to input *>
fn Vector3 Vector3.perpendicular(self) @export("vector3_perpendicular") {
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
fn float Vector3.length(self) @export("vector3_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
<* Calculate vector square length *>
fn float Vector3.length_sqr(self) @export("vector3_legnth_sqr") {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector3.dot_product(self, Vector3 v2) @export("vector3_dot_product") {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
}
<* Calculate distance between two vectors *>
fn float Vector3.distance(self, Vector3 v2) @export("vector3_distance") {
	return (v2 - self).length();
}
<* Calculate square distance between two vectors *>
fn float Vector3.distance_sqr(self, Vector3 v2) @export("vector3_distance_sqr") {
	return (v2 - self).length_sqr();
}
<* Calculate angle between two vectors in radians *>
fn float Vector3.angle_rad(self, Vector3 v2) @export("vector3_angle_rad") {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

  return math::atan2(len, dot);
}
<* Calculate angle between two vectors in degrees *>
fn float Vector3.angle_deg(self, Vector3 v2) @export("vector3_angle_deg") {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

	return math::atan2(len, dot) * (180 / math::PI);
}
<* Normalize provided vector *>
fn Vector3 Vector3.normalize(self) @export("vector3_normalize") {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return self * ilength;
	}

	return self;
}
<* Calculate the projection of the vector v1 on to v2 *>
fn Vector3 Vector3.project(self, Vector3 v2) @export("vector3_project") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return v2 * mag;
}
<* Calculate the rejection of the vector v1 on to v2 *>
fn Vector3 Vector3.reject(self, Vector3 v2) @export("vector3_reject") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return self - (v2 * mag);
}
<* Orthonormalize provided vectors. Makes vectors normalized and orthogonal to each other. Gram-Schmidt function implementation *>
fn void Vector3.orthonormalize(&self, Vector3* v2) @export("vector3_orthonormalize") {
	float len;
	float ilen;

	*self = self.normalize();
	Vector3 vn1 = self.cross_product(*v2);

	vn1 = vn1.normalize();
	Vector3 vn2 = vn1.cross_product(*self);

	*v2 = vn2;
}
<* Transforms a Vector3 by a given Matrix *>
fn Vector3 Vector3.transform(self, Matrix mat) @export("vector3_transform") {
	return (self.v4() * mat).v3();
}
<* Transform a vector by quaternion rotation *>
fn Vector3 Vector3.rotate_quaternion(self, Quaternion q) @export("vector3_rotate_q") {
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

	position.x = dist.x * math::cos(rot / (180/(float)math::PI)) - dist.z * math::sin(rot / (180/(float)math::PI));
	position.z = dist.x * math::sin(rot / (180/(float)math::PI)) + dist.z * math::cos(rot / (180/(float)math::PI));

	position.x += self.x;
	position.y  = self.y + dist.y;
	position.z += self.z;

	return position;
}
<* Rotates a vector around an axis Using Euler-Rodrigues Formula *>
fn Vector3 Vector3.rotate_axis(self, Vector3 axis, float angle) @export("vector3_rotate_axis") {
	Vector3 newAxis = axis.normalize();

	float a = math::sin(angle / 2);
	newAxis *= a;
	a = math::cos(angle);

	//* Cross product
	Vector3 wv  = newAxis.cross_product(self);
	Vector3 wwv = newAxis.cross_product(wv);

	//* Scale
	a *= 2;
	wv *= a;
	wv *= 2;

	return self + wv + wwv;
}
<* Move Vector towards target *>
fn Vector3 Vector3.move_towards(self, Vector3 target, float max_distance) @export("vector3_move_towards") {
	Vector3 d = target - self;
	float value = d.length_sqr();

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return self + d / dist * max_distance;
}
<* Calculate linear interpolation between two vectors *>
fn Vector3 Vector3.lerp(self, Vector3 target, float amount) @export("vector3_lerp") {
	return self + amount * (target - self);
}
<* Calculate reflected vector to normal *>
fn Vector3 Vector3.reflect(self, Vector3 normal) @export("vector3_reflect") {
	float dot = self.dot_product(normal);

	return self - (2 * normal) * dot;
}
<* Get min value for each pair of components *>
fn Vector3 Vector3.min(self, Vector3 v2) @export("vector3_min") {
	return {
		math::min(self.x, v2.x),
		math::min(self.y, v2.y),
		math::min(self.z, v2.z),
	};
}
<* Get max value for each pair of components *>
fn Vector3 Vector3.max(self, Vector3 v2) @export("vector3_max") {
	return {
		math::max(self.x, v2.x),
		math::max(self.y, v2.y),
		math::max(self.z, v2.z),
	};
}
<* Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c) *>
fn Vector3 Vector3.barycenter(self, Vector3 a, Vector3 b, Vector3 c) @export("vector3_barycenter") {
	Vector3 v0 = b - a;
	Vector3 v1 = c - a;
	Vector3 v2 = self - a;

	float d00 = v0.dot_product(v0);
	float d01 = v0.dot_product(v1);
	float d11 = v1.dot_product(v1);
	float d20 = v2.dot_product(v0);
	float d21 = v2.dot_product(v1);

	float denom = d00 * d11 - d01.pow(2);

	float z = (d00 * d21 - d01 * d20) / denom;
	float y = (d11 * d20 - d01 * d21) / denom;

	return {
		1.0 - (double)(z + y),
		y,
		z,
	};
}
<* Projects a Vector3 from screen space into object space *>
fn Vector3 Vector3.unproject(self, Matrix projection, Matrix view) @export("vector3_unproject") {
	// Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
	Matrix mat_view_proj = {
		view.m0  * projection.m0 + view.m1  * projection.m4 + view.m2  * projection.m8  + view.m3  * projection.m12,
		view.m0  * projection.m1 + view.m1  * projection.m5 + view.m2  * projection.m9  + view.m3  * projection.m13,
		view.m0  * projection.m2 + view.m1  * projection.m6 + view.m2  * projection.m10 + view.m3  * projection.m14,
		view.m0  * projection.m3 + view.m1  * projection.m7 + view.m2  * projection.m11 + view.m3  * projection.m15,
		view.m4  * projection.m0 + view.m5  * projection.m4 + view.m6  * projection.m8  + view.m7  * projection.m12,
		view.m4  * projection.m1 + view.m5  * projection.m5 + view.m6  * projection.m9  + view.m7  * projection.m13,
		view.m4  * projection.m2 + view.m5  * projection.m6 + view.m6  * projection.m10 + view.m7  * projection.m14,
		view.m4  * projection.m3 + view.m5  * projection.m7 + view.m6  * projection.m11 + view.m7  * projection.m15,
		view.m8  * projection.m0 + view.m9  * projection.m4 + view.m10 * projection.m8  + view.m11 * projection.m12,
		view.m8  * projection.m1 + view.m9  * projection.m5 + view.m10 * projection.m9  + view.m11 * projection.m13,
		view.m8  * projection.m2 + view.m9  * projection.m6 + view.m10 * projection.m10 + view.m11 * projection.m14,
		view.m8  * projection.m3 + view.m9  * projection.m7 + view.m10 * projection.m11 + view.m11 * projection.m15,
		view.m12 * projection.m0 + view.m13 * projection.m4 + view.m14 * projection.m8  + view.m15 * projection.m12,
		view.m12 * projection.m1 + view.m13 * projection.m5 + view.m14 * projection.m9  + view.m15 * projection.m13,
		view.m12 * projection.m2 + view.m13 * projection.m6 + view.m14 * projection.m10 + view.m15 * projection.m14,
		view.m12 * projection.m3 + view.m13 * projection.m7 + view.m14 * projection.m11 + view.m15 * projection.m1,
	};

	// Calculate inverted matrix -> MatrixInvert(matViewProj)
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

	// Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / ((b00 * b11) - (b01 * b10) + (b02 * b09) + (b03 * b08) - (b04 * b07) + (b05 * b06));

	Matrix mat_view_proj_inv = {
		(( mat_view_proj.m5  * b11) - (mat_view_proj.m6  * b10) + (mat_view_proj.m7  * b09)) * inv_det,
		((-mat_view_proj.m1  * b11) - (mat_view_proj.m2  * b10) + (mat_view_proj.m3  * b09)) * inv_det,
		(( mat_view_proj.m13 * b05) - (mat_view_proj.m14 * b04) + (mat_view_proj.m15 * b03)) * inv_det,
		((-mat_view_proj.m9  * b05) + (mat_view_proj.m10 * b04) - (mat_view_proj.m11 * b03)) * inv_det,
		((-mat_view_proj.m4  * b11) + (mat_view_proj.m6  * b08) - (mat_view_proj.m7  * b07)) * inv_det,
		(( mat_view_proj.m0  * b11) - (mat_view_proj.m2  * b08) + (mat_view_proj.m3  * b07)) * inv_det,
		((-mat_view_proj.m12 * b05) + (mat_view_proj.m14 * b02) - (mat_view_proj.m15 * b01)) * inv_det,
		(( mat_view_proj.m8  * b05) - (mat_view_proj.m10 * b02) + (mat_view_proj.m11 * b01)) * inv_det,
		(( mat_view_proj.m4  * b10) - (mat_view_proj.m5  * b08) + (mat_view_proj.m7  * b06)) * inv_det,
		((-mat_view_proj.m0  * b10) + (mat_view_proj.m1  * b08) - (mat_view_proj.m3  * b06)) * inv_det,
		(( mat_view_proj.m12 * b04) - (mat_view_proj.m13 * b02) + (mat_view_proj.m15 * b00)) * inv_det,
		((-mat_view_proj.m8  * b04) + (mat_view_proj.m9  * b02) - (mat_view_proj.m11 * b00)) * inv_det,
		((-mat_view_proj.m4  * b09) + (mat_view_proj.m5  * b07) - (mat_view_proj.m6  * b06)) * inv_det,
		(( mat_view_proj.m0  * b09) - (mat_view_proj.m1  * b07) + (mat_view_proj.m2  * b06)) * inv_det,
		((-mat_view_proj.m12 * b03) + (mat_view_proj.m13 * b01) - (mat_view_proj.m14 * b00)) * inv_det,
		(( mat_view_proj.m8  * b03) - (mat_view_proj.m9  * b01) + (mat_view_proj.m10 * b00)) * inv_det,
	};

	// Create quaternion from source point
	Quaternion quat = {self.x, self.y, self.z, 1};

	// Multiply quat point by unprojected matrix
	Vector4 q_tranformed = mat_view_proj_inv.quaternion_transform(quat);

	// Normalized world points in vectors
	return (q_tranformed / q_tranformed.w).v3();
}
<* Invert the given vector *>
fn Vector3 Vector3.invert(self) @export("vector3_invert") {
	return {
		1 / self.x,
		1 / self.y,
		1 / self.z,
	};
}
<* Clamp the components of the vector between min and max values specified by the given vectors *>
fn Vector3 Vector3.clamp(self, Vector3 min, Vector3 max) @export("vector3_clamp") {
	return {
		math::min(max.x, math::max(min.x, self.x)),
		math::min(max.y, math::max(min.y, self.y)),
		math::min(max.z, math::max(min.z, self.z)),
	};
}
<* Clamp the magnitude of the vector between two values *>
fn Vector3 Vector3.clamp_mag(self, float min, float max) @export("vector3_clamp_mag") {
	Vector3 result = self;

	float len = self.length_sqr();
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
<* Compute the direction of a refracted ray *>
fn Vector3 Vector3.refract(Vector3 v, Vector3 n, float r) @export("vector3_refract") {
	Vector3 result;

	float dot = v.dot_product(n);
	float d = 1 - r.pow(2) * (1 - dot.pow(2));

	if (d >= 0) {
		d = math::sqrt(d);

		result = {
			r * v.x - (r * dot + d) * n.x,
			r * v.y - (r * dot + d) * n.y,
			r * v.z - (r * dot + d) * n.z,
		};
	}

	return result;
}
<* Returns true of two floats are within amount of each other *>
fn bool float.close(&self, float f2, float amount) @export("float_close") {
	return *self + amount > f2 && *self - amount < f2;
}
<* Returns true if xyz all are close to v2 *>
fn bool Vector3.close(&self, Vector3 v2, float amount) @export("vector3_close") {
	return self.x.close(v2.x, amount) &&
				 self.y.close(v2.y, amount) &&
				 self.z.close(v2.z, amount);
}
<* Prints vector3 *>
fn void Vector3.print(self) @export("vector3_print") {
	io::printfn("[%f,%f,%f]", self.x, self.y, self.z);
}

