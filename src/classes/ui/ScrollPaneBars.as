package classes.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import scenes.songselection.ui.SongButton;
	
	public class ScrollPaneBars extends UIComponent
	{
		private var _pane:ScrollPane;
		private var _vscroll:VScrollBar;
		private var _hscroll:HScrollBar;
		private var _useVerticalBar:Boolean;
		private var _useHorizontalBar:Boolean;
		private var _forceVerticalBar:Boolean;
		private var _forceHorizontalBar:Boolean;
		
		public function ScrollPaneBars(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, useVertical:Boolean = true, useHorizontal:Boolean = false)
		{
			_useVerticalBar = useVertical;
			_useHorizontalBar = useHorizontal;
			super(parent, xpos, ypos);
		}
		
		override protected function addChildren():void
		{
			_pane = new ScrollPane();
			_pane.addEventListener(MouseEvent.MOUSE_WHEEL, e_scrollWheel);
			super.addChild(_pane);
			
			_vscroll = new VScrollBar();
			_vscroll.addEventListener(Event.CHANGE, e_scrollVerticalUpdate);
			super.addChild(_vscroll);
			
			_hscroll = new HScrollBar();
			_hscroll.addEventListener(Event.CHANGE, e_scrollHorizontalUpdate);
			super.addChild(_hscroll);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return _pane.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			_pane.removeChild(child);
			
			if (!_pane.doScrollVertical)
				_vscroll.scroll = 0;
			if (!_pane.doScrollHorizontal)
				_hscroll.scroll = 0;
			
			return child;
		}
		
		override public function draw():void
		{
			_pane.setSize(_width, _height);
			
			if (useHorizontalBar || forceHorizontalBar)
			{
				if (_pane.doScrollHorizontal || forceHorizontalBar)
				{
					_pane.height = _height - 20;
				}
				_hscroll.setSize(_pane.width, 15);
				_hscroll.move(0, _height - 15);
			}
			if (useVerticalBar || forceVerticalBar)
			{
				if (_pane.doScrollVertical || forceVerticalBar)
				{
					_pane.width = _width - 20;
				}
				_vscroll.setSize(15, _pane.height);
				_vscroll.move(_width - 15, 0);
			}
			
			scrollUpdate();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Remove All Children for this UI component.
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = 2147483647):void 
		{
			_pane.removeChildren(beginIndex, endIndex);
		}
		
		public function scrollUpdate(keepPosition:Boolean = false):void
		{
			_vscroll.visible = (useVerticalBar && _pane.doScrollVertical) || forceVerticalBar;
			_hscroll.visible = (useHorizontalBar && _pane.doScrollHorizontal) || forceHorizontalBar;
			
			if (useVerticalBar)
			{
				_vscroll.scrollFactor = _pane.scrollFactorVertical;
				_vscroll.scroll = _pane.scrollVertical;
			}
			if (useHorizontalBar)
			{
				_hscroll.scrollFactor = _pane.scrollFactorHorizontal;
				_hscroll.scroll = _pane.scrollHorizontal;
			}
		}
		
		public function scrollChild(child:DisplayObject):void
		{
			var pos:Array = _pane.scrollChild(child);
			if (useVerticalBar)
				_vscroll.scroll = pos[0];
			if (useHorizontalBar)
				_hscroll.scroll = pos[1];
		}
		
		public function scrollReset():void 
		{
			if (!useVerticalBar || (useVerticalBar && !_pane.doScrollVertical))
				_vscroll.scroll = 0;
			if (!useHorizontalBar || (useHorizontalBar && !_pane.doScrollHorizontal))
				_hscroll.scroll = 0;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_scrollWheel(e:MouseEvent):void
		{
			if (useVerticalBar && _pane.doScrollVertical)
				_vscroll.scroll += (_pane.scrollFactorVertical / 2) * (e.delta > 1 ? -1 : 1);
		}
		
		private function e_scrollVerticalUpdate(e:Event):void
		{
			_pane.scrollVertical = _vscroll.scroll;
		}
		
		private function e_scrollHorizontalUpdate(e:Event):void
		{
			_pane.scrollHorizontal = _hscroll.scroll;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////	
		
		public function get paneWidth():Number
		{
			return _pane.width;
		}
		
		public function get paneHeight():Number
		{
			return _pane.height;
		}
		
		public function get content():Sprite
		{
			return _pane.content;
		}
		
		public function get pane():ScrollPane
		{
			return _pane;
		}
		
		public function get verticalBar():VScrollBar
		{
			return _vscroll;
		}
		
		public function get useVerticalBar():Boolean
		{
			return _useVerticalBar;
		}
		
		public function set useVerticalBar(value:Boolean):void
		{
			_useVerticalBar = value;
			draw();
		}
		
		public function get forceVerticalBar():Boolean
		{
			return _forceVerticalBar;
		}
		
		public function set forceVerticalBar(value:Boolean):void
		{
			_forceVerticalBar = value;
			draw();
		}
		
		public function get horizontalBar():HScrollBar
		{
			return _hscroll;
		}
		
		public function get useHorizontalBar():Boolean
		{
			return _useHorizontalBar;
		}
		
		public function set useHorizontalBar(value:Boolean):void
		{
			_useHorizontalBar = value;
			draw();
		}
		
		public function get forceHorizontalBar():Boolean
		{
			return _forceHorizontalBar;
		}
		
		public function set forceHorizontalBar(value:Boolean):void
		{
			_forceHorizontalBar = value;
			draw();
		}
	}
}