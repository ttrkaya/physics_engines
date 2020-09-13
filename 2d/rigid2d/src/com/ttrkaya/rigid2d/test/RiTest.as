package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	internal class RiTest
	{
		protected var _parent:DisplayObjectContainer;
		
		private var _lastUpdateTime:Number;
		
		public function RiTest(parent:DisplayObjectContainer)
		{
			_parent = parent;
			
			_lastUpdateTime = getNow();
			_parent.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function destroy():void
		{
			_parent.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_parent.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_parent.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function getNow():Number { return (new Date()).time / 1000; }
		
		private function onEnterFrame(e:Event):void
		{
			var now:Number = getNow();
			var dt:Number = now - _lastUpdateTime;
			_lastUpdateTime = now;
			
			this.update(dt);
		}
		
		protected function update(dt:Number):void
		{
			throw "override this";
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			
		}
		
		protected function getViewCircle(r:Number, color:uint=0x00ff00):Shape
		{
			var view:Shape = new Shape();
			
			view.graphics.lineStyle(1, 0x0);
			view.graphics.beginFill(color);
			view.graphics.drawCircle(0, 0, r);
			view.graphics.endFill();
			
			view.graphics.moveTo(0, 0);
			view.graphics.lineTo(r, 0);
			
			view.alpha = 0.5;
			
			return view;
		}
		
		protected function getViewPolygon(vertices:Vector.<RiVec>, color:uint=0x0000ff):Shape
		{
			var i:int, l:int;
			
			var view:Shape = new Shape();
			
			var vertex0:RiVec = vertices[0];
			view.graphics.lineStyle(1, 0x0);
			view.graphics.beginFill(color);
			view.graphics.moveTo(vertex0.x, vertex0.y);
			for(i=1, l=vertices.length; i<l; i++)
			{
				var vertex:RiVec = vertices[i];
				view.graphics.lineTo(vertex.x, vertex.y);
			}
			view.graphics.endFill();
			
			view.alpha = 0.5;
			
			return view;
		}
	}
}