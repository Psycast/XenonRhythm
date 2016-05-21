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
	
	public class BoxComboOverlay extends UIOverlay
	{
		private var _holder:Box;
		private var _pane:ScrollPaneBars;
		private var _title:String;
		private var _titletf:TextField;
		private var _options:Array = [];
		private var _optionButtons:Array = [];
		private var _defaultHandler:Function;
		private var _listPostion:int;
		
		public function BoxComboOverlay(title:String = null, options:Array = null, defaultHandler:Function = null, postion:int = UIAnchor.CENTER)
		{
			_title = title;
			_options = options;
			_defaultHandler = defaultHandler;
			_listPostion = postion;
			super(null, 0, 0);
		}
		
		override protected function addChildren():void 
		{
			// Add Background
			_holder = new Box(this, 15, -1);
			_holder.setSize(250, Constant.GAME_HEIGHT + 2);
			
			// Pane
			_pane = new ScrollPaneBars(_holder, 10, 10);
			_pane.width = _holder.width - 22;
			
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
		
		override public function onResize():void
		{
			super.onResize();
			
			// Box Holder
			if ((_listPostion & UIAnchor.LEFT) != 0)
				_holder.x = 15;
			else if ((_listPostion & UIAnchor.RIGHT) != 0)
				_holder.x = Constant.GAME_WIDTH - _holder.width - 15;
			else
				_holder.x = Constant.GAME_WIDTH_CENTER - (_holder.width / 2);
			
			_holder.setSize(250, Constant.GAME_HEIGHT + 2);
			
			// Scroll Pane Position / size
			var yOffset:int = (_titletf ? _titletf.y + _titletf.height + 10 : 10);
			_pane.height = _holder.height - 10 - yOffset;
			_pane.y = yOffset;
			
			// button Size
			var paneWidth:Number = _pane.paneWidth;
			for (var i:int = 0; i < _optionButtons.length; i++)
			{
				_optionButtons[i].width = paneWidth;
			}
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
				else if (_options[i] is String)
				{
					lbl = _options[i];
					dat = _options[i];
				}
				else if (_options[i] is Object && _options[i]["label"] != null && _options[i]["value"] != null)
				{
					lbl = _options[i]["label"];
					dat = _options[i]["value"];
				}
				
				btn = new BoxButton(_pane, 0, i * 40, lbl, e_buttonHandler);
				btn.setSize(200, 35);
				btn.tag = { "label": lbl, "value": dat };
				_optionButtons.push(btn);
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
			ResizeListener.removeObject(this);
			if (_defaultHandler != null)
			{
				_defaultHandler((e.target as BoxButton).tag);
			}
			if (parent && parent.contains(this) && (parent is UI))
			{
				(parent as UI).removeOverlay(this);
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Gets the list postion on screen.
		 * Either: TOP_LEFT, TOP_CENTER, TOP_RIGHT
		 */
		public function get listPostion():int
		{
			return _listPostion;
		}
		
		/**
		 * Sets the list postion on screen using UIAnchor points.
		 * Either: LEFT, CENTER, RIGHT
		 */
		public function set listPostion(postion:int):void
		{
			_listPostion = postion;
			onResize();
		}
	}

}