package scenes.home
{
	import assets.menu.FFRDudeCenter;
	import assets.menu.FFRName;
	import classes.engine.EngineCore;
	import classes.ui.BoxButton;
	import classes.ui.UIAnchor;
	import classes.ui.UIComponent;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import com.flashfla.utils.ArrayUtil;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import scenes.songselection.SceneSelectionSongs;
	
	public class SceneTitleScreen extends UICore
	{
		private var ffrlogo:UISprite;
		private var ffrname:UISprite;
		
		private var btnsText:Array = ["Single Player", "Multiplayer", "Tutorial", "Settings"];
		private var selectedIndex:int = 0;
		private var menuButtons:Array;
		
		public function SceneTitleScreen(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
			super.onStage();
		}
		
		override public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
		}
		
		override public function draw():void
		{
			// FFR Dude
			ffrlogo = new UISprite(this, new FFRDudeCenter(), -125, -150);
			ffrlogo.anchor = UIAnchor.MIDDLE_CENTER;
			ffrlogo.scaleX = ffrlogo.scaleY = 1.5;
			ffrlogo.alpha = 0.85;
			
			// FFR Name
			ffrname = new UISprite(this, new FFRName(), -75, -150);
			ffrname.anchor = UIAnchor.MIDDLE_CENTER;
			ffrname.alpha = 0.85;
			
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
			
			// Menu Selection
			if (e.keyCode == Keyboard.ENTER)
			{
				_closeMenu(menuButtons[selectedIndex].tag);
			}
			
			// Menu Navigation
			else if (e.keyCode == core.user.settings.key_down || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.NUMPAD_2)
			{
				newIndex++;
			}
			else if (e.keyCode == core.user.settings.key_up || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.NUMPAD_8)
			{
				newIndex--;
			}
			
			// New Index
			if (newIndex != selectedIndex)
			{
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
				btn = new BoxButton(this, -75, ((i * 65) - 20), btnsText[i], e_menuClick);
				btn.setSize(250, 45);
				btn.tag = i;
				btn.anchor = UIAnchor.MIDDLE_CENTER;
				btn.enabled = (i == 0);
				btn.alpha = 0;
				menuButtons.push(btn);
			}
			selectedIndex = ArrayUtil.find_next_index(false, 0, menuButtons, function(n:BoxButton):Boolean
			{
				return n.enabled;
			});
			menuButtons[selectedIndex].highlight = true;
			
			// Create Timeline Effect
			var tl:TimelineLite = new TimelineLite();
			tl.staggerTo(menuButtons, 1, {"x": -125, "alpha": 1}, 0.15);
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
			tl.staggerTo(menuButtons, 1, {"x": -175, "alpha": 0}, 0.15);
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
					core.scene = new SceneSelectionSongs(core);
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
		
		private function e_comboReturn(value:*):void
		{
			core.source = value;
		}
	}

}