package com.ttrkaya.t2d.test
{
	import com.ttrkaya.t2d.physics.T2Physics;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticLine;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticPoint;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	internal class T2TestPhysics extends Sprite
	{
		private var physics:T2Physics;
		private var lastUpdate:Number;
		
		private var circles:Vector.<T2BodyDynamicCircle>;
		
		private var point:T2BodyStaticPoint;
		private var staticCircle:T2BodyStaticCircle;
		
		private var line:T2BodyStaticLine;
		private var linePoint1:T2BodyStaticPoint;
		private var linePoint2:T2BodyStaticPoint;
		
		public function T2TestPhysics()
		{
			physics = new T2Physics();
			
			circles = new Vector.<T2BodyDynamicCircle>;
			circles.push(physics.createDynamicCircle(200,100,15,1,0.95, 5, 5));
			circles.push(physics.createDynamicCircle(300,200,5,1/9,0.95));
			circles.push(physics.createDynamicCircle(335,200,15,1,0.95));
			circles.push(physics.createDynamicCircle(300,235,15,1,0.95));
			circles.push(physics.createDynamicCircle(355,255,30,4,0.95));
			
			circles[0].filterMask = 0x1;
			circles[4].filterMask = 0x2;
			
			physics.createStaticLine(0,0,600,0,0,1);
			physics.createStaticLine(600,0,600,400,-1,0);
			physics.createStaticLine(600,400,0,400,0,-1);
			physics.createStaticLine(0,400,0,0,1,0);
			
			point = physics.createStaticPoint(550,350);
			staticCircle = physics.createStaticCircle(50,350,20);
			
			linePoint1 = physics.createStaticPoint(500,50);
			linePoint2 = physics.createStaticPoint(550,100);
			line = physics.createStaticLine(500,50,550,100,-Math.SQRT1_2,Math.SQRT1_2);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			lastUpdate = (new Date).time/1000;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onClicked);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var now:Number = (new Date).time/1000;
			var dt:Number = now - lastUpdate;
			lastUpdate = now;
			
			physics.update(dt);
			
			this.graphics.clear();
			this.graphics.lineStyle(1,0);
			for each( var circle:T2BodyDynamicCircle in circles)
			{
				this.graphics.beginFill(circle == circles[0] ? 0x00ff00 : 0x0000ff);
				this.graphics.drawCircle(circle.x, circle.y, circle.r);
				this.graphics.endFill();
			}
			
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(point.x, point.y,2);
			this.graphics.drawCircle(staticCircle.x, staticCircle.y,staticCircle.r);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0xff0000);
			this.graphics.moveTo(linePoint1.x,linePoint1.y);
			this.graphics.lineTo(linePoint2.x,linePoint2.y);
		}
		
		private function onClicked(e:MouseEvent):void
		{
			var circleToControl:T2BodyDynamicCircle = circles[0];
			circleToControl.velX = (this.mouseX - circleToControl.x)*3;
			circleToControl.velY = (this.mouseY - circleToControl.y)*3;
			
			trace(circles[0].filterMask);
			trace(circles[1].filterMask);
			trace(circles[2].filterMask);
			trace(circles[3].filterMask);
			trace(circles[4].filterMask);
			trace(point.filterMask);
			trace(staticCircle.filterMask);
			trace(line.filterMask);
			trace(linePoint1.filterMask);
			trace(linePoint2.filterMask);
		}
	}
}