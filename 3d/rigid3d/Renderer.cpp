#include "Renderer.h"

#include "Utils.h"

Renderer::Renderer()
{
}


Renderer::~Renderer()
{
}

void Renderer::initialize(SDL_Renderer* context_){
	context = context_;
	canvasTex = SDL_CreateTexture(context, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, Constants::RES_W, Constants::RES_H);
}

void Renderer::render(){
	updateCanvasTex();
	renderCanvas();
	SDL_RenderPresent(context);
}

void Renderer::clear(){
	SDL_RenderClear(context);

	for (int y = 0; y < Constants::RES_H; y++)	{
		for (int x = 0; x < Constants::RES_W; x++) {
			canvasValues[y][x] = COLOR_BG;
		}
	}
}

void Renderer::updateCanvasTex(){
	static const SDL_Rect canvasRect{ 0, 0, Constants::RES_W, Constants::RES_H };
	SDL_UpdateTexture(canvasTex, &canvasRect, canvasValues, 4 * Constants::RES_W);
}

void Renderer::renderCanvas(){
	static const SDL_Rect destRect{ 0, 0, Constants::WIN_W, Constants::WIN_H };
	SDL_RenderCopy(context, canvasTex, NULL, &destRect);
}

void Renderer::drawLine(int sy, int sx, int ey, int ex, Uint32 color){
	bool steep = abs(ey - sy) > abs(ex - sx);
	if (steep) {
		if (ey < sy) {
			swap(sx, ex);
			swap(sy, ey);
		}

		int dx = ex - sx;
		int dy = ey - sy;
		int dirx = 1;
		if (dx < 0) {
			dx *= -1;
			dirx = -1;
		}
		int x = sx;
		int err = dy / 2;
		for (int y = sy; y <= ey; y++) {
			checkAndSetPixel(y, x, color);
			err += dx;
			if (err > dy) {
				err -= dy;
				x += dirx;
			}
		}
	}
	else {
		if (ex < sx) {
			swap(sx, ex);
			swap(sy, ey);
		}

		int dx = ex - sx;
		int dy = ey - sy;
		int diry = 1;
		if (dy < 0) {
			dy *= -1;
			diry = -1;
		}
		int y = sy;
		int err = dx / 2;
		for (int x = sx; x <= ex; x++) {
			checkAndSetPixel(y, x, color);
			err += dy;
			if (err > dx) {
				err -= dx;
				y += diry;
			}
		}
	}
}

void Renderer::drawLine(const Vec3& from, const Vec3& to){
	drawLine(from.y, from.x, to.y, to.x);
}

void Renderer::drawCircle(int cy, int cx, int r, Uint32 color) {
	int r2 = r * r;

	int x = r;
	for (int y = 0; y <= x; y++) {
		int errNow = abs(y * y + x * x - r2);
		int errThen = abs(y * y + (x - 1) * (x - 1) - r2);
		if (errThen < errNow) {
			x--;
		}

		checkAndSetPixel(cy + y, cx + x, color);
		checkAndSetPixel(cy + x, cx + y, color);
		checkAndSetPixel(cy + y, cx - x, color);
		checkAndSetPixel(cy + x, cx - y, color);
		checkAndSetPixel(cy - y, cx - x, color);
		checkAndSetPixel(cy - x, cx - y, color);
		checkAndSetPixel(cy - y, cx + x, color);
		checkAndSetPixel(cy - x, cx + y, color);
	}
}

void Renderer::checkAndSetPixel(int y, int x, Uint32 color) {
	if (y < 0) return;
	if (y >= Constants::RES_H) return;
	if (x < 0) return;
	if (x >= Constants::RES_W) return;

	canvasValues[y][x] = color;
}

void Renderer::drawModel(const Model& model){
	for (const BodyRect& rect : model.rects){
		drawRect(model.camera, rect);
	}

	Collision col = model.rects[0].getCollision(model.rects[1]);
	if (col.bodies[0] == nullptr) return;
	Vec3 from = col.pos;
	Vec3 to = col.pos + col.normal * col.depth;
	convertFromModelToView(model.camera, from);
	convertFromModelToView(model.camera, to);
	drawLine(from.y, from.x, to.y, to.x, 0xffff0000);
	drawCircle(from.y, from.x, 3, 0xffff0000);

	return;
	const BodyRect& cornered = model.rects[0];
	Vec3 corners[8]{
		cornered.orientation.getRotated(Vec3(cornered.halfVol.x, cornered.halfVol.y, cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(cornered.halfVol.x, cornered.halfVol.y, -cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(cornered.halfVol.x, -cornered.halfVol.y, cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(cornered.halfVol.x, -cornered.halfVol.y, -cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(-cornered.halfVol.x, cornered.halfVol.y, cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(-cornered.halfVol.x, cornered.halfVol.y, -cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(-cornered.halfVol.x, -cornered.halfVol.y, cornered.halfVol.z)),
			cornered.orientation.getRotated(Vec3(-cornered.halfVol.x, -cornered.halfVol.y, -cornered.halfVol.z))
	};
	for (int i = 0; i < 8; i++){
		Vec3 from = corners[i] + cornered.pos;
		Vec3 v = cornered.getVelAtGlobalPoint(corners[i]);
		Vec3 to = from + v;
		convertFromModelToView(model.camera, from);
		convertFromModelToView(model.camera, to);
		drawLine(from.y, from.x, to.y, to.x, 0xff00ff00);
	}
}

void Renderer::drawRect(const Quat& camera, const BodyRect& rect){
	Vec3 vs[8];
	int at = 0;
	for (int z = -1; z <= 1; z += 2){
		for (int y = -1; y <= 1; y += 2){
			for (int x = -1; x <= 1; x += 2){
				Vec3& v = vs[at++];
				v.x = x * rect.halfVol.x;
				v.y = y * rect.halfVol.y;
				v.z = z * rect.halfVol.z;
			}
		}
	}
	for (int i = 0; i < 8; i++){
		rect.orientation.rotate(vs[i]);
	}
	for (int i = 0; i < 8; i++){
		vs[i] += rect.pos;
	}

	for (int i = 0; i < 8; i++){
		convertFromModelToView(camera, vs[i]);
	}

	drawLine(vs[0], vs[1]);
	drawLine(vs[1], vs[3]);
	drawLine(vs[3], vs[2]);
	drawLine(vs[2], vs[0]);
	drawLine(vs[4], vs[5]);
	drawLine(vs[5], vs[7]);
	drawLine(vs[7], vs[6]);
	drawLine(vs[6], vs[4]);

	drawLine(vs[0], vs[4]);
	drawLine(vs[1], vs[5]);
	drawLine(vs[2], vs[6]);
	drawLine(vs[3], vs[7]);
}

void Renderer::convertFromModelToView(const Quat& camera, Vec3& v){
	camera.rotate(v);
	v.x += Constants::RES_W / 2;
	v.y += Constants::RES_H / 2;
}