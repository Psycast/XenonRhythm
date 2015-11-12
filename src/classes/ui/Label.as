package classes.ui
{
	import com.flashfla.utils.StringUtil;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends UIComponent
	{
		protected var _useHtml:Boolean = false;
		protected var _useArea:Boolean = false;
		protected var _autoSize:String = TextFieldAutoSize.LEFT;
		protected var _fontSize:int = 14;
		protected var _text:String = "";
		protected var _tf:TextField;
		
		public function Label(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", useHtml:Boolean = false)
		{
			_useHtml = useHtml;
			this.text = text;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_height = 18;
			_tf = new TextField();
			_tf.height = _height;
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = UIStyle.getTextFormat();
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = _text;
			addChild(_tf);
			draw();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSize(w:Number, h:Number):void
		{
			_useArea = true;
			super.setSize(w, h);
		}
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_useArea = true;
			super.width = w;
		}
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_useArea = true;
			super.height = h;
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
				//- Fit Witin Area
				if (width > 0)
				{
					while (_tf.width > width)
					{
						if (_fontSize <= 1) break;
						
						_fontSize--;
						_tf.htmlText = formatted_text;
					}
				}
				
				//- Text Alignment to Area
				if (_autoSize == TextFieldAutoSize.LEFT)
				{
					_tf.x = 0;
				}
				else if (_autoSize == TextFieldAutoSize.CENTER)
				{
					_tf.x = ((_width - _tf.width) / 2);
				}
				else if (_autoSize == TextFieldAutoSize.RIGHT)
				{
					_tf.x = (_width - _tf.width);
				}
				
				//- Text Alignment Vertical
				_tf.y = ((_height - _tf.height) / 2);
			}
			
			// Draw Click Area
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0,0, _width, _height);
			this.graphics.endFill();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
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
			return (_fontSize != 14 ? "<font size=\"" + _fontSize + "px\">" : "") + (_useHtml ? text : StringUtil.htmlEscape(text)) + (_fontSize != 14 ? "</font>" : "");
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
			invalidate();
		}
		
		/**
		 * Gets / sets whether or not this Label will autosize.
		 */
		public function set autoSize(auto:String):void
		{
			_autoSize = auto;
			invalidate();
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
	}

}