package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	internal class RiTestCollisionCirclesPair extends RiTest
	{
		private var _world:RiWorld;
		private var _body0:RiBodyCircle;
		private var _body1:RiBodyCircle;
		private var _view0:Shape;
		private var _view1:Shape;
		
		public function RiTestCollisionCirclesPair(parent:DisplayObjectContainer)
		{
			super(parent);
			
			const R0:Number = 10;
			const R1:Number = 15;
			
			_world = new RiWorld(new RiVec(0,0));
			_body0 = _world.addBodyCircle(0, 207, R0);
			_body0.setLinVel(new RiVec(150, 0));
			_body1 = _world.addBodyCircle(400, 200, R1);
			_body1.setLinVel(new RiVec(-150, 0));
			
			_view0 = getViewCircle(R0);
			_parent.addChild(_view0);
			
			_view1 = getViewCircle(R1, 0x0000ff);
			_parent.addChild(_view1);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt);
			
			_view0.x = _body0.getPosX();
			_view0.y = _body0.getPosY();
			
			_view1.x = _body1.getPosX();
			_view1.y = _body1.getPosY();
		}
		
	}
}