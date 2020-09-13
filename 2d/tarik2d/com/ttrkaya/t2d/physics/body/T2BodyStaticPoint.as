package com.ttrkaya.t2d.physics.body
{
	import com.ttrkaya.t2d.geom.T2Vec;

	public class T2BodyStaticPoint extends T2Body
	{
		private var _pos:T2Vec;
		
		public function T2BodyStaticPoint(pos:com.ttrkaya.t2d.geom.T2Vec)
		{
			super();
			
			_pos = pos;
		}
		
		public function get x():Number { return _pos.x }
		public function get y():Number { return _pos.y }
		
		public function getTimeOfCollisionWithDynamicCircle(circle:T2BodyDynamicCircle):Number
		{
			var ct:Number = -1;	
			
			var dx:Number = circle.x - _pos.x;
			var dy:Number = circle.y - _pos.y;
			
			var a:Number = circle.velX*circle.velX + circle.velY*circle.velY;
			var b:Number = 2 * (dx * circle.velX + dy * circle.velY);
			var c:Number = dx*dx + dy*dy - circle.r*circle.r;
			
			if (a != 0) 
			{ 
				var det:Number = b*b - (4 * a * c);
				var t:Number = (-b - Math.sqrt(det)) / (2 * a);
				if (t >= 0) ct = t;
			}
			
			return ct; 
		}
	}
}