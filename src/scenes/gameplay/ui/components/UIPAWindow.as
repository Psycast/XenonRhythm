package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.engine.EngineSettings;
	import classes.ui.UIAnchor;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import scenes.gameplay.ScoreValues;
	
	public class UIPAWindow extends UIPlayComponent
	{
		private static const FIELDS:Array = ["Amazing", "Perfect", "Good", "Average", "Miss", "Boo"];
		private var score:ScoreValues;
		private var settings:EngineSettings;
		private var _plane:Sprite;
		private var _textlabels:Array;
		private var _textvalues:Array;
		private var FIELD_INDEX:int = 0;
		
		public function UIPAWindow(parent:DisplayObjectContainer = null, core:EngineCore = null, score:ScoreValues = null, settings:EngineSettings = null)
		{
			this.score = score;
			this.settings = settings;
			super(parent, core);
		}
		
		override protected function init():void
		{
			setSize(180, 240, false);
			FIELD_INDEX = settings.display_amazing ? 0 : 1;
			super.init();
		}
		
		override protected function addChildren():void
		{
			addChild((_plane = new Sprite()));
			
			var ypos:int = -10;
			var TEXT_SIZE:int = 36;
			var _text:TextField;
			
			_textlabels = [];
			_textvalues = [];
			
			for (var i:int = FIELD_INDEX; i < FIELDS.length; i++)
			{
				
				// Labels
				_text = new TextField();
				_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 13, settings.judge_colors[i], true);
				_text.antiAliasType = AntiAliasType.ADVANCED;
				_text.embedFonts = true;
				_text.selectable = false;
				_text.y = ypos + TEXT_SIZE - 12;
				_text.text = FIELDS[i];
				_plane.addChild(_text);
				_textlabels.push(_text);
				
				// Values
				_text = new TextField();
				_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, TEXT_SIZE--, settings.judge_colors[i], true);
				_text.antiAliasType = AntiAliasType.ADVANCED;
				_text.embedFonts = true;
				_text.selectable = false;
				_text.y = ypos;
				_plane.addChild(_text);
				_textvalues.push(_text);
				
				ypos += 45 - (36 - TEXT_SIZE);
			}
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
			var offset:int = 0;
			if (settings.display_amazing) {
				updateScore(0, score.amazing);
				updateScore(1, score.perfect);
				offset = 1;
			} else
				updateScore(0, score.amazing + score.perfect);
			updateScore(offset + 1, score.good);
			updateScore(offset + 2, score.average);
			updateScore(offset + 3, score.miss);
			updateScore(offset + 4, score.boo);
		}
		
		private function updateScore(index:int, value:Number):void 
		{
			_textvalues[index].text = value.toString();
		}
		
		override public function positionChildren():void
		{
			_plane.x = UIAnchor.getOffsetH(alignment, width);
			_plane.y = UIAnchor.getOffsetV(alignment, height);
			
			var i:int = 0;
			var display_labels:Boolean = true;
			
			if (alignment & UIAnchor.RIGHT)
			{
				for (i = 0; i < _textlabels.length; i++)
				{
					_textlabels[i].visible = display_labels;
					_textlabels[i].x = width - 61;
					_textlabels[i].width = 0;
					_textlabels[i].autoSize = TextFieldAutoSize.LEFT;
					
					_textvalues[i].x = width - (display_labels ? 65 : 2);
					_textvalues[i].width = 0;
					_textvalues[i].autoSize = TextFieldAutoSize.RIGHT;
				}
			}
			else if (alignment & UIAnchor.CENTER)
			{
				for (i = 0; i < _textlabels.length; i++)
				{
					_textlabels[i].visible = false;
					
					_textvalues[i].x = (width / 2);
					_textvalues[i].width = 0;
					_textvalues[i].autoSize = TextFieldAutoSize.CENTER;
				}
			}
			else
			{
				for (i = 0; i < _textlabels.length; i++)
				{
					_textlabels[i].visible = display_labels;
					_textlabels[i].x = 61;
					_textlabels[i].width = 0;
					_textlabels[i].autoSize = TextFieldAutoSize.RIGHT;
					
					_textvalues[i].x = (display_labels ? 65 : 2);
					_textvalues[i].width = 0;
					_textvalues[i].autoSize = TextFieldAutoSize.LEFT;
				}
			}
		}
	}
}