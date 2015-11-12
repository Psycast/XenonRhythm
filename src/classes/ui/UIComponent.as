package classes.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	[Event(name="resize", type="flash.events.Event")]
	[Event(name="draw", type="flash.events.Event")]
	public class UIComponent extends Sprite
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:* = -1;
		protected var _enabled:Boolean = true;
		
		public static const DRAW:String = "draw";

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function UIComponent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			move(xpos, ypos);
			init();
			if(parent != null)
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
			addEventListener(Event.ENTER_FRAME, onInvalidate);
			//draw();
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
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
		 * Abstract draw function.
		 */
		public function draw():void
		{
			dispatchEvent(new Event(UIComponent.DRAW));
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
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
			invalidate();
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
			invalidate();
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
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
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
		 * Remove All Children for this UI component.
		 */
		public function removeChildren():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
	}

}