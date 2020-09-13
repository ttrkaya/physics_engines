package physic
{
	import math.Vec4;

	public class Collision
	{
		public var body0:PhysicalObject;
		public var body1:PhysicalObject;
		
		public var pos:Vec4;
		public var normal:Vec4;
		public var penetration:Number;
		
		public var closingSpeed2:Number;
		
		public function Collision()
		{
			
		}
	}
}