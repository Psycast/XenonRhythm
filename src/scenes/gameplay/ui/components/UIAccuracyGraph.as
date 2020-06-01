package scenes.gameplay.ui.components
{
	import classes.ui.UIAnchor;
	import classes.engine.EngineCore;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import com.flashfla.utils.StringUtil;

	public class UIAccuracyGraph extends UIPlayComponent
	{
		private var _renderTarget:Shape;
		private var _displayBM:Bitmap;
		private var _displayBMD:BitmapData;
		private var _alphaAdjust:ColorTransform;
		private var _alphaArea:Rectangle;

		private var fade_tick:int = 33;
		private var fade_timer:int = 0;

		private const LINE_WIDTH:int = 3;

		private var bound_lower:int = -117;
		private var bound_upper:int = 117;
		private var bound_range:int = 234;
		
		private var _colors:Array;

		public function UIAccuracyGraph(core:EngineCore = null)
		{
			this.UPDATE_MODE = ONTICK | ONSCORE;
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
			return "accuracygraph";
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

			// Set Size
			setSize(config["parts"]["size"]["width"], config["parts"]["size"]["height"], false);

			// Fade Tick Rate
			fade_tick = config["parts"]["fade_tick"];
			if(fade_tick <= 0) fade_tick = 33;

			// Parse Colors
			_colors = [];
			_colors[100] = parseColor(config["parts"]["colors"]["amazing"]);
			_colors[50] = parseColor(config["parts"]["colors"]["perfect"]);
			_colors[25] = parseColor(config["parts"]["colors"]["good"]);
			_colors[5] = parseColor(config["parts"]["colors"]["average"]);

			// Get Judge Range
			bound_range = Math.max(Math.abs(bound_lower), Math.abs(bound_upper)) * 2;

			// Setup Bitmap for Display, and ColorTransform for Fade
			_renderTarget = new Shape();
			_displayBMD  = new BitmapData(width, height, true, 0)
			_displayBM = new Bitmap(_displayBMD);
			_alphaAdjust = new ColorTransform(1, 1, 1, 0.95);
			_alphaArea = new Rectangle(0, 0, _displayBMD.width, _displayBMD.height);
			addChild(_displayBM);
			
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
		
		override public function update(currentMS:Number, milliseconds:Number):void
		{
			T_eclipsedMillis += milliseconds;

			while(T_eclipsedMillis > fade_tick)
			{
				_displayBMD.colorTransform(_alphaArea, _alphaAdjust);
				T_eclipsedMillis -= fade_tick;
			}
		}
		
		override public function positionChildren():void
		{
			_displayBM.x = UIAnchor.getOffsetH(alignment, width);
			_displayBM.y = UIAnchor.getOffsetV(alignment, height);
		}

		override public function onScoreSignal(_score:int, _judgeMS:int):void
		{
			// Judge Accuracy Lines
			_renderTarget.graphics.clear();

			_renderTarget.graphics.beginFill(_colors[_score], 1);
			_renderTarget.graphics.drawRect((_judgeMS / bound_range * (width - LINE_WIDTH)) + (width / 2), 0, LINE_WIDTH, height);
			_renderTarget.graphics.endFill();

			_displayBMD.draw(_renderTarget);
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
				"size": {
					"width": width,
					"height": height
				},
				"colors": {
					"amazing": StringUtil.pad(_colors[100].toString(16), 6, "0", StringUtil.STR_PAD_LEFT),
					"perfect": StringUtil.pad(_colors[50].toString(16), 6, "0", StringUtil.STR_PAD_LEFT),
					"good": StringUtil.pad(_colors[25].toString(16), 6, "0", StringUtil.STR_PAD_LEFT),
					"average": StringUtil.pad(_colors[5].toString(16), 6, "0", StringUtil.STR_PAD_LEFT)
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
			"type": "accuracygraph",
			"enabled": true,
			"anchor": UIAnchor.MIDDLE_CENTER,
			"anchor_lock": false,
			"alignment": UIAnchor.MIDDLE_CENTER,
			"x": 0,
			"y": 40,
			"parts": {
				"size": {
					"width": 120,
					"height": 32
				},
				"colors": {
					"amazing": "099fff",
					"perfect": "ffffff",
					"good": "01aa0f",
					"average": "f99800"
				}
			}
		};
	}
}