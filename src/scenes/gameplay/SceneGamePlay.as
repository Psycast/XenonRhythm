package scenes.gameplay
{
	import classes.Song;
	import classes.engine.EngineCore;
	import classes.engine.EngineSettings;
	import classes.engine.input.InputConfigGroup;
	import classes.engine.input.InputConfigManager;
	import classes.engine.track.TrackConfigGroup;
	import classes.engine.track.TrackConfigManager;
	import classes.noteskin.NoteskinEntry;
	import classes.noteskin.NoteskinManager;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import com.zehfernando.signals.SimpleSignal;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import scenes.gameplay.render.GameRenderNote;
	import scenes.gameplay.ui.components.UIAccuracyGraph;
	import scenes.gameplay.ui.components.UIComboValue;
	import scenes.gameplay.ui.components.UIPAWindow;
	import scenes.gameplay.ui.components.UIPlayComponent;
	import scenes.gameplay.ui.components.UIStaticText;
	import scenes.gameplay.ui.components.UINotebox;
	
	public class SceneGamePlay extends UICore
	{
		private static var gameNotePool:Vector.<GameRenderNote> = new Vector.<GameRenderNote>();

		private var song:Song;
		private var settings:EngineSettings;

		// Input Managers
		private var keys_global:InputConfigGroup;
		private var keys_tracks:InputConfigGroup;
		private var keys_last_action:String

		// Track Config
		private var noteskin_config:NoteskinEntry;
		private var track_config:TrackConfigGroup;
		
		// UI Components
		private var ui_notebox:UINotebox;
		private var editor_drag_target:UIPlayComponent;
		private var ui_components:Vector.<UIPlayComponent>;
		private var ui_onTick:Vector.<UIPlayComponent>;
		
		// Blitting
		private var stageBMD:BitmapData;
		private var stageBM:Bitmap;

		// Signals
		private var s_onScoreUpdate:SimpleSignal;

		// Gameplay Variables
		private var score:ScoreValues;

		public function SceneGamePlay(core:EngineCore)
		{
			super(core);
		}
	
		override public function init():void 
		{
			settings = core.user.settings;
			
			if (core.variables.song_queue.length > 0) 
			{
				song = core.song_loader.getSong(core.variables.song_queue[0]);
				
				// Set Song Variables
				song.playback_speed = settings.playback_speed;
			}

			// Track Configuration
			track_config = TrackConfigManager.getConfig("6key", settings.scroll_direction);
			noteskin_config = NoteskinManager.getNoteskin("ffr2");

			// Signals
			s_onScoreUpdate = new SimpleSignal();
			
			// Game Variables
			keys_global = settings.menu_keys;
			keys_tracks = InputConfigManager.getConfig(song.chart.laneType);
			
			score = new ScoreValues();
			
			super.init();
		}
		
		override public function onStage():void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_onKeyDown);
			
			//song.start();
			
			createUI();
			
			position();
			draw();
		}
		
		private function e_onKeyDown(e:KeyboardEvent):void 
		{
			_debugKeyboardEvent(e);

			keys_last_action = keys_global.isAction(e.keyCode);
			if(keys_last_action != null)
				trace(e.keyCode, keys_last_action);

			keys_last_action = keys_tracks.isAction(e.keyCode);
			if(keys_last_action != null)
				trace(e.keyCode, keys_last_action);
		}
		
		private function e_mouseDown(e:MouseEvent):void 
		{
			
			stage.addEventListener(MouseEvent.MOUSE_UP, e_mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			
			(editor_drag_target = (e.target as UIPlayComponent)).startDrag(false, new Rectangle(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT));
		}
		
		private function e_mouseMove(e:MouseEvent):void 
		{
			if (editor_drag_target)
			{
				
			}
		}
		
		private function e_mouseUp(e:MouseEvent):void 
		{
			if (editor_drag_target)
			{
				editor_drag_target.removeEventListener(MouseEvent.MOUSE_UP, e_mouseUp);
				editor_drag_target.stopDrag();
				editor_drag_target = null;
			}
		}
		
		private function createUI():void 
		{
			// Create Blitting Stage
			stageBMD = new BitmapData(Constant.GAME_WIDTH, Constant.GAME_HEIGHT, false, 0x111111);
			stageBM = new Bitmap(stageBMD);
			addChild(stageBM);

			// Create UI Components
			ui_components = new Vector.<UIPlayComponent>();
			ui_onTick = new Vector.<UIPlayComponent>();
			
			// Notebox
			ui_notebox = new UINotebox(settings);
			ui_notebox.buildFromConfig(UI_NOTEBOX);
			ui_notebox.anchor = ui_notebox.alignment = UIAnchor.MIDDLE_CENTER;
			ui_notebox.setConfigs(track_config, noteskin_config);
			ui_notebox.setNoteSource(song.chart.Notes);

			this.addChild(ui_notebox);
			ui_components.push(ui_notebox);

			// Optional
			var uicomp:UIPlayComponent;

			//for each (var anc:int in UIAnchor.ALIGNMENTS_A) 
			//{
				for each(var elm:Object in UI_OPTIONAL)
				{
					uicomp = createUIComponent(elm);
					if(uicomp && uicomp.buildFromConfig(elm))
					{
						Logger.log(this, Logger.DEBUG, "Built Component: " + uicomp.type);
						//uicomp.anchor = anc; // Testing
						//uicomp.alignment = anc; // Testing

						uicomp.editorMode = !uicomp.editorMode;
						uicomp.addEventListener(MouseEvent.MOUSE_DOWN, e_mouseDown);

						this.addChild(uicomp);
						ui_components.push(uicomp);

						// Setup Update Modes
						if((uicomp.UPDATE_MODE & UIPlayComponent.ONTICK) != 0)
							ui_onTick.push(uicomp);

						if((uicomp.UPDATE_MODE & UIPlayComponent.ONSCORE) != 0)
							s_onScoreUpdate.add(uicomp.onScoreSignal);
					}
				}
			//}
		}

		private function createUIComponent(configGroup:Object):UIPlayComponent
		{
			var uicomp:UIPlayComponent = null;

			switch(configGroup["type"])
			{
				case "static_text":
					uicomp = new UIStaticText();
					break;

				case "combo":
					uicomp = new UIComboValue(core, score);
					break;

				case "pawindow":
					uicomp = new UIPAWindow(core, score, settings);
					break;

				case "accuracygraph":
					uicomp = new UIAccuracyGraph(core);
					break;
			}

			if(uicomp == null)
				Logger.log(this, Logger.ERROR, "Unknown UI Component: " + configGroup["type"]);

			return uicomp;
		}

		override public function onTick(currentMS:Number, eclipsedMS:Number):void
		{
			ui_notebox.drawToBitmap(currentMS, eclipsedMS, stageBMD);

			for each (var item:UIPlayComponent in ui_onTick) 
			{
				item.update(currentMS, eclipsedMS);
			}
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _debugKeyboardEvent(e:KeyboardEvent):void
		{
			score.amazing = int(Math.random() * 25000);
			score.perfect = int(score.amazing / 2);
			score.good = int(score.perfect / 2);
			score.average = int(score.good / 2);
			score.miss = int(score.average / 2);
			score.boo = int(score.miss / 2);
			score.combo = int(Math.random() * 25000);
			s_onScoreUpdate.dispatch(100, Math.floor(Math.random() * 234) - 117);

			if (e.keyCode == Keyboard.BACKSPACE)
			{
				for each (var item:UIPlayComponent in ui_components) 
				{
					item.editorMode = !item.editorMode;
					if (item.editorMode)
					{
						item.addEventListener(MouseEvent.MOUSE_DOWN, e_mouseDown);
					}
					else
					{
						item.removeEventListener(MouseEvent.MOUSE_DOWN, e_mouseDown);
					}
				}
			}
			if (e.keyCode == Keyboard.SPACE)
			{
				if (song.musicIsPlaying)
				{
					song.stop();
					ui_notebox.isRunning = false;
				}
				else
				{
					song.start();
					ui_notebox.isRunning = true;
				}
			}
			else if (e.keyCode == Keyboard.UP)
			{
				song.playback_speed += 0.1;
			}
			
			else if (e.keyCode == Keyboard.DOWN)
			{
				song.playback_speed -= 0.1;
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private var UI_NOTEBOX:Object = {
				"type": "notebox",
				"enabled": true,
				"anchor": 0,
				"anchor_lock": true,
				"alignment": 0,
				"x": 0,
				"y": 0
			};

		private var UI_OPTIONAL:Object = [
			{
				"type": "pawindow",
				"enabled": true,
				"anchor": UIAnchor.MIDDLE_LEFT,
				"anchor_lock": false,
				"alignment": UIAnchor.MIDDLE_LEFT,
				"x": 0,
				"y": 0,
				"parts": {
					"labels": {
						"display": true
					},
					"numbers": {
						"amazing": {
							"display": true,
							"color": "099fff"
						},
						"perfect": {
							"display": true,
							"color": "ffffff"
						},
						"good": {
							"display": true,
							"color": "01aa0f"
						},
						"average": {
							"display": true,
							"color": "f99800"
						},
						"miss": {
							"display": true,
							"color": "fe0000"
						},
						"boo": {
							"display": true,
							"color": "804100"
						}
					}
				}
			},
			{
				"type": "accuracygraph",
				"enabled": true,
				"anchor": UIAnchor.MIDDLE_CENTER,
				"anchor_lock": false,
				"alignment": UIAnchor.MIDDLE_CENTER,
				"x": 0,
				"y": 40,
				"parts": {
					"size": {
						"width": 120,
						"height": 32
					},
					"colors": {
						"amazing": "099fff",
						"perfect": "ffffff",
						"good": "01aa0f",
						"average": "f99800"
					}
				}
			},
			{
				"type": "combo",
				"enabled": true,
				"anchor": UIAnchor.BOTTOM_CENTER,
				"anchor_lock": false,
				"alignment": UIAnchor.BOTTOM_RIGHT,
				"x": -90,
				"y": -30,
				"parts": {
					"colors": {
						"normal": "0099cc",
						"fc": "00ad00",
						"aaa": "fcc200"
					}
				}
			},
			{
				"type": "static_text",
				"enabled": true,
				"anchor": UIAnchor.BOTTOM_CENTER,
				"anchor_lock": false,
				"alignment": UIAnchor.BOTTOM_LEFT,
				"x": -90,
				"y": -30,
				"parts": {
					"text": "combo",
					"color": "0098cb"
				}
			},
			{
				"type": "total",
				"enabled": true,
				"anchor": UIAnchor.BOTTOM_CENTER,
				"anchor_lock": false,
				"alignment": UIAnchor.BOTTOM_LEFT,
				"x": 90,
				"y": -30,
				"parts": {
					"color": "0098cb"
				}
			},
			{
				"type": "static_text",
				"enabled": true,
				"anchor": UIAnchor.BOTTOM_CENTER,
				"anchor_lock": false,
				"alignment": UIAnchor.BOTTOM_RIGHT,
				"x": 90,
				"y": -30,
				"parts": {
					"text": "total",
					"color": "0098cb"
				}
			}
		];
	}
}