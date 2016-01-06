package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class Box extends UIComponent
	{
		private var _highlight:Boolean = false;
		
		protected var _background_color:uint = 0xFFFFFF;
		protected var _background_alpha:Number = 0.1;
		
		protected var _border_alpha:Number = 0.4;
		protected var _border_color:uint = 0xFFFFFF;
		
		public function Box(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0):void
		{
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(100, 20);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			this.graphics.clear();
			
			//- Draw Box
			this.graphics.lineStyle(1, borderColor, (highlight ? _border_alpha * 1.5 : _border_alpha));
			this.graphics.beginFill(color, (highlight ? _background_alpha * 1.5 : _background_alpha));
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Gets the highlight status of the box.
		 */
		public function get highlight():Boolean
		{
			return _highlight;
		}
		
		/**
		 * Sets the highlight status of the box.
		 */
		public function set highlight(val:Boolean):void
		{
			_highlight = val;
			invalidate();
		}
		
		/**
		 * Gets the background color for the box.
		 */
		public function get color():uint
		{
			return _background_color;
		}
		
		/**
		 * Sets the background color for the box.
		 */
		public function set color(value:uint):void
		{
			_background_color = value;
			invalidate();
		}

		/**
		 * Gets the border color for the box.
		 */
		public function get borderColor():uint
		{
			return _border_color;
		}
		
		/**
		 * Sets the border color for the box.
		 */
		public function set borderColor(value:uint):void
		{
			_border_color = value;
			invalidate();
		}

	}

}