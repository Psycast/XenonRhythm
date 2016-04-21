package classes.ui
{
	import classes.engine.EngineCore;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class BoxCombo extends BoxButton
	{
		private var core:EngineCore;
		private var handler:Function;
		private var _selectedIndex:int = 0;
		public var _options:Array;
		public var overlayPosition:String = UIAnchor.TOP_CENTER;
		public var title:String = "";
		
		public function BoxCombo(core:EngineCore, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
		{
			this.core = core;
			this.handler = defaultHandler;
			super(parent, xpos, ypos, label);
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void
		{
			mouseChildren = false;
			super.addChildren();
			_label.autoSize = TextFieldAutoSize.LEFT;
			addEventListener(MouseEvent.CLICK, e_clickDown);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
		}
		
		override public function drawBox():void 
		{
			super.drawBox();
			
			graphics.moveTo(width - 21, 0);
			graphics.lineTo(width - 21, height);
			
			graphics.lineStyle(1, 0xFFFFFF, 0);
			graphics.beginFill(0xFFFFFF, 0.55);
			graphics.moveTo(width - 16, (height / 2) - 3);
			graphics.lineTo(width - 4, (height / 2) - 3);
			graphics.lineTo(width - 10, (height / 2) + 5);
			graphics.moveTo(width - 16, (height / 2) - 3);
			graphics.endFill();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_clickDown(e:MouseEvent):void
		{
			if (options != null && options.length > 0)
			{
				core.addOverlay(new BoxComboOverlay(title, options, e_overlayReturn, overlayPosition));
			}
		}
		
		private function e_overlayReturn(e:Object):void
		{
			selectedIndex = e["value"];
			if (handler != null)
			{
				handler(e);
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(i:*):void
		{
			if (!options || options.length == 0)
				return;
			
			if (i is Number)
			{
				if (i > options.length)
					return;
				
				label = options[i]["label"];
				_selectedIndex = i;
				return;
			}
			else
			{
				for (var j:int = 0; j < options.length; j++)
				{
					if (options[j]["value"] == i)
					{
						
						label = options[j]["label"];
						_selectedIndex = j;
						break;
					}
				}
				return;
			}
			label = options[0]["label"];
			_selectedIndex = 0;
		}
		
		public function get options():Array
		{
			return _options;
		}
		
		public function set options(newOptions:Array):void
		{
			_options = [];
			for (var i:int = 0; i < newOptions.length; i++)
			{
				var lbl:String = "";
				var dat:*;
				var option:* = newOptions[i];
				
				if (option is Array && newOptions[i].length == 2)
				{
					lbl = option[0];
					dat = option[1];
				}
				else if (option is String)
				{
					lbl = option;
					dat = option;
				}
				else if (option is Object && option["label"] != null && option["value"] != null)
				{
					lbl = option["label"];
					dat = option["value"];
				}
				_options.push({"label": lbl, "value": dat});
			}
		}
	
	}

}