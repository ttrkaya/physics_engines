package com.ttrkaya.rigid2d.phys
{
	public class RiBodyCircle extends RiBody
	{
		private var _r:Number;
		
		public function RiBodyCircle(r:Number, density:Number, x:Number, y:Number, 
									 restitution:Number, friction:Number, linDrag:Number, angDrag:Number)
		{
			var mass:Number = density * Math.PI * r * r;
			var inertia:Number = density * Math.PI * r*r*r*r / 2;
			
			super(x, y, 1/mass, 1/inertia, restitution, friction, linDrag, angDrag);
			_type = RiBodyTypes.CIRCLE;
			
			_r = r;
		}
		
		public function getR():Number { return _r; }
	}
}