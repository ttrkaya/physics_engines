#pragma once

#include "Constants.h"
#include "Vec3.h"

class Particle
{
public:
	Vec3 pos;
	Vec3 linVel;
	Vec3 linAcc;

	real invMass;

	Vec3 forceAccum;

	Particle() {};
	void setIdentity();

	void update(real dt);
	void applyForce(const Vec3& force);
	void applyImpulse(const Vec3& impulse);
};

