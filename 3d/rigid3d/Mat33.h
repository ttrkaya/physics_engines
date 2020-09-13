#pragma once

#include "Constants.h"
#include "Vec3.h"

class Mat33
{
public:

	real d[3][3];

	Mat33();
	Mat33(real a1, real a2, real a3,
		real b1, real b2, real b3, 
		real c1, real c2, real c3);
	void setIdentity();

	Vec3 operator*(const Vec3& v);
};

