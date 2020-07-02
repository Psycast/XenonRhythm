package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	/**
	 * Wrapper for icon shapes into UIComponent compatible shapes.
	 */
	public class UIIcon extends UIComponent
	{
		private var _spr:DisplayObject;
		private var _sprWidth:Number = 1;
		private var _sprHeight:Number = 1;

		public function UIIcon(parent:DisplayObjectContainer = null, sprite:DisplayObject = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			mouseChildren = false;
			
			if (sprite)
			{
				_spr = sprite;
				_sprWidth = sprite.width;
				_sprHeight = sprite.height;
				addChild(_spr);
			}
		}

		override public function setSize(w:Number, h:Number, redraw:Boolean = true):void
		{
			_spr.scaleX = _spr.scaleY = Math.min(w / _sprWidth, h / _sprHeight);

			this.graphics.clear();
			this.graphics.lineStyle(1, 0, 0);
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(-(_spr.width / 2), -(_spr.height / 2), w, h);
			this.graphics.endFill();
		}
	}
}