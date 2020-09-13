package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiGeomUtils;
	import com.ttrkaya.rigid2d.geom.RiVec;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	internal class RiTestLineIntersection extends RiTest
	{
		private var _v00:RiVec;
		private var _v01:RiVec;
		private var _v10:RiVec;
		private var _v11:RiVec;
		
		private var _drawer:Shape;
		
		public function RiTestLineIntersection(parent:DisplayObjectContainer)
		{
			super(parent);
			
			_v00 = new RiVec(300, 50);
			_v01 = new RiVec(350, 100);
			
			_v10 = new RiVec(50, 350);
			_v11 = new RiVec();
			
			_drawer = new Shape();
			_parent.addChild(_drawer);
		}
		
		protected override function update(dt:Number):void
		{
			_v11.x = _parent.mouseX;
			_v11.y = _parent.mouseY;
			
			_drawer.graphics.clear();
			_drawer.graphics.beginFill(0x000000);
			_drawer.graphics.drawRect(-1000, -1000, 3000, 3000);
			_drawer.graphics.endFill();
			
			_drawer.graphics.lineStyle(1, 0xffffff);
			_drawer.graphics.moveTo(_v00.x, _v00.y);
			_drawer.graphics.lineTo(_v01.x, _v01.y);
			_drawer.graphics.moveTo(_v10.x, _v10.y);
			_drawer.graphics.lineTo(_v11.x, _v11.y);
			
			var colPoint:RiVec = RiGeomUtils.getLineSegmentsIntersectionPoint(_v00, _v01, _v10, _v11);
			if(colPoint)
			{
				_drawer.graphics.lineStyle(1, 0xff8888);
				_drawer.graphics.drawCircle(colPoint.x, colPoint.y, 3);
			}
		}
	}
}