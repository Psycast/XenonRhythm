package scenes.songselection.ui
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.ui.Label;
	import classes.ui.UIComponent;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class SongButton extends UIComponent
	{
		public static const FIXED_HEIGHT:int = 31;

		private var core:EngineCore;
		public var songData:EngineLevel;

		public var index:int = 0;

		/** Marks the Button as in-use to avoid removeal in song selector. */
		public var garbageSweep:Boolean = false;
		
		private var _lblSongName:Label;
		private var _lblSongFlag:Label;
		private var _lblSongDifficulty:Label;
		
		private var _title_only:Boolean = true;
		
		public function SongButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			mouseChildren = false;
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(250, FIXED_HEIGHT, false);
			addChildren();
			drawBox();

			this.group = "song-list";
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_lblSongName = new Label(this, 5, 2, "--", true);

			_lblSongFlag = new Label(this, 5, 2, "--", true);
			_lblSongFlag.autoSize = TextFieldAutoSize.RIGHT;

			_lblSongDifficulty = new Label(this, 5, 2, "--");
			_lblSongDifficulty.autoSize = TextFieldAutoSize.RIGHT;
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			drawBox();

			// Song Divider
			if (songData.is_title_only)
			{
				_lblSongName.setSize(width - 10, 28);
			}
			else
			{
				_lblSongDifficulty.x = width - 25;
				_lblSongDifficulty.setSize(23, 28);
				_lblSongFlag.visible = core.user.settings.display_song_flags;
				_lblSongFlag.x = _lblSongDifficulty.x - 95;
				_lblSongFlag.setSize(90, 28);
				_lblSongName.setSize(_lblSongFlag.x - 10, 28);
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////

		public function setData(core:EngineCore, songData:EngineLevel):void
		{
			this.core = core;
			this.songData = songData;

			_title_only = (songData.is_title_only);
			mouseEnabled = buttonMode = !_title_only;
			
			if (_title_only)
			{
				_lblSongName.htmlText = '<font color="' + UIStyle.ACTIVE_FONT_COLOR + '">' + songData.name + '</font>';
				_lblSongName.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				_lblSongName.htmlText = songData.name;
				_lblSongName.autoSize = TextFieldAutoSize.LEFT;
				_lblSongFlag.htmlText = Constant.getSongIcon(core, songData);
				_lblSongDifficulty.text = songData.difficulty.toString();
			}
			draw();
		}
		
		/**
		 * Draws the background rectangle.
		 */
		public function drawBox():void
		{
			//- Draw Box
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF, (highlight ? 0.8 : 0.55));
			this.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], (highlight ? [0.5, 0.25] : [0.35, 0.1]), [0, 255], UIStyle.GRADIENT_MATRIX);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
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
			drawBox();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			drawBox();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		override public function set highlight(val:Boolean):void
		{
			super.highlight = val;
			drawBox();
		}
	}
}