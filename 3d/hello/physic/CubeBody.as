package physic
{
	import math.Mat4;
	import math.Vec4;

	public class CubeBody extends PhysicalObject
	{
		private var _halfSize:Vec4;
		
		public function CubeBody(halfSize:Vec4)
		{
			super();
			
			_halfSize = halfSize;
			_halfSize.s = 0;
			
			_invMass = 8 * _halfSize.x * _halfSize.y * _halfSize.z;
			_invMass = 1/_invMass;
			
			_invInertiaTensor = new Mat4(3*_invMass/(_halfSize.y*_halfSize.y + _halfSize.z*_halfSize.z),0,0,0,
										0,3*_invMass/(_halfSize.x*_halfSize.x + _halfSize.z*_halfSize.z),0,0,
										0,0,3*_invMass/(_halfSize.x*_halfSize.x + _halfSize.y*_halfSize.y),0);
		}
		
		public function get hw():Number { return _halfSize.x; }
		public function get hh():Number { return _halfSize.y; }
		public function get hd():Number { return _halfSize.z; }
	}
}