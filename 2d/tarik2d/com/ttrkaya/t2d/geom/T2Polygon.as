package com.ttrkaya.t2d.geom
{
	public class T2Polygon
	{
		private var _points:Vector.<T2Vec>;
		
		public function T2Polygon(points:Vector.<T2Vec> = null)
		{
			_points = points ? points : new Vector.<T2Vec>;
		}
		
		public function getX(i:int):Number { return _points[i].x; }
		public function getY(i:int):Number { return _points[i].y; }
		public function get numPoints():Number { return _points.length; }
		
		public function addPoint(point:T2Vec):void
		{
			_points.push(point);
		}
		
		public function clear():void
		{
			_points.length = 0;
		}
		
		public function hitTestPoint(o:T2Vec):Boolean
		{
			var r:Boolean = false;
			for(var i:int=0; i<_points.length; i++)
			{
				var p:T2Vec = _points[i];
				var q:T2Vec = _points[(i+1)%_points.length];
				
				if ((p.y <= o.y && o.y < q.y || 
					q.y <= o.y && o.y < p.y) &&
					o.x < p.x + (q.x - p.x) * (o.y - p.y) / (q.y - p.y))
					r = !r;
			}
			return r;
		}
	}
}