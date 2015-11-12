package classes.ui
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class _Text extends Sprite
	{
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		
		private var _textTF:TextField;
		private var _textTFormat:TextFormat;
		private var _message:String;
		private var _width:Number = -1;
		private var _height:Number = 22.6;
		private var _fontSize:Number;
		private var _fontColor:String;
		private var _area:Sprite;
		private var _useArea:Boolean = false;
		private var _align:String = LEFT;
		private var _isUnicode:Boolean = false;
		
		///- Constructor
		public function _Text(message:String, fontSize:int = 12, fontColor:String = "#FFFFFF", textAlign:String = "left")
		{
			this._message = message.toString();
			this._fontSize = fontSize;
			this._fontColor = fontColor;
			
			//var style:StyleSheet = new StyleSheet();
			//style.setStyle("BODY", { "text-align": textAlign } );
			//style.setStyle("A", { "textDecoration": "underline" } );
			
			_textTFormat = new TextFormat();
			_textTFormat.align = textAlign;
			_align = textAlign;
			
			// Build Text
			_textTF = new TextField();
			//_textTF.styleSheet = style;
			_textTF.selectable = false;
			_textTF.embedFonts = true;
			_textTF.antiAliasType = AntiAliasType.ADVANCED;
			_textTF.autoSize = textAlign;
			_textTF.defaultTextFormat = _textTFormat;
			this.addChild(_textTF);
			
			_isUnicode = isUnicode(_message);
			
			draw();
		}
		
		override public function set width(nW:Number):void
		{
			_width = nW;
			_useArea = true;
			draw();
		}
		
		override public function set height(nH:Number):void
		{
			_height = nH;
			_useArea = true;
			draw();
		}
		
		public function get useArea():Boolean
		{
			return _useArea;
		}
		
		public function set useArea(inBool:Boolean):void
		{
			_useArea = inBool;
			draw();
		}
		
		public function set align(inString:String):void
		{
			_align = inString;
			_useArea = true;
			draw();
		}
		
		public function get textfield():TextField
		{
			return _textTF;
		}
		
		public function get text():String
		{
			return _message;
		}
		
		public function set text(value:String):void
		{
			_message = value;
			draw();
		}
		
		public function get fontColor():String
		{
			return _fontColor;
		}
		
		public function set fontColor(value:String):void
		{
			_fontColor = value;
			draw();
		}
		
		public function get fontSize():int
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			draw();
		}
		
		private function html():String
		{
			return "<font face=\"Segoe UI\" color=\"" + _fontColor + "\" size=\"" + _fontSize + "\"><b>" + _message + "</b></font>";
		}
		
		private function draw():void
		{
			_textTF.htmlText = html();
			
			if (_useArea)
			{
				//- Clickable Area
				if (_area != null)
				{
					this.removeChild(_area);
					_area = null;
				}
				_area = new Sprite();
				_area.graphics.beginFill(0xFFFFFF, 0);
				_area.graphics.drawRect(0, 0, _width, _height);
				_area.graphics.endFill();
				this.addChild(_area);
				
				//- Auto Center Y axis.
				if (_width > 0)
				{
					while (_textTF.width > _width)
					{
						_fontSize--;
						_textTF.htmlText = html();
					}
				}
				_textTF.y = ((_height - _textTF.height) / 2);
				
				//- Text Alignment to Area
				if (_align == LEFT)
				{
					_textTF.x = 0;
				}
				else if (_align == CENTER)
				{
					_textTF.x = ((_width - _textTF.width) / 2);
				}
				else if (_align == RIGHT)
				{
					_textTF.x = (_width - _textTF.width);
				}
			}
		}
		
		public static function isUnicode(input:String):Boolean
		{
			var textLength:int = input.length;
			for (var i:int = 0; i < textLength; i++)
			{
				if (input.charCodeAt(i) > 255)
				{
					return true;
				}
			}
			return false;
		}
	}
}