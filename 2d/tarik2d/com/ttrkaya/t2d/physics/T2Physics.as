package com.ttrkaya.t2d.physics
{
	import com.ttrkaya.t2d.geom.T2Circle;
	import com.ttrkaya.t2d.geom.T2Line;
	import com.ttrkaya.t2d.geom.T2Vec;
	import com.ttrkaya.t2d.physics.body.T2BodyDynamicCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticCircle;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticLine;
	import com.ttrkaya.t2d.physics.body.T2BodyStaticPoint;

	public class T2Physics
	{
		private var _dynamicCircles:Vector.<T2BodyDynamicCircle>;
		private var _staticCircles:Vector.<T2BodyStaticCircle>;
		private var _lines:Vector.<T2BodyStaticLine>;
		private var _points:Vector.<T2BodyStaticPoint>;
		
		public function T2Physics()
		{
			_dynamicCircles = new Vector.<T2BodyDynamicCircle>;
			_staticCircles = new Vector.<T2BodyStaticCircle>;
			_lines = new Vector.<T2BodyStaticLine>;
			_points = new Vector.<T2BodyStaticPoint>;
		}
		
		public function createDynamicCircle(x:Number, y:Number, r:Number, mass:Number, friction:Number, velX:Number = 0, velY:Number = 0):T2BodyDynamicCircle
		{
			var circle:T2Circle = new T2Circle(new T2Vec(x,y),r);
			var dynamicCircle:T2BodyDynamicCircle = new T2BodyDynamicCircle(circle, mass, friction, new T2Vec(velX, velY));
			_dynamicCircles.push(dynamicCircle);
			return dynamicCircle;
		}
		
		public function destroyDynamicCircle(c:T2BodyDynamicCircle):void
		{
			for(var i:int=0; i<_dynamicCircles.length; i++)
			{
				if(_dynamicCircles[i] == c)
				{
					_dynamicCircles.splice(i,1);
					return;
				}
			}
		}
		
		public function createStaticCircle(x:Number, y:Number, r:Number):T2BodyStaticCircle
		{
			var staticCircle:T2BodyStaticCircle = new T2BodyStaticCircle(new T2Circle(new T2Vec(x,y),r));
			_staticCircles.push(staticCircle);
			return staticCircle;
		}
		
		public function destroyStaticCircle(c:T2BodyStaticCircle):void
		{
			for(var i:int=0; i<_staticCircles.length; i++)
			{
				if(_staticCircles[i] == c)
				{
					_staticCircles.splice(i,1);
					return;
				}
			}
		}
		
		public function createStaticLine(x1:Number,y1:Number,x2:Number,y2:Number,normalX:Number,normalY:Number):T2BodyStaticLine
		{
			var body:T2BodyStaticLine = new T2BodyStaticLine(new T2Line(new T2Vec(x1,y1), new T2Vec(x2,y2)),new T2Vec(normalX,normalY));
			_lines.push(body);
			return body;
		}
		
		public function destroyStaticLine(l:T2BodyStaticLine):void
		{
			for(var i:int=0; i<_lines.length; i++)
			{
				if(_lines[i] == l)
				{
					_lines.splice(i,1);
					return;
				}
			}
		}
		
		public function createStaticPoint(x:Number,y:Number):T2BodyStaticPoint
		{
			var body:T2BodyStaticPoint = new T2BodyStaticPoint(new T2Vec(x,y));
			_points.push(body);
			return body;
		}
		
		public function destroyStaticPoint(p:T2BodyStaticPoint):void
		{
			for(var i:int=0; i<_points.length; i++)
			{
				if(_points[i] == p)
				{
					_points.splice(i,1);
					return;
				}
			}
		}
		
		public function update(dt:Number):void
		{
			var i:int, j:int, dynamicCircle:T2BodyDynamicCircle, dynamicCircle2:T2BodyDynamicCircle;
			var collision:T2Collision;
			var minColTime:Number, colTime:Number;
			
			//clear collision lists
			for(i=0; i<_dynamicCircles.length; i++)
			{
				_dynamicCircles[i].clearCollisionList();
			}
			
			while(dt > 0)
			{
				//calculate soonest collision
				collision = null;
				minColTime = Number.MAX_VALUE;
				for(i=0; i<_dynamicCircles.length; i++)
				{
					dynamicCircle = _dynamicCircles[i];  
					for(j=i+1; j<_dynamicCircles.length; j++)
					{
						dynamicCircle2 = _dynamicCircles[j];
						
						if(dynamicCircle.filterMask & dynamicCircle2.filterMask)
						{
							var dp:T2Vec = new T2Vec(dynamicCircle2.x-dynamicCircle.x, dynamicCircle2.y-dynamicCircle.y);
							var dv:T2Vec = new T2Vec(dynamicCircle2.velX-dynamicCircle.velX, dynamicCircle2.velY-dynamicCircle.velY);
							if(dp.dotProduct(dv) < 0)
							{
								colTime = dynamicCircle.getTimeOfCollisionWithDynamicCircle(dynamicCircle2);
								if(colTime > 0 && colTime < dt && colTime < minColTime)
								{
									
									minColTime = colTime;
									collision = new T2CollisionDCwDC(dynamicCircle, dynamicCircle2);
								}
							}
						}
					}
				}
				
				for(i=0; i<_lines.length; i++)
				{
					var line:T2BodyStaticLine = _lines[i];
					for(j=0; j<_dynamicCircles.length; j++)
					{
						dynamicCircle = _dynamicCircles[j]; 
						
						if(dynamicCircle.filterMask & line.filterMask)
						{
							if(line.normal.x*dynamicCircle.velX + line.normal.y*dynamicCircle.velY < 0)
							{
								colTime = line.getTimeOfCollisionWithCircle(dynamicCircle);
								if(colTime > 0 && colTime < dt && colTime < minColTime)
								{
									minColTime = colTime;
									collision = new T2CollisionDCwL(dynamicCircle,line);
								}
							}
						}
					}
				}
				
				for(i=0; i<_points.length; i++)
				{
					var point:T2BodyStaticPoint = _points[i];
					for(j=0; j<_dynamicCircles.length; j++)
					{
						dynamicCircle = _dynamicCircles[j];  
						
						if(dynamicCircle.filterMask & point.filterMask)
						{
							if(dynamicCircle.velX*(point.x-dynamicCircle.x)+dynamicCircle.velY*(point.y-dynamicCircle.y) > 0)
							{
								colTime = point.getTimeOfCollisionWithDynamicCircle(dynamicCircle);
								if(colTime > 0 && colTime < dt && colTime < minColTime)
								{
									minColTime = colTime;
									collision = new T2CollisionDCwP(dynamicCircle,point);
								}
							}
						}
					}
				}
				
				for(i=0; i<_staticCircles.length; i++)
				{
					var staticCircle:T2BodyStaticCircle = _staticCircles[i];  
					for(j=0; j<_dynamicCircles.length; j++)
					{
						dynamicCircle = _dynamicCircles[j];
						
						if(dynamicCircle.filterMask & staticCircle.filterMask)
						{
							if(dynamicCircle.velX*(staticCircle.x-dynamicCircle.x)+dynamicCircle.velY*(staticCircle.y-dynamicCircle.y) > 0)
							{
								colTime = staticCircle.getTimeOfCollisionWithDynamicCircle(dynamicCircle);
								if(colTime > 0 && colTime < dt && colTime < minColTime)
								{
									minColTime = colTime;
									collision = new T2CollisionDCwSC(dynamicCircle,staticCircle);
								}
							}
						}
					}
				}
				
				var dtApplied:Number = minColTime < dt ? minColTime : dt;
				for each(dynamicCircle in _dynamicCircles)
				{
					dynamicCircle.updatePoisition(dtApplied);
				}
				if(collision) collision.resolve();
				for each(dynamicCircle in _dynamicCircles)
				{
					dynamicCircle.updateVelocity(dtApplied);
				}
				dt -= dtApplied;
			}
			
		}
	}
}