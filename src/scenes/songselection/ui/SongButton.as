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
	import classes.ui.UIIcon;
	import assets.menu.icons.fa.iconMusic;
	
	public class SongButton extends UIComponent
	{
		public static const FIXED_HEIGHT:int = 31;

		/** Index in Vector */
		public var index:int = 0;

		/** Marks the Button as in-use to avoid removal in song selector. */
		public var garbageSweep:Boolean = false;
		
		private var core:EngineCore;
		public var songData:EngineLevel;

		private var _flagIconIndex:int = 1;
		private var _flagIconColor:int = 0xFFFFFF;
		private var _lblSongName:Label;
		private var _lblSongFlag:Label;
		private var _lblSongDifficulty:Label;
		private var _btnMusicPreview:UIIcon;
		
		private var _title_only:Boolean = true;
		
		public function SongButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(250, FIXED_HEIGHT, false);
			addChildren();
			drawBox();

			this.group = UISongSelector.LIST_SONG;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_lblSongName = new Label(this, 5, 2, "--", true);

			_lblSongFlag = new Label(this, 1, 2, "--", true);
			_lblSongFlag.autoSize = TextFieldAutoSize.RIGHT;
			_lblSongFlag.setSize(90, 28);

			_lblSongDifficulty = new Label(this, 1, 2, "--");
			_lblSongDifficulty.autoSize = TextFieldAutoSize.CENTER;
			_lblSongDifficulty.setSize(30, 28);

			_btnMusicPreview = new UIIcon(this, new iconMusic(), 5, 16);
			_btnMusicPreview.setSize(20, 16);
			_btnMusicPreview.alpha = 0.8;
			_btnMusicPreview.mouseEnabled = true;
			_btnMusicPreview.tag = "song_preview";
			
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
				_lblSongName.x = 5;
				_lblSongName.setSize(width - 10, 28);
			}
			else
			{
				_btnMusicPreview.x = width - 16;
				_lblSongFlag.visible = core.user.settings.display_song_flags && _lblSongFlag.text != "";
				_lblSongFlag.x = width - 127; // 90px Width + 32px Song Preview +  7px Padding
				_lblSongName.x = 40;
				_lblSongName.setSize(width - 84 - (_lblSongFlag.visible ? _lblSongFlag.textField.textWidth + 5 : 0), 28);
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
				_flagIconIndex = Constant.getSongIcon(core, songData);
				_flagIconColor = Constant.SONG_ICON_COLOR[_flagIconIndex];
				_lblSongName.htmlText = songData.name;
				_lblSongName.autoSize = TextFieldAutoSize.LEFT;
				_lblSongFlag.htmlText = Constant.SONG_ICON_TEXT[_flagIconIndex];
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

			if (songData && !songData.is_title_only)
			{
				// Difficulty Divider
				this.graphics.moveTo(32, 0);
				this.graphics.lineTo(32, height);

				// Preview Divider
				this.graphics.lineStyle(3, _flagIconColor, (highlight ? 0.8 : 0.55));
				this.graphics.moveTo(width - 32, 0);
				this.graphics.lineTo(width - 32, height);

				// Draw NPS Graph
				if(songData.details)
				{
					this.graphics.lineStyle(0, 0, 0);
					var graph:Array = songData.details.nps_data_normalized;
					var graphLength:int = graph.length;
					var gapX:Number = (width - 10) / graphLength;
					var ratioY:Number = Math.max(20, songData.details.nps_data_normalized_max); // Use 20nps as base upper limit.

					this.graphics.beginFill(0xffffff, 0.13);
					this.graphics.moveTo(0, height);
					for(var i:int = 0; i < graphLength; i++)
					{
						this.graphics.lineTo(5 + i * gapX, height - height * (graph[i] / ratioY));
					}
					this.graphics.lineTo(width, height);
					this.graphics.lineTo(0, height);
					this.graphics.endFill();
				}
			}
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