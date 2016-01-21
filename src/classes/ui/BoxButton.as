package classes.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class BoxButton extends Box
	{
		protected var _label:Label;
		protected var _label_text:String = "";
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		
		public function BoxButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
		{
			this._label_text = label;
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			setSize(100, 20);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_label = new Label(this, 0, 0, _label_text, true);
			_label.autoSize = TextFieldAutoSize.CENTER;
			addChild(_label);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_label.setSize(width, height + 1);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			invalidate();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			invalidate();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function get label():String
		{
			return _label_text;
		}
		
		public function set label(val:String):void
		{
			_label.text = _label_text = val;
		}
		
		override public function get highlight():Boolean
		{
			return enabled && (super.highlight || _over);
		}
		
		public function set fontSize(size:int):void
		{
			_label.fontSize = size;
		}
	
	}

}