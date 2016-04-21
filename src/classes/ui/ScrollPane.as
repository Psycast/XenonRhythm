package classes.ui
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollPane extends UIComponent
	{
		private var _content:Sprite;
		private var _batchMode:Boolean = false;
		
		public function ScrollPane(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(150, 100, false);
			super.init();
			scrollRect = new Rectangle(0, 0, width + 1, height);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSize(w:Number, h:Number, redraw:Boolean = true):void
		{
			scrollRect = new Rectangle(0, 0, w + 1, h);
			super.setSize(w, h, redraw);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_content = new Sprite();
			super.addChild(_content);
			draw();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_content.addChild(child);
			
			// Update Visibility
			var maskY:Number = _content.y * -1;
			child.visible = ((child.y >= maskY || child.y + child.height >= maskY) && child.y < maskY + this.height);
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return _content.removeChild(child);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			this.graphics.clear();
			//this.graphics.lineStyle(1, 0xFFFFFF);
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			updateChildrenVisibility();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Remove All Children for this UI component.
		 */
		override public function removeChildren():void
		{
			while (_content.numChildren > 0)
			{
				_content.removeChildAt(0);
			}
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		private function updateChildrenVisibility():void
		{
			var maskX:Number = _content.x * -1;
			var maskY:Number = _content.y * -1;
			var _children:int = _content.numChildren;
			var _child:DisplayObject;
			for (var i:int = 0; i < _children; i++)
			{
				_child = _content.getChildAt(i);
				_child.visible = ((_child.x >= maskX || _child.x + _child.width >= maskX) && _child.x < maskX + this.width) 
						&& ((_child.y >= maskY || _child.y + _child.height >= maskY) && _child.y < maskY + this.height);
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			scrollRect = new Rectangle(0, 0, w + 1, height);
			super.width = w;
		}
		
		/**
		 * Sets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			scrollRect = new Rectangle(0, 0, width + 1, h);
			super.height = h;
		}
		
		public function scroll(v:Number, h:Number):void
		{
			scrollVertical = v;
			scrollHorizontal = h;
		}
		
		/**
		 * Returns the current vertical scroll percent.
		 */
		public function get scrollVertical():Number
		{
			return -_content.y / (contentHeight - this.height);
		}
		
		/**
		 * Sets the current vertical scroll percent.
		 * @param percent Range of 0-1
		 */
		public function set scrollVertical(val:Number):void
		{
			if (UIStyle.USE_ANIMATION)
				TweenLite.to(content, 0.25, {y: -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0)), onUpdate: updateChildrenVisibility, onComplete: updateChildrenVisibility});
			else
				_content.y = -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0));
			updateChildrenVisibility();
		}
		
		/**
		 * Returns the current horizontal scroll percent.
		 */
		public function get scrollHorizontal():Number
		{
			return -_content.x / (contentWidth - this.width);
		}
		
		/**
		 * Sets the current horizontal scroll percent.
		 * @param percent Range of 0-1
		 */
		public function set scrollHorizontal(val:Number):void
		{
			if (UIStyle.USE_ANIMATION)
				TweenLite.to(content, 0.25, {x: -((contentWidth - this.width) * Math.max(Math.min(val, 1), 0)), onUpdate: updateChildrenVisibility, onComplete: updateChildrenVisibility});
			else
				_content.x = -((contentWidth - this.width) * Math.max(Math.min(val, 1), 0));
			updateChildrenVisibility();
		}
		
		/**
		 * Gets the scroll values required to display a specified child.
		 * @param	child Child to show.
		 * @return	Scroll Value required to show child in center of scroll pane.
		 */
		public function scrollChild(child:DisplayObject):Array
		{
			return [scrollChildVertical(child), scrollChildHorizontal(child)];
		}
		
		/**
		 * Gets the vertical scroll value required to display a specified child.
		 * @param	child Child to show.
		 * @return	Scroll Value required to show child in center of scroll pane.
		 */
		public function scrollChildVertical(child:DisplayObject):Number
		{
			// Checks
			if (child == null || !_content.contains(child) || !doScrollVertical)
				return 0;
			
			// Child to Tall, Scroll to top.
			if(child.height > height)
				return Math.max(Math.min(child.y / (contentHeight - this.height), 1), 0);
			
			return Math.max(Math.min(((child.y + (child.height / 2)) - (this.height / 2)) / (contentHeight - this.height), 1), 0);
		}
		
		/**
		 * Gets the horizontal scroll value required to display a specified child.
		 * @param	child Child to show.
		 * @return	Scroll Value required to show child in center of scroll pane.
		 */
		public function scrollChildHorizontal(child:DisplayObject):Number
		{
			// Checks
			if (child == null || !_content.contains(child) || !doScrollHorizontal)
				return 0;
			
			// Child to Tall, Scroll to top.
			if(child.width > width)
				return Math.max(Math.min(child.x / (contentWidth - this.width), 1), 0);
			
			return Math.max(Math.min(((child.x + (child.width / 2)) - (this.width / 2)) / (contentWidth - this.width), 1), 0);
		}
		
		/**
		 * Gets the current vertical scroll factor.
		 * Scroll factor is the percent of the height the scrollpane is compared to the overall content height.
		 */
		public function get scrollFactorVertical():Number
		{
			return Math.max(Math.min(height / contentHeight, 1), 0) || 0;
		}
		
		/**
		 * Gets the current horizontal scroll factor.
		 * Scroll factor is the percent of the width the scrollpane is compared to the overall content width.
		 */
		public function get scrollFactorHorizontal():Number
		{
			return Math.max(Math.min(width / contentWidth, 1), 0) || 0;
		}
		
		/**
		 * Gets if the content height is taller then the scrollpane height visible area.
		 */
		public function get doScrollVertical():Boolean
		{
			return contentHeight > height;
		}
		
		/**
		 * Gets if the content width is taller then the scrollpane width visible area.
		 */
		public function get doScrollHorizontal():Boolean
		{
			return contentWidth > width;
		}
		
		/**
		 * Gets the overall content height.
		 */
		public function get contentHeight():Number
		{
			return _content.getBounds(_content).bottom;
		}
		
		/**
		 * Gets the overall content width.
		 */
		public function get contentWidth():Number
		{
			return _content.getBounds(_content).right;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
	}
}