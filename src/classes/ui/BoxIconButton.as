package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import classes.ui.BoxButton;
	import classes.ui.UIIcon;

	public class BoxIconButton extends BoxButton
	{
		protected var _icon:UIIcon;

		public function BoxIconButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", sprite:DisplayObject = null, defaultHandler:Function = null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
			
			if(sprite != null)
			{
				_icon = new UIIcon(null, sprite, 0, 0);
				_icon.alpha = 0.2;
				this.addChildAt(_icon, 0);
			}
		}

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			if(_icon)
			{
				_icon.setSize(_width - 10, _height - 10);
				_icon.move(_width / 2, _height / 2);
			}

			super.draw();
		}
	}
}