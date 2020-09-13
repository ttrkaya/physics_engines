package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	internal class RiTestCollisionCirclePolygonPair extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyCircle:RiBodyCircle;
		private var _bodyPoly:RiBodyPolygon;
		private var _viewCircle:Shape;
		private var _viewPoly:Shape;
		
		public function RiTestCollisionCirclePolygonPair(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			const R:Number = 25;
			const W:Number = 18;
			const H:Number = 43;
			const vertices:Vector.<RiVec> = new <RiVec>[
				new RiVec(W,H),
				new RiVec(-W,H),
				new RiVec(-W,-H),
				new RiVec(W,-H)
			];
			
			_world = new RiWorld(new RiVec(0,0));
			_bodyCircle = _world.addBodyCircle(0, 207, R);
			_bodyPoly = _world.addBodyPolygon(vertices, 1);
			
			_viewCircle = getViewCircle(R);
			_parent.addChild(_viewCircle);
			
			_viewPoly = getViewPolygon(_bodyPoly.getLocalVertices());
			_parent.addChild(_viewPoly);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt);
			
			_viewCircle.x = _bodyCircle.getPosX();
			_viewCircle.y = _bodyCircle.getPosY();
			
			_viewPoly.x = _bodyPoly.getPosX();
			_viewPoly.y = _bodyPoly.getPosY();
			_viewPoly.rotation = _bodyPoly.getOrientation() * 180 / Math.PI;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_bodyCircle.setPos(new RiVec(0, 200));
			_bodyCircle.setOrientation(0);
			_bodyCircle.setLinVel(new RiVec(150, 0));
			_bodyCircle.setAngVel(0);
			
			_bodyPoly.setPos(new RiVec(400, 205));
			_bodyPoly.setOrientation(0);
			_bodyPoly.setLinVel(new RiVec(-150, 0));
			_bodyPoly.setAngVel(13 * (Math.random() - 0.5));
		}
	}
}