package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBody;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	internal class RiTestFriction extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyPoly:RiBodyPolygon;
		private var _bodyCircle:RiBodyCircle;
		private var _viewPoly:Shape;
		private var _viewCircle:Shape;
		
		public function RiTestFriction(parent:DisplayObjectContainer)
		{
			super(parent);
			
			_world = new RiWorld(new RiVec(0, 50));
			
			var platformBody:RiBodyPolygon = _world.addBodyRectangle(new RiVec(200, 390), new RiVec(200,10), 1);
			platformBody.setStatic();
			var platformView:Shape = getViewPolygon(platformBody.getGlobalVertices(), 0xff8888);
			platformView.alpha = 0.5;
			_parent.addChild(platformView);
			
			_bodyPoly = _world.addBodyRectangle(new RiVec(), new RiVec(15, 15), 1);
			_viewPoly = getViewPolygon(_bodyPoly.getGlobalVertices());
			_viewPoly.alpha = 0.5;
			_parent.addChild(_viewPoly);
			
			_bodyCircle = _world.addBodyCircle(0, 0, 12);
			_viewCircle = getViewCircle(12);
			_viewCircle.alpha = 0.5;
			_parent.addChild(_viewCircle);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt);
			
			_viewPoly.x = _bodyPoly.getPosX();
			_viewPoly.y = _bodyPoly.getPosY();
			_viewPoly.rotation = _bodyPoly.getOrientation() * 180 / Math.PI;
			
			_viewCircle.x = _bodyCircle.getPosX();
			_viewCircle.y = _bodyCircle.getPosY();
			_viewCircle.rotation = _bodyCircle.getOrientation() * 180 / Math.PI;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_bodyPoly.setPos(new RiVec(0, 350));
			_bodyPoly.setOrientation(0);
			_bodyPoly.setAngVel((Math.random() - 0.5) * 10);
			_bodyPoly.setLinVel(new RiVec(100, 0));
			
			_bodyCircle.setPos(new RiVec(400, 350));
			_bodyCircle.setOrientation(0);
			_bodyCircle.setAngVel(0);
			_bodyCircle.setLinVel(new RiVec(-100, 0));
		}
	}
}