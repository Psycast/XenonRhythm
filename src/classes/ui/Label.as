package classes.ui
{
	import com.flashfla.utils.StringUtil;
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends UIComponent
	{
		protected var DEFAULT_FONT_SIZE:int = UIStyle.FONT_SIZE;
		protected var _useHtml:Boolean = false;
		protected var _useArea:Boolean = false;
		protected var _autoSize:String = TextFieldAutoSize.LEFT;
		protected var _fontSize:int = 12;
		protected var _text:String = "";
		protected var _tf:TextField;
		
		private var _textformat:TextFormat;
		
		/**
		 * 
		 * @param	parent
		 * @param	xpos
		 * @param	ypos
		 * @param	text
		 * @param	useHtml
		 */
		public function Label(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", useHtml:Boolean = false)
		{
			_useHtml = useHtml;
			_text = text;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			_textformat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));
			mouseEnabled = false;
			mouseChildren = false;
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_height = 18;
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = _textformat;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			//_tf.border = true;
			_tf.cacheAsBitmap = true;
			addChild(_tf);
			draw();
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSize(w:Number, h:Number, redraw:Boolean = true):void
		{
			if (w != _width || h != _height)
			{
				_useArea = true;
				_width = w;
				_height = h;
				
				if (redraw)
					draw();
			}
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			
			_tf.htmlText = formatted_text;
			
			// Adjust sizes
			if (_useArea)
			{
				if(_width > 0)
				{
					_tf.scaleX = 1;
					if (_tf.width > _width)
						_tf.scaleX = (_width / _tf.width);
				}
				/*
				if(_height > 0)
				{
					_tf.scaleY = 1;
					if (_tf.height > _height)
						_tf.scaleY = (_height / _tf.height);
				}
				*/
				_height = Math.max(_height, _tf.height);
				
				//- Text Alignment Vertical
				_tf.y = ((height - _tf.height) / 2);
			}
			
			//- Text Alignment to Area
			if (_autoSize == TextFieldAutoSize.LEFT)
				_tf.x = 0;
			else if (_autoSize == TextFieldAutoSize.CENTER)
				_tf.x = Math.floor((width - _tf.width) / 2);
			else if (_autoSize == TextFieldAutoSize.RIGHT)
				_tf.x = Math.floor(width - _tf.width);
			
			// Draw Click Area
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			//this.graphics.lineStyle(1, 0xFFFFFF, 1);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_useArea = true;
			_width = w;
			draw();
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_useArea = true;
			_height = h;
			draw();
		}
		
		/**
		 * Gets / sets the text of this Label.
		 */
		public function set text(t:String):void
		{
			_useHtml = false;
			_textSet(t);
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function get formatted_text():String
		{
			return (_fontSize != _tf.defaultTextFormat.size ? "<FONT SIZE=\"" + _fontSize + "px\">" : "") + (_useHtml ? text : StringUtil.htmlEscape(text)) + (_fontSize != DEFAULT_FONT_SIZE ? "</font>" : "");
		}
		
		/**
		 * Gets / sets the html text of this Label.
		 */
		public function set htmlText(t:String):void
		{
			_useHtml = true;
			_textSet(t);
		}
		
		public function get htmlText():String
		{
			return _text;
		}
		
		/**
		 * Sets the text variable from tet and htmlText.
		 * @param	t
		 */
		private function _textSet(t:String):void
		{
			_text = t;
			if (_text == null)
				_text = "";
				
			_textformat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));

			draw();
		}
		
		/**
		 * Gets / sets whether or not this Label will autosize.
		 */
		public function set autoSize(auto:String):void
		{
			_autoSize = auto;
			draw();
		}
		
		public function get autoSize():String
		{
			return _autoSize;
		}
		
		/**
		 * Gets the internal TextField of the label if you need to do further customization of it.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		public function get fontSize():int
		{
			return (_textformat.size != null ? _textformat.size as int : UIStyle.FONT_SIZE);
		}
		
		public function set fontSize(value:int):void
		{
			var def:TextFormat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));
			if (value == DEFAULT_FONT_SIZE)
			{
				_textformat = def;
			}
			else
			{
				_textformat = new TextFormat();
				_textformat.font = def.font;
				_textformat.color = def.color;
				_textformat.size = value;
			}
			_fontSize = value;
			draw();
		}
	}

}