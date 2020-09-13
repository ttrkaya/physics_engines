package com.ttrkaya.t2d.geom
{
	public class T2Circle
	{
		public var center:T2Vec;
		public var r:Number;
		
		public function T2Circle(center:T2Vec = null, r:Number = 0)
		{
			this.center = center ? center : new T2Vec();
			this.r = r;
		}
		
		public function collidesWithCircle(c:T2Circle):Boolean
		{
			var dx:Number = center.x - c.center.x;
			var dy:Number = center.y - c.center.y;
			var tr:Number = r + c.r;
			
			return dx*dx + dy*dy < tr*tr;
		}
	}
}