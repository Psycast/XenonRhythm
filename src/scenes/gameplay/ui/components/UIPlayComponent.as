package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.ui.UIAnchor;
	import classes.ui.UIComponent;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	
	public class UIPlayComponent extends UIComponent
	{
		public static const ONTICK:int = 1;
		public static const ONSCORE:int = 2;
		
		public var UPDATE_MODE:int = 0;

		protected var core:EngineCore;

		protected var _canExport:Boolean = false;

		protected var _alignment:int = UIAnchor.TOP_LEFT;
		protected var _editorMode:Boolean = false;
		protected var _anchorLock:Boolean = false;

		protected var T_eclipsedMillis:int = 0;
		
		/**
		 * Constructor
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function UIPlayComponent(core:EngineCore = null)
		{
			this.core = core;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			this.cacheAsBitmapMatrix = new Matrix();

			super(null, 0, 0);
		}

		/**
		 * Get Type of the UIPlayComponent.
		 * @return Type
		 */
		public function get type():String
		{
			return "unknown";
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		override public function draw():void 
		{
			if (editorMode)
			{
				graphics.lineStyle(1, 0xFF00FF, 1);
				graphics.moveTo(-5, 0);
				graphics.lineTo(5, 0);
				graphics.moveTo(0, -5);
				graphics.lineTo(0, 5);
				graphics.beginFill(0x000000, 0);
				graphics.drawRect( -5, -5, 10, 10);
				graphics.endFill();
			}
			super.draw();
		}
		
		/**
		 * Abstract function to update display.
		 */
		public function update(currentMS:Number, eclipsedMS:Number):void
		{
			
		}

		/**
		 * Abstract function to build component from json object.
		 */
		public function buildFromConfig(config:Object):Boolean
		{
			if(!config["enabled"] || config["type"] != type)
				return false;

			return true;
		}

		/**
		 * Set basic values from a configuration object.
		 * These values should always exist of a UI Configuration object.
		 * @param config 
		 */
		public function setFromConfig(config:Object):void
		{
			this.anchor = config["anchor"];
			this.alignment = config["alignment"];
			this.x = config["x"];
			this.y = config["y"];

			if(config["anchor_lock"] != null)
				this._anchorLock = config["anchor_lock"];
		}
		
		/**
		 * Abstract function to position child items.
		 */
		public function positionChildren():void
		{
			
		}

		/**
		 * Parse a string hex color into a int.
		 * @param val Color as a string, without the prefix. (0x or #)
		 * @return 
		 */
		public function parseColor(val:String):int
		{
			return parseInt("0x" + val);
		}

		///////////////////////////////////
		// signal calls
		///////////////////////////////////

		public function onScoreSignal(score:int, judgeMS:int):void
		{
			
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets the status of editor mode for this component.
		 */
		public function get editorMode():Boolean 
		{
			return _editorMode;
		}
		
		/**
		 * Sets the editor mode. Used to draw the bounding box and clickable area.
		 */
		public function set editorMode(value:Boolean):void 
		{
			_editorMode = value;
			mouseEnabled = value;
			useHandCursor = value;
			draw();
		}
		
		/**
		 * Gets the alignment to use for positioning elements within the component.
		 */
		public function get alignment():int 
		{
			return _alignment;
		}
		
		/**
		 * Sets the alignment to use for positioning elements within the component.
		 */
		public function set alignment(value:int):void 
		{
			_alignment = value;
			positionChildren();
			update(0, 0);
			draw();
		}

		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Export UIPlayComponent into JSON format.
		 * @param k 
		 * @return Object containing struct.
		 */
		public function toJSON(k:String):Object
		{
			if(!_canExport) return null;

			return {
				"type": type,
				"enabled": true,
				"anchor": anchor,
				"anchor_lock": _anchorLock,
				"alignment": alignment,
				"x": x,
				"y": y
			};
		}
		
		/**
		 * Gets the default configuration for this UIPlayComponent.
		 * @return Object Config.
		 */
		public function getDefaultConfig():Object
		{
			return DEFAULT_CONFIG;
		}

		private static const DEFAULT_CONFIG:Object = {
			"type": "unknown",
			"enabled": false,
			"anchor": 0,
			"anchor_lock": false,
			"alignment": 0,
			"x": 0,
			"y": 40
		};
	}
}