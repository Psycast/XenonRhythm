package classes.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class VScrollBar extends UIComponent 
	{
		private var _lastScroll:Number = 0;
		private var _scrollFactor:Number = 0.5;
		
		private var _dragger:Sprite;
		
		public function VScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
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
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void 
		{
			_dragger = new Sprite();
			_dragger.buttonMode = true;
			addChild(_dragger);
			
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, e_startDrag);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void 
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff, 0.1);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			_dragger.graphics.clear();
			_dragger.graphics.lineStyle(1, 0xffffff, 0.5);
			_dragger.graphics.beginFill(0xffffff, 0.25);
			_dragger.graphics.drawRect(0, 0, width - 1, Math.max(height * scrollFactor, 30));
			_dragger.graphics.endFill();
			
			scroll = _lastScroll;
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_startDrag(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, e_stopDrag); 
			stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			_dragger.startDrag(false, new Rectangle(0, 0, 0, height - _dragger.height));
		}
		
		private function e_stopDrag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, e_stopDrag);
			_dragger.stopDrag();
			_lastScroll = scroll;
		}
		
		private function e_mouseMove(e:MouseEvent):void 
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Returns the current scroll percent.
		 */
		public function get scroll():Number
		{
			return _dragger.y / (height - 1 - _dragger.height);
		}
		
		/**
		 * Sets the current scroll percent.
		 * @param percent Range of 0-1
		 */
		public function set scroll(percent:Number):void
		{
			_dragger.y = Math.max(Math.min((height - _dragger.height) * percent, height - _dragger.height), 0);
			_lastScroll = percent;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Gets the current scroll factor. 
		 * Scroll factor is the percent of the height the dragger should be displayed as.
		 */
		public function get scrollFactor(): Number
		{
			return _scrollFactor;
		}
		
		/**
		 * Sets the scroll factor for the dragger to use.
		 */
		public function set scrollFactor(value:Number):void 
		{
			_scrollFactor = value;
			invalidate();
		}
		
		/**
		 * Returns if the dragger is visible.
		 */
		public function get showDragger():Boolean
		{
			return _dragger.visible;
		}
		
		/**
		 * Show / Hide the dragger.
		 */
		public function set showDragger(value:Boolean):void 
		{
			_dragger.visible = value;
		}
	}

}