package physic
{
	import flash.geom.Point;
	
	import math.Mat4;
	import math.Vec4;

	public class Physics
	{
		private var _spheres:Vector.<SphereBody>;
		private var _cubes:Vector.<CubeBody>;
		
		public static const RESTITUTION:Number = 1;
		
		private static const NUM_ITER_POS:int = 10;
		private static const NUM_ITER_VEL:int = 10;
		
		public function Physics()
		{
			_spheres = new Vector.<SphereBody>;
			_cubes = new Vector.<CubeBody>;
		}
		
		public function addSphere(c:Vec4, r:Number):SphereBody
		{
			var s:SphereBody = new SphereBody(r);
			s.setCenter(c);
			_spheres.push(s);
			return s;
		}
		
		public function addCube(c:Vec4, halfSize:Vec4):CubeBody
		{
			var cube:CubeBody = new CubeBody(halfSize);
			cube.setCenter(c);
			_cubes.push(cube);
			return cube;
		}
		
		public function update(dt:Number):void
		{
			var i:int, l:int;
			
			var damping:Number = Math.pow(0.99, dt);
			
			for(i=0, l=_spheres.length; i<l; i++)
			{
				_spheres[i].update(dt, damping);
			}
			for(i=0, l=_cubes.length; i<l; i++)
			{
				_cubes[i].update(dt, damping);
			}
			
			var cols:Vector.<Collision> = getCollisions();
			
			for(i=0; i<NUM_ITER_POS; i++)
			{
				var posCriticalCol:Collision = getMostSeverePosCollision(cols);
				if(!posCriticalCol) break;
				handleColPos(posCriticalCol);
			}
			
			for(i=0; i<NUM_ITER_VEL; i++)
			{
				var velCriticalCol:Collision = getMostSeverePosCollision(cols);
				if(!velCriticalCol) break;
				handleColVel(velCriticalCol);
			}
		}
		
		private function getCollisions():Vector.<Collision>
		{
			var i:int, li:int, j:int, lj:int, l:int;
			
			var cols:Vector.<Collision> = new Vector.<Collision>;
			l = _spheres.length;
			for(i=0; i<l; i++)
			{
				var sphere0:SphereBody = _spheres[i];
				for(j=i+1; j<l; j++)
				{
					var sphere1:SphereBody = _spheres[j];
					
					var colss:Collision = getSphereSphereCollision(sphere0, sphere1);
					if(colss) cols.push(colss);
				}
			}
			
			for(i=0, li=_cubes.length; i<li; i++)
			{
				var cube:CubeBody = _cubes[i];
				for(j=0, lj=_spheres.length; j<lj; j++)
				{
					var sphere:SphereBody = _spheres[j];
					
					var colcs:Collision = getCubeSphereCollision(cube, sphere);
					if(colcs) cols.push(colcs);
				}
			}
			
			l = _cubes.length;
			for(i=0; i<l; i++)
			{
				var cube0:CubeBody = _cubes[i];
				for(j=i+1; j<l; j++)
				{
					var cube1:CubeBody = _cubes[j];
					
					var colcc:Collision = getCubeCubeCollision(cube0, cube1);
					if(colcc) cols.push(colcc);
				}
			}
			
			return cols;
		}
		
		private function getSphereSphereCollision(sphere0:SphereBody, sphere1:SphereBody):Collision
		{
			var dc:Vec4 = sphere1.getCenter().getSubbed(sphere0.getCenter());
			var tr:Number = sphere0.getR() + sphere1.getR();
			if(dc.lengthSquared() > tr*tr) return null;
			
			var col:Collision = new Collision();
			col.body0 = sphere0;
			col.body1 = sphere1;
			
			col.penetration = tr - dc.length();
			
			dc.normalize();
			dc.s = 0;
			col.normal = dc;
			
			col.pos = sphere0.getCenter().getAdded(dc.getScaled(sphere0.getR() - col.penetration/2));
			
			var dv:Vec4 = sphere0.getLinVel().getSubbed(sphere1.getLinVel());
			col.closingSpeed2 = dv.lengthSquared();
			
			return col;
		}
		
		private function getCubeSphereCollision(cube:CubeBody, sphere:SphereBody):Collision
		{
			var cubeTransformMat:Mat4 = cube.getTransformMat();
			var localSphereCenter:Vec4 = cubeTransformMat.getInverseTransformed(sphere.getCenter());
			
			var closestPoint:Vec4 = localSphereCenter.clone();
			if(closestPoint.x < -cube.hw) closestPoint.x = -cube.hw;
			else if(closestPoint.x > cube.hw) closestPoint.x = cube.hw;
			if(closestPoint.y < -cube.hh) closestPoint.y = -cube.hh;
			else if(closestPoint.y > cube.hh) closestPoint.y = cube.hh;
			if(closestPoint.z < -cube.hd) closestPoint.z = -cube.hd;
			else if(closestPoint.z > cube.hd) closestPoint.z = cube.hd;
			
			var d:Vec4 = localSphereCenter.getSubbed(closestPoint);
			if(d.lengthSquared() < sphere.getR()*sphere.getR())
			{
				var normal:Vec4 = d.clone();
				normal.normalize();
				normal.s = 0;
				var penetration:Number = sphere.getR() - d.length();
				
				cubeTransformMat.transform(closestPoint);
				cubeTransformMat.transform(normal);
				
				var col:Collision = new Collision();
				col.body0 = cube;
				col.body1 = sphere;
				col.pos = closestPoint;
				col.normal = normal;
				col.penetration = penetration;
				
				var dv:Vec4 = cube.getLinVel().getSubbed(sphere.getLinVel());
				col.closingSpeed2 = dv.lengthSquared();
				
				return col;
			}
			
			return null;
		}
		
		private function getCubeCubeCollision(cube0:CubeBody, cube1:CubeBody):Collision
		{
			var i:int;
			
			//cube-cube (SAT algorithm)
			var face0x:Vec4 = cube0.getOrientation().getAxis(0);
			var face0y:Vec4 = cube0.getOrientation().getAxis(1);
			var face0z:Vec4 = cube0.getOrientation().getAxis(2);
			var face1x:Vec4 = cube1.getOrientation().getAxis(0);
			var face1y:Vec4 = cube1.getOrientation().getAxis(1);
			var face1z:Vec4 = cube1.getOrientation().getAxis(2);
			var edgexx:Vec4 = face0x.cross(face1x);
			edgexx.normalize();
			var edgexy:Vec4 = face0x.cross(face1y);
			edgexy.normalize();
			var edgexz:Vec4 = face0x.cross(face1z);
			edgexz.normalize();
			var edgeyx:Vec4 = face0y.cross(face1x);
			edgeyx.normalize();
			var edgeyy:Vec4 = face0y.cross(face1y);
			edgeyy.normalize();
			var edgeyz:Vec4 = face0y.cross(face1z);
			edgeyz.normalize();
			var edgezx:Vec4 = face0z.cross(face1x);
			edgezx.normalize();
			var edgezy:Vec4 = face0z.cross(face1y);
			edgezy.normalize();
			var edgezz:Vec4 = face0z.cross(face1z);
			edgezz.normalize();
			
			var axes:Vector.<Vec4> = new <Vec4>[face0x, face0y, face0z, face1x, face1y, face1z, 
				edgexx, edgexy, edgexz, edgeyx, edgeyy, edgeyz, edgezx, edgezy, edgezz];
			
			var minPenetration:Number = Number.MAX_VALUE;
			var minPenetrationIndex:int = -1;
			for(i=0; i<15; i++)
			{
				var axis:Vec4 = axes[i];
				if(axis.isZero()) continue;
				
				var limit0:Point = getLimits1D(cube0, axis);
				var limit1:Point = getLimits1D(cube1, axis);
				
				if(limit0.x > limit1.y || limit0.y < limit1.x)
				{
					minPenetration = -1;
					break;
				}
				else
				{
					var curPenetration:Number = Math.min(Math.abs(limit0.x-limit1.y), Math.abs(limit0.y-limit1.x));
					if(curPenetration < minPenetration)
					{
						minPenetration = curPenetration;
						minPenetrationIndex = i;
					}
				}
			}
			
			if(minPenetration <= 0) return null; 

			var col:Collision = new Collision();
			col.penetration = minPenetration;
			
			if(minPenetrationIndex < 6) //face-vertex
			{
				var cubeOfVertex:CubeBody;
				var cubeOfFace:CubeBody;
				if(minPenetrationIndex < 3)//face of cube0, vertex of cube1
				{
					cubeOfFace = cube0;
					cubeOfVertex = cube1;
				}
				else //vertex of cube0, face of cube1
				{
					cubeOfVertex = cube0;
					cubeOfFace = cube1;
				}
				
				col.body0 = cubeOfFace;
				col.body1 = cubeOfVertex;
				col.pos = getClosestVertex(cubeOfVertex, cubeOfFace);
				col.normal = cubeOfFace.getOrientation().getAxis(minPenetrationIndex%3);
				if(col.normal.dot(cubeOfVertex.getCenter().getSubbed(cubeOfFace.getCenter())) < 0) col.normal.scale(-1);
			}
			else //edges of both
			{
				var axis0:Vec4;
				var pointsOnEdges:Vector.<Vec4> = new Vector.<Vec4>(4); 
				if(minPenetrationIndex < 9)
				{
					axis0 = new Vec4(1,0,0,0);
					pointsOnEdges[0] = new Vec4(0, cube0.hh, cube0.hd);
					pointsOnEdges[1] = new Vec4(0, cube0.hh, -cube0.hd);
					pointsOnEdges[2] = new Vec4(0, -cube0.hh, cube0.hd);
					pointsOnEdges[3] = new Vec4(0, -cube0.hh, -cube0.hd);
				}
				else if(minPenetrationIndex < 12)
				{
					axis0 = new Vec4(0,1,0,0);
					pointsOnEdges[0] = new Vec4(cube0.hw, 0, cube0.hd);
					pointsOnEdges[1] = new Vec4(cube0.hw, 0, -cube0.hd);
					pointsOnEdges[2] = new Vec4(-cube0.hw, 0, cube0.hd);
					pointsOnEdges[3] = new Vec4(-cube0.hw, 0, -cube0.hd);
				}
				else
				{
					axis0 = new Vec4(0,0,1,0);
					pointsOnEdges[0] = new Vec4(cube0.hw, cube0.hh, 0);
					pointsOnEdges[1] = new Vec4(cube0.hw, -cube0.hh, 0);
					pointsOnEdges[2] = new Vec4(-cube0.hw, cube0.hh, 0);
					pointsOnEdges[3] = new Vec4(-cube0.hw, -cube0.hh, 0);
				}
				
				var midPointOnEdge0:Vec4;
				var minDist2:Number = Number.MAX_VALUE;
				var transformMat0:Mat4 = cube0.getTransformMat();
				for(i=0; i<4; i++)
				{
					var pointOnEdge:Vec4 = pointsOnEdges[i];
					transformMat0.transform(pointOnEdge);
					var dist2:Number = pointOnEdge.getSubbed(cube1.getCenter()).lengthSquared();
					if(dist2 < minDist2)
					{
						midPointOnEdge0 = pointOnEdge;
						minDist2 = dist2;
					}
				}
				transformMat0.transform(axis0);
				
				var axis1:Vec4;
				if(minPenetrationIndex%3 == 0)
				{
					axis1 = new Vec4(1,0,0,0);
					pointsOnEdges[0] = new Vec4(0, cube1.hh, cube1.hd);
					pointsOnEdges[1] = new Vec4(0, cube1.hh, -cube1.hd);
					pointsOnEdges[2] = new Vec4(0, -cube1.hh, cube1.hd);
					pointsOnEdges[3] = new Vec4(0, -cube1.hh, -cube1.hd);
				}
				if(minPenetrationIndex%3 == 1)
				{
					axis1 = new Vec4(0,1,0,0);
					pointsOnEdges[0] = new Vec4(cube1.hw, 0, cube1.hd);
					pointsOnEdges[1] = new Vec4(cube1.hw, 0, -cube1.hd);
					pointsOnEdges[2] = new Vec4(-cube1.hw, 0, cube1.hd);
					pointsOnEdges[3] = new Vec4(-cube1.hw, 0, -cube1.hd);
				}
				else
				{
					axis1 = new Vec4(0,0,1,0);
					pointsOnEdges[0] = new Vec4(cube1.hw, cube1.hh, 0);
					pointsOnEdges[1] = new Vec4(cube1.hw, -cube1.hh, 0);
					pointsOnEdges[2] = new Vec4(-cube1.hw, cube1.hh, 0);
					pointsOnEdges[3] = new Vec4(-cube1.hw, -cube1.hh, 0);
				}
				
				var midPointOnEdge1:Vec4;
				minDist2 = Number.MAX_VALUE;
				var transformMat1:Mat4 = cube1.getTransformMat();
				for(i=0; i<4; i++)
				{
					pointOnEdge = pointsOnEdges[i];
					transformMat1.transform(pointOnEdge);
					dist2 = pointOnEdge.getSubbed(cube0.getCenter()).lengthSquared();
					if(dist2 < minDist2)
					{
						midPointOnEdge1 = pointOnEdge;
						minDist2 = dist2;
					}
				}
				transformMat1.transform(axis1);
				
				col.body0 = cube0;
				col.body1 = cube1;
				col.pos = getMidPointBetweenLines(axis0, midPointOnEdge0, axis1, midPointOnEdge1);
				col.normal = axis0.cross(axis1);
				if(col.normal.dot(col.body1.getCenter().getSubbed(col.body0.getCenter())) < 0) col.normal.scale(-1);
				col.normal.normalize();
			}
			
			var dv:Vec4 = cube0.getLinVel().getSubbed(cube1.getLinVel());
			col.closingSpeed2 = dv.lengthSquared();
			
			return col;
		}
		
		
		private function getLimits1D(cube:CubeBody, axis:Vec4):Point
		{
			var i:int;
			
			var transformMat:Mat4 = cube.getTransformMat();
			
			var vertices:Vector.<Vec4> = new <Vec4>[ new Vec4(cube.hw, cube.hh, cube.hd),
				new Vec4(cube.hw, cube.hh, -cube.hd),
				new Vec4(cube.hw, -cube.hh, cube.hd),
				new Vec4(cube.hw, -cube.hh, -cube.hd),
				new Vec4(-cube.hw, cube.hh, cube.hd),
				new Vec4(-cube.hw, cube.hh, -cube.hd),
				new Vec4(-cube.hw, -cube.hh, cube.hd),
				new Vec4(-cube.hw, -cube.hh, -cube.hd)];
			
			var min:Number = Number.MAX_VALUE;
			var max:Number = -Number.MAX_VALUE;
			for(i=0; i<8; i++)
			{
				var vertex:Vec4 = vertices[i];
				transformMat.transform(vertex);
				var value1D:Number = axis.dot(vertex);
				
				if(value1D < min) min = value1D;
				if(value1D > max) max = value1D;
			}
			
			return new Point(min,max);
		}
		
		private function getClosestVertex(cubeOfVertex:CubeBody, cubeOfFace:CubeBody):Vec4
		{
			var i:int;
			
			var transformMat:Mat4 = cubeOfVertex.getTransformMat();
			
			var vertices:Vector.<Vec4> = new <Vec4>[ new Vec4(cubeOfVertex.hw, cubeOfVertex.hh, cubeOfVertex.hd),
				new Vec4(cubeOfVertex.hw, cubeOfVertex.hh, -cubeOfVertex.hd),
				new Vec4(cubeOfVertex.hw, -cubeOfVertex.hh, cubeOfVertex.hd),
				new Vec4(cubeOfVertex.hw, -cubeOfVertex.hh, -cubeOfVertex.hd),
				new Vec4(-cubeOfVertex.hw, cubeOfVertex.hh, cubeOfVertex.hd),
				new Vec4(-cubeOfVertex.hw, cubeOfVertex.hh, -cubeOfVertex.hd),
				new Vec4(-cubeOfVertex.hw, -cubeOfVertex.hh, cubeOfVertex.hd),
				new Vec4(-cubeOfVertex.hw, -cubeOfVertex.hh, -cubeOfVertex.hd)];
			
			for(i=0; i<8; i++) transformMat.transform(vertices[i]);
			
			var cubeOfFaceCenter:Vec4 = cubeOfFace.getCenter();
			var closestVertex:Vec4;
			var minDist2:Number = Number.MAX_VALUE; //minimum distance squared
			for(i=0; i<8; i++)
			{
				var dist2:Number = cubeOfFaceCenter.getSubbed(vertices[i]).lengthSquared();
				if(dist2 < minDist2)
				{
					closestVertex = vertices[i];
					minDist2 = dist2;
				}
			}
			
			return closestVertex;
		}
		
		private function getMidPointBetweenLines(axis0:Vec4, p0:Vec4, axis1:Vec4, p1:Vec4):Vec4
		{
			var dp:Vec4 = p0.getSubbed(p1);
			
			var dpp0:Number = axis0.dot(dp);
			var dpp1:Number = axis1.dot(dp);
			
			var sm0:Number = axis0.lengthSquared();
			var sm1:Number = axis1.lengthSquared();
			var dotEdges:Number = axis0.dot(axis1);
			var denom:Number = sm0 * sm1 - dotEdges*dotEdges;
			var a:Number = (dotEdges * dpp1 - sm1 * dpp0) / denom;
			var b:Number = (sm0 * dpp1 - dotEdges * dpp0) / denom;
			
			var nearest0:Vec4 = p0.getAdded(axis0.getScaled(a));
			var nearest1:Vec4 = p1.getAdded(axis1.getScaled(b));
			var mid:Vec4 = nearest0.getScaled(0.5).getAdded(nearest1.getScaled(0.5));
			
			return mid;
		}
		
		private function getMostSeverePosCollision(cols:Vector.<Collision>):Collision
		{
			var i:int, l:int;
			
			var maxPenetration:Number = 0;
			var mostSevereCol:Collision;
			for(i=0, l=cols.length; i<l; i++)
			{
				var col:Collision = cols[i];
				if(col.penetration > maxPenetration)
				{
					maxPenetration = col.penetration;
					mostSevereCol = col;
				}
			}
			
			return col;
		}
		
		private function handleColPos(col:Collision):void
		{
			var totalInvMass:Number = col.body0.getInvMass() + col.body1.getInvMass();
			var move0:Vec4 = col.normal.getScaled(-col.penetration * col.body0.getInvMass() / totalInvMass);
			var move1:Vec4 = col.normal.getScaled(col.penetration * col.body1.getInvMass() / totalInvMass);
			col.body0.translate(move0);
			col.body1.translate(move1);
			col.penetration = 0;
		}
		
		private function getMostSevereVelCollision(cols:Vector.<Collision>):Collision
		{
			var i:int, l:int;
			
			var maxClosingSpeed:Number = 0;
			var mostSevereCol:Collision;
			for(i=0, l=cols.length; i<l; i++)
			{
				var col:Collision = cols[i];
				if(col.closingSpeed2 > maxClosingSpeed)
				{
					maxClosingSpeed = col.closingSpeed2;
					mostSevereCol = col;
				}
			}
			
			return col;
		}
		
		private function handleColVel(col:Collision):void
		{
			var vel0:Vec4 = col.body0.getVelAtPoint(col.pos);
			var vel1:Vec4 = col.body1.getVelAtPoint(col.pos);
			
			var normalSpeed0:Number = col.normal.dot(vel0);
			var normalSpeed1:Number = col.normal.dot(vel1);
			var closingSpeed:Number = normalSpeed0-normalSpeed1;
			if(closingSpeed < 0) return;
			var desiredSpeedChange:Number = -(1 + RESTITUTION) * closingSpeed;
			
			var velChangePerImpulse0:Vec4 = col.body0.getVelAtPointChangePerImpulse(col.normal.getScaled(-1), col.pos);
			var velChangePerImpulse1:Vec4 = col.body0.getVelAtPointChangePerImpulse(col.normal, col.pos);
			var closingSpeedChangePerImpulse:Number = col.normal.dot(velChangePerImpulse0) - col.normal.dot(velChangePerImpulse1);
			
			var imp:Vec4 = col.normal.getScaled(desiredSpeedChange / closingSpeedChangePerImpulse);
			
			col.body0.applyImpulse(imp.getScaled(-1), col.pos);
			col.body1.applyImpulse(imp, col.pos);
		}
	}
}