#include "Particle.h"

void Particle::setIdentity(){
	pos.setZero();
	linVel.setZero();
	linAcc.setZero();
	invMass = 1;
	forceAccum.setZero();
}

void Particle::update(real dt){
	linAcc = forceAccum * invMass;
	forceAccum.setZero();

	linVel += linAcc * dt;
	pos += linVel * dt;
}

void Particle::applyForce(const Vec3& force){
	forceAccum += force;
}

void Particle::applyImpulse(const Vec3& impulse){
	linVel += impulse * invMass;
}