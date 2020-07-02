package scenes.songselection.ui
{
	import classes.ui.UIComponent;
	import classes.engine.EngineCore;
	import flash.display.DisplayObjectContainer;
	import classes.engine.EngineLevel;
	import classes.ui.Label;
	import flash.text.TextFieldAutoSize;
	import flash.filters.GlowFilter;
	import flash.display.Shape;
	import com.flashfla.utils.NumberUtil;
	import classes.engine.EngineRanksLevel;
	import com.flashfla.utils.StringUtil;

	public class SongDetailsBox extends UIComponent
	{
		private static const statVars:Array = ["perfect", "good", "average", "miss", "boo"];

		private var core:EngineCore;
		private var songData:EngineLevel;

		private var _flagIconIndex:int;

		private var difficulty:Label;
		private var name:Label;
		private var artist:Label;

		private var pa_labels:Vector.<Label> = new <Label>[];
		private var pa_values:Vector.<Label> = new <Label>[];
		private var score_value:Label;
		private var score_label:Label;
		private var combo_value:Label;
		private var combo_label:Label;
		private var rank_value:Label;
		private var rank_label:Label;

		
		public function SongDetailsBox(core:EngineCore, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			this.core = core;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(365, 126, false);
			super.init();
		}
		
		override protected function addChildren():void
		{
			var offset_y:Number = 5;
			
			difficulty = new Label(this, 10, -5);
			difficulty.fontSize = 35;
			difficulty.autoSize = TextFieldAutoSize.RIGHT;
			difficulty.alpha = 0.05;
			difficulty.mouseEnabled = false;

			name = new Label(this, 10, offset_y);
			name.fontSize = 21;
			name.autoSize = TextFieldAutoSize.CENTER;
			(offset_y += 32);

			artist = new Label(this, 10, offset_y);
			artist.fontSize = 17;
			artist.autoSize = TextFieldAutoSize.CENTER;
			(offset_y += 40);


			// Song Stats
			score_value = new Label(this, 0 , offset_y, "999,999");
			score_value.autoSize = TextFieldAutoSize.RIGHT;
			score_value.fontSize = 34;
			score_label = new Label(this, 0 , offset_y + 42, "SCORE");
			score_label.alpha = 0.3;

			combo_value = new Label(this, 0 , offset_y, "99,999");
			combo_value.autoSize = TextFieldAutoSize.RIGHT;
			combo_value.fontSize = 16;
			combo_label = new Label(this, 0 , offset_y + 9, "COMBO");
			combo_label.alpha = 0.3;

			rank_value = new Label(this, 0 , offset_y + 30, "999,999");
			rank_value.autoSize = TextFieldAutoSize.RIGHT;
			rank_value.fontSize = 16;
			rank_label = new Label(this, 0 , offset_y + 39, "RANK");
			rank_label.alpha = 0.3;
			offset_y += 60;
			
			var statLabel:Label;
			for each (var stat:String in statVars)
			{
				statLabel = new Label(this, 0 , offset_y, "---");
				statLabel.autoSize = TextFieldAutoSize.CENTER;
				pa_values.push(statLabel);

				statLabel = new Label(this, 0 , offset_y + 9, stat.charAt(0).toLocaleUpperCase());
				statLabel.alpha = 0.3;
				pa_labels.push(statLabel);
			}
			offset_y += 30;
			//, "combo", "score"
		}

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			drawBox();

			this.graphics.lineStyle(0, 0, 0);

			var labelWidth:Number;
			var i:int;

			// Draw NPS Graph
			if (songData && !songData.is_title_only && songData.details)
			{
				var graph:Array = songData.details.nps_data_normalized;
				var graphLength:int = graph.length;
				var gapX:Number = (height - 10) / graphLength;
				var ratioY:Number = Math.max(20, songData.details.nps_data_normalized_max); // Use 20nps as base upper limit.

				this.graphics.beginFill(0xffffff, 0.05);
				this.graphics.moveTo(width, 0);
				for(i = 0; i < graphLength; i++)
				{
					this.graphics.lineTo(width - Math.min(25, width) * (graph[i] / ratioY), 5 + i * gapX);
				}
				this.graphics.lineTo(width, height);
				this.graphics.moveTo(width, 0);
				this.graphics.endFill();
			}

			// Draw Song Flag Triangle
			if(_flagIconIndex > 1)
			{
				this.graphics.beginFill(Constant.SONG_ICON_COLOR[_flagIconIndex], 0.75);
				this.graphics.moveTo(1, 1);
				this.graphics.lineTo(16, 1);
				this.graphics.lineTo(1, 16);
				this.graphics.lineTo(1, 1);
				this.graphics.endFill()
			}

			// Adjust Label Widths
			name.setSize(width - 20, 30);
			artist.setSize(width - 20, 30);
			difficulty.setSize(width - 20, 60);

			// Adjust Score, Combo, Rank
			i = 0;
			labelWidth = width * 0.60;
			score_value.setSize(labelWidth - 5, 60);
			combo_value.setSize(width - labelWidth - 5, 30);
			combo_label.setSize(width - labelWidth, 30);
			rank_value.setSize(width - labelWidth - 5, 30);
			rank_label.setSize(width - labelWidth, 30);
			combo_value.x = rank_value.x = labelWidth;
			combo_label.x = rank_label.x = labelWidth;
			for each(var label:Label in [score_value, combo_value, rank_value])
			{
				this.graphics.beginFill(0xFFFFFF, (0.13 / ++i));
				this.graphics.drawRect(label.x, label.y, label.width + 5, label.height);
				this.graphics.endFill();
			}

			// Adjust PA Values
			if(pa_values.length > 0)
			{
				labelWidth = width / pa_values.length;
				var paLabel:Label;
				for(i = 0; i < pa_values.length; i++)
				{
					paLabel = pa_values[i];
					paLabel.x = i * labelWidth;
					paLabel.setSize(labelWidth, 30);

					this.graphics.beginFill(0xFFFFFF, (i + 1 & 1) ? 0.10 : 0.05);
					this.graphics.drawRect(paLabel.x, paLabel.y, labelWidth, paLabel.height);
					this.graphics.endFill();

					paLabel = pa_labels[i];
					paLabel.x = i * labelWidth;
					paLabel.setSize(labelWidth, 30);
				}
			}
		}
		
		/**
		 * Draws the background rectangle.
		 */
		public function drawBox():void 
		{
			//- Draw Box
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF, 0.4);
			this.graphics.beginFill(0xFFFFFF, 0.1);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}

		public function setDetails(level:EngineLevel):void
		{
			songData = level;

			_flagIconIndex = Constant.getSongIcon(core, songData)

			name.htmlText = level.name;
			artist.htmlText = level.author_with_url;
			difficulty.text = level.difficulty.toString();

			var index:int = 0;
			var levelRanks:EngineRanksLevel = core.user.levelranks.getEngineRanks(songData.source).getRank(songData.id);
			if (levelRanks != null && levelRanks.score > 0)
			{
				for each (var stat:String in statVars)
				{
					pa_values[index].text = NumberUtil.numberFormat(levelRanks[stat]);
					if (stat == "amazing" && levelRanks["amazing"] == 0)
						pa_values[index].text = "---";
					index++;
				}
				score_value.text = NumberUtil.numberFormat(levelRanks.raw_score);
				combo_value.text = NumberUtil.numberFormat(levelRanks.combo);
				rank_value.text = NumberUtil.numberFormat(levelRanks.rank);
			}
			else
			{
				for each(var paLabel:Label in pa_values)
				{
					paLabel.text = "---";
				}
				score_value.text = "---";
				combo_value.text = "---";
				rank_value.text = "---";
			}

			draw();
		}
	}
}