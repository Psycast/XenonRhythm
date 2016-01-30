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
		public var options:Array;
		public var overlayPosition:String = UIAnchor.TOP_CENTER;
		public var title:String = "";
		
		
		public function BoxCombo(core:EngineCore, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
		{
			this.core = core;
			this.handler = defaultHandler;
			super(parent, xpos, ypos, label);
		}
		
		override protected function addChildren():void 
		{
			mouseChildren = false;
			super.addChildren();
			_label.autoSize = TextFieldAutoSize.LEFT;
			addEventListener(MouseEvent.CLICK, e_clickDown);
		}
		
		private function e_clickDown(e:MouseEvent):void 
		{
			if (options != null && options.length > 0)
			{
				core.addOverlay(new BoxComboOverlay(title, options, e_overlayReturn, overlayPosition));
			}
		}
		
		private function e_overlayReturn(e:*):void 
		{
			label = e["text"];
			if (handler != null)
			{
				handler(e);
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			
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
		
	}

}