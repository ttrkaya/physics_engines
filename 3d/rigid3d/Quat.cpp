#include "Quat.h"

void Quat::setIdentity(){
	r = 1;
	v.setZero();
}

void Quat::setAxisAngle(const Vec3& axis, real angle){ 
	angle /= 2;
	r = cosReal(angle);
	// TO-OPTIMIZE remove normalization maybe?
	v = axis.getNormalized() * sinReal(angle);
}

Quat Quat::operator*(const Quat& q) const{
	return Quat(r * q.r - v * q.v, v * q.r + q.v * r + v % q.v);
}

// TO-OPTIMIZE
void Quat::rotate(Vec3& o) const{
	Quat qr = (*this) * Quat(0, o) * (~(*this));
	o = qr.v;
}
Vec3 Quat::getRotated(const Vec3& v) const{
	Quat qr = *this * Quat(0, v) * ~(*this);
	return qr.v;
}

void Quat::operator+=(const Vec3& o){
	Quat q = Quat(0, o) * (*this);

	r += q.r * 0.5;
	v += q.v * 0.5;
}