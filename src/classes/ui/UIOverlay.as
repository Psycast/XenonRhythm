package classes.ui 
{
	import assets.sGameBackground;
	import flash.display.DisplayObjectContainer;
	
	public class UIOverlay extends UIComponent 
	{
		
		public function UIOverlay(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
		}
		
		override protected function init():void 
		{
			super.init();
			setSize(Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			ResizeListener.addObject(this);
		}
		
		override public function draw():void 
		{
			super.draw();
			
			this.graphics.clear();
			this.graphics.beginFill(sGameBackground.BG_DARK, 0.85);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		override public function onResize():void 
		{
			_width = Constant.GAME_WIDTH
			_height = Constant.GAME_HEIGHT;
			
			super.onResize();
			
			this.graphics.clear();
			this.graphics.beginFill(sGameBackground.BG_DARK, 0.85);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
	}

}