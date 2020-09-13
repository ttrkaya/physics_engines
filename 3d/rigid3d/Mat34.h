#pragma once

#include "Constants.h"
#include "Vec3.h"
#include "Quat.h"

class Mat34
{
public:
	real d[3][4];

	Mat34();
	Mat34(real a1, real a2, real a3, real a4, 
		real b1, real b2, real b3, real b4, 
		real c1, real c2, real c3, real c4);

	void setIdentity();
	void setRotation(const Quat& q);
	void setTranslation(const Vec3& v);

	Vec3 operator*(const Vec3& v) const;
	Vec3 operator/(Vec3 v) const;
};

