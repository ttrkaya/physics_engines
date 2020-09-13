package physic
{
	import math.Mat4;
	import math.Quaternion;
	import math.Vec4;

	public class PhysicalObject
	{
		protected var _pos:Vec4;
		protected var _linVel:Vec4;
		protected var _linAcc:Vec4;
		
		protected var _orientation:Quaternion;
		protected var _angVel:Vec4;
		protected var _angAcc:Vec4;
		
		protected var _invMass:Number;
		protected var _invInertiaTensor:Mat4;
		
		public function PhysicalObject()
		{
			_pos = new Vec4(0,0,0);
			_linVel = new Vec4(0,0,0,0);
			_linAcc = new Vec4(0,0,0,0);
			
			_orientation = new Quaternion();
			_angVel = new Vec4(0,0,0,0);
			_angAcc = new Vec4(0,0,0,0);
		}
		
		public function setStatic():void
		{
			_invMass = 0;
		}
		
		public function applyImpulse(imp:Vec4, globalPos:Vec4):void
		{
			_linVel.addScaled(imp, _invMass);
			
			var transformMat:Mat4 = getTransformMat();
			var localImp:Vec4 = transformMat.getInverseTransformed(imp); 
			var localPos:Vec4 = transformMat.getInverseTransformed(globalPos);
			
			var torqueImp:Vec4 = localImp.cross(localPos); //take local torque to global??
			_angVel.add(_invInertiaTensor.getTransformed(torqueImp));
		}
		
		public function update(dt:Number, damping:Number):void
		{
			_linVel.addScaled(_linAcc, dt);
			_linVel.scale(damping); //linear damping
			_pos.addScaled(_linVel, dt);
			
			_angVel.addScaled(_angAcc, dt);
			_angVel.scale(damping); //angular damping
			_orientation.addScaledVector(_angVel, dt);
			_orientation.normalise();
		}
		
		public function translate(v:Vec4):void
		{
			_pos.add(v);
		}
		
		public function getCenter():Vec4 { return _pos; }
		public function setCenter(c:Vec4):void { _pos.copy(c); }
		public function getLinVel():Vec4 { return _linVel; }
		public function setLinVel(v:Vec4):void { _linVel.copy(v); }
		public function getOrientation():Quaternion { return _orientation; }
		public function setAngVel(v:Vec4):void { _angVel.copy(v); }
		public function getInvMass():Number { return _invMass; }
		
		public function getTransformMat():Mat4
		{
			var t:Mat4 = _orientation.getRotationMatrix();
			t.setPosition(_pos);
			return t;
		}
		
		public function getVelAtPoint(p:Vec4):Vec4
		{
			var relPoint:Vec4 = p.getSubbed(_pos)
			var vel:Vec4 = _angVel.cross(relPoint);
			vel.add(_linVel);
			return vel;
		}
		
		public function getVelAtPointChangePerImpulse(imp:Vec4, globalPoint:Vec4):Vec4
		{
			var linChange:Vec4 = imp.getScaled(_invMass);
			//return linChange;
			
			var transformMat:Mat4 = getTransformMat();
			var localPoint:Vec4 = transformMat.getInverseTransformed(globalPoint);
			var localImp:Vec4 = transformMat.getInverseTransformed(imp);
			var torqueImp:Vec4 = localImp.cross(localPoint);
			var localAngChange:Vec4 = _invInertiaTensor.getTransformed(torqueImp);
			var globalAngChange:Vec4 = transformMat.getTransformed(localAngChange);
			var relPoint:Vec4 = globalPoint.getSubbed(_pos);
			var angChange:Vec4 = globalAngChange.cross(relPoint);
			
			return linChange.getAdded(angChange);
		}
	}
}