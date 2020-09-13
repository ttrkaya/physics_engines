package com.ttrkaya.t2d.test
{
	import com.ttrkaya.t2d.geom.T2Line;
	import com.ttrkaya.t2d.geom.T2Vec;
	
	import flash.display.Sprite;
	import flash.events.Event;

	internal class T2TestLineIntersection extends Sprite
	{
		private var line0:T2Line;
		private var line1:T2Line;
		
		public function T2TestLineIntersection()
		{
			line0 = new T2Line(new T2Vec(50,50), new T2Vec(550,350));
			line1 = new T2Line(new T2Vec(10,390), new T2Vec(0,0));
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			line1.setPointB(this.mouseX, this.mouseY);
			var doesCollide:Boolean = line0.collidesWithLine(line1);
			
			this.graphics.clear();
			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(line0.pointAX, line0.pointAY);
			this.graphics.lineTo(line0.pointBX, line0.pointBY);
			
			this.graphics.lineStyle(1,doesCollide ? 0xff0000 : 0);
			this.graphics.moveTo(line1.pointAX, line1.pointAY);
			this.graphics.lineTo(line1.pointBX, line1.pointBY);
			
			var collisionPoint:T2Vec = line0.getCollisionPointWithLine(line1);
			if(collisionPoint)
			{
				this.graphics.lineStyle(1,0x00ff00);
				this.graphics.drawCircle(collisionPoint.x, collisionPoint.y, 3);
			}
		}
	}
}