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
		
		public function ScrollPane(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(150, 100);
			scrollRect = new Rectangle(0, 0, width + 1, height);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSize(w:Number, h:Number):void
		{
			scrollRect = new Rectangle(0, 0, w + 1, h);
			super.setSize(w, h);
		}
		
		/**
		 * Sets the size of the component and drawing instantly.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSizeInstant(w:Number, h:Number):void
		{
			scrollRect = new Rectangle(0, 0, w + 1, h);
			super.setSizeInstant(w, h);
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
			var maskY:Number = _content.y * -1;
			var _children:int = _content.numChildren;
			var _child:DisplayObject;
			for (var i:int = 0; i < _children; i++)
			{
				_child = _content.getChildAt(i);
				_child.visible = ((_child.y >= maskY || _child.y + _child.height >= maskY) && _child.y < maskY + this.height);
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
		
		/**
		 * Returns the current scroll percent.
		 */
		public function get scroll():Number
		{
			return -_content.y / (contentHeight - this.height);
		}
		
		/**
		 * Sets the current scroll percent.
		 * @param percent Range of 0-1
		 */
		public function set scroll(val:Number):void
		{
			if (UIStyle.USE_ANIMATION)
				TweenLite.to(content, 0.25, {y: -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0)), onUpdate: updateChildrenVisibility, onComplete: updateChildrenVisibility});
			else
				_content.y = -((contentHeight - this.height) * Math.max(Math.min(val, 1), 0));
			updateChildrenVisibility();
		}
		
		/**
		 * Gets the scroll value required to display a specified child.
		 * @param	child Child to show.
		 * @return	Scroll Value required to show child in center of scroll pane.
		 */
		public function scrollChild(child:DisplayObject):Number
		{
			// Checks
			if (child == null || !_content.contains(child) || !doScroll)
				return 0;
			
			return Math.max(Math.min(((child.y + (child.height / 2)) - (this.height / 2)) / (contentHeight - this.height), 1), 0);
		}
		
		/**
		 * Gets the current scroll factor.
		 * Scroll factor is the percent of the height the scrollpane is compared to the overall content height.
		 */
		public function get scrollFactor():Number
		{
			return Math.max(Math.min(height / contentHeight, 1), 0);
		}
		
		/**
		 * Gets if the content height is taller then the scrollpane visible area.
		 */
		public function get doScroll():Boolean
		{
			return contentHeight > height;
		}
		
		/**
		 * Gets the overall content height.
		 */
		public function get contentHeight():Number
		{
			return _content.getBounds(_content).bottom;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
	}
}