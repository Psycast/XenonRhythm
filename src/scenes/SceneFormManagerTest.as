package scenes 
{
	import classes.engine.EngineCore;
	import classes.ui.BoxButton;
	import classes.ui.FormManager;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class SceneFormManagerTest extends UICore 
	{
		
		public function SceneFormManagerTest(core:EngineCore) 
		{
			super(core);
			
		}
		
		override public function onStage():void 
		{
			super.onStage();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_onKeyDown);
			
			FormManager.registerGroup(this, "group-a", UIAnchor.WRAP_ALL);
			
			var didHighlight:Boolean = false;
			for (var xx:int = 0; xx < 4; xx++) {
				for (var yy:int = 0; yy < 4; yy++) {
					var box:BoxButton = new BoxButton(this, xx * 55 + 5, yy * 55 + 5, xx + "," + yy);
					box.setSize(50, 50);
					box.group = "group-a";
					if ((Math.random() < 0.1 || (xx == 3 && yy == 3)) && !didHighlight) {
						box.highlight = true;
						didHighlight = true;
					}
				}
			}
			
			draw();
		}
		
		private function e_onKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case Keyboard.UP:
					FormManager.handleAction("up");
					break;
				case Keyboard.DOWN:
					FormManager.handleAction("down");
					break;
				case Keyboard.LEFT:
					FormManager.handleAction("left");
					break;
				case Keyboard.RIGHT:
					FormManager.handleAction("right");
					break;
			}
		}
		
	}

}