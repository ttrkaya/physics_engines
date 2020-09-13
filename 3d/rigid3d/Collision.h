#pragma once

#include "Constants.h"
#include "Body.h"

class Collision
{
public:
	Body* bodies[2];
	Vec3 pos;
	Vec3 normal;
	real depth;
};

