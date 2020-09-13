#pragma once

#include "Constants.h"
#include "Utils.h"
#include "BodyRect.h"

class Model
{
public:
	BodyRect rects[2];

	Quat camera;

	Model();
	~Model();
	void init();

	void update(real dt);
};

