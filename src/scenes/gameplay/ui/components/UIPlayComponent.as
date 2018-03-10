package scenes.gameplay.ui.components
{
	import classes.engine.EngineCore;
	import classes.ui.UIAnchor;
	import classes.ui.UIComponent;
	import flash.display.DisplayObjectContainer;
	
	public class UIPlayComponent extends UIComponent
	{
		protected var core:EngineCore;
		protected var _alignment:int = UIAnchor.TOP_LEFT;
		protected var _editorMode:Boolean = true;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function UIPlayComponent(parent:DisplayObjectContainer = null, core:EngineCore = null)
		{
			this.core = core;
			this.mouseChildren = false;
			super(parent, 0, 0);
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
		public function update():void
		{
			
		}
		
		/**
		 * Abstract function to position child items.
		 */
		public function positionChildren():void
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
			update();
			draw();
		}
	
	}

}