package classes.ui
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class BoxInput extends Box
	{
		protected var _focus:Boolean = false;
		protected var _password:Boolean = false;
		protected var _text:String = "";
		protected var _tf:TextField;
		
		public function BoxInput(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", defaultHandler:Function = null)
		{
			_text = text;
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(100, 18, false);
			super.init();
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void
		{
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.defaultTextFormat = UIStyle.getTextFormat(true);
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			addChild(_tf);
			_tf.addEventListener(Event.CHANGE, onChange);
			_tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			
			_tf.displayAsPassword = _password;
			
			if (_text != null)
			{
				_tf.text = _text;
			}
			else
			{
				_tf.text = "";
			}
			_tf.width = _width - 4;
			if (_tf.text == "")
			{
				_tf.text = "X";
				_tf.height = Math.min(_tf.textHeight + 4, _height);
				_tf.text = "";
			}
			else
			{
				_tf.height = Math.min(_tf.textHeight + 4, _height);
			}
			_tf.x = 2;
			_tf.y = Math.round(_height / 2 - _tf.height / 2);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
			event.stopImmediatePropagation();
			dispatchEvent(event);
		}
		
		/**
		 * Internal focus handler.
		 * @param event The Event passed by the system.
		 */
		protected function onFocusIn(event:Event):void
		{
			_focus = true;
			_tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			draw();
		}
		
		/**
		 * Internal focus handler.
		 * @param event The Event passed by the system.
		 */
		protected function onFocusOut(event:Event):void
		{
			_focus = false;
			_tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			draw();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text shown in this InputText.
		 */
		public function set text(t:String):void
		{
			_text = t;
			if (_text == null)
				_text = "";
			draw();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		override public function get highlight():Boolean
		{
			return super.highlight || _focus;
		}
		
		override public function set highlight(value:Boolean):void
		{
			super.highlight = value;
			if (stage) {
				stage.focus = value ? _tf : null;
				
				if (value)
					_tf.setSelection(_tf.length, _tf.length);
			}
		}
		
		/**
		 * Gets / sets the list of characters that are allowed in this TextInput.
		 */
		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}
		
		public function get restrict():String
		{
			return _tf.restrict;
		}
		
		/**
		 * Gets / sets the maximum number of characters that can be shown in this InputText.
		 */
		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}
		
		public function get maxChars():int
		{
			return _tf.maxChars;
		}
		
		/**
		 * Gets / sets whether or not this input text will show up as password (asterisks).
		 */
		public function set password(b:Boolean):void
		{
			_password = b;
			draw();
		}
		
		public function get password():Boolean
		{
			return _password;
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			_tf.tabEnabled = value;
		}
	
	}

}