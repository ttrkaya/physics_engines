package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	internal class RiTestCollisionStatic extends RiTest
	{
		private var _world:RiWorld;
		private var _bodyPolyStatic:RiBodyPolygon;
		private var _bodyPolyDynamic:RiBodyPolygon;
		private var _bodyCircleDynamic:RiBodyCircle;
		private var _bodyCircleStatic:RiBodyCircle;
		private var _viewPolyStatic:Shape;
		private var _viewPolyDynamic:Shape;
		private var _viewCircleStatic:Shape;
		private var _viewCircleDynamic:Shape;
		
		public function RiTestCollisionStatic(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			const W:Number = 25;
			const H:Number = 37;
			const verticesStatic:Vector.<RiVec> = new <RiVec>[
				new RiVec(W*r(),H*r()),
				new RiVec(-W*r(),H*r()),
				new RiVec(-W*r(),-H*r()),
				new RiVec(W*r(),-H*r())
			];
			const WW:Number = W * 1.4;
			const HH:Number = H * 1.4;
			const verticesDynamic:Vector.<RiVec> = new <RiVec>[
				new RiVec(W,H),
				new RiVec(0,HH),
				new RiVec(-W,H),
				new RiVec(-WW,0),
				new RiVec(-W,-H),
				new RiVec(0,-HH),
				new RiVec(W,-H),
				new RiVec(WW,0),
			];
			
			const RD:Number = 20;
			const RS:Number = 15;
			const POS_D:Point = new Point(200, 0);
			const POS_S:Point = new Point(210, 350);
			
			_world = new RiWorld(new RiVec(0,110));
			
			_bodyPolyDynamic = _world.addBodyPolygon(verticesDynamic, 1);
			_bodyPolyStatic = _world.addBodyPolygon(verticesStatic, 1);
			_bodyPolyStatic.setPos(new RiVec(50, 270));
			_bodyCircleDynamic = _world.addBodyCircle(POS_D.x, POS_D.y, RD);
			_bodyCircleStatic = _world.addBodyCircle(POS_S.x, POS_S.y, RS);
			
			_bodyPolyStatic.setStatic();
			_bodyCircleStatic.setStatic();
			
			_viewPolyStatic = getViewPolygon(_bodyPolyStatic.getLocalVertices(), 0x0000ff);
			_viewPolyStatic.x = _bodyPolyStatic.getPosX();
			_viewPolyStatic.y = _bodyPolyStatic.getPosY();
			_parent.addChild(_viewPolyStatic);
			_viewPolyDynamic = getViewPolygon(_bodyPolyDynamic.getLocalVertices(), 0x00ff00);
			_viewPolyDynamic.x = _bodyPolyDynamic.getPosX();
			_viewPolyDynamic.y = _bodyPolyDynamic.getPosY();
			_parent.addChild(_viewPolyDynamic);
			_viewCircleStatic = getViewCircle(RS, 0x0000ff);
			_parent.addChild(_viewCircleStatic);
			_viewCircleDynamic = getViewCircle(RD, 0x00ff00);
			_parent.addChild(_viewCircleDynamic);
			
			_parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt * 0.7);
			
			_viewPolyStatic.x = _bodyPolyStatic.getPosX();
			_viewPolyStatic.y = _bodyPolyStatic.getPosY();
			_viewPolyStatic.rotation = _bodyPolyStatic.getOrientation() * 180 / Math.PI;
			
			_viewPolyDynamic.x = _bodyPolyDynamic.getPosX();
			_viewPolyDynamic.y = _bodyPolyDynamic.getPosY();
			_viewPolyDynamic.rotation = _bodyPolyDynamic.getOrientation() * 180 / Math.PI;
			
			_viewCircleStatic.x = _bodyCircleStatic.getPosX();
			_viewCircleStatic.y = _bodyCircleStatic.getPosY();
			_viewCircleStatic.rotation = _bodyCircleStatic.getOrientation() * 180 / Math.PI;
			
			_viewCircleDynamic.x = _bodyCircleDynamic.getPosX();
			_viewCircleDynamic.y = _bodyCircleDynamic.getPosY();
			_viewCircleDynamic.rotation = _bodyCircleDynamic.getOrientation() * 180 / Math.PI;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_parent.removeChildren();
			_parent.addChild(_viewPolyStatic);
			_parent.addChild(_viewPolyDynamic);
			_parent.addChild(_viewCircleStatic);
			_parent.addChild(_viewCircleDynamic);
			
			_bodyPolyDynamic.setPos(new RiVec(400, 300));
			_bodyPolyDynamic.setOrientation(0);
			_bodyPolyDynamic.setLinVel(new RiVec(-150, -150));
			_bodyPolyDynamic.setAngVel(15 * (Math.random() - 0.5));
			
			_bodyCircleDynamic.setPos(new RiVec(200, 0));
			_bodyCircleDynamic.setOrientation(0);
			_bodyCircleDynamic.setLinVel(new RiVec(0, 0));
			_bodyCircleDynamic.setAngVel(0);
		}
		
		private function r():Number 
		{ 
			return 1 + 0.7 * (Math.random()-0.5); 
		}
	}
}