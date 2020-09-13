package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiVec;

	public class RiWorld
	{
		private var _gravity:RiVec;
		
		private var _bodies:Vector.<RiBody>;
		private var _collisionDetector:RiCollisionDetector;
		private var _collisionResolver:RiCollisionResolver;
		
//		private static const MAX_LOOP_COUNT:int = 10;
		
		public function RiWorld(gravity:RiVec=null)
		{
			_gravity = gravity ? gravity : new RiVec(0,0);
			
			_bodies = new Vector.<RiBody>;
			_collisionDetector = new RiCollisionDetector();
			_collisionResolver = new RiCollisionResolver();
		}
		
		public function addBodyCircle(x:Number, y:Number, r:Number, density:Number=1, restitution:Number=0.5, 
									  friction:Number=0.2, linDrag:Number=0.9, angDrag:Number=0.9):RiBodyCircle
		{
			var body:RiBodyCircle = new RiBodyCircle(r, density, x, y, restitution, friction, linDrag, angDrag);
			body.setGravity(_gravity);
			_bodies.push(body);
			return body;
		}
		
		public function addBodyPolygon(vertices:Vector.<RiVec>, density:Number=1, restitution:Number=0.5, 
									   friction:Number=0.2, linDrag:Number=0.9, angDrag:Number=0.9):RiBodyPolygon
		{
			var body:RiBodyPolygon = new RiBodyPolygon(vertices, density, restitution, friction, linDrag, angDrag);
			body.setGravity(_gravity);
			_bodies.push(body);
			return body;
		}
		
		public function addBodyRectangle(pos:RiVec, halfSize:RiVec, density:Number=1, restitution:Number=0.5, 
										 friction:Number=0.2, linDrag:Number=0.9, angDrag:Number=0.9):RiBodyPolygon
		{
			var vertices:Vector.<RiVec> = new <RiVec>[
				new RiVec(pos.x + halfSize.x, pos.y + halfSize.y),
				new RiVec(pos.x - halfSize.x, pos.y + halfSize.y),
				new RiVec(pos.x - halfSize.x, pos.y - halfSize.y),
				new RiVec(pos.x + halfSize.x, pos.y - halfSize.y)
			];
			
			return addBodyPolygon(vertices, density, restitution, friction, linDrag, angDrag);
		}
		
		public function destroyBody(body:RiBody):void
		{
			var i:int, l:int;
			
			for(i=0, l=_bodies.length; i<l; i++)
			{
				if(_bodies[i] == body)
				{
					_bodies.splice(i, 1);
					return;
				}
			}
			
			throw "Body not found";
		}
		
		public function update(dt:Number):void
		{
			var i:int, l:int;
			
			for(i=0, l=_bodies.length; i<l; i++)
			{
				var body:RiBody = _bodies[i];
				
				body.update(dt);
			}
			
			var collisions:Vector.<RiCollision> = _collisionDetector.getCollisions(_bodies);
			
			//Book method, results suck!!!
//			l = Math.min(collisions.length, MAX_LOOP_COUNT);
//			collisions = collisions.sort(collisionPenetrationSortHelperFunction);
//			for(i=0; i<l; i++)
//			{
//				var collisionToMove:RiCollision = collisions[i];
//				if(i>0) collisionToMove.update(_collisionDetector);
//				_collisionResolver.separate(collisionToMove);
//			}
//			collisions = collisions.sort(collisionClosingSpeedSortHelperFunction);
//			for(i=0; i<l; i++)
//			{
//				var collisionToImpulse:RiCollision = collisions[i];
//				collisionToImpulse.update(_collisionDetector);
//				_collisionResolver.applyImpulses(collisionToImpulse);
//			}
			
			collisions = collisions.sort(collisionPenetrationSortHelperFunction);
			for(i=0,l=collisions.length; i<l; i++)
			{
				var col:RiCollision = collisions[i];
				if(i>0) col.update(_collisionDetector);
				_collisionResolver.separate(col);
				_collisionResolver.applyImpulses(col);
			}
		}
		
		private function collisionPenetrationSortHelperFunction(c0:RiCollision, c1:RiCollision):Number
		{
			return c1.penetration - c0.penetration;
		}
//		private function collisionClosingSpeedSortHelperFunction(c0:RiCollision, c1:RiCollision):Number
//		{
//			return c1.closingSpeed - c0.closingSpeed;
//		}
	}
}