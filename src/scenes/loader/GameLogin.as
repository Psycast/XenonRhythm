package scenes.loader 
{
	import classes.engine.EngineCore;
	import classes.UICore;
	import classes.user.User;
	import flash.events.Event;
	
	public class GameLogin extends UICore 
	{
		
		public function GameLogin(core:EngineCore) 
		{
			super(core);
		}
		
		override public function init():void
		{
			// Login User
			var session:Session = new Session(_loginUserComplete, _loginUserError);
			session.login(DebugStrings.USERNAME, DebugStrings.PASSWORD);
		}
		
		private function _loginUserComplete(e:Event):void
		{
			log(0, "User Login Success");
			
			// Load User using Session
			core.user = new User(true, true);
			core.user.permissions.didLogin = true;
			
			// Jump back to Loading Screen
			core.scene = new GameLoader_UI(core);
		}
		
		private function _loginUserError(e:Event):void
		{
			log(0, "User Login Error");
		}
	}

}