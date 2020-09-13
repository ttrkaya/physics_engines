#pragma once

#include "Constants.h"


class Vec3{
public:
	union{
		struct {
			real x, y, z;
		};
		real d[3];
	};

	Vec3() {}
	Vec3(real x_, real y_, real z_) : x(x_), y(y_), z(z_) {}
	void setZero() { x = y = z = 0; }

	Vec3 operator+(const Vec3& v) const { return Vec3(x + v.x, y + v.y, z + v.z); }
	Vec3 operator-(const Vec3& v) const { return Vec3(x - v.x, y - v.y, z - v.z); }
	Vec3 operator-() const { return Vec3(-x, -y, -z); }

	void operator+=(const Vec3& v) { x += v.x; y += v.y; z += v.z; }
	void operator-=(const Vec3& v) { x -= v.x; y -= v.y; z -= v.z; }

	Vec3 operator*(real s) const { return Vec3(x * s, y * s, z * s); }
	Vec3 operator/(real s) const { return Vec3(x / s, y / s, z / s); }

	void operator*=(real s) { x *= s; y *= s; z *= s; }
	void operator/=(real s) { x /= s; y /= s; z /= s; }

	real operator*(const Vec3& v) const { return x * v.x + y * v.y + z * v.z; }
	Vec3 operator%(const Vec3& v) const { return Vec3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x); }

	real lengthSquared() const { return x * x + y * y + z * z; }
	real length() const { return sqrtReal(lengthSquared()); }
	void normalize() { real l = length(); if (l > 0.0) (*this)/=(l); }
	Vec3 getNormalized() const { Vec3 v = *this; v.normalize(); return v; }
};

