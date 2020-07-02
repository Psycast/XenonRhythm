package classes.engine
{
	import com.flashfla.utils.StringUtil;
	
	public class EngineLanguage
	{
		public var data:Object;
		public var indexed:Array;
		
		public var id:String;
		public var valid:Boolean = false;
		
		public function EngineLanguage(id:String)
		{
			this.id = id;
		}
		
		public function parseData(input:String):void
		{
			input = StringUtil.trim(input);
			// Create XML Tree
			try
			{
				var xmlMain:XML = new XML(input);
				var xmlChildren:XMLList = xmlMain.children();
			}
			catch (e:Error)
			{
				Logger.log(this, Logger.ERROR, "\"" + id + "\" - Malformed XML Language");
				return;
			}
			
			// Init Data Holders
			data = new Object();
			indexed = new Array();
			
			// Parse XML Tree
			for (var a:uint = 0; a < xmlChildren.length(); ++a)
			{
				// Check for Language Object, if not, create one.
				var lang:String = xmlChildren[a].attribute("id").toString();
				if (data[lang] == null)
				{
					data[lang] = new Object();
				}
				
				// Add Attributes to Object
				var langAttr:XMLList = xmlChildren[a].attributes();
				for (var b:uint = 0; b < langAttr.length(); b++)
				{
					data[lang]["_" + langAttr[b].name()] = langAttr[b].toString();
				}
				
				// Add Text to Object
				var langNodes:XMLList = xmlChildren[a].children();
				for (var c:uint = 0; c < langNodes.length(); c++)
				{
					data[lang][langNodes[c].attribute("id").toString()] = langNodes[c].children()[0].toString();
				}
				indexed[data[lang]["_index"]] = lang;
			}
			
			valid = true;
		}
		
		public function getString(id:String, lang:String = "us"):String
		{
			if (data[lang] && data[lang][id])
			{
				return data[lang][id];
			}
			
			return "";
		}

		/**
		 * Prefill the required elements for login screen, as only user data is loaded at that time to save time.
		 */
		public function loadLoginText():void
		{
			// Init Data Holders
			data = {
				"us": {
					"_en_name": "English",
					"_id": "us",
					"_index": "1",
					"_real_name": "English",
					"login_name": "Username:",
					"login_pass": "Password:",
					"login_remember": "Remember Me",
					"login_text": "LOGIN",
					"login_guest": "GUEST",
					"login_change_user": "CHANGE USER",
					"login_continue_as": "Continue as:",
					"login_invalid_session": "Expired session, please re-login to continue.",
					"login_status_failure": "Login Failure",
					"login_status_waiting": "Logging in..."
				}
			};
			indexed = ["us"];
			valid = true;
		}
	}
}