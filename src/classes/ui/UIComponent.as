package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name = "resize", type = "flash.events.Event")]
	public class UIComponent extends Sprite
	{
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:* = -1;
		protected var _enabled:Boolean = true;
		protected var _anchor:String = UIAnchor.NONE;
		protected var _invalid:Boolean = false;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function UIComponent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			move(xpos, ypos);
			init();
			if (parent != null)
			{
				parent.addChild(this);
			}
		}
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			tabEnabled = false;
			invalidate();
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
		
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
			if (!_invalid)
			{
				_invalid = true;
				addEventListener(Event.ENTER_FRAME, onInvalidate);
				//draw();
			}
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = xpos;
			y = ypos;
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}
		
		/**
		 * Sets the size of the component and drawing instantly.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSizeInstant(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			dispatchEvent(new Event(Event.RESIZE));
			draw();
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
		
		}
		
		/**
		 * Abstract stage resize function.
		 */
		public function onResize():void
		{
			move(_x, _y);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Remove All Children for this UI component.
		 */
		public function removeChildren():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			_invalid = false;
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:*):void
		{
			_tag = value;
		}
		
		public function get tag():*
		{
			return _tag;
		}
		
		/**
		 * Overrides the getter for x to allow for anchor points.
		 */
		override public function get x():Number
		{
			return _x;
		}
		
		/**
		 * Returns the real x position instead of the anchor based x.
		 */
		public function get real_x():Number
		{
			return super.x;
		}
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel and anchors..
		 */
		override public function set x(value:Number):void
		{
			_x = Math.round(value);
			switch (anchor)
			{
				default: 
				case UIAnchor.NONE: 
				case UIAnchor.TOP_LEFT: 
				case UIAnchor.MIDDLE_LEFT: 
				case UIAnchor.BOTTOM_LEFT: 
					super.x = _x;
					break;
				case UIAnchor.TOP_CENTER: 
				case UIAnchor.MIDDLE_CENTER: 
				case UIAnchor.BOTTOM_CENTER: 
					super.x = Constant.GAME_WIDTH_CENTER + _x;
					break;
				case UIAnchor.TOP_RIGHT: 
				case UIAnchor.MIDDLE_RIGHT: 
				case UIAnchor.BOTTOM_RIGHT: 
					super.x = Constant.GAME_WIDTH + _x;
					break;
			}
		}
		
		/**
		 * Overrides the getter for y to allow for anchor points.
		 */
		override public function get y():Number
		{
			return _y;
		}
		
		/**
		 * Returns the real y position instead of the anchor based y.
		 */
		public function get real_y():Number
		{
			return super.y;
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel and anchors.
		 */
		override public function set y(value:Number):void
		{
			_y = Math.round(value);
			switch (anchor)
			{
				default: 
				case UIAnchor.NONE: 
				case UIAnchor.TOP_LEFT: 
				case UIAnchor.TOP_CENTER: 
				case UIAnchor.TOP_RIGHT: 
					super.y = _y;
					break;
				case UIAnchor.MIDDLE_LEFT: 
				case UIAnchor.MIDDLE_CENTER: 
				case UIAnchor.MIDDLE_RIGHT: 
					super.y = Constant.GAME_HEIGHT_CENTER + _y;
					break;
				case UIAnchor.BOTTOM_LEFT: 
				case UIAnchor.BOTTOM_CENTER: 
				case UIAnchor.BOTTOM_RIGHT: 
					super.y = Constant.GAME_HEIGHT + _y;
					break;
			}
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			var ta:Number = alpha;
			_enabled = value;
			mouseEnabled = mouseChildren = tabEnabled = _enabled;
			alpha = ta;
			invalidate();
			//alpha = _enabled ? 1.0 : 0.5;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Overrides the setter for alpha to allow althering of alpha without breaking enabled status.
		 */
		override public function get alpha():Number
		{
			return super.alpha * (!enabled ? 2 : 1);
		}
		
		/**
		 * Overrides the setter for alpha to allow althering of alpha without breaking enabled status.
		 */
		override public function set alpha(val:Number):void
		{
			super.alpha = val / (!enabled ? 2 : 1);
		}
		
		/**
		 * Gets the currently set anchor point.
		 */
		public function get anchor():String
		{
			return _anchor;
		}
		
		/**
		 * Sets the anchor point for the object to follow when the game stage resizes.
		 * Positioning is relative to the anchor points provided in the UIAnchor class.
		 * Thus being, (0,0) is the anchor point on the stage and not it's real coordinates on stage.
		 */
		public function set anchor(value:String):void
		{
			_anchor = value;
			(_anchor == UIAnchor.NONE ? ResizeListener.removeObject(this) : ResizeListener.addObject(this));
			onResize();
		}
	
	}

}