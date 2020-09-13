package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class RiTestStackOfBoxes extends RiTest
	{
		private var _world:RiWorld;
		private var _circleBodies:Vector.<RiBodyCircle>;
		private var _circleViews:Vector.<Shape>;
		private var _hanoiBodies:Vector.<RiBodyPolygon>;
		private var _hanoiViews:Vector.<Shape>;
		private var _squareBodies:Vector.<RiBodyPolygon>;
		private var _squareViews:Vector.<Shape>;
		
		private static const NUM_HANOI_BOXES:int = 12;
		private static const NUM_SQUARES:int = 6;
		private static const NUM_CIRCLES:int = 8;
		
		public function RiTestStackOfBoxes(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			_world = new RiWorld(new RiVec(0, 30));
			
			var platformBody:RiBodyPolygon = _world.addBodyRectangle(new RiVec(200, 390), new RiVec(200, 10));
			platformBody.setStatic();
			var plarformView:Shape = getViewPolygon(platformBody.getGlobalVertices(), 0xff8888);
			plarformView.alpha = 0.5;
			_parent.addChild(plarformView);
			
			_circleBodies = new Vector.<RiBodyCircle>(NUM_CIRCLES);
			for(i=0; i<NUM_CIRCLES; i++)
			{
				_circleBodies[i] = _world.addBodyCircle(0,0,10);
			}
			_circleViews = new Vector.<Shape>(NUM_CIRCLES);
			for(i=0; i<NUM_CIRCLES; i++)
			{
				var circleView:Shape = getViewCircle(10);
				circleView.alpha = 0.5;
				_parent.addChild(circleView);
				_circleViews[i] = circleView;
			}
				
			_hanoiBodies = new Vector.<RiBodyPolygon>(NUM_HANOI_BOXES);
			for(i=0; i<NUM_HANOI_BOXES; i++)
			{
				_hanoiBodies[i] = _world.addBodyRectangle(new RiVec(), new RiVec(20-i, 10));
			}
			_hanoiViews = new Vector.<Shape>(NUM_HANOI_BOXES);
			for(i=0; i<NUM_HANOI_BOXES; i++)
			{
				var polyView:Shape = getViewPolygon(_hanoiBodies[i].getLocalVertices());
				polyView.alpha = 0.5;
				_parent.addChild(polyView);
				_hanoiViews[i] = polyView;
			}
			
			_squareBodies= new Vector.<RiBodyPolygon>(NUM_SQUARES);
			for(i=0; i<NUM_SQUARES; i++)
			{
				_squareBodies[i] = _world.addBodyRectangle(new RiVec(), new RiVec(10, 10));
			}
			_squareViews = new Vector.<Shape>(NUM_SQUARES);
			for(i=0; i<NUM_SQUARES; i++)
			{
				var squareView:Shape = getViewPolygon(_squareBodies[i].getLocalVertices(), 0x00ffff);
				squareView.alpha = 0.5;
				_parent.addChild(squareView);
				_squareViews[i] = squareView;
			}
		}
		
		protected override function update(dt:Number):void
		{
			var i:int;
			
			_world.update(dt);
			
			for(i=0; i<NUM_CIRCLES; i++)
			{
				var circleView:Shape = _circleViews[i];
				var circleBody:RiBodyCircle = _circleBodies[i];
				circleView.x = circleBody.getPosX();
				circleView.y = circleBody.getPosY();
				circleView.rotation = circleBody.getOrientation() * 180 / Math.PI;
			}
			
			for(i=0; i<NUM_HANOI_BOXES; i++)
			{
				var polyView:Shape = _hanoiViews[i];
				var polyBody:RiBodyPolygon = _hanoiBodies[i];
				polyView.x = polyBody.getPosX();
				polyView.y = polyBody.getPosY();
				polyView.rotation = polyBody.getOrientation() * 180 / Math.PI;
			}
			
			for(i=0; i<NUM_SQUARES; i++)
			{
				var squareView:Shape = _squareViews[i];
				var squareBody:RiBodyPolygon = _squareBodies[i];
				squareView.x = squareBody.getPosX();
				squareView.y = squareBody.getPosY();
				squareView.rotation = squareBody.getOrientation() * 180 / Math.PI;
			}
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			var i:int;
			
			for(i=0; i<NUM_CIRCLES; i++)
			{
				var circleBody:RiBodyCircle = _circleBodies[i];
				circleBody.setPos(new RiVec(50, 370 - i*20));
				circleBody.setLinVel(new RiVec());
				circleBody.setOrientation(0);
				circleBody.setAngVel(0);
			}
			
			for(i=0; i<NUM_HANOI_BOXES; i++)
			{
				var polyBody:RiBodyPolygon = _hanoiBodies[i];
				polyBody.setPos(new RiVec(200, 370 - i*20));
				polyBody.setLinVel(new RiVec());
				polyBody.setOrientation(0);
				polyBody.setAngVel(0);
			}
			
			for(i=0; i<NUM_SQUARES; i++)
			{
				var squareBody:RiBodyPolygon = _squareBodies[i];
				squareBody.setPos(new RiVec(350, 370 - i*20));
				squareBody.setLinVel(new RiVec());
				squareBody.setOrientation(0);
				squareBody.setAngVel(0);
			}
		}
	}
}