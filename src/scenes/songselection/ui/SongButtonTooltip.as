package scenes.songselection.ui 
{
	import classes.ui.UIStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SongButtonTooltip extends Sprite 
	{
		private var _field:TextField;
		private var drawPoint:Point;
		
		public function SongButtonTooltip(parent:DisplayObjectContainer = null) 
		{
			_field = new TextField();
			_field.defaultTextFormat = UIStyle.TEXT_FORMAT_U;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.embedFonts = true;
			_field.selectable = false;
			_field.x = 5;
			_field.y = 5;
			addChild(_field);
			
			this.filters[new GlowFilter(0xFFFFFF, 1, 1, 1)];
			
			if (parent)
				parent.addChild(this);
		}
		
		private function draw():void
		{
			var drawWidth:Number = Math.max(200, _field.width + 10);
			
			graphics.clear();
			graphics.lineStyle(1, 0xFFFFFF, 1, true);
			graphics.beginFill(UIStyle.BG_DARK, 0.95);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(drawWidth, 0);
			graphics.lineTo(drawWidth, height);
			graphics.lineTo(0, height);
			if (drawPoint)
			{
				graphics.lineTo(0, drawPoint.y + 21);
				graphics.lineTo(-7, drawPoint.y + 15);
				graphics.lineTo(0, drawPoint.y + 8);
			}
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
		
		public function move(nx:Number, ny:Number):void
		{
			x = Math.max(Math.min(nx, Constant.GAME_WIDTH - width - 10), 0);
			y = Math.max(Math.min(ny, Constant.GAME_HEIGHT - height - 10), 0);
			
			drawPoint = globalToLocal(new Point(nx, ny));
			
			draw();
		}
		
		public function moveObject(spr:DisplayObject):void
		{
			drawPoint = spr.localToGlobal(new Point(spr.width - 250, spr.height / 2 - 15));
			move(drawPoint.x, drawPoint.y);
		}
		
		public function set text(str:String):void
		{
			_field.htmlText = str;
			draw();
		}
	}

}