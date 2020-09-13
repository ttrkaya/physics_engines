package com.ttrkaya.t2d.physics
{
	import com.ttrkaya.t2d.geom.T2Vec;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticPoint;

	public class T2CollisionDCwP implements T2Collision
	{
		private var _circle:T2BodyDynamicCircle;
		private var _point:T2BodyStaticPoint;
		
		public function T2CollisionDCwP(circle:T2BodyDynamicCircle, point:com.ttrkaya.t2d.physics.body.T2BodyStaticPoint)
		{
			_circle = circle;
			_point = point;
		}
		
		public function resolve():void
		{
			var sin:Number = (_point.x - _circle.x) / _circle.r;
			var cos:Number = (_circle.y - _point.y) / _circle.r;
			
			//rotated velocity
			var w:T2Vec = new T2Vec(_circle.velX*cos + _circle.velY*sin,
				_circle.velY*cos - _circle.velX*sin);
			
			//collided rotated velocity
			w.y = -w.y;
			
			//collided velocity
			_circle.velX = w.x*cos - w.y*sin;
			_circle.velY = w.y*cos + w.x*sin;
			
			_circle.addToCollisionList(_point);
		}
	}
}