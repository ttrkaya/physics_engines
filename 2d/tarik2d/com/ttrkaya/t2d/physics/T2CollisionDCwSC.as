package com.ttrkaya.t2d.physics
{
	import com.ttrkaya.t2d.geom.T2Vec;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticCircle;

	public class T2CollisionDCwSC implements T2Collision
	{
		private var _dynamicCirle:T2BodyDynamicCircle;
		private var _staticCircle:T2BodyStaticCircle;
		
		public function T2CollisionDCwSC(dynamicCirle:T2BodyDynamicCircle, staticCircle:T2BodyStaticCircle)
		{
			_dynamicCirle = dynamicCirle;
			_staticCircle = staticCircle;
		}
		
		public function resolve():void
		{
			var tr:Number = _dynamicCirle.r + _staticCircle.r;
			var sin:Number = (_staticCircle.x - _dynamicCirle.x) / tr;
			var cos:Number = (_dynamicCirle.y - _staticCircle.y) / tr;
			
			//rotated velocity
			var w:T2Vec = new T2Vec(_dynamicCirle.velX*cos + _dynamicCirle.velY*sin,
				_dynamicCirle.velY*cos - _dynamicCirle.velX*sin);
			
			//collided rotated velocity
			w.y = -w.y;
			
			//collided velocity
			_dynamicCirle.velX = w.x*cos - w.y*sin;
			_dynamicCirle.velY = w.y*cos + w.x*sin;
			
			_dynamicCirle.addToCollisionList(_staticCircle);
		}
	}
}