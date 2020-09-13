#include "Mat33.h"


Mat33::Mat33()
{
}

Mat33::Mat33(real a1, real a2, real a3,
	real b1, real b2, real b3,
	real c1, real c2, real c3)
{
	d[0][0] = a1;
	d[0][1] = a2;
	d[0][2] = a3;
	d[1][0] = b1;
	d[1][1] = b2;
	d[1][2] = b3;
	d[2][0] = c1;
	d[2][1] = c2;
	d[2][2] = c3;
}

void Mat33::setIdentity(){
	d[0][0] = 1;
	d[0][1] = 0;
	d[0][2] = 0;

	d[1][0] = 0;
	d[1][1] = 1;
	d[1][2] = 0;

	d[2][0] = 0;
	d[2][1] = 0;
	d[2][2] = 1;
}

Vec3 Mat33::operator*(const Vec3& v){
	return Vec3(d[0][0] * v.x + d[0][1] * v.y + d[0][2] * v.z,
				d[1][0] * v.x + d[1][1] * v.y + d[1][2] * v.z,
				d[2][0] * v.x + d[2][1] * v.y + d[2][2] * v.z);
}