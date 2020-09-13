package com.ttrkaya.rigid2d.test
{
	import com.ttrkaya.rigid2d.geom.RiGeomUtils;
	import com.ttrkaya.rigid2d.geom.RiVec;
	import com.ttrkaya.rigid2d.phys.RiBody;
	import com.ttrkaya.rigid2d.phys.RiBodyPolygon;
	import com.ttrkaya.rigid2d.phys.RiWorld;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	internal class RiTestCutting extends RiTest
	{
		private var _world:RiWorld;
		private var _bodies:Vector.<RiBodyPolygon>;
		private var _views:Vector.<Shape>;
		private var _viewsContainer:Sprite;
		private var _cutLineDrawer:Shape;
		
		private var _mouseDownPos:RiVec;
		
		public function RiTestCutting(parent:DisplayObjectContainer)
		{
			super(parent);
			
			_world = new RiWorld(new RiVec(0, 50));
			
			_viewsContainer = new Sprite();
			_parent.addChild(_viewsContainer);
			_cutLineDrawer = new Shape();
			_parent.addChild(_cutLineDrawer);
			
			var platformBody:RiBodyPolygon = _world.addBodyRectangle(new RiVec(200, 390), new RiVec(200,10), 1);
			platformBody.setStatic();
			var platformView:Shape = getViewPolygon(platformBody.getGlobalVertices(), 0xff8888);
			_viewsContainer.addChild(platformView);
			
			_bodies = new Vector.<RiBodyPolygon>;
			_views = new Vector.<Shape>;
			
			var staticBody:RiBodyPolygon = _world.addBodyRectangle(new RiVec(200, 100), new RiVec(100, 30));
			staticBody.setStatic();
			_bodies.push(staticBody);
			var staticView:Shape = getViewPolygon(staticBody.getLocalVertices());
			_viewsContainer.addChild(staticView);
			_views.push(staticView);
		}
		
		protected override function update(dt:Number):void
		{
			var i:int, l:int;
			
			_world.update(dt);
			
			for(i=0, l=_bodies.length; i<l; i++)
			{
				var body:RiBodyPolygon = _bodies[i];
				var view:Shape = _views[i];
				view.x = body.getPosX();
				view.y = body.getPosY();
				view.rotation = body.getOrientation() * 180 / Math.PI;
			}
			
			_cutLineDrawer.graphics.clear();
			if(_mouseDownPos)
			{
				_cutLineDrawer.graphics.lineStyle(1, 0xffffff);
				_cutLineDrawer.graphics.moveTo(_mouseDownPos.x, _mouseDownPos.y);
				_cutLineDrawer.graphics.lineTo(_parent.mouseX, _parent.mouseY);
			}
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			_mouseDownPos = new RiVec(e.stageX, e.stageY);
		}
		
		protected override function onMouseUp(e:MouseEvent):void
		{
			var i:int, l:int;
			
			var mouseUpPos:RiVec = new RiVec(e.stageX, e.stageY);
			
			//check for cuts
			for(i=0, l=_bodies.length; i<l; i++)
			{
				var oldBody:RiBodyPolygon = _bodies[i];
				var cutPoints:Vector.<CutPoint> = getCutPoints(oldBody, _mouseDownPos, mouseUpPos);
				
//				_viewsContainer.graphics.lineStyle(1, 0xff0000);
//				for each(var c:CutPoint in cutPoints) _viewsContainer.graphics.drawCircle(c.pos.x, c.pos.y, 3);
				
				if(cutPoints.length == 2)
				{
					_world.destroyBody(oldBody);
					_bodies.splice(i, 1);
					
					var oldView:Shape = _views[i];
					_viewsContainer.removeChild(oldView);
					_views.splice(i, 1);
					
					var newVerticesPair:Vector.<Vector.<RiVec>> = getNewVertices(oldBody.getGlobalVertices(), cutPoints);
					for(var t:int=0; t<2; t++)
					{
						var newVertices:Vector.<RiVec> = newVerticesPair[t];
						var newBody:RiBodyPolygon = _world.addBodyPolygon(newVertices);
						if(newVertices.length != 3) newBody.setStatic();
						_bodies.splice(i,0,newBody);
						var newView:Shape = getViewPolygon(newBody.getLocalVertices(), newBody.isStatic() ? 0x0000ff : 0x00ffff);
						_viewsContainer.addChild(newView);
						_views.splice(i,0,newView);
					}
					
					i++;
					l++;
				}
				
			}
			
			_mouseDownPos = null;
		}
		
		private function getCutPoints(body:RiBodyPolygon, v0:RiVec, v1:RiVec):Vector.<CutPoint>
		{
			var i:int, l:int;
			
			var cutPoints:Vector.<CutPoint> = new Vector.<CutPoint>;
			var vertices:Vector.<RiVec> = body.getGlobalVertices();
			l = vertices.length;
			var vertex0:RiVec = vertices[l-1];
			for(i=0; i<l; i++)
			{
				var vertex1:RiVec = vertices[i];
				
				var cutPos:RiVec = RiGeomUtils.getLineSegmentsIntersectionPoint(vertex0, vertex1, v0, v1);
				if(cutPos)
				{
					var cutPoint:CutPoint = new CutPoint();
					cutPoint.pos = cutPos;
					cutPoint.lineIndex = i;
					cutPoints.push(cutPoint);
				}
				
				vertex0 = vertex1;
			}
			
			return cutPoints;
		}
		
		private function getNewVertices(oldVertices:Vector.<RiVec>, cutPoints:Vector.<CutPoint>):Vector.<Vector.<RiVec>>
		{
			var i:int, l:int;
			
			var r:Vector.<Vector.<RiVec>> = new Vector.<Vector.<RiVec>>(2);
			
			var newVertices0:Vector.<RiVec> = new Vector.<RiVec>;
			var newVertices1:Vector.<RiVec> = new Vector.<RiVec>;
			r[0] = newVertices0;
			r[1] = newVertices1;
			
			var passedCutPoint0:Boolean = false;
			var passedCutPoint1:Boolean = false;
			for(i=0, l=oldVertices.length; i<l; i++)
			{
				var oldVertex:RiVec = oldVertices[i];
				
				if(passedCutPoint1)
				{
					newVertices0.push(oldVertex);
				}
				else if(passedCutPoint0)
				{
					if(i == cutPoints[1].lineIndex)
					{
						newVertices0.push(cutPoints[1].pos);
						newVertices1.push(cutPoints[1].pos);
						newVertices0.push(oldVertex);
						passedCutPoint1 = true;
					}
					else
					{
						newVertices1.push(oldVertex);
					}
				}
				else
				{
					if(i == cutPoints[0].lineIndex)
					{
						newVertices0.push(cutPoints[0].pos);
						newVertices1.push(cutPoints[0].pos);
						newVertices1.push(oldVertex);
						passedCutPoint0 = true;
					}
					else
					{
						newVertices0.push(oldVertex);
					}
					
				}
			}
			
			return r;
		}
	}
}

import com.ttrkaya.rigid2d.geom.RiVec;

class CutPoint
{
	public var pos:RiVec;
	public var lineIndex:int;
}