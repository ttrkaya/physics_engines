package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	internal class RiTestCircleInsidePolygon extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyPoly:RiBodyPolygon;
		private var _bodyCircle:RiBodyCircle;
		private var _viewPoly:Shape;
		private var _viewCircle:Shape;
		
		public function RiTestCircleInsidePolygon(parent:DisplayObjectContainer)
		{
			super(parent);
			
			const R:Number = 30;
			
			_world = new RiWorld();
			_bodyCircle = _world.addBodyCircle(201, 200, R);
			_bodyPoly = _world.addBodyRectangle(new RiVec(200, 200), new RiVec(40, 40), 1);
			
			_viewCircle = getViewCircle(R);
			_viewCircle.alpha = 0.5;
			_parent.addChild(_viewCircle);
			
			_viewPoly = getViewPolygon(_bodyPoly.getLocalVertices());
			_viewPoly.alpha = 0.5;
			_parent.addChild(_viewPoly);
		}
		
		protected override function update(dt:Number):void
		{
			//_world.update(dt);
			
			_viewCircle.x = _bodyCircle.getPosX();
			_viewCircle.y = _bodyCircle.getPosY();
			_viewCircle.rotation = _bodyCircle.getOrientation() * 180 / Math.PI;
			
			_viewPoly.x = _bodyPoly.getPosX();
			_viewPoly.y = _bodyPoly.getPosY();
			_viewPoly.rotation = _bodyPoly.getOrientation() * 180 / Math.PI;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_world.update(0.01);
			//_bodyCircle.setPos(new RiVec(200, 200));
			//_bodyPoly.setPos(new RiVec(200, 200));
		}
	}
}