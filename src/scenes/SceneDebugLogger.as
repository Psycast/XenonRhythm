package scenes
{
	import classes.engine.EngineCore;
	import classes.ui.UICore;
	import classes.ui.UIStyle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.GridFitType;
	
	public class SceneDebugLogger extends UICore
	{
		private var _tf:TextField;
		private var _colours:Array = ["#DDDDDD", "#FFFFFF", "#FFCE7F", "#FF5E5B", "#B9FFAD"];
		
		//------------------------------------------------------------------------------------------------//
		
		public function SceneDebugLogger(core:EngineCore)
		{
			super(core);
			init();
		}
		
		override public function init():void
		{
			_tf = new TextField();
			_tf.x = 5;
			_tf.y = 5;
			_tf.width = Constant.GAME_WIDTH - 10;
			_tf.height = Constant.GAME_HEIGHT - 10;
			_tf.embedFonts = true;
			_tf.multiline = true;
			_tf.defaultTextFormat = UIStyle.TEXT_FORMAT_CONSOLE;
			_tf.autoSize = TextFieldAutoSize.NONE;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.gridFitType = GridFitType.SUBPIXEL;
			addChild(_tf);
			
			this.graphics.beginFill(0, 0.5);
			this.graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			this.graphics.endFill();
			
			Logger.debugUpdateCallback.add(draw);
		}
		
		override public function onStage():void
		{
			_tf.width = stage.stageWidth - 10;
			_tf.height = stage.stageHeight - 10;
			draw();
		}
		
		override public function draw():void
		{
			_tf.htmlText = _buildHistory();
			_tf.scrollV = _tf.maxScrollV;
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		private function _buildHistory():String
		{
			var a:Array = Logger.history;
			var b:Array;
			var s:String = "";
			for (var i:int = 0; i < a.length; i++)
			{
				b = a[i];
				s += "<font color=\"" + _colours[b[2]] + "\">" + (!b[4] ? "[" + b[0] + "][" + b[1] + "] " : "") + b[3] + "</font><br>";
			}
			return s;
		}
	}

}