package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	internal class RiTestCollisionPolygonsPair extends RiTest
	{
		private var _world:RiWorld;
		private var _body0:RiBodyPolygon;
		private var _body1:RiBodyPolygon;
		private var _view0:Shape;
		private var _view1:Shape;
		
		public function RiTestCollisionPolygonsPair(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			const W:Number = 25;
			const H:Number = 37;
			const vertices0:Vector.<RiVec> = new <RiVec>[
				new RiVec(W*r(),H*r()),
				new RiVec(-W*r(),H*r()),
				new RiVec(-W*r(),-H*r()),
				new RiVec(W*r(),-H*r())
			];
			const WW:Number = W * 1.4;
			const HH:Number = H * 1.4;
			const vertices1:Vector.<RiVec> = new <RiVec>[
				new RiVec(W,H),
				new RiVec(0,HH),
				new RiVec(-W,H),
				new RiVec(-WW,0),
				new RiVec(-W,-H),
				new RiVec(0,-HH),
				new RiVec(W,-H),
				new RiVec(WW,0),
			];
			
			_world = new RiWorld(new RiVec(0,110));
			
			_body0 = _world.addBodyPolygon(vertices0, 1);
			_body1 = _world.addBodyPolygon(vertices1, 1);
			
			_view0 = getViewPolygon(_body0.getLocalVertices(), 0x00ff00);
			_parent.addChild(_view0);
			_view1 = getViewPolygon(_body1.getLocalVertices());
			_parent.addChild(_view1);
			
			_parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected override function update(dt:Number):void
		{
			_world.update(dt * 0.7);
			
			_view0.x = _body0.getPosX();
			_view0.y = _body0.getPosY();
			_view0.rotation = _body0.getOrientation() * 180 / Math.PI;
			
			_view1.x = _body1.getPosX();
			_view1.y = _body1.getPosY();
			_view1.rotation = _body1.getOrientation() * 180 / Math.PI;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_parent.removeChildren();
			_parent.addChild(_view0);
			_parent.addChild(_view1);
			
			_body0.setPos(new RiVec(0, 300));
			_body0.setOrientation(0);
			_body0.setLinVel(new RiVec(150, -150));
			_body0.setAngVel(15 * (Math.random() - 0.5));
			
			_body1.setPos(new RiVec(400, 300));
			_body1.setOrientation(0);
			_body1.setLinVel(new RiVec(-150, -150));
			_body1.setAngVel(15 * (Math.random() - 0.5));
		}
		
		private function r():Number 
		{ 
			return 1 + 0.7 * (Math.random()-0.5); 
		}
	}
}