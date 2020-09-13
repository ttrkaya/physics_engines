#pragma once

#include "Body.h"

#include "Collision.h"
#include "Utils.h"

class BodyRect : public Body
{
public:
	Vec3 halfVol;

	BodyRect() {}
	void setIdentity();
	void updateMassData(real density);

	real supportMin(const Vec3& axis) const;
	real supportMax(const Vec3& axis) const;
	Vec3 getFurthestPoint(const Vec3& axis) const;
	void getFurthestEdge(const Vec3& axis, Vec3& edgea, Vec3& edgeb) const;

	Collision getCollision(const BodyRect& otherBody) const;
};

