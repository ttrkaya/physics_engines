package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	internal class RiTestFall extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyCircle:RiBodyCircle;
		private var _viewCicle:Shape;
		private var _bodyPoly:RiBodyPolygon;
		private var _viewPolygon:Shape;
		
		public function RiTestFall(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			_world = new RiWorld(new RiVec(0, 10));
			
			const r:Number = 10;
			_bodyCircle = _world.addBodyCircle(100, 0, r);
			
			_viewCicle = getViewCircle(r);
			_parent.addChild(_viewCicle);
			
			const vertices:Vector.<RiVec> = new <RiVec>[
				new RiVec(10, 10),
				new RiVec(10, -10),
				new RiVec(-10, -15),
				new RiVec(-15, 10)
			];
			
			_bodyPoly = _world.addBodyPolygon(vertices, 1);
			_bodyPoly.setPos(new RiVec(300,0));
			
			_viewPolygon = getViewPolygon(_bodyPoly.getLocalVertices());
			_viewPolygon.x = _bodyPoly.getPosX();
			_viewPolygon.y = _bodyPoly.getPosY();
			_parent.addChild(_viewPolygon);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt);
			
			_viewCicle.x = _bodyCircle.getPosX();
			_viewCicle.y = _bodyCircle.getPosY();
			
			_viewPolygon.x = _bodyPoly.getPosX();
			_viewPolygon.y = _bodyPoly.getPosY();
		}
	}
}