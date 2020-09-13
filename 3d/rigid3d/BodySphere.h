#pragma once

#include "Body.h"

class BodySphere : public Body
{
public:
	real r;

	BodySphere() {}
	void setIdentity();
};

