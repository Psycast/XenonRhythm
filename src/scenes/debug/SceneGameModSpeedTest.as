package scenes.debug 
{
	import classes.engine.EngineCore;
	import classes.ui.BoxButton;
	import classes.ui.FormManager;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class SceneGameModSpeedTest extends UICore 
	{
		
		public function SceneGameModSpeedTest(core:EngineCore) 
		{
			super(core);
			
		}
		
		override public function onStage():void 
		{
			super.onStage();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_onKeyDown);
		}
		
		private function e_onKeyDown(e:KeyboardEvent):void 
		{
			var compFunc:Function = function(item:TestModSetting, index:int, vector:Vector.<TestModSetting>):Boolean
			{
				return item.name == "test2";
			}
			
			var i:int = 0;
			var isSet:Boolean = false;
			var modd:Object = new Object();
			modd["test1"] = new TestModSetting("test1");
			modd["test2"] = new TestModSetting("test2");
			modd["test3"] = new TestModSetting("test3");
			modd["test4"] = new TestModSetting("test4");
			var mods:Vector.<TestModSetting> = new < TestModSetting > [new TestModSetting("test1"), new TestModSetting("test2"), new TestModSetting("test3"), new TestModSetting("test4")];
			var modi:int = 0x00fc31;
			var beginTime:int = getTimer();
			switch(e.keyCode) {
				case Keyboard.UP:
					for (i = 0; i < 10000000; i++)
						isSet = "test2" in modd;
					break;
				case Keyboard.DOWN:
					for (i = 0; i < 10000000; i++)
						isSet = modd["test2"] != null;
					break;
				case Keyboard.LEFT:
					for (i = 0; i < 10000000; i++)
						isSet = mods.some(compFunc);
					break;
				case Keyboard.RIGHT:
					var l:int = mods.length;
					var n:int = 0;
					for (i = 0; i < 10000000; i++)
						for (n = 0; n < l; n++)
						{
							if (mods[n].name == "test2")
							{
								isSet = true;
								break;
							}
						}
					break;
			}
			var endTimer:int = getTimer();
			Logger.log(this, Logger.DEBUG, "Starting Time: " + beginTime + ", End Time: " + endTimer + ", Length: " + (endTimer - beginTime));
		}
		
	}

}