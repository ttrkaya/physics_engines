package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiGeomUtils;
	import com.ttrkaya.rigid2d.geom.RiVec;
	
//	import com.ttrkaya.rigid2d.test.RiTester;
//	import flash.display.Shape;

	public class RiCollisionDetector
	{
		public function RiCollisionDetector()
		{
			
		}
		
		public function getCollisions(bodies:Vector.<RiBody>):Vector.<RiCollision>
		{
			var i:int, j:int, l:int;
			
			var collisions:Vector.<RiCollision> = new Vector.<RiCollision>;
			l = bodies.length;
			for(i=0; i<l; i++)
			{
				var body0:RiBody = bodies[i];
				for(j=i+1; j<l; j++)
				{
					var body1:RiBody = bodies[j];
					var col:RiCollision = getCollision(body0, body1);
					if(col)
					{
						collisions.push(col);
					}
					
					//ACHTUNG! delete
//					if(col)
//					{
//						var line:Shape = new Shape();
//						line.graphics.lineStyle(1, 0xff0000);
//						line.graphics.drawCircle(0,0,3);
//						line.graphics.moveTo(0,0);
//						const C:Number = 10;
//						line.graphics.lineTo(col.normal.x  * col.penetration, col.normal.y  * col.penetration);
//						line.x = col.pos.x;
//						line.y = col.pos.y;
//												
//						MainRigid2D._stage.addChild(line);
//					}
				}
			}
			
			return collisions;
		}
		
		public function getCollision(body0:RiBody, body1:RiBody):RiCollision
		{
			var type0:uint = body0.getType();
			var type1:uint = body1.getType();
			var type:uint = RiCollisionTypes.get(type0, type1);
			var col:RiCollision;
			switch(type)
			{
				case RiCollisionTypes.CIRCLE_CIRCLE:
					col = getCollisionCircleCircle(body0 as RiBodyCircle, body1 as RiBodyCircle);
					break;
				
				case RiCollisionTypes.POLY_POLY:
					col = getCollisionPolyPoly(body0 as RiBodyPolygon, body1 as RiBodyPolygon);
					break;
				
				case RiCollisionTypes.CIRCLE_POLY:
					col = getCollisionCirclePoly(body0 as RiBodyCircle, body1 as RiBodyPolygon);
					break;
				case RiCollisionTypes.POLY_CIRCLE:
					col = getCollisionCirclePoly(body1 as RiBodyCircle, body0 as RiBodyPolygon);
					break;
				
				case RiCollisionTypes.SPOLY_POLY:
					col = getCollisionPolyPoly(body0 as RiBodyPolygon, body1 as RiBodyPolygon);
					break;
				case RiCollisionTypes.POLY_SPOLY:
					col = getCollisionPolyPoly(body1 as RiBodyPolygon, body0 as RiBodyPolygon);
					break;
				
				case RiCollisionTypes.SPOLY_CIRCLE:
					col = getCollisionCirclePoly(body1 as RiBodyCircle, body0 as RiBodyPolygon);
					break;
				case RiCollisionTypes.CIRCLE_SPOLY:
					col = getCollisionCirclePoly(body0 as RiBodyCircle, body1 as RiBodyPolygon);
					break;
				
				case RiCollisionTypes.SCIRCLE_POLY:
					col = getCollisionCirclePoly(body0 as RiBodyCircle, body1 as RiBodyPolygon);
					break;
				case RiCollisionTypes.POLY_SCIRCLE:
					col = getCollisionCirclePoly(body1 as RiBodyCircle, body0 as RiBodyPolygon);
					break;
				
				case RiCollisionTypes.SCIRCLE_CIRCLE:
					col = getCollisionCircleCircle(body0 as RiBodyCircle, body1 as RiBodyCircle);
					break;
				case RiCollisionTypes.CIRCLE_SCIRCLE:
					col = getCollisionCircleCircle(body1 as RiBodyCircle, body0 as RiBodyCircle);
					break;
			}
			return col;
		}
		
		private function getCollisionCircleCircle(body0:RiBodyCircle, body1:RiBodyCircle):RiCollision
		{
			var r0:Number = body0.getR();
			var r1:Number = body1.getR();
			var tr:Number = r0 + r1;
			
			var x0:Number = body0.getPosX();
			var y0:Number = body0.getPosY();
			var x1:Number = body1.getPosX();
			var y1:Number = body1.getPosY();
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			
			if(dx*dx+dy*dy > tr*tr) return null;
			
			var col:RiCollision = new RiCollision();
			col.body0 = body0;
			col.body1 = body1;
			
			var d:Number = Math.sqrt(dx*dx + dy*dy);
			var penetration:Number = tr - d;
			col.penetration = penetration;
			
			var normal:RiVec = new RiVec(dx/d, dy/d);
			col.normal = normal;
			
			col.pos = new RiVec(x0 + normal.x * (r0 - penetration/2), y0 + normal.y * (r0 - penetration/2));
			
			return col;
		}
		
		private function getCollisionCirclePoly(bodyCircle:RiBodyCircle, bodyPoly:RiBodyPolygon):RiCollision
		{
			var i:int, l:int;
			
			var circlePos:RiVec = bodyCircle.getPos();
			var circleR:Number = bodyCircle.getR();
			
			var polyPos:RiVec = bodyPoly.getPos();
			var globalVertices:Vector.<RiVec> = bodyPoly.getGlobalVertices();
			
			var isCircleCenterInsidePoly:Boolean = RiGeomUtils.isPointInsidePolygon(circlePos, globalVertices);
			var isPolyCenterInsideCircle:Boolean = (polyPos.getSubbed(circlePos).getLengthSquared() < circleR*circleR);
			var isAnyInsideOther:Boolean = isCircleCenterInsidePoly || isPolyCenterInsideCircle;
			
			var closestPoint:RiVec;
			var closestDist2:Number = Number.MAX_VALUE;
			for(i=0, l=globalVertices.length; i<l; i++)
			{
				var vertex:RiVec = globalVertices[i];
				
				var vertexDist2:Number = vertex.getSubbed(circlePos).getLengthSquared();
				if(vertexDist2 < closestDist2)
				{
					closestDist2 = vertexDist2;
					closestPoint = vertex;
				}
				
				var vertexNext:RiVec = globalVertices[(i+1)%l];
				var edgeDir:RiVec = vertexNext.getSubbed(vertex);
				
				var projectionRatio:Number = 
					((circlePos.x - vertex.x) * edgeDir.x + (circlePos.y - vertex.y) * edgeDir.y) 
					/ edgeDir.getLengthSquared();
				
				if(projectionRatio > 0 && projectionRatio < 1)
				{
					var closestPointOnEdge:RiVec = vertex.getAdded(edgeDir.getScaled(projectionRatio));
					var edgeDist2:Number = closestPointOnEdge.getSubbed(circlePos).getLengthSquared();
					if(edgeDist2 < closestDist2)
					{
						closestDist2 = edgeDist2;
						closestPoint = closestPointOnEdge;
					}
				}
			}
			
			if(closestDist2 > circleR*circleR && !isAnyInsideOther) return null;

			var col:RiCollision = new RiCollision();
			col.body0 = bodyPoly;
			col.body1 = bodyCircle;
			col.pos = closestPoint;
			
			col.normal = circlePos.getSubbed(closestPoint);
			var dist:Number = col.normal.getLength();
			col.normal.normalize();
			
			if(isCircleCenterInsidePoly) col.normal.scale( -1);
			
			col.penetration = circleR;
			if (isCircleCenterInsidePoly) col.penetration += dist;
			else col.penetration -= dist;
			
			return col;
		}
		
		private function getCollisionPolyPoly(body0:RiBodyPolygon, body1:RiBodyPolygon):RiCollision
		{
			var i:int;
			
			var vertices0:Vector.<RiVec> = body0.getGlobalVertices();
			var vertices1:Vector.<RiVec> = body1.getGlobalVertices();
			l0 = vertices0.length;
			l1 = vertices1.length;
			
			var isColPolyOfEdgeFirst:Boolean;
			var colDir:RiVec;
			var minPenetration:Number = Number.MAX_VALUE;
			var colVertexIndex:int = -1;
			
			var dirs0:Vector.<RiVec> = body0.getGlobalDirs();
			var l0:int = dirs0.length;
			for(i=0; i<l0; i++)
			{
				var dir0:RiVec = dirs0[i];
				var range00:RiRange1D = getRangeInDir(vertices0, dir0);
				var range01:RiRange1D = getRangeInDir(vertices1, dir0);
				
				if(range00.max < range01.min || range01.max < range00.min)
				{
					minPenetration = -1;
					break;
				}
				
				var penetration0:Number;
				var currColVertexIndex0:int;
				if(range00.min < range01.min)
				{
					penetration0 = range00.max - range01.min;
					currColVertexIndex0 = range01.minVertexIndex;
				}
				else
				{
					penetration0 = range01.max - range00.min;
					currColVertexIndex0 = range01.maxVertexIndex;
				}
				
				if(penetration0 < minPenetration)
				{
					minPenetration = penetration0;
					isColPolyOfEdgeFirst = true;
					colDir = dir0;
					colVertexIndex = currColVertexIndex0;
				}
			}
			
			if(minPenetration < 0) return null;
			
			var dirs1:Vector.<RiVec> = body1.getGlobalDirs();
			var l1:int = dirs1.length;
			for(i=0; i<l1; i++)
			{
				var dir1:RiVec = dirs1[i];
				var range10:RiRange1D = getRangeInDir(vertices0, dir1);
				var range11:RiRange1D = getRangeInDir(vertices1, dir1);
				
				if(range10.max < range11.min || range11.max < range10.min)
				{
					minPenetration = -1;
					break;
				}
				
				var penetration1:Number;
				var currColVertexIndex1:int;
				if(range10.min < range11.min)
				{
					penetration1 = range10.max - range11.min;
					currColVertexIndex1 = range10.maxVertexIndex;
				}
				else
				{
					penetration1 = range11.max - range10.min;
					currColVertexIndex1 = range10.minVertexIndex;
				}
				
				if(penetration1 < minPenetration)
				{
					minPenetration = penetration1;
					isColPolyOfEdgeFirst = false;
					colDir = dir1;
					colVertexIndex = currColVertexIndex1;
				}
			}
			
			if(minPenetration < 0) return null;
			
			var col:RiCollision = new RiCollision();
			col.body0 = body0;
			col.body1 = body1;
			col.penetration = minPenetration;
			
			col.pos = isColPolyOfEdgeFirst ? vertices1[colVertexIndex] : vertices0[colVertexIndex];
			var polyOfVertexCenter:RiVec = isColPolyOfEdgeFirst ? body1.getPos() : body0.getPos();
			
			col.normal = colDir;
			
			var scale:Number = 1;
			if(col.pos.getSubbed(polyOfVertexCenter).dot(col.normal) < 0) scale *= -1;
			if(isColPolyOfEdgeFirst) scale *= -1;
			col.normal.scale(scale);

			return col;
		}
		
		private function getRangeInDir(poly:Vector.<RiVec>, dir:RiVec):RiRange1D
		{
			var i:int, l:int;
			
			var range:RiRange1D = new RiRange1D();
			range.min = Number.MAX_VALUE;
			range.max = -Number.MAX_VALUE;
			for(i=0, l=poly.length; i<l; i++)
			{
				var vertex:RiVec = poly[i];
				var proj:Number = vertex.x * dir.x + vertex.y * dir.y;
				if(proj < range.min)
				{
					range.min = proj;
					range.minVertexIndex = i;
				}
				if(proj > range.max)
				{
					range.max = proj;
					range.maxVertexIndex = i;
				}
			}
			return range;
		}
	}
}

class RiRange1D
{
	public var min:Number;
	public var max:Number;
	
	public var minVertexIndex:int;
	public var maxVertexIndex:int;
}