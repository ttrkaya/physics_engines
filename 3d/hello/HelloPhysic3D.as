package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import math.Vec4;
	
	import physic.CubeBody;
	import physic.Physics;
	import physic.SphereBody;
	
	import render.CubeTransformer;
	import render.Renderer;
	import render.Sphere;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class HelloPhysic3D extends Sprite
	{
		private var _physics:Physics;
		private var _sphereBody0:SphereBody;
		private var _sphereBody1:SphereBody;
		private var _cubeBody0:CubeBody;
		private var _cubeBody1:CubeBody;
		
		private var _renderer:Renderer;
		private var _sphereViewCenter0:Vec4;
		private var _sphereViewCenter1:Vec4;
		private var _cubeView0:CubeTransformer;
		private var _cubeView1:CubeTransformer;
		
		private const _sphereR0:Number = 30;
		private const _sphereR1:Number = 30;
		
		private var _isMouseDown:Boolean = false;
		
		private var _lastUpdatedTime:Number;
		
		private static const SW:Number = 400;
		private static const SH:Number = 400;
		
		private static const cubePos0:Vec4 = new Vec4(100,0,0);
		private static const cubeHalfSize0:Vec4 = new Vec4(30,30,30);
		private static const cubePos1:Vec4 = new Vec4(100,-150,0);
		private static const cubeHalfSize1:Vec4 = new Vec4(30,30,30);
		
		public function HelloPhysic3D()
		{
			_renderer = new Renderer();
			_renderer.setCameraPos(0,0,-300);
			this.addChild(_renderer);
			_renderer.x = SW/2;
			_renderer.y = SH/2;
			
			_sphereViewCenter0 = new Vec4(-100,10,0);
			_sphereViewCenter1 = new Vec4(0,0,0);
			_renderer.addSphere(_sphereViewCenter0, _sphereR0, 0x00ff00, 1);
			_renderer.addSphere(_sphereViewCenter1, _sphereR1, 0x00ff00, 1);
			_cubeView0 = _renderer.addCube(cubePos0, cubeHalfSize0.x, cubeHalfSize0.y, cubeHalfSize0.z, 0x00ff00, 1);
			_cubeView1 = _renderer.addCube(cubePos1, cubeHalfSize1.x, cubeHalfSize1.y, cubeHalfSize1.z, 0x00ff00, 1);
			
			_physics = new Physics();
			
			_sphereBody0 = _physics.addSphere(_sphereViewCenter0, _sphereR0);
			_sphereBody1 = _physics.addSphere(_sphereViewCenter1, _sphereR1);
			_cubeBody0 = _physics.addCube(cubePos0, cubeHalfSize0);
			_cubeBody1 = _physics.addCube(cubePos1, cubeHalfSize1);
			
			_lastUpdatedTime = getNow();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var now:Number = getNow();
			var dt:Number = now - _lastUpdatedTime;
			_lastUpdatedTime = now;
			
			_physics.update(dt);
			
			_sphereViewCenter0.copy(_sphereBody0.getCenter());
			_sphereViewCenter1.copy(_sphereBody1.getCenter());
			_cubeView0.pos.copy(_cubeBody0.getCenter());
			_cubeView1.pos.copy(_cubeBody1.getCenter());
			_cubeView0.orientation.copy(_cubeBody0.getOrientation());
			_cubeView1.orientation.copy(_cubeBody1.getOrientation());
			
//			if(_isMouseDown)
//			{
//				var mdx:Number = stage.mouseX - SW/2;
//				var mdy:Number = stage.mouseY - SH/2;
//				_renderer.rotateCamera(new Vec4(-mdy,-mdx,0), dt*0.01);
//			}
			
			_renderer.render();
		}
		
		private function getNow():Number { return (new Date()).time / 1000; }
		
		private function onMouseDown(e:MouseEvent):void
		{
			_isMouseDown = true;
			
			reset();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_isMouseDown = false;
		}
		
		private function reset():void
		{
			_sphereBody0.setCenter(new Vec4(-100,10,0));
			_sphereBody1.setCenter(new Vec4(0,0,0));
			_sphereBody0.setAngVel(new Vec4(0,0,0,0));
			_sphereBody1.setAngVel(new Vec4(0,0,0,0));
			_sphereBody0.setLinVel(new Vec4(0,0,0,0));
			_sphereBody1.setLinVel(new Vec4(0,0,0,0));
			
			_cubeBody0.setCenter(new Vec4(100,0,0));
			_cubeBody1.setCenter(new Vec4(100,-150,0));
			_cubeBody0.setLinVel(new Vec4(0,0,0,0));
			_cubeBody1.setLinVel(new Vec4(0,0,0,0));
			_cubeBody0.setAngVel(new Vec4(0,0,0,0));
			_cubeBody1.setAngVel(new Vec4(0,0,0,0));
			
			_cubeBody0.setAngVel(new Vec4(Math.random(),Math.random(),Math.random()));
			_cubeBody1.setAngVel(new Vec4(Math.random(),Math.random(),Math.random()));
			
			_cubeBody1.setLinVel(new Vec4(0,50,0,0));
			_sphereBody0.setLinVel(new Vec4(50,0,0,0));
		}
	}
}