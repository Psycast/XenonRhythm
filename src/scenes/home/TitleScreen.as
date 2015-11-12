package scenes.home
{
	import assets.menu.FFRDudeCenter;
	import assets.menu.FFRName;
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import classes.ui.BoxButton;
	import classes.ui.UIComponent;
	import classes.ui.UICore;
	import com.flashfla.utils.ArrayUtil;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import scenes.songselection.SelectionSongs;
	
	public class TitleScreen extends UICore
	{
		private var ffrlogo:FFRDudeCenter;
		private var ffrname:FFRName;
		
		private var btnsText:Array = ["Single Player", "Multiplayer", "Tutorial", "Settings"];
		private var selectedIndex:int = 0;
		private var menuButtons:Array;
		
		public function TitleScreen(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			draw();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
		}
		
		override public function draw():void
		{
			var bg:sGameBackground = new sGameBackground();
			addChildAt(bg, 0);
			
			// FFR Dude
			ffrlogo = new FFRDudeCenter();
			ffrlogo.x = Constant.GAME_WIDTH_CENTER - 125;
			ffrlogo.y = Constant.GAME_HEIGHT_CENTER - 150;
			ffrlogo.scaleX = ffrlogo.scaleY = 1.5;
			ffrlogo.alpha = 0.85;
			addChild(ffrlogo);
			
			// FFR Name
			ffrname = new FFRName();
			ffrname.x = Constant.GAME_WIDTH_CENTER - 75;
			ffrname.y = Constant.GAME_HEIGHT_CENTER - 150;
			ffrname.alpha = 0.85;
			addChild(ffrname);
			
			_createMenu();
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Event: KEY_DOWN
		 * Used to navigate the menu using the arrow keys or user set keys
		 * @param	e Keyboard Event
		 */
		private function e_keyDown(e:KeyboardEvent):void
		{
			var newIndex:int = selectedIndex;
			
			// Menu Navigation
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.NUMPAD_2 || e.keyCode == core.user.settings.key_down)
			{
				newIndex = selectedIndex + 1;
			}
			
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.NUMPAD_8 || e.keyCode == core.user.settings.key_up)
			{
				newIndex = selectedIndex - 1;
			}
			
			// New Index
			if (newIndex != selectedIndex)
			{
				// Checks
				if (newIndex < 0)
					newIndex = menuButtons.length - 1;
				if (newIndex >= menuButtons.length)
					newIndex = 0;
				if (menuButtons[newIndex] == null)
					return;
				
				// Find First Menu Item
				newIndex = ArrayUtil.find_next_index(newIndex < selectedIndex, newIndex, menuButtons, function(n:BoxButton):Boolean
					{
						return n.enabled;
					});
				
				// Set Highlight
				menuButtons[selectedIndex].highlight = false;
				menuButtons[newIndex].highlight = true;
				selectedIndex = newIndex;
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Creates the menu buttons.
		 */
		private function _createMenu():void
		{
			// Setup Menu Buttons
			menuButtons = [];
			var btn:BoxButton;
			for (var i:int = 0; i < btnsText.length; i++)
			{
				btn = new BoxButton(this, Constant.GAME_WIDTH_CENTER - 75, (Constant.GAME_HEIGHT - ((btnsText.length - i) * 65) - 50), btnsText[i], e_menuClick);
				btn.setSize(250, 45);
				btn.tag = i;
				btn.enabled = !(i == 1 || i == 2);
				btn.alpha = 0;
				menuButtons.push(btn);
			}
			menuButtons[selectedIndex].highlight = true;
			
			// Create Timeline Effect
			var tl:TimelineLite = new TimelineLite();
			tl.staggerTo(menuButtons, 1, {"x": Constant.GAME_WIDTH_CENTER - 125, "alpha": 1}, 0.15);
		}
		
		/**
		 * Transitions the menu to closed state and jumps to the menu index UI scene.
		 * @param	menuIndex	Selected Menu Index
		 */
		private function _closeMenu(menuIndex:int):void
		{
			// Animate Menu Close
			for each (var item:BoxButton in menuButtons)
			{
				item.enabled = false;
			}
			new TweenLite([ffrlogo, ffrname], 0.5, {"alpha": 0});
			var tl:TimelineLite = new TimelineLite({"onComplete": function():void
				{
					_switchScene(menuIndex);
				}});
			tl.staggerTo(menuButtons, 1, {"x": Constant.GAME_WIDTH_CENTER - 175, "alpha": 0}, 0.15);
		}
		
		/**
		 * Changes scenes based on ID from menu.
		 * @param	menuIndex Scene ID to change to.
		 */
		private function _switchScene(menuIndex:int):void
		{
			// Switch to Intended UI scene
			switch (menuIndex)
			{
				case 0: 
					core.scene = new SelectionSongs(core);
					break;
			}
		}
		
		/**
		 * Event: CLICK
		 * Handles the click event for menu buttons.
		 * @param	e	Click Event
		 */
		private function e_menuClick(e:Event):void
		{
			var menuIndex:int = (e.target as UIComponent).tag;
			
			_closeMenu(menuIndex);
		}
	}

}