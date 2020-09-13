package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBody;
	import com.ttrkaya.rigid2d.phys.RiBodyCircle;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;

	internal class RiTestCrowdedFall extends RiTest
	{
		private var _world:RiWorld;
		
		private var _bodies:Vector.<RiBody>;
		private var _views:Vector.<Shape>;
		
		public function RiTestCrowdedFall(parent:DisplayObjectContainer)
		{
			var i:int;
			
			super(parent);
			
			_world = new RiWorld(new RiVec(0, 70));
			
			var platformPos:Point = new Point(200, 380);
			var platformHalfSize:Point = new Point(150, 10);
			var platformBody:RiBodyPolygon = _world.addBodyPolygon(new <RiVec>[
				new RiVec(platformPos.x + platformHalfSize.x, platformPos.y + platformHalfSize.y),
				new RiVec(platformPos.x - platformHalfSize.x, platformPos.y + platformHalfSize.y),
				new RiVec(platformPos.x - platformHalfSize.x, platformPos.y - platformHalfSize.y),
				new RiVec(platformPos.x + platformHalfSize.x, platformPos.y - platformHalfSize.y)
			], 1);
			platformBody.setStatic();
			var platformView:Shape = getViewPolygon(platformBody.getGlobalVertices(), 0xff8888);
			_parent.addChild(platformView);
			
			_bodies = new Vector.<RiBody>;
			_views = new Vector.<Shape>;
			
			for(i=0; i<5; i++)
			{
				var r:Number = 10 + 25*Math.random();
				var circleBody:RiBodyCircle = _world.addBodyCircle(400*Math.random(), -600*Math.random(), r);
				_bodies.push(circleBody);
				
				var circleView:Shape = getViewCircle(r);
				circleView.alpha = 0.5;
				_parent.addChild(circleView);
				_views.push(circleView);
			}
			for(i=0; i<8; i++)
			{
				const CC:Number = 10;
				const CR:Number = 15;
				var vertices:Vector.<RiVec> = new <RiVec>[
					new RiVec((CC+CR*Math.random()), (CC+CR*Math.random())),
					new RiVec(-(CC+CR*Math.random()), (CC+CR*Math.random())),
					new RiVec(-(CC+CR*Math.random()), -(CC+CR*Math.random())),
					new RiVec((CC+CR*Math.random()), -(CC+CR*Math.random()))
				];
				var polyBody:RiBodyPolygon = _world.addBodyPolygon(vertices, 1);
				polyBody.setPos(new RiVec(400*Math.random(), -600*Math.random()));
				_bodies.push(polyBody);
				
				var polyView:Shape = getViewPolygon(polyBody.getLocalVertices());
				polyView.alpha = 0.5;
				_parent.addChild(polyView);
				_views.push(polyView);
			}
			for(i=0; i<7; i++)
			{
				var halfSize:RiVec = new RiVec(10 + 20 * Math.random(), 10 + 20 * Math.random());
				var pos:RiVec = new RiVec(400*Math.random(), -600*Math.random());
				var rectBody:RiBodyPolygon = _world.addBodyRectangle(pos, halfSize, 1);
				_bodies.push(rectBody);
				
				var rectView:Shape = getViewPolygon(rectBody.getLocalVertices(), 0x00ffff);
				rectView.alpha = 0.5;
				_parent.addChild(rectView);
				_views.push(rectView);
			}
		}
		
		protected override function update(dt:Number):void
		{
			var i:int;
			
			_world.update(dt);
			
			for(i=0; i<_bodies.length; i++)
			{
				var body:RiBody = _bodies[i];
				if(body.getPosY() > 500)
				{
					body.setPos(new RiVec(Math.random() * 400, -100));
					body.setLinVel(body.getLinVel().getScaled(0.3));
				}
				
				var view:Shape = _views[i];
				view.x = body.getPosX();
				view.y = body.getPosY();
				view.rotation = body.getOrientation() * 180 / Math.PI;
			}
		}
	}
}