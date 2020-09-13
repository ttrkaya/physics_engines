package com.ttrkaya.t2d.geom
{
	public class T2Line
	{
		private var _pointA:T2Vec;
		private var _pointB:T2Vec;
		
		//for optimization purposes (caching)
		private var _direction:T2Vec;
		private var _directionLengthSquared:Number;
		
		public function T2Line(T2PointA:T2Vec = null, T2PointB:T2Vec = null)
		{
			_pointA = T2PointA ? T2PointA : new T2Vec;
			_pointB = T2PointB ? T2PointB : new T2Vec;
			
			_direction = new T2Vec();  
			this.updateDirection();
		}
		
		private function updateDirection():void
		{
			_direction.x = _pointB.x - _pointA.x;
			_direction.y = _pointB.y - _pointA.y;  
			_directionLengthSquared = _direction.lengthSquared;
		}
		
		public function setPointA(x:Number, y:Number):void
		{
			_pointA.x = x;
			_pointA.y = y;
			this.updateDirection();
		}
		public function setPointB(x:Number, y:Number):void
		{
			_pointB.x = x;
			_pointB.y = y;
			this.updateDirection();
		}
		
		public function get pointAX():Number { return _pointA.x; }
		public function get pointAY():Number { return _pointA.y; }
		public function get pointBX():Number { return _pointB.x; }
		public function get pointBY():Number { return _pointB.y; }
		
		//returns a value between 0-1 in case of the projection is on the line
		//0 => projects on to _T2PointA
		//1 => projects on to -T2PointB
		//other results indicate that the T2Point's projection is not on the line
		public function getProjectionRatio(p:T2Vec):Number
		{
			return ((p.x - _pointA.x) * _direction.x + (p.y - _pointA.y) * _direction.y) / _directionLengthSquared;
		}
		
		public function getProjectionPointWithoutBounds(p:T2Vec):T2Vec
		{
			var u:Number = this.getProjectionRatio(p);
			return new T2Vec(_pointA.x + u*_direction.x, _pointA.y + u*_direction.y);
		}
		
		public function getProjectionPointWithinBounds(p:T2Vec):T2Vec
		{
			var u:Number = this.getProjectionRatio(p);
			if(u < 0) u = 0;
			if(u > 1) u = 1;
			return new T2Vec(_pointA.x + u*_direction.x, _pointA.y + u*_direction.y);
		}
		
		public function getDistanceSquaredFromPoint(p:T2Vec):Number
		{
			var pr:T2Vec = this.getProjectionPointWithinBounds(p);
			pr.x -= p.x;
			pr.y -= p.y;
			return pr.lengthSquared;
		}
		
		public function getDistanceFromPoint(p:T2Vec):Number
		{
			var pr:T2Vec = this.getProjectionPointWithinBounds(p);
			pr.x -= p.x;
			pr.y -= p.y;
			return pr.length;
		}
		
		public function getDistanceFromPointWithoutBounds(p:T2Vec):Number
		{
			var pr:T2Vec = this.getProjectionPointWithoutBounds(p);
			pr.x -= p.x;
			pr.y -= p.y;
			return pr.length;
		}
		
		public function collidesWithCircle(c:T2Circle):Boolean
		{
			var d:Number = this.getDistanceSquaredFromPoint(c.center);
			return d < c.r*c.r;
		}
		
		public function collidesWithLine(l:T2Line):Boolean
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return false; //parallel
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			return t <= 1 && t >= 0 && u <= 1 && u >= 0;
		}
		
		public function collidesWithInfiniteLine(l:T2Line):Boolean
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return false; //parallel
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			return u <= 1 && u >= 0;
		}
		
		public function getCollisionPointWithLine(l:T2Line):T2Vec
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return null; //parallel
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			if(t <= 1 && t >= 0 && u <= 1 && u >= 0)
			{
				return _pointA.add(_direction.getMagnified(u));
			}
			return null;
		}
		
		public function getCollisionPointWithInfiniteLine(l:T2Line):T2Vec
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return null; //parallel
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			if(u <= 1 && u >= 0)
			{
				return _pointA.add(_direction.getMagnified(u));
			}
			return null;
		}
		
		public function getCollisionRatioWithLine(l:T2Line):Number
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return -1;
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			if(t <= 1 && t >= 0 && u <= 1 && u >= 0)
			{
				return u;
			}
			return -1;
		}
		
		public function getCollisionRatioWithInfiniteLine(l:T2Line):Number
		{
			var directionCross:Number = l._direction.crossProduct(_direction);
			if(directionCross == 0) return -1;
			
			var pointADiff:T2Vec = _pointA.substract(l._pointA)
			var t:Number = pointADiff.crossProduct(_direction) / directionCross;
			var u:Number = pointADiff.crossProduct(l._direction) / directionCross;
			
			if(u <= 1 && u >= 0)
			{
				return t;
			}
			return -1;
		}
	}
}