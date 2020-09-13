#include <string>
#include <iostream>

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#include <SDL_mixer.h>

#include "Constants.h"
#include "PlayerInput.h"
#include "Renderer.h"

double getNow()
{
	return SDL_GetTicks() / 1000.0;
}

int main(int argc, char** argv)
{
	SDL_Init(SDL_INIT_EVERYTHING);
	IMG_Init(IMG_INIT_PNG);
	TTF_Init();
	Mix_Init(MIX_INIT_MP3);

	SDL_Window* window = SDL_CreateWindow("Empty", 50, 50, Constants::WIN_W, Constants::WIN_H, SDL_WINDOW_SHOWN);
	SDL_Renderer* context = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

	//Utils::init();

	Model* model = new Model();
	model->init();

	Renderer* renderer = new Renderer();
	renderer->initialize(context);

	double lastUpdateTime = getNow();
	bool quit = false;
	SDL_Event event;
	while (!quit)
	{
		double now = getNow();
		double dt = now - lastUpdateTime;
		lastUpdateTime = now;

		while (SDL_PollEvent(&event))
		{
			if (event.type == SDL_QUIT)
			{
				quit = true;
			}
			else if (event.type == SDL_KEYDOWN)
			{
				PlayerInput::handleKey(event.key.keysym.sym, true);
			}
			else if (event.type == SDL_KEYUP)
			{
				PlayerInput::handleKey(event.key.keysym.sym, false);
			}
			else if (event.type == SDL_MOUSEMOTION)
			{
				PlayerInput::mx = event.motion.x;
				PlayerInput::my = event.motion.y;
			}
		}
		if (PlayerInput::esc) quit = true;

		renderer->clear();
		//renderer->drawLine(300, 400, PlayerInput::my, PlayerInput::mx);
		//renderer->drawCircle(PlayerInput::my, PlayerInput::mx, 70);
		model->update((real)0.017);
		renderer->drawModel(*model);
		renderer->render();
	}

	Mix_CloseAudio();
	Mix_Quit();
	TTF_Quit();
	IMG_Quit();
	SDL_Quit();

	return 0;
}