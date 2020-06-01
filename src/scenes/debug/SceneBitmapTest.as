package scenes.debug 
{
	import classes.engine.EngineCore;
	import classes.engine.track.TrackConfigManager;
	import classes.noteskin.NoteskinManager;
	import classes.ui.UICore;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import classes.engine.EngineSettings;
	
	public class SceneBitmapTest extends UICore 
	{
		public var renderMain:Sprite;
		public var displayBitmap:Bitmap;
		public var testBitmapData:BitmapData = new BitmapData(Constant.GAME_WIDTH, 155, true, 0);
		public var alphaAdjust:ColorTransform;
		public var alphaArea:Rectangle;

		public var noteskinCache:Vector.<BitmapData>;

		private var T_eclipsedMillis:Number = 0; // Milliseconds
		private var T_updateRateMillis:Number = 50; // Milliseconds

		private var drawIndex:int = 0;
		private var drawMatrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
		private var drawPoint:Point = new Point(0, 0);
		private var bitmapRect:Rectangle = new Rectangle(0, 0, 64, 64);

		private var notePosition:Point = new Point(32,32);

		private var isRunning:Boolean = true;

		public function SceneBitmapTest(core:EngineCore) 
		{
			super(core);
		}
		
		override public function onStage():void 
		{
			stage.color = 0x111111;

			// Create Render Target for Updates
			renderMain = new Sprite();
			renderMain.graphics.lineStyle(1, 0, 0);

			// Generate Cache for Noteskin 1, using Track Config "4key - up";
			noteskinCache = NoteskinManager.NOTESKINS[0].buildNoteCache(TrackConfigManager.TRACK_CONFIGS[0], new EngineSettings());

			// Setup Bitmap for Display, and ColorTransform for Fade
			displayBitmap = new Bitmap(testBitmapData);
			alphaAdjust = new ColorTransform(1, 1, 1, 0.95);
			alphaArea = new Rectangle(0, 0, testBitmapData.width, testBitmapData.height);

			// Put Bitmap on Stage
			displayBitmap.x = 0;
			displayBitmap.y = Constant.GAME_HEIGHT - testBitmapData.height;
			addChild(displayBitmap);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyDown);
		}

		public function e_keyDown(e:KeyboardEvent):void
		{
			isRunning = !isRunning;
		}
		
		override public function onTick(current:Number, milliseconds:Number):void
		{
			if(!isRunning)
				return;

			T_eclipsedMillis += milliseconds;

			while(T_eclipsedMillis > T_updateRateMillis)
			{
				drawNotesAlphaClear();
				T_eclipsedMillis -= T_updateRateMillis;
			}
		}

		private function drawAccuracyGraph1():void
		{
			// Clear old Render Data
			renderMain.graphics.clear();

			// Judge Accuracy Lines
			renderMain.graphics.beginFill(Math.random() * 0xFFFFFF, 1);
			renderMain.graphics.drawRect(Math.random() * testBitmapData.width, 80, 3, 75);
			renderMain.graphics.endFill();

			testBitmapData.colorTransform(alphaArea, alphaAdjust);
			testBitmapData.draw(renderMain);
		}

		private function drawNotesAlphaClear():void
		{
			// Clear old Render Data
			testBitmapData.colorTransform(alphaArea, alphaAdjust);
			renderMain.graphics.clear();

			// Test Noteskin Cache
			drawIndex++;
			drawIndex = drawIndex % noteskinCache.length;
			drawMatrix.tx = 5 + drawIndex * 34;

			trace(noteskinCache.length);

			var cN:BitmapData = noteskinCache[drawIndex];

			renderMain.graphics.beginBitmapFill(cN, drawMatrix);
			renderMain.graphics.drawRect(drawMatrix.tx, 0, cN.width, cN.height);
			renderMain.graphics.endFill();

			testBitmapData.draw(renderMain);
		}

		private function drawNotesBlackFill():void
		{
			// Clear old Render Data
			testBitmapData.fillRect(alphaArea, 0);
			renderMain.graphics.clear();

			// Test Noteskin Cache
			drawIndex++;
			drawIndex = drawIndex % noteskinCache.length;
			drawMatrix.tx = 5 + drawIndex * 34;

			var cN:BitmapData = noteskinCache[drawIndex];

			renderMain.graphics.beginBitmapFill(cN, drawMatrix);
			renderMain.graphics.drawRect(drawMatrix.tx, 0, cN.width, cN.height);
			renderMain.graphics.endFill();

			testBitmapData.draw(renderMain);
		}

		private function drawNotesCopyPixels():void
		{
			// Clear old Render Data
			testBitmapData.fillRect(alphaArea, 0);

			// Test Noteskin Cache
			drawIndex++;
			drawIndex = drawIndex % noteskinCache.length;
			drawPoint.x = notePosition.x;
			drawPoint.x = notePosition.y;

			var cN:BitmapData = noteskinCache[drawIndex];
			bitmapRect.width = cN.width;
			bitmapRect.height = cN.height;

			// Center Noteskin
			drawPoint.x -= (cN.width >> 1);
			drawPoint.y -= (cN.height >> 1);
			
			testBitmapData.copyPixels(cN, bitmapRect, drawPoint, null, null, true);
		}
	}
}