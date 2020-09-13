#include "Body.h"

void Body::setIdentity(){
	Particle::setIdentity();
	orientation.setIdentity();
	angVel.setZero();
	angAcc.setZero();
	invInertia.setIdentity();
	torqueAccum.setZero();
}

Vec3 Body::getVelAtGlobalPoint(const Vec3& at) const{
	return linVel + angVel % (at - pos);
}

void Body::update(real dt){
	Particle::update(dt);
	angAcc = invInertia * torqueAccum;
	torqueAccum.setZero();
	angVel += angAcc * dt;
	orientation += angVel * dt;
	orientation.normalize();
}

void Body::applyForce(const Vec3& force, const Vec3& at){
	Particle::applyForce(force);

	Vec3 d = at - pos;
	torqueAccum -= force % d;
}

void Body::applyImpulse(const Vec3& impulse, const Vec3& at){
	Particle::applyImpulse(impulse);

	Vec3 d = at - pos;
	//Quat invOrient = ~orientation;
	//invOrient.rotate(d);
	angVel -= invInertia * (impulse % d);
}