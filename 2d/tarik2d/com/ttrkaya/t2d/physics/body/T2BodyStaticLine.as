package com.ttrkaya.t2d.physics.body
{
	import com.ttrkaya.t2d.geom.T2Line;
	import com.ttrkaya.t2d.geom.T2Vec;

	//IMPORTANT NOTE: one sided body, it only collides with the bodies coming from opposite of normal
	//If you want to have a line with two side colliding, create two lines with opposing normals
	
	public class T2BodyStaticLine extends T2Body
	{
		private var _line:T2Line;
		private var _normal:T2Vec;
		
		public function T2BodyStaticLine(line:T2Line, normal:T2Vec)
		{
			super();
			
			_line = line;
			_normal = normal;
		}
		
		public function getTimeOfCollisionWithCircle(c:T2BodyDynamicCircle):Number
		{
			var circleTip:T2Vec = new T2Vec(c.x - _normal.x*c.r, c.y - _normal.y*c.r);
			var circleVel:T2Vec = new T2Vec(c.velX, c.velY);
			var circlePath:T2Line = new T2Line(circleTip, circleTip.add(circleVel));
			
			return _line.getCollisionRatioWithInfiniteLine(circlePath);
		}
		
		
		public function get pointAX():Number { return _line.pointAX; }
		public function get pointAY():Number { return _line.pointAY; }
		public function get pointBX():Number { return _line.pointBX; }
		public function get pointBY():Number { return _line.pointBY; }
		public function get normal():T2Vec { return _normal; }
	}
}