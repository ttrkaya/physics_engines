package com.ttrkaya.t2d.test
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	public class T2Tester
	{
		private var _parent:DisplayObjectContainer
		
		public function T2Tester(parent:DisplayObjectContainer)
		{
			_parent = parent;
		}
		
		public function testPhysics():void { _parent.addChild(new T2TestPhysics()); }
		public function testLineProjection():void { _parent.addChild(new T2TestLineProjection); }
		public function testLineIntersection():void { _parent.addChild(new T2TestLineIntersection); }
		public function testLineIntersectionInfinite():void { _parent.addChild(new T2TestLineIntersectionInfinite); }
		public function testPolygonHit():void { _parent.addChild(new T2TestPolygonHit); }
	}
}