package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiGeomUtils;
	import com.ttrkaya.rigid2d.geom.RiVec;

	public class RiBodyPolygon extends RiBody
	{
		protected var _vertices:Vector.<RiVec>;
		protected var _dirs:Vector.<RiVec>;
		
		private static const DIR_SAME_TOLERANCE:Number = 0.000001;
		
		public function RiBodyPolygon(vertices:Vector.<RiVec>, density:Number, 
									  restitution:Number, friction:Number, linDrag:Number, angDrag:Number)
		{
			var i:int, j:int;
			var l:int = vertices.length;
			
			var geomCenter:RiVec = RiGeomUtils.getAverage(vertices);
			
			var mass:Number = 0;
			var centerOfMass:RiVec = new RiVec(0, 0);
			var triangleCenters:Vector.<RiVec> = new Vector.<RiVec>(l);
			var triangleMasses:Vector.<Number> = new Vector.<Number>(l);
			for(i=0, l=vertices.length; i<l; i++)
			{
				var area:Number = RiGeomUtils.getTriangleArea(geomCenter, vertices[i], vertices[(i+1)%l]);
				var triangleMass:Number = area * density;
				mass += triangleMass;
				
				var triangleCenter:RiVec = RiGeomUtils.getCenterOfTriangle(geomCenter, vertices[i], vertices[(i+1)%l]);
				centerOfMass.addScaled(triangleCenter, triangleMass);
				triangleCenters[i] = triangleCenter;
				triangleMasses[i] = triangleMass;
			}
			centerOfMass.scale(1/mass);
			
			var inertia:Number = 0;
			for(i=0; i<l; i++)
			{
				var triangleInertia:Number = getMomentOfInertiaOfTriangle(geomCenter, vertices[i], vertices[(i+1)%l]);
				var d2:Number = triangleCenters[i].getSubbed(centerOfMass).getLengthSquared();
				inertia += triangleInertia + triangleMasses[i] * d2;
			}
			inertia *= density;
			
			_vertices = new Vector.<RiVec>(l);
			for(i=0; i<l; i++)
			{
				_vertices[i] = vertices[i].getSubbed(centerOfMass);
			}
			
			super(centerOfMass.x, centerOfMass.y, 1/mass, 1/inertia, restitution, friction, linDrag, angDrag);
			_type = RiBodyTypes.POLYGON;
			
			_dirs = new Vector.<RiVec>;
			for(i=0; i<l; i++)
			{
				var newDir:RiVec = _vertices[(i+1)%l].getSubbed(_vertices[i]);
				newDir.orthogonalize();
				newDir.normalize();
				
				var isSameWithAnotherDir:Boolean = false;
				for(j=0; j<_dirs.length; j++)
				{
					if(Math.abs(newDir.cross(_dirs[j])) < DIR_SAME_TOLERANCE)
					{
						isSameWithAnotherDir = true;
						break;
					}
				}
				
				if(!isSameWithAnotherDir) _dirs.push(newDir);
			}
		}
		
		public function getLocalVertices():Vector.<RiVec>
		{
			return _vertices;
		}
		
		public function getGlobalVertices():Vector.<RiVec>
		{
			var i:int;
			var l:int = _vertices.length;
			
			var sin:Number = Math.sin(_orientation);
			var cos:Number = Math.cos(_orientation);
			
			var globalVertices:Vector.<RiVec> = new Vector.<RiVec>(l);
			for(i=0; i<l; i++)
			{
				var localVertex:RiVec = _vertices[i];
				var globalVertex:RiVec = new RiVec(
					cos*localVertex.x - sin*localVertex.y + _center.x,
					cos*localVertex.y + sin*localVertex.x + _center.y );
				globalVertices[i] = globalVertex;
			}
			
			return globalVertices;
		}
		
		public function getLocalDirs():Vector.<RiVec>
		{
			return _dirs;
		}
		
		public function getGlobalDirs():Vector.<RiVec>
		{
			var i:int;
			var l:int = _dirs.length;
			
			var sin:Number = Math.sin(_orientation);
			var cos:Number = Math.cos(_orientation);
			
			var globalDirs:Vector.<RiVec> = new Vector.<RiVec>(l);
			for(i=0; i<l; i++)
			{
				var localDir:RiVec = _dirs[i];
				var globalDir:RiVec = new RiVec(
					cos*localDir.x - sin*localDir.y,
					cos*localDir.y + sin*localDir.x);
				globalDirs[i] = globalDir;
			}
			
			return globalDirs;
		}
		
		private function getMomentOfInertiaOfTriangle(v0:RiVec, v1:RiVec, v2:RiVec):Number
		{
			var dir:RiVec = v1.getSubbed(v0);
			var u:Number = v2.getSubbed(v0).dot(dir)/dir.getLengthSquared();
			var vh:RiVec = v0.getAddedScaled(dir, u);
			
			var a:Number = dir.getScaled(u).getLength();
			
			var h:Number = vh.getSubbed(v2).getLength();
			
			var b:Number = dir.getLength();
			
			var inertia:Number = b*b*b*h - b*b*h*a + b*h*a*a + b*h*h*h;
			inertia /= 36;
			
			return inertia;
		}
	}
}