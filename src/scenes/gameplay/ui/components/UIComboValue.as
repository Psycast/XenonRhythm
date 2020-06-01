package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.ui.UIAnchor;
	import classes.ui.UIStyle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import scenes.gameplay.ScoreValues;
	import com.flashfla.utils.ColorUtil;
	import com.flashfla.utils.StringUtil;
	
	public class UIComboValue extends UIPlayComponent
	{
		private var score:ScoreValues;
		private var _text:TextField;
		private var _textShadow:TextField;
		private var _colors:Vector.<uint>;
		private var _colorsDark:Vector.<uint>;
		
		public function UIComboValue(core:EngineCore = null, score:ScoreValues = null)
		{
			this.UPDATE_MODE = ONSCORE;
			this.score = score;
			super(core);
		}
		
		/**
		 * Get Type of the UIPlayComponent.
		 * @return Type
		 */
		override protected function init():void
		{
			setSize(150, 42, false);
			super.init();
		}
		
		override public function get type():String
		{
			return "combo";
		}

		/**
		 * Builds the UI Component using the provided configuration object.
		 * Check DEFAULT_CONFIG for an example.
		 * @param config Object containing configuration block.
		 * @return If config was valid.
		 */
		override public function buildFromConfig(config:Object):Boolean
		{
			if(!super.buildFromConfig(config))
				return false;

			// Parse Colors
			_colors = new Vector.<uint>(3, true);
			_colorsDark = new Vector.<uint>(3, true);
			_colors[0] = parseColor(config["parts"]["colors"]["normal"]);
			_colors[1] = parseColor(config["parts"]["colors"]["fc"]);
			_colors[2] = parseColor(config["parts"]["colors"]["aaa"]);
			
			for(var i:int = 0; i < _colors.length; i++)
				_colorsDark[i] = ColorUtil.darkenColor(_colors[i], 0.5);

			// Textfields
			_textShadow = new TextField();
			_textShadow.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 50, _colors[0], true);
			_textShadow.antiAliasType = AntiAliasType.ADVANCED;
			_textShadow.embedFonts = true;
			_textShadow.selectable = false;
			_textShadow.autoSize = TextFieldAutoSize.LEFT;
			addChild(_textShadow);
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 50, _colorsDark[0], true);
			_text.antiAliasType = AntiAliasType.ADVANCED;
			_text.embedFonts = true;
			_text.selectable = false;
			_text.autoSize = TextFieldAutoSize.LEFT;
			addChild(_text);
			
			// Set General Config Values
			setFromConfig(config);
			_canExport = true;

			return true;
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
		
		override public function onScoreSignal(_score:int, _judgeMS:int):void
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
					_text.textColor = _colors[0];
					_textShadow.textColor = _colorsDark[0];
				}
				else if (score.good + score.average + score.boo == 0)
				{
					_text.textColor = _colors[2];
					_textShadow.textColor = _colorsDark[2];
				}
				else
				{
					_text.textColor = _colors[1];
					_textShadow.textColor = _colorsDark[1];
				}
			}
		}
		
		override public function positionChildren():void
		{
			// Text Position
			_text.text = "";
			_text.autoSize = UIAnchor.getTextAutoSize(alignment);
			_text.x = -3;
			_text.y = UIAnchor.getOffsetV(alignment, height) - 18;

			// Shadow Position
			_textShadow.text = "";
			_textShadow.autoSize = _text.autoSize;
			_textShadow.x = _text.x + 2;
			_textShadow.y = _text.y + 2;
		}
		
		////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Export UIPlayComponent into JSON format.
		 * @param k 
		 * @return Object containing struct.
		 */
		override public function toJSON(k:String):Object
		{
			if(!_canExport) return null;

			var sup:Object = super.toJSON(k);
			sup["parts"] = {
				"color": {
					"normal": StringUtil.pad(_colors[0].toString(16), 6, "0", StringUtil.STR_PAD_LEFT),
					"fc": StringUtil.pad(_colors[1].toString(16), 6, "0", StringUtil.STR_PAD_LEFT),
					"aaa": StringUtil.pad(_colors[2].toString(16), 6, "0", StringUtil.STR_PAD_LEFT)
				}
			};
			return sup;
		}
		
		/**
		 * Gets the default configuration for this UIPlayComponent.
		 * @return Object Config.
		 */
		override public function getDefaultConfig():Object
		{
			return DEFAULT_CONFIG;
		}

		/** Default Config Object for this UIPlayComponent */
		private static const DEFAULT_CONFIG:Object = {
			"type": "combo",
			"enabled": true,
			"anchor": UIAnchor.BOTTOM_CENTER,
			"anchor_lock": false,
			"alignment": UIAnchor.BOTTOM_RIGHT,
			"x": -90,
			"y": -30,
			"parts": {
				"colors": {
					"normal": "0099cc",
					"fc": "00ad00",
					"aaa": "fcc200"
				}
			}
		};
	}
}