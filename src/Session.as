package
{
	import com.adobe.serialization.json.JSONManager;
	import com.flashfla.net.WebRequest;
	import flash.events.Event;
	
	public class Session
	{
		public static var SESSION_ID:String = "0";
		
		private var _funOnComplete:Function;
		private var _funOnError:Function;
		
		private var wr:WebRequest;
		
		public function Session(cbc:Function = null, cbf:Function = null)
		{
			wr = new WebRequest(Constant.SITE_LOGIN_URL, e_loginComplete, e_loginFailure);
			_funOnComplete = cbc;
			_funOnError = cbf;
		}
		
		private function e_loginFailure(e:Event):void
		{
			trace("3:[Session] Login Failure");
			if (_funOnError != null)
			{
				_funOnError(e);
			}
		}
		
		private function e_loginComplete(e:Event):void
		{
			var _data:Object = JSONManager.decode(e.target.data);
			if (_data["result"] && _data["session"] && _data["result"] == 1)
			{
				trace("4:[Session] Login Success! - Session ID:", _data["session"]);
				SESSION_ID = _data["session"];
				if (_funOnComplete != null)
				{
					_funOnComplete(e);
				}
			}
			else
			{
				e_loginFailure(e);
			}
		
		}
		
		public function login(uname:String, upass:String):void
		{
			if (!wr.active)
			{
				trace("0:[Session] Attempted Login:", uname);
				wr.load({"username": uname, "password": upass, "ver": Constant.VERSION});
			}
		}
	}
}