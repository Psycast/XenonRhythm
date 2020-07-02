package scenes.songselection.ui
{
	import classes.engine.EngineCore;
	import classes.ui.Label;
	import classes.ui.UIComponent;
	import classes.ui.UIStyle;
	import com.flashfla.utils.NumberUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class UserInfoBox extends UIComponent
	{
		private var core:EngineCore;

		private var usernameLabel:Label;
		private var avatar:Bitmap;
		private var numberLabels:TextField;
		private var numberValues:TextField;
		public function UserInfoBox(core:EngineCore, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			this.core = core;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(276, 126, false);
			super.init();
		}
		
		override protected function addChildren():void
		{
			usernameLabel = new Label(this, 13, 2, core.user.name);
			usernameLabel.fontSize = 14;

			// Number Labels
			numberLabels = createTextBox("Level:\nRank:\nPlays:\nCredits:\nTotal:", TextFieldAutoSize.LEFT);
			numberLabels.x = 13;
			numberLabels.y = 30;
			addChild(numberLabels);
			
			var values:String = "Lv. " + core.user.info.skill_level + "\n" +
					NumberUtil.numberFormat(core.user.info.game_rank) + "\n" +
					NumberUtil.numberFormat(core.user.info.games_played) + "\n" +
					NumberUtil.numberFormat(core.user.info.credits) + "\n" +
					NumberUtil.numberFormat(core.user.info.grand_total);
					
			// Number Values
			numberValues = createTextBox(values, TextFieldAutoSize.RIGHT);
			numberValues.x = width - numberValues.width - 10;
			numberValues.y = 30;
			addChild(numberValues);
			
			// Avatar
			if(core.user.avatar != null && core.user.avatar.width > 0 && core.user.avatar.height > 0)
			{
				var minScale:Number = Math.min(84 / core.user.avatar.width, 84 / core.user.avatar.height);
				avatar = new Bitmap();
				avatar.bitmapData = new BitmapData(core.user.avatar.width, core.user.avatar.height, true, 0);
				avatar.bitmapData.draw(core.user.avatar, null, null, null, null, true);
				avatar.scaleX = avatar.scaleY = minScale;
				avatar.x = 13;
                avatar.y = 35;
				addChildAt(avatar, 0);

				// Adjust Label Position
				numberLabels.x += avatar.width + 5;
			}
		}

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			drawBox();

			usernameLabel.setSize(width - 26, 25);
			numberValues.x = width - numberValues.width - 10;
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

			this.graphics.moveTo(14, 27);
			this.graphics.lineTo(width - 13, 27);
		}

		private function createTextBox(text:String, align:String):TextField
		{
			var _tf:TextField = new TextField();
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.width = 220;
			_tf.defaultTextFormat = getTextFormat(text, align);
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			//_tf.border = true;
			_tf.cacheAsBitmap = true;
			_tf.htmlText = text;
			return _tf;
		}

		private function getTextFormat(text:String, align:String):TextFormat
		{
			var base:TextFormat = UIStyle.getTextFormat(UIStyle.textIsUnicode(text));;
			var _tf:TextFormat = new TextFormat();
			_tf.font = base.font;
			_tf.size = 12;
			_tf.color = base.color;
			_tf.bold = base.bold;
			_tf.leading = 2;
			_tf.align = align;
			return _tf;
		}
	}
}