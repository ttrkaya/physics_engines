package com.ttrkaya.t2d.physics.body
{
	import com.ttrkaya.t2d.geom.T2Circle;
	import com.ttrkaya.t2d.geom.T2Vec;

	public class T2BodyDynamicCircle extends T2Body
	{
		private var _circle:T2Circle;
		private var _mass:Number;
		private var _friction:Number;
		private var _vel:T2Vec;
		private var _collisionList:Vector.<T2Body>;
		
		public function T2BodyDynamicCircle(circle:T2Circle, mass:Number, friction:Number, vel:T2Vec = null)
		{
			super();
			
			_circle = circle;
			_mass = mass;
			_friction = friction;
			_vel = vel ? vel : new T2Vec();
			_collisionList = new Vector.<T2Body>;
		}
		
		public function get x():Number { return _circle.center.x; }
		public function get y():Number { return _circle.center.y; }
		public function get velX():Number { return _vel.x; }
		public function get velY():Number { return _vel.y; }
		public function set x(value:Number):void { _circle.center.x = value; }
		public function set y(value:Number):void { _circle.center.y = value; }
		public function set velX(value:Number):void { _vel.x = value; }
		public function set velY(value:Number):void { _vel.y = value; }
		public function get r():Number { return _circle.r; }
		public function get mass():Number { return _mass; }
		
		public function clearCollisionList():void { _collisionList.length = 0; }
		public function addToCollisionList(body:T2Body):void {_collisionList.push(body); }
		public function get collisionList():Vector.<T2Body> { return _collisionList; }
		
		public function updatePoisition(dt:Number):void
		{
			_circle.center.x += _vel.x * dt;
			_circle.center.y += _vel.y * dt;
		}
		
		public function updateVelocity(dt:Number):void
		{
			_vel.magnify(Math.pow(_friction, dt));			
		}

		public function getTimeOfCollisionWithDynamicCircle(otherCircle:T2BodyDynamicCircle):Number
		{
			var ct:Number = -1;	
			
			var dx:Number = otherCircle.x - _circle.center.x;
			var dy:Number = otherCircle.y - _circle.center.y;
			var dVelX:Number = otherCircle.velX - _vel.x;
			var dVelY:Number = otherCircle.velY - _vel.y;
			var tr:Number = otherCircle.r + _circle.r;
			
			var a:Number = dVelX*dVelX + dVelY*dVelY;
			var b:Number = 2 * (dx * dVelX + dy * dVelY);
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