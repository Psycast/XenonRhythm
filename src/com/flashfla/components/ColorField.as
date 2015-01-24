package com.flashfla.components {
	import flash.display.Sprite;
	
	public class ColorField extends Sprite {
		
		private var _color:int = 0x000000;
		private var _width:Number;
		private var _height:Number;
		
		public function ColorField(defaultColor:int = 0x000000, dWidth:Number = 75, dHeight:Number = 20) {
			this._color = defaultColor;
			this._width = dWidth;
			this._height = dHeight;
			
			draw();
		}
		
		private function draw():void {
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			this.graphics.beginFill(_color);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		
		public function get color():int {
			return _color;
		}
		
		public function set color(newColor:int):void {
			this._color = newColor;
			draw();
		}
	}

}