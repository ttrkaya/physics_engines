#include "BodyRect.h"

void BodyRect::setIdentity(){
	Body::setIdentity();
	halfVol = Vec3(1, 1, 1);
}

void BodyRect::updateMassData(real density){
	invMass = 1 / (density * 8 * halfVol.x * halfVol.y * halfVol.z);
	invInertia.setIdentity();
	invInertia.d[0][0] = 3 * invMass / (halfVol.y * halfVol.y + halfVol.z * halfVol.z);
	invInertia.d[1][1] = 3 * invMass / (halfVol.x * halfVol.x + halfVol.z * halfVol.z);
	invInertia.d[2][2] = 3 * invMass / (halfVol.x * halfVol.x + halfVol.y * halfVol.y);
}

real BodyRect::supportMin(const Vec3& axis) const{
	Vec3 corners[8]{
		orientation.getRotated(Vec3(halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, -halfVol.z))
	};
	real res = axis * corners[0];
	for (int i = 1; i < 8; i++){
		res = min(res, axis * corners[i]);
	}
	res += pos * axis;
	return res;
}

real BodyRect::supportMax(const Vec3& axis) const{
	Vec3 corners[8]{
		orientation.getRotated(Vec3(halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, -halfVol.z))
	};
	real res = axis * corners[0];
	for (int i = 1; i < 8; i++){
		res = max(res, axis * corners[i]);
	}
	res += pos * axis;
	return res;
}

Vec3 BodyRect::getFurthestPoint(const Vec3& axis) const{
	Vec3 corners[8]{
		orientation.getRotated(Vec3(halfVol.x, halfVol.y, halfVol.z)),
		orientation.getRotated(Vec3(halfVol.x, halfVol.y, -halfVol.z)),
		orientation.getRotated(Vec3(halfVol.x, -halfVol.y, halfVol.z)),
		orientation.getRotated(Vec3(halfVol.x, -halfVol.y, -halfVol.z)),
		orientation.getRotated(Vec3(-halfVol.x, halfVol.y, halfVol.z)),
		orientation.getRotated(Vec3(-halfVol.x, halfVol.y, -halfVol.z)),
		orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, halfVol.z)),
		orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, -halfVol.z))
	};
	Vec3 res = corners[0];
	real resVal = res * axis;
	for (int i = 1; i < 8; i++){
		real cur = corners[i] * axis;
		if (cur > resVal){
			resVal = cur;
			res = corners[i];
		}
	}
	res += pos;
	return res;
}

void BodyRect::getFurthestEdge(const Vec3& axis, Vec3& edgea, Vec3& edgeb) const{
	Vec3 corners[8]{
		orientation.getRotated(Vec3(halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(halfVol.x, -halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, halfVol.y, -halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, halfVol.z)),
			orientation.getRotated(Vec3(-halfVol.x, -halfVol.y, -halfVol.z))
	};
	edgea = corners[0];
	edgeb = corners[1];
	for (int i = 2; i < 8; i++){
		if (axis * corners[i] > axis * edgea){
			if (axis * edgea > axis * edgeb){
				edgeb = edgea;
			}
			edgea = corners[i];
		}
		else if (axis * corners[i] > axis * edgeb){
			edgeb = corners[i];
		}
	}
	edgea += pos;
	edgeb += pos;
}

real getu(Vec3 nor, Vec3 ea, Vec3 d, Vec3 oea, Vec3 od){
	//TO-DO: dem may be too small
	real u = (nor.z * (oea.y - ea.y) - nor.y * (oea.z - ea.z)) * (nor.x * od.y - nor.y * od.x) -
		(nor.y * (oea.x - ea.x) - nor.x * (oea.y - ea.y)) * (nor.y * od.z - nor.z * od.y);
	real dem = (nor.x * d.y - nor.y * d.x) * (nor.y * od.z - nor.z * od.y) - 
		(nor.y * d.z - nor.z * d.y) * (nor.x * od.y - nor.y * od.x);
	u /= dem;
	return u;
}

real getw(Vec3 nor, Vec3 ea, Vec3 d, Vec3 oea, Vec3 od, real u){
	real dem = nor.x * od.y - nor.y * od.x;
	if (abs(dem) < 0.0001){
		dem = nor.y * od.z - nor.z * od.y;
		real w = u * (nor.y * d.z - nor.z * d.y) + nor.z * (oea.y - ea.y) - nor.y * (oea.z - ea.z);
		w /= dem;
		return w;
	}
	real w = u * (nor.x * d.y - nor.y * d.x) + nor.y * (oea.x - ea.x) - nor.x * (oea.y - ea.y);
	w /= dem;
	return w;
}

Collision BodyRect::getCollision(const BodyRect& otherBody) const{
	Collision col;
	col.bodies[0] = nullptr;

	Vec3 faceNormals[6]{
		orientation.getRotated(Vec3(1, 0, 0)),
		orientation.getRotated(Vec3(0, 1, 0)),
		orientation.getRotated(Vec3(0, 0, 1)),
		otherBody.orientation.getRotated(Vec3(1, 0, 0)),
		otherBody.orientation.getRotated(Vec3(0, 1, 0)),
		otherBody.orientation.getRotated(Vec3(0, 0, 1))
	};

	col.depth = 2 * (halfVol.x + halfVol.y + halfVol.z + 
		otherBody.halfVol.x + otherBody.halfVol.y + otherBody.halfVol.z);
	Vec3 dp = otherBody.pos - pos;
	for (int i = 0; i < 6; i++){
		Vec3 axis = faceNormals[i];
		if (axis * dp < 0) axis *= -1;

		real curDepth = supportMax(axis) - otherBody.supportMin(axis);
		if (curDepth < 0) return col;
		if (curDepth < col.depth){
			col.depth = curDepth;
			col.normal = axis;
			if (i < 3){
				col.pos = otherBody.getFurthestPoint(-axis) + col.normal * (col.depth * 0.5);
			}
			else{
				col.pos = getFurthestPoint(axis) - col.normal * (col.depth * 0.5);
			}
		}
	}
	
	for (int i = 0; i < 3; i++){
		for (int j = 3; j < 6; j++){
			Vec3 edgeNormal = faceNormals[i] % faceNormals[j];
			edgeNormal.normalize();
			if (edgeNormal * dp < 0) edgeNormal *= -1;

			real curDepth = supportMax(edgeNormal) - otherBody.supportMin(edgeNormal);
			if (curDepth < 0) return col;
			if (curDepth < col.depth){
				col.depth = curDepth;
				col.normal = edgeNormal;
				
				Vec3 edgea, edgeb, otherEdgea, otherEdgeb;
				getFurthestEdge(edgeNormal, edgea, edgeb);
				otherBody.getFurthestEdge(-edgeNormal, otherEdgea, otherEdgeb);
				Vec3 edgeDir = edgeb - edgea;
				Vec3 otherEdgeDir = otherEdgeb - otherEdgea;
				real u = getu(edgeNormal, edgea, edgeDir, otherEdgea, otherEdgeDir);
				real w = getw(edgeNormal, edgea, edgeDir, otherEdgea, otherEdgeDir, u);
				Vec3 pointa = edgea + edgeDir * u;
				Vec3 pointb = otherEdgea + otherEdgeDir * w;
				col.pos = (pointa + pointb) / 2;
			}
		}
	}

	col.bodies[0] = (Body*)this;
	col.bodies[1] = (Body*)(&otherBody);
	return col;
}

