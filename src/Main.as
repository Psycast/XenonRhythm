package 
{
	import classes.user.User;
	import com.adobe.serialization.json.JSONManager;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Init Classes
			JSONManager.init();
			
			// Test Stuff
			var user:User = new User(true, true);
		}
		
	}
	
}