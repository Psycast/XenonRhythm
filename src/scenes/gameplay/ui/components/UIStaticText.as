package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.ui.UIAnchor;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class UIStaticText extends UIPlayComponent
	{
		private var _textfield:TextField;
		private var _text:String;
		
		public function UIStaticText(parent:DisplayObjectContainer = null, text:String = "")
		{
			_text = text;
			super(parent);
		}
		
		override protected function addChildren():void
		{
			_textfield = new TextField();
			_textfield.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 17, 0x0098CB, true);
			_textfield.antiAliasType = AntiAliasType.ADVANCED;
			_textfield.embedFonts = true;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.text = _text;
			addChild(_textfield);
			
			positionChildren();
		}
		
		override public function draw():void
		{
			graphics.clear();
			
			// Create Clickable surface for Editor Mode
			if (editorMode)
			{
				graphics.lineStyle(1, 0x80FFFF, 1);
				graphics.beginFill(0x000000, 0);
				graphics.drawRect(_textfield.x, _textfield.y, _textfield.width, _textfield.height);
				graphics.endFill();
			}
			super.draw();
		}
		
		override public function positionChildren():void
		{
			_textfield.x = UIAnchor.getOffsetH(alignment, _textfield.width);
			_textfield.y = UIAnchor.getOffsetV(alignment, _textfield.height);
		}
	}
}