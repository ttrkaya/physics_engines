package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiVec;

	public class RiBody
	{
		protected var _center:RiVec;
		protected var _orientation:Number; // [-Math.PI, Math.PI]
		
		protected var _linVel:RiVec;
		protected var _angVel:Number;
		
		protected var _invMass:Number;		// 1 / mass
		protected var _invInertia:Number;	// 1 / momentOfInertia
		
		protected var _restitution:Number;
		protected var _friction:Number;
		protected var _linDrag:Number;
		protected var _angDrag:Number;
		
		protected var _gravity:RiVec;
		
		protected var _type:uint;
		
		public function RiBody(x:Number, y:Number, invMass:Number, invInertia:Number, 
							   restitution:Number, friction:Number, linDrag:Number, angDrag:Number)
		{
			_center = new RiVec(x, y);
			_orientation = 0;
			
			_linVel = new RiVec();
			_angVel = 0;
			
			_invMass = invMass;
			_invInertia = invInertia;
			
			_restitution = restitution;
			_friction = friction;
			_linDrag = linDrag;
			_angDrag = angDrag;
			
			_gravity = new RiVec();
		}
		
		public function update(dt:Number):void
		{
			_linVel.addScaled(_gravity, dt);
			_linVel.scale(Math.pow(_linDrag, dt));
			_center.addScaled(_linVel, dt);
			
			_angVel *= Math.pow(_angDrag, dt);
			_orientation += _angVel * dt;
		}
		
		public function getType():uint { return _type; }
		
		public function setGravity(g:RiVec):void
		{
			_gravity.x = g.x;
			_gravity.y = g.y;
		} 
		
		public function setStatic():void
		{
			_invMass = 0;
			_invInertia = 0;
			_gravity.zero();
			
			_type = _type | RiBodyTypes.STATIC;
		}
		
		public function isStatic():Boolean
		{
			return ((_type & RiBodyTypes.STATIC) != 0);
		}
		
		public function getPos():RiVec { return _center; }
		public function getPosX():Number { return _center.x; }
		public function getPosY():Number { return _center.y; }
		public function getOrientation():Number { return _orientation; }
		public function getInvMass():Number { return _invMass; }
		
		public function move(v:RiVec):void
		{
			_center.x += v.x;
			_center.y += v.y;
		}
		
		public function setPos(v:RiVec):void { _center.copy(v); }
		public function setOrientation(v:Number):void { _orientation = v; }
			
		public function getLinVel():RiVec { return _linVel; }
		public function setLinVel(v:RiVec):void	{ _linVel.copy(v); }
		public function getAngVel():Number { return _angVel; }
		public function setAngVel(v:Number):void { _angVel = v; }
		
		public function getRestitution():Number { return _restitution; }
		public function getFriction():Number { return _friction; }
		
		public function applyImpulse(imp:RiVec, pos:RiVec):void
		{
			_linVel.addScaled(imp, _invMass);
			
			var relPos:RiVec = pos.getSubbed(_center);
			var torqueImpulse:Number = relPos.cross(imp);
			_angVel += torqueImpulse * _invInertia;
		}
		
		public function getVelAtPoint(pos:RiVec):RiVec
		{
			var relPos:RiVec = pos.getSubbed(_center);
			var angToLinVel:RiVec = new RiVec(-_angVel*relPos.y, _angVel*relPos.x);
			return _linVel.getAdded(angToLinVel);
		}
		
		public function getVelAtPointIfAppliedImpulse(pos:RiVec, imp:RiVec):RiVec
		{
			var newLinVel:RiVec = _linVel.getAddedScaled(imp, _invMass);
			
			var relPos:RiVec = pos.getSubbed(_center);
			var torqueImpulse:Number = relPos.cross(imp);
			var newAngVel:Number = _angVel + torqueImpulse * _invInertia;
			
			var angToLinVel:RiVec = new RiVec(-newAngVel*relPos.y, newAngVel*relPos.x);
			return newLinVel.getAdded(angToLinVel);
		}
	}
}