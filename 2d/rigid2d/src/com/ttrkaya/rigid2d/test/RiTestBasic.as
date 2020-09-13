package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;

	internal class RiTestBasic extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyCircle:RiBodyCircle;
		private var _viewCicle:Shape;
		
		public function RiTestBasic(parent:DisplayObjectContainer)
		{
			super(parent);
			
			const r:Number = 10;
			
			_world = new RiWorld(new RiVec(0, 10));
			_bodyCircle = _world.addBodyCircle(200, 0, r);
			
			_viewCicle = getViewCircle(r);
			_parent.addChild(_viewCicle);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt);
			
			_viewCicle.x = _bodyCircle.getPosX();
			_viewCicle.y = _bodyCircle.getPosY();
		}
	}
}