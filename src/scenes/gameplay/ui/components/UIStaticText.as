package scenes.gameplay.ui.components
{
	import classes.ui.UIAnchor;
	import classes.ui.UIStyle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.flashfla.utils.StringUtil;
	
	public class UIStaticText extends UIPlayComponent
	{
		private var _textfield:TextField;
		private var _text:String;
		private var _text_color:int = 0;

		/**
		 * Get Type of the UIPlayComponent.
		 * @return Type
		 */
		override public function get type():String
		{
			return "static_text";
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

			_text_color = parseColor(config["parts"]["color"]);

			_text = config["parts"]["text"];

			_textfield = new TextField();
			_textfield.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 17, _text_color, true);
			_textfield.antiAliasType = AntiAliasType.ADVANCED;
			_textfield.embedFonts = true;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.text = _text;
			addChild(_textfield);
			
			// Set General Config Values
			setFromConfig(config);
			_canExport = true;

			return true;
		}
		
		override public function draw():void
		{
			graphics.clear();
			
			// Create Clickable surface for Editor Mode
			if (editorMode && _textfield)
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
			if(_textfield)
			{
				_textfield.x = UIAnchor.getOffsetH(alignment, _textfield.width);
				_textfield.y = UIAnchor.getOffsetV(alignment, _textfield.height);
			}
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
				"text": _text,
				"color": StringUtil.pad(_text_color.toString(16), 6, "0", StringUtil.STR_PAD_LEFT)
			}
			return sup;
		}	
	}
}