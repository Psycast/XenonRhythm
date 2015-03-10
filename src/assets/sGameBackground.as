package assets 
{
	import classes.UICore;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class sGameBackground extends Sprite 
	{
		private var _text:String;
		private var _field:TextField;
		public var BG_DARK:int = 0x033242;
		public var BG_LIGHT:int = 0x1495BD;
		
		public function sGameBackground(text:String = "") 
		{
			// Displays Text in bottom left corner. Mainly Debug.
			_text = text;
			if (_text != "")
			{
				_field = new TextField();
				_field.x = 5;
				_field.y = Constant.GAME_HEIGHT - 25;
				_field.embedFonts = true;
				_field.defaultTextFormat = Constant.TEXT_FORMAT;
				_field.text = _text;
				_field.mouseEnabled = false;
				_field.autoSize = "left";
				_field.alpha = 0.3;
				addChild(_field);
			}
			
			// Draw Component
			draw();
		}
		
		public function draw():void
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(Constant.GAME_WIDTH, Constant.GAME_HEIGHT, 5.75);
			
			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.LINEAR, [BG_LIGHT, BG_DARK], [1, 1], [0x00, 0xFF], m);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
		}
		
	}

}