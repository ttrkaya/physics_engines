#include "Mat34.h"


Mat34::Mat34(){}

Mat34::Mat34(real a1, real a2, real a3, real a4,
			real b1, real b2, real b3, real b4,
			real c1, real c2, real c3, real c4) {
	d[0][0] = a1;
	d[0][1] = a2;
	d[0][2] = a3;
	d[0][3] = a4;
	d[1][0] = b1;
	d[1][1] = b2;
	d[1][2] = b3;
	d[1][3] = b4;
	d[2][0] = c1;
	d[2][1] = c2;
	d[2][2] = c3;
	d[2][3] = c4;
}

void Mat34::setIdentity(){
	d[0][0] = 1;
	d[0][1] = 0;
	d[0][2] = 0;
	d[0][3] = 0;

	d[1][0] = 0;
	d[1][1] = 1;
	d[1][2] = 0;
	d[1][3] = 0;

	d[2][0] = 0;
	d[2][1] = 0;
	d[2][2] = 1;
	d[2][3] = 0;
}

void Mat34::setRotation(const Quat& q){
	d[0][0] = 1 - 2 * (q.v.y*q.v.y + q.v.z*q.v.z);
	d[0][1] = 2 * (q.v.x*q.v.y + q.v.z*q.r);
	d[0][2] = 2 * (q.v.x*q.v.z - q.v.y*q.r);

	d[1][0] = 2 * (q.v.x*q.v.y - q.v.z*q.r);
	d[1][1] = 1 - 2 * (q.v.x*q.v.x + q.v.z*q.v.z);
	d[1][2] = 2 * (q.v.y*q.v.z + q.v.x*q.r);
	
	d[2][0] = 2 * (q.v.x*q.v.z + q.v.y*q.r);
	d[2][1] = 2 * (q.v.y*q.v.z - q.v.x*q.r);
	d[2][2] = 1 - 2 * (q.v.x*q.v.x + q.v.y*q.v.y);
}

void Mat34::setTranslation(const Vec3& v){
	d[0][3] = v.x;
	d[1][3] = v.y;
	d[2][3] = v.z;
}

Vec3 Mat34::operator*(const Vec3& v) const{
	return Vec3(d[0][0] * v.x + d[0][1] * v.y + d[0][2] * v.z + d[0][3],
				d[1][0] * v.x + d[1][1] * v.y + d[1][2] * v.z + d[1][3],
				d[2][0] * v.x + d[2][1] * v.y + d[2][2] * v.z + d[2][3]);
}

Vec3 Mat34::operator/(Vec3 v) const{
	v.x -= d[0][3];
	v.y -= d[1][3];
	v.z -= d[2][3];
	return Vec3(d[0][0] * v.x + d[1][0] * v.y + d[2][0],
				d[0][1] * v.x + d[1][1] * v.y + d[2][1],
				d[0][2] * v.x + d[1][2] * v.y + d[2][2]);
}