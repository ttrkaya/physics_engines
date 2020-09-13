#pragma once

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>

#include "Constants.h"
#include "Mat34.h"
#include "Model.h"

class Renderer
{
private:
	SDL_Renderer* context;

	SDL_Texture* canvasTex;
	Uint32 canvasValues[Constants::RES_H][Constants::RES_W];

	static const Uint32 COLOR_BG = 0xff000000;
	static const Uint32 COLOR_LINE = 0xffffffff;

public:
	Renderer();
	~Renderer();

	void initialize(SDL_Renderer* context);

	void clear();
	void drawLine(int sy, int sx, int ey, int ex, Uint32 color = COLOR_LINE);
	void drawCircle(int cy, int cx, int r, Uint32 color = COLOR_LINE);
	void drawModel(const Model& model);
	void render();

private:
	void updateCanvasTex();
	void renderCanvas();

	void checkAndSetPixel(int y, int x, Uint32 color);

	void drawLine(const Vec3& from, const Vec3& to);
	void drawRect(const Quat& camera, const BodyRect& rect);
	void convertFromModelToView(const Quat& camera, Vec3& v);
};

