package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BoxCombo extends UIComponent
	{
		private var _holder:Box;
		private var _pane:ScrollPane;
		private var _title:String;
		private var _titletf:TextField;
		private var _options:Array = [];
		private var _defaultHandler:Function;
		private var _listPostion:String;
		
		public function BoxCombo(title:String = null, options:Array = null, defaultHandler:Function = null, postion:String = UIAnchor.TOP_LEFT)
		{
			super(null, 0, 0);
			_title = title;
			_options = options;
			_defaultHandler = defaultHandler;
			_listPostion = postion;
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void 
		{
			super.init();
			setSize(Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			ResizeListener.addObject(this);
		}
		
		override public function onResize():void 
		{
			// Prevent Mouse Clicks
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
			
			// Box Holder
			switch(_listPostion)
			{
				default:
				case UIAnchor.TOP_LEFT:
					_holder.x = 15;
					break;
				case UIAnchor.TOP_CENTER:
					_holder.x = Constant.GAME_WIDTH_CENTER - (_holder.width / 2);
					break;
				case UIAnchor.TOP_RIGHT:
					_holder.x = Constant.GAME_WIDTH - _holder.width - 15;
					break;
			}
			_holder.setSizeInstant(250, Constant.GAME_HEIGHT + 2);
			
			// Scroll Pane Position / size
			var yOffset:int = (_titletf ? _titletf.y + _titletf.height + 10 : 10);
			_pane.height = _holder.height - 10 - yOffset;
			_pane.y = yOffset;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void 
		{
			// Blue Scenes
			(this.parent as UI).blurInterface();
			
			// Add Background
			_holder = new Box(this, 15, -1);
			_holder.setSize(250, Constant.GAME_HEIGHT + 2);
			
			// Pane
			_pane = new ScrollPane(_holder, 10, 10);
			_pane.width = _holder.width - 20;
			
			// Add Title
			if (_title)
			{
				_titletf = new TextField();
				_titletf.width = _holder.width - 20;
				_titletf.x = 10;
				_titletf.y = 10;
				_titletf.multiline = true;
				_titletf.wordWrap = true;
				_titletf.embedFonts = true;
				_titletf.selectable = false;
				_titletf.mouseEnabled = false;
				_titletf.defaultTextFormat = UIStyle.getTextFormat();
				_titletf.autoSize = TextFieldAutoSize.LEFT;
				_titletf.htmlText = _title;
				_holder.addChild(_titletf);
			}
			
			// Add Options
			_addOptions();
			
			// Move / Positioning
			onResize();
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Creates the option buttons and adds them to the scrollpane.
		 */
		private function _addOptions():void 
		{
			var btn:BoxButton;
			for (var i:int = 0; i < _options.length; i++)
			{
				var lbl:String = "";
				var dat:*;
				
				if (_options[i] is Array && _options[i].length == 2)
				{
					lbl = _options[i][0];
					dat = _options[i][1];
				}
				else if (_options[i] is Object && _options[i]["label"] != null && _options[i]["data"] != null)
				{
					lbl = _options[i]["label"];
					dat = _options[i]["data"];
				}
				else
				{
					lbl = _options[i];
					dat = _options[i];
				}
				
				btn = new BoxButton(_pane, 0, i * 60, lbl, e_buttonHandler);
				btn.setSize(_pane.width, 45);
				btn.tag = dat;
			}
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Event handler for the option buttons.
		 */
		private function e_buttonHandler(e:Event):void 
		{
			if (_defaultHandler != null)
			{
				_defaultHandler((e.target as BoxButton).tag);
			}
			if (parent && parent.contains(this))
			{
				ResizeListener.removeObject(this);
				(this.parent as UI).unblurInterface();
				parent.removeChild(this);
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Gets the list postion on screen.
		 * Either: TOP_LEFT, TOP_CENTER, TOP_RIGHT
		 */
		public function get listPostion():String 
		{
			return _listPostion;
		}
		
		/**
		 * Sets the list postion on screen using UIAnchor TOP points.
		 * Either: TOP_LEFT, TOP_CENTER, TOP_RIGHT
		 */
		public function set listPostion(postion:String):void 
		{
			_listPostion = postion;
			onResize();
		}
	}

}