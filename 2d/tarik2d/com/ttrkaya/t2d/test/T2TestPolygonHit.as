package com.ttrkaya.t2d.test
{
	import com.ttrkaya.t2d.geom.T2Polygon;
	import com.ttrkaya.t2d.geom.T2Vec;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	internal class T2TestPolygonHit extends Sprite
	{
		private var polygon:T2Polygon;
		
		public function T2TestPolygonHit()
		{
			polygon = new T2Polygon(new <T2Vec>[
				new T2Vec(30,50),
				new T2Vec(150,50),
				new T2Vec(50,150),
				new T2Vec(550,30),
				new T2Vec(250,150),
				new T2Vec(350,350),
				new T2Vec(30,200),
			]);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0);
			this.graphics.beginFill(polygon.hitTestPoint(new T2Vec(this.mouseX, this.mouseY)) ? 0x00ff00 : 0x0000ff);
			this.graphics.moveTo(polygon.getX(polygon.numPoints-1), polygon.getY(polygon.numPoints-1));
			for(var i:int=0; i<polygon.numPoints; i++)
			{
				this.graphics.lineTo(polygon.getX(i), polygon.getY(i));
			}
			this.graphics.endFill();
		}
	}
}