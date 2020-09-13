package com.ttrkaya.t2d.test
{
	import com.ttrkaya.t2d.geom.T2Line;
	import com.ttrkaya.t2d.geom.T2Vec;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	
	internal class T2TestLineProjection extends Sprite
	{
		private var line0:T2Line;
		private var line1:T2Line;
		private var line2:T2Line;
		private var line3:T2Line;
		
		public function T2TestLineProjection()
		{
			line0 = new T2Line(new T2Vec(30,30), new T2Vec(130,60));
			line1 = new T2Line(new T2Vec(400,50), new T2Vec(400,300));
			line2 = new T2Line(new T2Vec(50,350), new T2Vec(400,350));
			line3 = new T2Line(new T2Vec(200,200), new T2Vec(300,300));
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var projection:T2Vec;
			var mousePos:T2Vec = new T2Vec(this.mouseX, this.mouseY);
			
			this.graphics.clear();
			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(line0.pointAX, line0.pointAY);
			this.graphics.lineTo(line0.pointBX, line0.pointBY);
			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(line1.pointAX, line1.pointAY);
			this.graphics.lineTo(line1.pointBX, line1.pointBY);
			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(line2.pointAX, line2.pointAY);
			this.graphics.lineTo(line2.pointBX, line2.pointBY);
			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(line3.pointAX, line3.pointAY);
			this.graphics.lineTo(line3.pointBX, line3.pointBY);
			
			this.graphics.lineStyle(0);
			
			projection = line0.getProjectionPointWithoutBounds(mousePos);
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(projection.x, projection.y,3);
			this.graphics.endFill();
			
			projection = line1.getProjectionPointWithoutBounds(mousePos);
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawCircle(projection.x, projection.y,3);
			this.graphics.endFill();
			
			projection = line2.getProjectionPointWithoutBounds(mousePos);
			this.graphics.beginFill(0x0000ff);
			this.graphics.drawCircle(projection.x, projection.y,3);
			this.graphics.endFill();
			
			projection = line3.getProjectionPointWithinBounds(mousePos);
			this.graphics.beginFill(0x00ffff);
			this.graphics.drawCircle(projection.x, projection.y,3);
			this.graphics.endFill();
		}
	}
}