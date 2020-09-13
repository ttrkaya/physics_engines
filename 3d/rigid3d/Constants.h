#pragma once

#include <cmath>

#define PHYSICS_USE_DOUBLE_PRECISION

#ifdef PHYSICS_USE_DOUBLE_PRECISION
typedef double real;
#define sqrtReal std::sqrt
#define sinReal std::sin
#define cosReal std::cos
#define powReal std::pow
#else
typedef float real;
#define sqrtReal std::sqrtf
#define sinReal std::sinf
#define cosReal std::cosf
#define powReal std::powf
#endif

namespace Constants
{
	const int WIN_W = 800;
	const int WIN_H = 600;

	const int RES_W = 800;
	const int RES_H = 600;
};

