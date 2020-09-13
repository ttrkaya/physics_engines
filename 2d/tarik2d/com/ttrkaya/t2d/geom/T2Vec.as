package com.ttrkaya.t2d.geom
{
	public class T2Vec
	{
		public var x:Number;
		public var y:Number;
		
		public function T2Vec(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function get lengthSquared():Number { return x*x + y*y; }
		public function get length():Number { return Math.sqrt(x*x + y*y); }
		
		public function dotProduct(p:T2Vec):Number { return x*p.x + y*p.y; }
		public function crossProduct(p:T2Vec):Number { return x*p.y - y*p.x; }
		
		public function normalize():void
		{
			if(x != 0 || y != 0)
			{
				var l:Number = this.length;
				x /= l;
				y /= l;
			}
		}
		public function magnify(n:Number):void { x*=n; y*=n; }
		public function getMagnified(n:Number):T2Vec { return new T2Vec(x*n, y*n); }
		
		public function substract(p:T2Vec):T2Vec { return new T2Vec(x-p.x, y-p.y); }
		public function add(p:T2Vec):T2Vec { return new T2Vec(x+p.x, y+p.y); }
		
		public function clone():T2Vec { return new T2Vec(x,y); }
	}
}