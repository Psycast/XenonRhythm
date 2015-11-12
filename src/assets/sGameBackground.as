package assets
{
	import classes.ui.UICore;
	import classes.ui.UIStyle;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class sGameBackground extends Sprite
	{
		private var _matrix:Matrix = new Matrix();
		private var _text:String;
		private var _field:TextField;
		public var BG_DARK:int = 0x033242;
		public var BG_LIGHT:int = 0x1495BD;
		
		public function sGameBackground()
		{
			// Draw Component
			_matrix.createGradientBox(Constant.GAME_WIDTH, Constant.GAME_HEIGHT, 5.75);
			draw();
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			// Cache BG
			scrollRect = new Rectangle(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Displays Text in bottom left corner. Mainly Debug.
			CONFIG::debug {
			if (parent && parent is UICore && !_text)
				text = CONFIG::timeStamp + " - " + (parent as UICore).class_name;
			}
		}
		
		public function set text(t:String):void
		{
			_text = t;
			if (_text == null)
				_text = "";
			
			// Create Textbox
			if (_text != "")
			{
				if (!_field)
				{
					_field = new TextField();
					_field.x = 5;
					_field.y = Constant.GAME_HEIGHT - 25;
					_field.defaultTextFormat = UIStyle.getTextFormat();
					_field.embedFonts = true;
					_field.mouseEnabled = false;
					_field.autoSize = "left";
					_field.alpha = 0.3;
					addChild(_field);
				}
			}
			
			// Update Textbox
			if (_field)
				_field.text = _text;
		}
		
		public function draw():void
		{
			cacheAsBitmap = false;
			
			// Create Background
			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.LINEAR, [BG_LIGHT, BG_DARK], [1, 1], [0x00, 0xFF], _matrix);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, 0, 0.25);
			for (var i:int = -Constant.GAME_WIDTH; i < Constant.GAME_WIDTH; i += 6)
			{
				this.graphics.moveTo(i, 0);
				this.graphics.lineTo(i + Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			}
			
			cacheAsBitmap = true;
		}
	
	}

}