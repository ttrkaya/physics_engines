#pragma once

#include "Constants.h"
#include "Particle.h"
#include "Quat.h"
#include "Mat33.h"

class Body : public Particle
{
public:
	Quat orientation;
	Vec3 angVel;
	Vec3 angAcc;

	Mat33 invInertia;

	Vec3 torqueAccum;

	Body() {}
	void setIdentity();

	Vec3 getVelAtGlobalPoint(const Vec3& at) const;

	void update(real dt);
	void applyForce(const Vec3& force, const Vec3& at);
	void applyImpulse(const Vec3& impulse, const Vec3& at);
};

