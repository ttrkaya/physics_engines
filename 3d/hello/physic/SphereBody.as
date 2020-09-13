package physic
{
	import math.Mat4;

	public class SphereBody extends PhysicalObject
	{
		private var _r:Number
		
		public function SphereBody(r:Number)
		{
			super();
			
			_r = r;
			
			_invMass = (4/3) * Math.PI * r*r*r;
			_invMass = 1 / _invMass;
			
			_invInertiaTensor = new Mat4(5*_invMass/(2*r*r),0,0,0,
										0,5*_invMass/(2*r*r),0,0,
										0,0,5*_invMass/(2*r*r),0);
		}
		
		public function getR():Number { return _r; }
	}
}