package com.ttrkaya.rigid2d.test
{
	import flash.display.DisplayObjectContainer;

	public class RiTester
	{
		private var _parent:DisplayObjectContainer;
		
		private var _test:RiTest;
		
		public function RiTester(parent:DisplayObjectContainer)
		{
			_parent = parent;
		}
		
		public function testBasic():void
		{
			destroyOldTest();
			_test = new RiTestBasic(_parent);
		}
		
		public function testFall():void
		{
			destroyOldTest();
			_test = new RiTestFall(_parent);
		}
		
		public function testCollisionCirclesPair():void
		{
			destroyOldTest();
			_test = new RiTestCollisionCirclesPair(_parent);
		}
		
		public function testCollisionCirclePolygonPair():void
		{
			destroyOldTest();
			_test = new RiTestCollisionCirclePolygonPair(_parent);
		}
		
		public function testCollisionPolygonsPair():void
		{
			destroyOldTest();
			_test = new RiTestCollisionPolygonsPair(_parent);
		}
		
		public function testCollisionStatic():void
		{
			destroyOldTest();
			_test = new RiTestCollisionStatic(_parent);
		}
		
		public function testCrowdedFall():void
		{
			destroyOldTest();
			_test = new RiTestCrowdedFall(_parent);
		}
		
		public function testCircleInsidePolygon():void
		{
			destroyOldTest();
			_test = new RiTestCircleInsidePolygon(_parent);
		}
		
		public function testFriction():void
		{
			destroyOldTest();
			_test = new RiTestFriction(_parent);
		}
		
		public function testStackOfBoxes():void
		{
			destroyOldTest();
			_test = new RiTestStackOfBoxes(_parent);
		}
		
		public function testLineIntersaction():void
		{
			destroyOldTest();
			_test = new RiTestLineIntersection(_parent);
		}
		
		public function testCutting():void
		{
			destroyOldTest();
			_test = new RiTestCutting(_parent);
		}
		
		public function testSmallCircleTowardsBigPolygon():void
		{
			destroyOldTest();
			_test = new RiTestSmallCircleTowardsBigPolygon(_parent);
		}
		
		public function testSmallPolygonTowardsBigCircle():void
		{
			destroyOldTest();
			_test = new RiTestSmallPolygonTowardsBigCircle(_parent);
		}
		
		private function destroyOldTest():void
		{
			if(_test)
			{
				_test.destroy();
				_test = null;
			}
		}
	}
}