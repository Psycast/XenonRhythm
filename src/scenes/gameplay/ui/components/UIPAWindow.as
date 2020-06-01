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
	import com.flashfla.utils.StringUtil;
	
	public class UIPAWindow extends UIPlayComponent
	{
		private static const FIELDS:Array = ["amazing", "perfect", "good", "average", "miss", "boo"];
		
		private var score:ScoreValues;
		private var settings:EngineSettings;

		private var _textLabels:Vector.<TextField>;
		private var _textValues:Vector.<TextField>;
		private var _labelGroups:Vector.<PALabelGroup>;

		private var _display_labels:Boolean = true;

		private var _plane:Sprite;
		
		public function UIPAWindow(core:EngineCore = null, score:ScoreValues = null, settings:EngineSettings = null)
		{
			this.UPDATE_MODE = ONSCORE;
			this.score = score;
			this.settings = settings;
			super(core);
		}

		/**
		 * Get Type of the UIPlayComponent.
		 * @return Type
		 */
		override public function get type():String
		{
			return "pawindow";
		}
		
		/**
		 * Init default size of the PAWindow, this should be
		 * it's max render size on stage, but will exceed it's 
		 * width if any score value goes above 99999.
		 */
		override protected function init():void
		{
			setSize(180, 240, false);
			super.init();
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

			// Create Plane
			addChild((_plane = new Sprite()));

			// Create Labels
			var ypos:int = -10;
			var TEXT_SIZE:int = 36;
			var label_color:int = label_color;
			var _text:TextField;

			_display_labels = config["parts"]["labels"]["display"];

			var labelConfig:Object;
			var labelGroup:PALabelGroup;
			
			_textLabels = new Vector.<TextField>();
			_textValues = new Vector.<TextField>();
			_labelGroups = new Vector.<PALabelGroup>();

			for each(var paIndex:String in FIELDS)
			{
				labelConfig = config["parts"]["numbers"][paIndex];

				if(!labelConfig["display"])
					continue;

				label_color = parseInt("0x" + labelConfig["color"]);

				// Labels
				_text = new TextField();
				_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, 13, label_color, true);
				_text.antiAliasType = AntiAliasType.ADVANCED;
				_text.embedFonts = true;
				_text.selectable = false;
				_text.y = ypos + TEXT_SIZE - 12;
				_text.text = core.getString("game_" + paIndex);
				_text.cacheAsBitmap = true;
				_plane.addChild(_text);
				_textLabels.push(_text);

				// Values
				_text = new TextField();
				_text.defaultTextFormat = new TextFormat(UIStyle.FONT_NAME, TEXT_SIZE--, label_color, true);
				_text.antiAliasType = AntiAliasType.ADVANCED;
				_text.embedFonts = true;
				_text.selectable = false;
				_text.y = ypos;
				_text.cacheAsBitmap = true;
				_plane.addChild(_text);
				_textValues.push(_text);
				_labelGroups.push(new PALabelGroup(score, paIndex, _text));
				
				ypos += 45 - (36 - TEXT_SIZE);
			}

			// Fix Vector Size
			_textLabels.fixed = _textValues.fixed = _labelGroups.fixed = true;

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
			for each(var display_group:PALabelGroup in _labelGroups)
				display_group.update();
		}
		
		/**
		 * Positions 
		 */
		override public function positionChildren():void
		{
			_plane.x = UIAnchor.getOffsetH(alignment, width);
			_plane.y = UIAnchor.getOffsetV(alignment, height);
			
			// Position Labels and Values
			var i:int = 0;

			if (alignment & UIAnchor.RIGHT)
			{
				for (i = 0; i < _textLabels.length; i++)
				{
					_textLabels[i].visible = _display_labels;
					_textLabels[i].x = width - 61;
					_textLabels[i].width = 0;
					_textLabels[i].autoSize = TextFieldAutoSize.LEFT;
					
					_textValues[i].x = width - (_display_labels ? 65 : 2);
					_textValues[i].width = 0;
					_textValues[i].autoSize = TextFieldAutoSize.RIGHT;
				}
			}
			else if (alignment & UIAnchor.CENTER)
			{
				for (i = 0; i < _textLabels.length; i++)
				{
					_textLabels[i].visible = false;
					
					_textValues[i].x = (width / 2);
					_textValues[i].width = 0;
					_textValues[i].autoSize = TextFieldAutoSize.CENTER;
				}
			}
			else
			{
				for (i = 0; i < _textLabels.length; i++)
				{
					_textLabels[i].visible = _display_labels;
					_textLabels[i].x = 61;
					_textLabels[i].width = 0;
					_textLabels[i].autoSize = TextFieldAutoSize.RIGHT;
					
					_textValues[i].x = (_display_labels ? 65 : 2);
					_textValues[i].width = 0;
					_textValues[i].autoSize = TextFieldAutoSize.LEFT;
				}
			}
		}

		private function getLabelGroup(index:String):PALabelGroup
		{
			for each(var group:PALabelGroup in _labelGroups)
			{
				if(group.index == index)
					return group;
			}
			return null;
		}

		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Export UIPlayComponent into JSON format.
		 * This probably shouldbe cleaned up.
		 * @param k 
		 * @return Object containing struct.
		 */
		override public function toJSON(k:String):Object
		{
			if(!_canExport) return null;

			var sup:Object = super.toJSON(k);
			sup["parts"] = {
				"labels": {
					"display": _display_labels
				},
				"numbers": {}
			};
			for each(var paIndex:String in FIELDS)
			{
				var lg:PALabelGroup = getLabelGroup(paIndex);

				if(lg != null)
				{
					sup["parts"]["numbers"][paIndex] = {
						"display": true,
						"color": StringUtil.pad(lg.field.defaultTextFormat.color.toString(16), 6, "0", StringUtil.STR_PAD_LEFT)
					};
				}
				else
				{
					sup["parts"]["numbers"][paIndex] = {
						"display": false,
						"color": StringUtil.pad(DEFAULT_CONFIG["parts"]["numbers"][paIndex]["color"].toString(16), 6, "0", StringUtil.STR_PAD_LEFT)
					};
				}
			}
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
			"type": "pawindow",
			"enabled": true,
			"anchor": UIAnchor.MIDDLE_LEFT,
			"anchor_lock": false,
			"alignment": UIAnchor.MIDDLE_LEFT,
			"x": 0,
			"y": 0,
			"parts": {
				"labels": {
					"display": true
				},
				"numbers": {
					"amazing": {
						"display": true,
						"color": "099fff"
					},
					"perfect": {
						"display": true,
						"color": "ffffff"
					},
					"good": {
						"display": true,
						"color": "01aa0f"
					},
					"average": {
						"display": true,
						"color": "f99800"
					},
					"miss": {
						"display": true,
						"color": "fe0000"
					},
					"boo": {
						"display": true,
						"color": "804100"
					}
				}
			}
		};
	}
}

import flash.text.TextField;
import scenes.gameplay.ScoreValues;

internal class PALabelGroup
{
	public var score:ScoreValues;
	public var index:String;
	public var field:TextField;

	public function PALabelGroup(scores:ScoreValues, index:String, field:TextField)
	{
		this.score = scores;
		this.index = index;
		this.field = field;
	}

	public function update():void
	{
		field.text = score[index].toString();
	}
}