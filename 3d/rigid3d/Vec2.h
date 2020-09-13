#pragma once

#include "Constants.h"

class Vec2
{
public:

	real x, y;

	Vec2() {}
	Vec2(real x_, real y_) : x(x_), y(y_) {}

	Vec2 operator+(const Vec2& v) const { return Vec2(x + v.x, y + v.y); }
	Vec2 operator-(const Vec2& v) const { return Vec2(x - v.x, y - v.y); }

	void operator+=(const Vec2& v) { x += v.x; y += v.y; }
	void operator-=(const Vec2& v) { x -= v.x; y -= v.y; }

	Vec2 operator*(real s) const { return Vec2(x * s, y * s); }
	Vec2 operator/(real s) const { return Vec2(x / s, y / s); }

	void operator*=(real s) { x *= s; y *= s; }
	void operator/=(real s) { x /= s; y /= s; }

	real operator*(const Vec2& v) const { return x * v.x + y * v.y; }
	real operator%(const Vec2& v) const{ return x * v.y - y * v.x; }

	real lengthSquared() const { return x * x + y * y; }
	real length() const { return sqrtReal(lengthSquared()); }
	void normalize() { real l = length(); if (l > 0.0) this->operator/=(l); }
};

