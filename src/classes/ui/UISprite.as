package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Wrapper for normal sprites into UIComponent compatible sprites.
	 */
	public class UISprite extends UIComponent
	{
		
		public function UISprite(parent:DisplayObjectContainer = null, sprite:Sprite = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			
			if (sprite)
				addChild(sprite);
		}
	
	}

}