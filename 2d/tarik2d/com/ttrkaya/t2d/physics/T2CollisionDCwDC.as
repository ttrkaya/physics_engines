package com.ttrkaya.t2d.physics
{
	import com.ttrkaya.t2d.geom.T2Vec;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;

	//collision between dynamic circles
	internal class T2CollisionDCwDC implements T2Collision
	{
		private var _circle0:T2BodyDynamicCircle;
		private var _circle1:T2BodyDynamicCircle;
		
		public function T2CollisionDCwDC(circle0:T2BodyDynamicCircle, circle1:T2BodyDynamicCircle)
		{
			_circle0 = circle0;
			_circle1 = circle1;
		}
		
		public function resolve():void
		{
			var tr:Number = _circle0.r + _circle1.r
			var sin:Number = (_circle1.x - _circle0.x) / tr;
			var cos:Number = (_circle0.y - _circle1.y) / tr;
			
			//rotated velocities
			var w1:T2Vec = new T2Vec(_circle0.velX*cos + _circle0.velY*sin,
				_circle0.velY*cos - _circle0.velX*sin);
			var w2:T2Vec = new T2Vec(_circle1.velX*cos + _circle1.velY*sin,
				_circle1.velY*cos - _circle1.velX*sin);
			
			var tm:Number = _circle0.mass + _circle1.mass;
			var m1Ratio:Number = _circle0.mass / tm;
			var m2Ratio:Number = _circle1.mass / tm;
			
			//collided rotated velocities
			var wa1:T2Vec = new T2Vec(w1.x,0);
			var wa2:T2Vec = new T2Vec(w2.x,0);
			wa1.y = (m1Ratio-m2Ratio)*w1.y + 2*m2Ratio*w2.y;
			wa2.y = (m2Ratio-m1Ratio)*w2.y + 2*m1Ratio*w1.y;
			
			//collided velocities
			_circle0.velX = wa1.x*cos - wa1.y*sin;
			_circle0.velY = wa1.y*cos + wa1.x*sin;
			
			_circle1.velX = wa2.x*cos - wa2.y*sin;
			_circle1.velY = wa2.y*cos + wa2.x*sin;
			
			_circle0.addToCollisionList(_circle1);
			_circle1.addToCollisionList(_circle0);
		}
	}
}