package com.ttrkaya.rigid2d.phys
{
	import com.ttrkaya.rigid2d.geom.RiVec;

	public class RiCollisionResolver
	{
		private static const MOVE_EXTRA_FACTOR:Number = 1.01;
		
		public function RiCollisionResolver()
		{
		}
		
		public function separate(col:RiCollision):void
		{
			if(col.penetration <= 0) return;
			
			var totalInvMass:Number = col.body0.getInvMass() + col.body1.getInvMass();
			var massRatio0:Number = col.body0.getInvMass() / totalInvMass;
			var massRatio1:Number = col.body1.getInvMass() / totalInvMass;
			
			var move0:RiVec = col.normal.getScaled(-col.penetration * MOVE_EXTRA_FACTOR * massRatio0);
			var move1:RiVec = col.normal.getScaled(col.penetration * MOVE_EXTRA_FACTOR * massRatio1);
			
			col.body0.move(move0);
			col.body1.move(move1);
		}
		
		public function applyImpulses(col:RiCollision):void
		{
			var closingSpeed:Number = col.normal.dot(col.body0.getVelAtPoint(col.pos)) - 
										col.normal.dot(col.body1.getVelAtPoint(col.pos));
			
			if(closingSpeed <= 0) return;
			
			var restitution0:Number = col.body0.getRestitution();
			var restitution1:Number = col.body1.getRestitution();
			var restitution:Number = restitution0 < restitution1 ? restitution0 : restitution1;
			var desiredClosingSpeedChange:Number = closingSpeed * -(1 + restitution);
			
			var newPointVelIfAppliedNormalImpulse0:RiVec = col.body0.getVelAtPointIfAppliedImpulse(col.pos, col.normal.getScaled(-1));
			var newPointVelIfAppliedNormalImpulse1:RiVec = col.body1.getVelAtPointIfAppliedImpulse(col.pos, col.normal);
			var newClosingSpeedIfAppliedImpulse:Number = col.normal.dot(newPointVelIfAppliedNormalImpulse0) -
															col.normal.dot(newPointVelIfAppliedNormalImpulse1);
			var closingSpeedChangePerImpulse:Number = newClosingSpeedIfAppliedImpulse - closingSpeed;
			
			var normalImpulseStrength:Number = desiredClosingSpeedChange / closingSpeedChangePerImpulse;
			
			col.body0.applyImpulse(col.normal.getScaled(-normalImpulseStrength), col.pos);
			col.body1.applyImpulse(col.normal.getScaled(normalImpulseStrength), col.pos);
			
			//friction
			var tangent:RiVec = col.normal.getOrthogonalized();
			var tangentRelativeSpeed:Number = tangent.dot(col.body0.getVelAtPoint(col.pos)) - 
												tangent.dot(col.body1.getVelAtPoint(col.pos));
			
			var newPointVelIfAppliedTangentImpulse0:RiVec = col.body0.getVelAtPointIfAppliedImpulse(col.pos, tangent.getScaled(-1));
			var newPointVelIfAppliedTangentImpulse1:RiVec = col.body1.getVelAtPointIfAppliedImpulse(col.pos, tangent);
			var newTangentSpeedIfAppliedImpulse:Number = tangent.dot(newPointVelIfAppliedTangentImpulse0) -
															tangent.dot(newPointVelIfAppliedTangentImpulse1);
			var tangentSpeedChangePerImpulse:Number = newTangentSpeedIfAppliedImpulse - tangentRelativeSpeed;
			
			var friction0:Number = col.body0.getFriction();
			var friction1:Number = col.body1.getFriction();
			var friction:Number = friction0 > friction1 ? friction0 : friction1;
			
			var tangentImpulseStrengthToStop:Number = -tangentRelativeSpeed / tangentSpeedChangePerImpulse;
			var tangentImpulseStrengthToApply:Number = 
				Math.abs(tangentImpulseStrengthToStop) < normalImpulseStrength * friction ?
				tangentImpulseStrengthToStop : 
				normalImpulseStrength * friction * (tangentImpulseStrengthToStop < 0 ? -1 : 1);
			
			col.body0.applyImpulse(tangent.getScaled(-tangentImpulseStrengthToApply), col.pos);
			col.body1.applyImpulse(tangent.getScaled(tangentImpulseStrengthToApply), col.pos);
		}
	}
}