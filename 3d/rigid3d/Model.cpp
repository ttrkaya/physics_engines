#include "Model.h"

#include "Constants.h"
#include "Utils.h"
#include "PlayerInput.h"

Model::Model(){}


Model::~Model(){
}

void Model::init(){
	camera.setIdentity();

	rects[0].setIdentity();
	rects[0].halfVol = Vec3(100, 100, 100);
	rects[0].updateMassData(1);
	//rects[0].orientation.setAxisAngle(Vec3(1, 1, 1), 3.14 / 4);
	//rects[0].pos.y = -150;
	//rects[0].linVel.y = 10;
	//rects[0].angVel = Vec3(0.1, 0.15, 0.17);
	//rects[0].applyImpulse(Vec3(0, 0, 100000000), rects[0].pos + Vec3(100, 0, 0));

	rects[1].setIdentity();
	rects[1].halfVol = Vec3(100, 100, 100);
	rects[1].updateMassData(1);
	//rects[1].orientation.setAxisAngle(Vec3(0, 0, 1), 3.14 / 4);
	//rects[1].pos.y = 100;
	//rects[1].angVel = Vec3(0.02, 0.03, 0.01);
}

real getRandom(){
	real r = rand();
	r /= RAND_MAX;
	return r;
}

void Model::update(real dt){
	if (PlayerInput::right){
		camera += Vec3(0, 0.01, 0);
	}
	if (PlayerInput::left){
		camera += Vec3(0, -0.01, 0);
	}
	if (PlayerInput::up){
		camera += Vec3(0.01, 0, 0);
	}
	if (PlayerInput::down){
		camera += Vec3(-0.01, 0, 0);
	}

	camera.normalize();
	if (PlayerInput::space) return;

	real drag = powReal(1, dt);
	for (int i = 0; i < 2; i++){
		BodyRect& rect = rects[i];
		rect.update(dt);
		rect.linVel *= drag;
		rect.angVel *= drag;
	}

	const real DUR = 3;
	static real timeCounter = DUR;
	timeCounter += dt;
	if (timeCounter >= DUR){
		timeCounter -= DUR;

		rects[0].halfVol = Vec3(30 + 120 * getRandom(), 30 + 120 * getRandom(), 30 + 120 * getRandom());
		rects[0].updateMassData(1);
		rects[0].pos = Vec3(-250, 0, 0);
		rects[0].linVel = Vec3(70, (getRandom() - 0.5) * 5, (getRandom() - 0.5) * 5);
		rects[0].orientation.setIdentity();
		rects[0].angVel = Vec3((getRandom() - 0.5) * 3, (getRandom() - 0.5) * 3, (getRandom() - 0.5) * 3);

		rects[1].halfVol = Vec3(30 + 120 * getRandom(), 30 + 120 * getRandom(), 30 + 120 * getRandom());
		rects[1].updateMassData(1);
		rects[1].pos = Vec3(250, 0, 0);
		rects[1].linVel = Vec3(-70, (getRandom() - 0.5) * 5, (getRandom() - 0.5) * 5);
		rects[1].orientation.setIdentity();
		rects[1].angVel = Vec3((getRandom() - 0.5) * 3, (getRandom() - 0.5) * 3, (getRandom() - 0.5) * 3);
	}

	Collision col = rects[0].getCollision(rects[1]);
	if (col.bodies[0] == nullptr) return;
	real restitution = 0.3;
	Vec3 va = rects[0].getVelAtGlobalPoint(col.pos);
	Vec3 vb = rects[1].getVelAtGlobalPoint(col.pos);
	Vec3 vab = va - vb;
	real j = (1 + restitution) * (vab * col.normal);
	Vec3 rap = col.pos - rects[0].pos;
	Vec3 rbp = col.pos - rects[1].pos;
	Vec3 ca = rap % col.normal;
	Vec3 cb = rbp % col.normal;
	real dem = rects[0].invMass + rects[1].invMass +
		(rects[0].invInertia * col.normal).length() * ca.lengthSquared() +
		(rects[1].invInertia * col.normal).length() * cb.lengthSquared();
	j /= dem;
	if (j < 0) return;
	col.bodies[0]->applyImpulse(col.normal * -j, col.pos);
	col.bodies[1]->applyImpulse(col.normal * j, col.pos);
}