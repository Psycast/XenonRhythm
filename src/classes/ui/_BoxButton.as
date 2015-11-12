package classes.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class _BoxButton extends Sprite
	{
		private var _box:Box;
		private var _text:Text;
		
		private var _width:Number;
		private var _height:Number;
		private var _useHover:Boolean;
		public var tag:*;
		
		public function _BoxButton(width:Number, height:Number, text:String, size:int = 12, color:String = "#FFFFFF", useHover:Boolean = true, useGradient:Boolean = false)
		{
			super();
			
			this._width = width;
			this._height = height;
			this._useHover = useHover;
			
			//- Box
			_box = new Box(this._width, this._height, false, useGradient);
			this.addChild(_box);
			
			//- Add Text
			_text = new Text(text, size, color);
			_text.height = _height + 1;
			_text.width = _width;
			_text.align = Text.CENTER;
			this.addChild(_text);
			
			//- Set Defaults
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true;
			
			if (this._useHover)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, boxOver, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OUT, boxOut, false, 0, true);
			}
		}
		
		public function get text():String
		{
			return _text.text;
		}
		
		public function set text(value:String):void
		{
			_text.text = value;
		}
		
		public function set boxColor(value:uint):void
		{
			_box.color = value;
		}
		
		public function dispose():void
		{
			// Remove Events
			if (this._useHover)
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, boxOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, boxOut);
			}
			
			//- Remove is already existed.
			if (_text != null)
			{
				_text.dispose();
				this.removeChild(_text);
				_text = null;
			}
			if (_box != null)
			{
				_box.dispose();
				this.removeChild(_box);
				_box = null;
			}
		}
		
		private function boxOver(e:MouseEvent):void
		{
			_box.boxOver();
		}
		
		private function boxOut(e:MouseEvent):void
		{
			_box.boxOut();
		}
	}
}