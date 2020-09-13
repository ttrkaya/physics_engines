package com.ttrkaya.t2d.physics
{
	import com.ttrkaya.t2d.geom.T2Vec;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticLine;
	
	public class T2CollisionDCwL implements T2Collision
	{
		private var _line:T2BodyStaticLine;
		private var _circle:T2BodyDynamicCircle;
		
		public function T2CollisionDCwL(circle:T2BodyDynamicCircle, line:T2BodyStaticLine)
		{
			_line = line;
			_circle = circle;
		}
		
		public function resolve():void
		{
			var response:T2Vec = _line.normal.getMagnified(2*(_line.normal.x*_circle.velX + _line.normal.y*_circle.velY));
			_circle.velX -= response.x;
			_circle.velY -= response.y;
			
			_circle.addToCollisionList(_line);
		}
	}
}