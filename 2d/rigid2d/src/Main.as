package
{
	import com.ttrkaya.rigid2d.phys.RiBodyTypes;
	import com.ttrkaya.rigid2d.test.RiTester;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class Main extends Sprite
	{
		public static var _stage:Stage;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_stage = stage;
			
			(new RiTester(stage)).testCrowdedFall();
		}
	}
}