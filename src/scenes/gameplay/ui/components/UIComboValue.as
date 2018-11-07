package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.engine.EngineSettings;
	import classes.ui.UIAnchor;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import scenes.gameplay.ScoreValues;
	
	public class UIComboValue extends UIPlayComponent
	{
		private var score:ScoreValues;
		private var _text:TextField;
		private var _textShadow:TextField;
		
		public function UIComboValue(parent:DisplayObjectContainer = null, core:EngineCore = null, score:ScoreValues = null)
		{
			this.score = score;
			super(parent, core);
		}
		
		override protected function init():void
		{
			setSize(150, 42, false);
			super.init();
		}
		
		override protected function addChildren():void
		{
			_textShadow = new TextField();
			_textShadow.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 50, 0xCC6600, true);
			_textShadow.antiAliasType = AntiAliasType.ADVANCED;
			_textShadow.embedFonts = true;
			_textShadow.selectable = false;
			_textShadow.autoSize = TextFieldAutoSize.LEFT;
			addChild(_textShadow);
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 50, 0xFCC200, true);
			_text.antiAliasType = AntiAliasType.ADVANCED;
			_text.embedFonts = true;
			_text.selectable = false;
			_text.autoSize = TextFieldAutoSize.LEFT;
			addChild(_text);
			
			positionChildren();
		}
		
		override public function draw():void
		{
			graphics.clear();
			
			// Create Clickable surface for Editor Mode
			if (editorMode)
			{
				var drawX:int = UIAnchor.getOffsetH(alignment, width);
				var drawY:int = UIAnchor.getOffsetV(alignment, height);
				
				graphics.lineStyle(1, 0x80FFFF, 1);
				graphics.beginFill(0x000000, 0);
				graphics.drawRect(drawX, drawY, width, height);
				graphics.endFill();
			}
			super.draw();
		}
		
		override public function update():void
		{
			_text.text = score.combo.toString();
			_textShadow.text = score.combo.toString();
			
			if (core.variables.is_autoplay && !editorMode)
			{
				_text.textColor = 0xD00000;
				_textShadow.textColor = 0x5B0000;
			}
			else
			{
				if (score.miss)
				{
					_text.textColor = 0x0099CC;
					_textShadow.textColor = 0x0000FF;
				}
				else if (score.good + score.average + score.boo == 0)
				{
					_text.textColor = 0xFCC200;
					_textShadow.textColor = 0xCC6600;
				}
				else
				{
					_text.textColor = 0x00AD00;
					_textShadow.textColor = 0x004F04;
				}
			}
		}
		
		override public function positionChildren():void
		{
			// Text Position
			_text.autoSize = UIAnchor.getTextAutoSize(alignment);
			_text.x = -3;
			_text.y = UIAnchor.getOffsetV(alignment, height) - 18;

			// Set Shadow Position
			_textShadow.autoSize = _text.autoSize;
			_textShadow.x = _text.x + 2;
			_textShadow.y = _text.y + 2;
		}
	}
}