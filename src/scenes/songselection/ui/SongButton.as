package scenes.songselection.ui
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineRanksLevel;
	import classes.ui.Label;
	import classes.ui.UIComponent;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	public class SongButton extends UIComponent
	{
		private static const detailsShown:Array = [["Author", "author", 0.25], ["Stepauthor", "stepauthor", 0.24], ["Style", "style", 0.22], ["Length", "time", 0.1], ["Best Score", "rank", 0.19, TextFieldAutoSize.RIGHT]];
		private var core:EngineCore;
		public var songData:EngineLevel;
		
		private var _lblSongName:Label;
		private var _lblSongFlag:Label;
		private var _lblSongDifficulty:Label;
		private var _lblSongDetails:Array;
		
		private var _title_only:Boolean = true;
		
		public function SongButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, core:EngineCore = null, songData:EngineLevel = null)
		{
			this.core = core;
			this.songData = songData;
			super(parent, xpos, ypos);
			mouseEnabled = buttonMode = !songData.is_title_only;
			mouseChildren = false;
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			_title_only = (songData.is_title_only || songData.difficulty == 0);
			setSize(250, 31, false);
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if (_title_only)
			{
				_lblSongName = new Label(this, 5, 2, '<font color="' + UIStyle.ACTIVE_FONT_COLOR + '">' + songData.name + '</font>', true);
				_lblSongName.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				_lblSongName = new Label(this, 5, 2, songData.name);
				_lblSongFlag = new Label(this, 5, 2, Constant.getSongIcon(core, songData), true);
				_lblSongFlag.autoSize = TextFieldAutoSize.RIGHT;
				_lblSongDifficulty = new Label(this, 5, 2, songData.difficulty.toString());
				_lblSongDifficulty.autoSize = TextFieldAutoSize.RIGHT;
			}
			
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
			if (songData.is_title_only || songData.difficulty == 0)
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
				
				if (_lblSongDetails && highlight)
				{
					positionDetails(true);
				}
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
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
		
		/**
		 * Create expanded song details.
		 */
		private function createDetails():void
		{
			if (!_lblSongDetails && !_title_only)
			{
				_lblSongDetails = [];
				for (var i:int = 0; i < detailsShown.length; i++)
				{
					// Get Value
					var value:String = "---";
					if (detailsShown[i][1] == "rank")
					{
						var rank:EngineRanksLevel = Constant.getSongRank(core, songData);
						if (rank && rank.score > 0)
							value = rank.results;
					}
					else
						value = songData[detailsShown[i][1]];
						
					_lblSongDetails.push([
						new Label(this, 5, 2, "<font color=\"#d3d3d3\">" + detailsShown[i][0] + ":</font>", true),
						new Label(this, 5, 2, value)
					]);
					_lblSongDetails[_lblSongDetails.length - 1][0].fontSize = UIStyle.FONT_SIZE - 1;
					_lblSongDetails[_lblSongDetails.length - 1][1].fontSize = UIStyle.FONT_SIZE - 2;
				}
			}
		}
		
		/**
		 * Positions, adjust, and sets visibility of expanded song details.
		 * @param	visible Sets the mode to use for positioning.
		 */
		private function positionDetails(visible:Boolean):void
		{
			if (_lblSongDetails)
			{
				var maxWidth:Number = (Math.min(width, 1000) - ((_lblSongDetails.length + 1) * 5));
				var nextX:Number = 5;
				for (var i:int = 0; i < _lblSongDetails.length; i++)
				{
					var lbl:Array = _lblSongDetails[i];
					var xWidth:Number = maxWidth * detailsShown[i][2];
					if (visible)
					{
						lbl[0].move(nextX, 28); // Text
						lbl[0].setSize(xWidth, 20);
						lbl[1].move(nextX, 48); // Value
						lbl[1].setSize(xWidth, 20);
						
						if (detailsShown[i][3])
						{
							lbl[0].autoSize = detailsShown[i][3];
							lbl[1].autoSize = detailsShown[i][3];
						}
					}
					else
					{
						lbl[0].y = 2; // Text
						lbl[1].y = 2; // Value
					}
					lbl[0].visible = visible;
					lbl[1].visible = visible;
					nextX += xWidth + 5;
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
			
			// Only create song details when required.
			if (val && !_lblSongDetails)
				createDetails();
			
			//
			if (!_title_only && _lblSongDetails)
			{
				_height = val ? 71 : 31;
				positionDetails(val);
			}
			drawBox();
		}
	}
}