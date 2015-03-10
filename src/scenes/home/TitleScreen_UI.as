package scenes.home
{
	import assets.menu.FFRDudeCenter;
	import assets.menu.FFRName;
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Power2;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	public class TitleScreen_UI extends TitleScreen
	{
		
		public function TitleScreen_UI(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			var bg:sGameBackground = new sGameBackground(class_name);
			addChildAt(bg, 0);
			
			// FFR Dude
			var man:FFRDudeCenter = new FFRDudeCenter();
			man.x = (Constant.GAME_WIDTH / 2);
			man.y = (Constant.GAME_HEIGHT / 2);
			man.scaleX = man.scaleY = 3;
			man.alpha = 0;
			addChild(man);
			
			// FFR Name
			var name:FFRName = new FFRName();
			name.x = (Constant.GAME_WIDTH / 2) - 125;
			name.y = (Constant.GAME_HEIGHT / 2);
			name.alpha = 0;
			addChild(name);
			
			// Logo Animation
			var logoAnimation:TimelineLite = new TimelineLite({"onComplete": createMenu});
			logoAnimation.add([
					new TweenLite(man, 0.5, { "alpha": 0.85 } ), 
					new TweenLite(man, 1.5, { "scaleX": 1.5, "scaleY": 1.5, "ease": Elastic.easeOut.config(0.3) } )
				], 0);
			logoAnimation.to(man, 1, {"x": "-=125", "ease": Power2.easeInOut}, "-=0.7");
			logoAnimation.add([
					new TweenLite(name, 0.5, { "alpha": 0.85 } ), 
					new TweenLite(name, 1.2, { "x": "+=50", "ease": Power2.easeOut } )
				], "-=0.7");
			logoAnimation.to([man, name], 0.8, {"y": "-=150", "ease": Power2.easeInOut}, "-=0.25");
			logoAnimation.play();
			
			// Draw Reuseable items
			draw();
		}
		
		private function createMenu():void
		{
			log(1, "createMenu");
		}
		
		override public function draw():void
		{
		
		}
	
	}

}