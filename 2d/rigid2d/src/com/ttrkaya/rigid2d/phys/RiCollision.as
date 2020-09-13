package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiVec;

	public class RiCollision
	{
		public var body0:RiBody;
		public var body1:RiBody;
		
		public var pos:RiVec;
		public var normal:RiVec; //from body0 to body1
		public var penetration:Number;
		
		public function copy(c:RiCollision):void
		{
			body0 = c.body0;
			body1 = c.body1;
			
			pos = c.pos;
			normal = c.normal;
			penetration = c.penetration;
		}
		
		public function update(collisionDetector:RiCollisionDetector):void
		{
			var newCol:RiCollision = collisionDetector.getCollision(body0, body1);
			if(newCol)
			{
				copy(newCol);
			}
			else
			{
				penetration = -1;
			}
		}
	}
	
}