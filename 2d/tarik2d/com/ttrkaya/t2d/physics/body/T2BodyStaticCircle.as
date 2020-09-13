package com.ttrkaya.t2d.physics.body
{
	import com.ttrkaya.t2d.geom.T2Circle;
	import com.ttrkaya.t2d.geom.T2Vec;

	public class T2BodyStaticCircle extends T2Body
	{
		private var _circle:T2Circle;
		
		public function T2BodyStaticCircle(circle:T2Circle)
		{
			super();
			
			_circle = circle;
		}
		
		public function get x():Number { return _circle.center.x }
		public function get y():Number { return _circle.center.y }
		public function get r():Number { return _circle.r }
		
		public function getTimeOfCollisionWithDynamicCircle(dynamicCircle:T2BodyDynamicCircle):Number
		{
			var ct:Number = -1;	
			
			var dx:Number = dynamicCircle.x - _circle.center.x;
			var dy:Number = dynamicCircle.y - _circle.center.y;
			var tr:Number = dynamicCircle.r + _circle.r;
			
			var a:Number = dynamicCircle.velX*dynamicCircle.velX + dynamicCircle.velY*dynamicCircle.velY;
			var b:Number = 2 * (dx * dynamicCircle.velX + dy * dynamicCircle.velY);
			var c:Number = dx*dx + dy*dy - tr*tr;
			
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