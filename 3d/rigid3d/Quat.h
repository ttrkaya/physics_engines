#pragma once

#include "Constants.h"
#include "Vec3.h"

class Quat{
public:
	real r;
	Vec3 v;

	Quat(real r_, Vec3 v_) : r(r_), v(v_) {}
	Quat(real r_ = 0, real i = 0, real j = 0, real k = 0) : r(r_), v(i, j, k) {}
	void setIdentity();
	void setAxisAngle(const Vec3& axis, real angle);

	void negate() { v *= -1.0; }
	void normalize() { real l = sqrtReal(r*r + v.lengthSquared()); r /= l; v /= l; }

	Quat operator*(const Quat& q) const;
	Quat operator~() const { return Quat(r, v * -1); }
	void operator+=(const Vec3& v);

	void rotate(Vec3& v) const;
	Vec3 getRotated(const Vec3& v) const;
};

