package scenes.loader
{
	import assets.menu.FFRDudeCenter;
	import assets.menu.FFRName;
	import classes.engine.EngineCore;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxCheck;
	import classes.ui.BoxInput;
	import classes.ui.Label;
	import classes.ui.UICore;
	import classes.user.User;
	import com.greensock.easing.Power2;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	public class SceneGameLogin extends UICore
	{
		private var guest_btn:BoxButton;
		private var login_btn:BoxButton;
		private var input_user:BoxInput;
		private var input_pass:BoxInput;
		private var save_checkbox:BoxCheck;
		private var loginBox:Box;
		
		//------------------------------------------------------------------------------------------------//
		
		public function SceneGameLogin(core:EngineCore)
		{
			super(core);
			core.flags[Flag.LOGIN_SCREEN_SHOWN] = true;
		}
		
		override public function onStage():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_loginKeyDown);
			super.onStage();
		}
		
		override public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_loginKeyDown);
		}
		
		override public function draw():void
		{
			// FFR Dude
			var ffrlogo:FFRDudeCenter = new FFRDudeCenter();
			ffrlogo.x = Constant.GAME_WIDTH_CENTER - 125;
			ffrlogo.y = Constant.GAME_HEIGHT_CENTER - 150;
			ffrlogo.scaleX = ffrlogo.scaleY = 1.5;
			ffrlogo.alpha = 0.85;
			addChild(ffrlogo);
			
			// FFR Name
			var ffrname:FFRName = new FFRName();
			ffrname.x = Constant.GAME_WIDTH_CENTER - 75;
			ffrname.y = Constant.GAME_HEIGHT_CENTER - 150;
			ffrname.alpha = 0.85;
			addChild(ffrname);
			
			// Login Box
			loginBox = new Box(this, Constant.GAME_WIDTH_CENTER - 75, Constant.GAME_HEIGHT_CENTER - 70);
			loginBox.setSize(300, 140);
			loginBox.alpha = 0;
			
			//- Text
			// Username
			new Label(loginBox, 5, 5, core.getString("login_name"));
			
			input_user = new BoxInput(loginBox, 5, 25);
			input_user.setSize(290, 20);
			
			// Password
			new Label(loginBox, 5, 55, core.getString("login_pass"));
			
			input_pass = new BoxInput(loginBox, 5, 75);
			input_pass.setSize(290, 20);
			input_pass.password = true;
			
			// Save Login
			new Label(loginBox, 110, 108, core.getString("login_remember"));
			
			save_checkbox = new BoxCheck(loginBox, 92, 113);
			
			//- Buttons
			guest_btn = new BoxButton(loginBox, 6, loginBox.height - 36, core.getString("login_guest"), e_playAsGuest);
			guest_btn.setSize(75, 30);
			
			login_btn = new BoxButton(loginBox, loginBox.width - 81, loginBox.height - 36, core.getString("login_text"), e_playAsUser);
			login_btn.setSize(75, 30);
			
			// Load Saved Login Data
			var SO:Array = _loadLoginDetails();
			if (SO != null && SO[2] == true)
			{
				input_user.text = SO[0];
				input_pass.text = SO[1];
				save_checkbox.checked = true;
			}
			
			stage.focus = input_user.textField;
			input_user.textField.setSelection(input_user.text.length, input_user.text.length);
			
			_setFields(true);
			TweenLite.to(loginBox, 1, {"x": "-=75", "alpha": 1, "ease": Power2.easeOut});
		}
		
		//------------------------------------------------------------------------------------------------//
		
		/**
		 * Changes Username/Password UI fields.
		 * @param	enabled		Sets enabled status on relevent UI fields.
		 * @param	isError		Sets colour indicators on password field.
		 */
		private function _setFields(enabled:Boolean, isError:Boolean = false):void
		{
			
			input_user.enabled = input_pass.enabled = login_btn.enabled = guest_btn.enabled = enabled;
			
			if (isError)
			{
				input_pass.text = "";
				//input_pass.textColor = 0xFFDBDB;
				input_pass.color = 0xFF0000;
				input_pass.borderColor = 0xFF0000;
			}
		}
		
		/**
		 * Plays closing animation and switches back to GameLoader scene.
		 */
		private function _gotoLoader():void
		{
			TweenLite.to(loginBox, 1, {"x": "-=75", "alpha": 0, "ease": Power2.easeIn, "onComplete": function():void
			{
				// Remove Placeholder Language Loader
				core.removeLoader(core.getCurrentLoader());
				
				// Jump back to Engine Loading
				core.scene = new SceneGameLoader(core);
			}});
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Event: CLICK
		 * Click Event for "Login" button.
		 * @param	e
		 */
		private function e_playAsUser(e:Event):void
		{
			_loginUser(input_user.text, input_pass.text);
		}
		
		/**
		 * Event: CLICK
		 * Click event for "Guest" button.
		 * @param	e
		 */
		private function e_playAsGuest(e:Event):void
		{
			_asGuest();
		}
		
		/**
		 * Event: KEY_DOWN
		 * Keyboard listener for enter key to login user or play as guest.
		 * @param	e
		 */
		private function e_loginKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				if (input_user.text.length > 0)
					e_playAsUser(e);
				else
					e_playAsGuest(e);
			}
			e.stopPropagation();
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Guest Play, disables UI items and goes back to game loader.
		 */
		private function _asGuest():void
		{
			Logger.log(this, Logger.INFO, "Playing as Guest");
			_setFields(false);
			_gotoLoader();
		}
		
		/**
		 * Attempts to login as requested user through the use of temporary session.
		 * @param	username	Username of user to login as.
		 * @param	password	Password of user to login as.
		 */
		private function _loginUser(username:String = "", password:String = ""):void
		{
			Logger.log(this, Logger.INFO, "Attepting Login: " + username);
			_setFields(false);
			
			// Login User
			var session:Session = new Session(_loginUserComplete, _loginUserError);
			session.login(username, password);
		}
		
		/**
		 * Callback for successful user login from "_loginUser".
		 * Creates new user using session details and goes back to loader.
		 * @param	e
		 */
		private function _loginUserComplete(e:Event):void
		{
			Logger.log(this, Logger.INFO, "User Login Success");
			
			// Save Login Details
			_saveLoginDetails(save_checkbox.checked, input_user.text, input_pass.text);
			
			// Load User using Session
			core.user = new User(true, true);
			
			// Jump back to Loading Screen
			_gotoLoader();
		}
		
		/**
		 * Callback for unsuccessful user login from "_loginUser".
		 * Reenables UI fields and informs user of incorrect/invalid login.
		 * @param	e
		 */
		private function _loginUserError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "User Login Error");
			_setFields(true, true);
		}
		
		/**
		 * Saves user information to players local storage.
		 * @param	saveLogin 	To save user information or clear user information.
		 * @param	username	Username to store.
		 * @param	password	Password to store.
		 */
		private function _saveLoginDetails(saveLogin:Boolean = false, username:String = "", password:String = ""):void
		{
			var gameSave:SharedObject = SharedObject.getLocal(Constant.LOCAL_SO_NAME);
			if (saveLogin)
			{
				gameSave.data.uUsername = username;
				gameSave.data.uPassword = password; // TODO: Something About this...
			}
			else
			{
				delete gameSave.data.uUsername;
				delete gameSave.data.uPassword;
			}
			gameSave.flush();
		}
		
		/**
		 * Loads saved local user information from local storage.
		 * @return array username,password,isLoaded
		 */
		private function _loadLoginDetails():Array
		{
			var gameSave:SharedObject = SharedObject.getLocal(Constant.LOCAL_SO_NAME);
			if (gameSave.data.uUsername != null)
			{
				return [(gameSave.data.uUsername ? gameSave.data.uUsername : ''), (gameSave.data.uPassword ? gameSave.data.uPassword : ''), true];
			}
			return ["", "", false];
		}
	}
}