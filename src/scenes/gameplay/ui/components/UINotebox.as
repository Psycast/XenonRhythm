package scenes.gameplay.ui.components
{
	import classes.engine.EngineSettings;
	import classes.engine.track.TrackConfigGroup;
	import classes.noteskin.NoteskinEntry;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import classes.engine.track.TrackLocationResolve;
	import classes.engine.track.TrackConfigLane;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import scenes.gameplay.render.GameRenderNote;
	import classes.chart.Note;
	import flash.utils.getTimer;

	public class UINotebox extends UIPlayComponent
	{
		private var settings:EngineSettings;
		private var track_config:TrackConfigGroup;
		private var noteskin_config:NoteskinEntry;

		private var source_receptor_points:Vector.<Point>;
		private var receptor_points:Vector.<Point>;
		private var receptor_images:Vector.<BitmapData>;
		private var note_images:Vector.<BitmapData>;
		private var note_render_data:Vector.<GameRenderNote>;

		private var note_data:Vector.<Note>;
		private var note_count:int;

		// Drawing Variables, avoid garable collection.
		private var _stage_rectangle:Rectangle = new Rectangle(0, 0, 100, 100);
		private var draw_index:int;
		private var _draw_note_point:Point = new Point();
		private var _draw_recp_point:Point;
		private var _draw_p_adjusted:Point = new Point();
		private var _draw_bitmap:BitmapData;
		private var _bitmap_rectangle:Rectangle = new Rectangle(0, 0, 100, 100);

		// Editor
		private var drag_point:Point = new Point();
		private var last_position:Point = new Point(-1000, -1000);

		public var isRunning:Boolean = false;
		public var currentSongMS:Number = 0;
		public var currentTime:Number = 0;
		public var READAHEAD:Number = 3;

		
		public function UINotebox(settings:EngineSettings):void
		{
			this._anchorLock = true;
			this.settings = settings;
		}

		/**
		 * Get Type of the UIPlayComponent.
		 * @return Type
		 */
		override public function get type():String
		{
			return "notebox";
		}
		
		override public function draw():void
		{
			graphics.clear();
			
			// Create Clickable surface for Editor Mode
			if (editorMode)
			{
				graphics.lineStyle(1, 0x80FFFF, 1);
				graphics.beginFill(0x80FFFF, 0.1);
				graphics.drawRect(x - (width / 2), y - (height / 2), width - 1, height - 1);
				graphics.endFill();
			}
			super.draw();
		}

		/**
		 * Set config from block. Only X and Y are relevent for NoteBox.
		 * @param config 
		 */
		override public function setFromConfig(config:Object):void
		{
			this.x = config["x"];
			this.y = config["y"];
		}

		public function setNoteSource(data:Vector.<Note>):void
		{
			var startMS:int = getTimer();
			this.note_data = data;

			
			// Track Data
			var render_note:GameRenderNote;
			note_count = data.length;
			note_render_data = new Vector.<GameRenderNote>(note_count, true);
			for(var i:int = 0; i < note_count; i++)
			{
				render_note = new GameRenderNote();
				render_note.setData(data[i], receptor_points, track_config, settings);
				note_render_data[i] = render_note;
			}

			// Test Garbage
			/*
			var testData:Vector.<Note> = new Vector.<Note>(6, true);
			testData[0] = new Note("left", 1, "red");
			testData[1] = new Note("down_left", 1, "blue");
			testData[3] = new Note("down", 1, "yellow");
			testData[2] = new Note("up", 1, "orange");
			testData[4] = new Note("up_right", 1, "cyan");
			testData[5] = new Note("right", 1, "purple");

			// Track Data
			var render_note:GameRenderNote;
			note_count = 499998;
			note_render_data = new Vector.<GameRenderNote>(note_count, true);
			for(var i:int = 0; i < note_count; i += 6)
			{
				render_note = new GameRenderNote();
				render_note.setData(testData[0], receptor_points, track_config, settings);
				testData[0].time += 0.01;
				note_render_data[i] = render_note;
				
				render_note = new GameRenderNote();
				render_note.setData(testData[1], receptor_points, track_config, settings);
				testData[1].time += 0.01;
				note_render_data[i+1] = render_note;
				
				render_note = new GameRenderNote();
				render_note.setData(testData[2], receptor_points, track_config, settings);
				testData[2].time += 0.01;
				note_render_data[i+2] = render_note;
				
				render_note = new GameRenderNote();
				render_note.setData(testData[3], receptor_points, track_config, settings);
				testData[3].time += 0.01;
				note_render_data[i+3] = render_note;
				
				render_note = new GameRenderNote();
				render_note.setData(testData[4], receptor_points, track_config, settings);
				testData[4].time += 0.01;
				note_render_data[i+4] = render_note;
				
				render_note = new GameRenderNote();
				render_note.setData(testData[5], receptor_points, track_config, settings);
				testData[5].time += 0.01;
				note_render_data[i+5] = render_note;
			}
			*/
			Logger.log(this, Logger.DEBUG, "Generated " + note_count + " notes in " + (getTimer() - startMS) + "ms");
		}

		/**
		 * Draws all the game notes and receptors into the target BitmapData.
		 * This is the main draw loop for gameplay.
		 * @param target Bitmap Data to draw everything into.
		 */
		private var NOTE_INDEX:int = 0;
		public function drawToBitmap(currentMS:Number, eclipsedMS:Number, target:BitmapData):void
		{
			if(!isRunning) return;

			currentSongMS += eclipsedMS;
			currentTime = (currentSongMS / 1000);

			target.lock();

			_stage_rectangle.width = target.width;
			_stage_rectangle.height = target.height;

			target.fillRect(_stage_rectangle, 0);

			// Draw Notes
			var n_note:GameRenderNote;
			var n_time:Number = 0;
			var n_last:int = NOTE_INDEX; // Store first note, cuts loop counts down.
			var d_drawn:int = 0;
			for(draw_index = NOTE_INDEX; draw_index < note_count; draw_index++) {

				// Update Note
				n_note = note_render_data[draw_index];
				n_note.update(currentTime)
				n_time = n_note.time;

				// Old Note, Skip
				if(n_time < currentTime) {
					n_last = draw_index;
					continue;
				}
				// Future Note, bail.
				else if(n_time > currentTime + READAHEAD)
					break;

				// Draw Note
				_draw_note_point.x = n_note.x;
				_draw_note_point.y = n_note.y;

				_draw_bitmap = note_images[n_note.bitmapIndex];
				_bitmap_rectangle.width = _draw_bitmap.width;
				_bitmap_rectangle.height = _draw_bitmap.height;

				_draw_p_adjusted.x = _draw_note_point.x - (_bitmap_rectangle.width >> 1);
				_draw_p_adjusted.y = _draw_note_point.y - (_bitmap_rectangle.height >> 1);

				target.copyPixels(_draw_bitmap, _bitmap_rectangle, _draw_p_adjusted);
				d_drawn++;
				
				//drawNote(_draw_bitmap, RECEPTOR_LINE + (NOTE_VERTEX * (NOTE_SPEED * (n_time - CURRENT_TIME))));
			}
			trace("Drawn Notes:", d_drawn);
			NOTE_INDEX = n_last;

			// Draw Receptors
			for(draw_index = 0; draw_index < receptor_points.length; draw_index++)
			{
				_draw_recp_point = receptor_points[draw_index];

				_draw_bitmap = receptor_images[draw_index];
				_bitmap_rectangle.width = _draw_bitmap.width;
				_bitmap_rectangle.height = _draw_bitmap.height;

				_draw_p_adjusted.x = _draw_recp_point.x - (_bitmap_rectangle.width >> 1);
				_draw_p_adjusted.y = _draw_recp_point.y - (_bitmap_rectangle.height >> 1);

				target.copyPixels(_draw_bitmap, _bitmap_rectangle, _draw_p_adjusted);
			}

			target.unlock();
		}

		/**
		 * Sets-up required config data for drawing.
		 * 
		 * This resoves the receptor positions, generates the noteskin cache,
		 * and calculates the general bounds of the notebox for the editor.
		 * @param track_config Track Config
		 * @param noteskin_config Noteskin Entry
		 */
		public function setConfigs(track_config:TrackConfigGroup, noteskin_config:NoteskinEntry):void
		{
			var i:int;

			this.track_config = track_config;
			this.noteskin_config = noteskin_config;

			note_images = noteskin_config.buildNoteCache(track_config, settings);
			receptor_images = noteskin_config.buildReceptorCache(track_config, settings);
			source_receptor_points = TrackLocationResolve.resolveReceptors(track_config, noteskin_config, settings);

			// Get Max Receptor Size
			var maxReceptorSize:Number = 64;
			for(i = 0; i < receptor_images.length; i++)
				maxReceptorSize = Math.max(maxReceptorSize, receptor_images[i].width, receptor_images[i].height);

			// Create Draw Points for Receptors
			receptor_points = new Vector.<Point>(source_receptor_points.length, true);
			for(i = 0; i < source_receptor_points.length; i++)
				receptor_points[i] = new Point(0, 0);
			updateReceptorPoints(x, y);
			
			// Create Size Bounds
			var xMin:Number = Number.MAX_VALUE;
			var xMax:Number = Number.MIN_VALUE;
			var yMin:Number = Number.MAX_VALUE;
			var yMax:Number = Number.MIN_VALUE;

			for(i = 0; i < receptor_points.length; i++)
			{
				var receptorPoint:Point = receptor_points[i];
				xMin = Math.min(xMin, receptorPoint.x);
				xMax = Math.max(xMax, receptorPoint.x);
				yMin = Math.min(yMin, receptorPoint.y);
				yMax = Math.max(yMax, receptorPoint.y);
			}

			var xWidth:Number = (xMax - xMin) + maxReceptorSize + 6;
			var yHeight:Number = (yMax - yMin) + maxReceptorSize + 6;

			var lane:TrackConfigLane;
			for(i = 0; i < track_config.lane_count; i++)
			{
				lane = track_config.track_indexs[i];
				if(lane.vertex == 0)
					yHeight = Constant.GAME_HEIGHT;
				if(lane.vertex == 1)
					xWidth = Constant.GAME_WIDTH;
			}

			setSize(xWidth, yHeight);
		}

		/**
		 * Updates the receptor positions using the original receptors
		 * and the offset provided. This is generally the x/y position
		 * of the notebox.
		 * @param ox Offset X
		 * @param oy Offset Y
		 */
		private function updateReceptorPoints(ox:Number, oy:Number):void
		{
			if(receptor_points == null)
				return;

			var i:int;
			var sourcePoint:Point;
			var targetPoint:Point;

			for(i = 0; i < receptor_points.length; i++)
			{
				sourcePoint = source_receptor_points[i];
				targetPoint = receptor_points[i];

				targetPoint.x = sourcePoint.x + ox;
				targetPoint.y = sourcePoint.y + oy;
			}
		}

		/**
		 * Set component X position, update receptor points.
		 * @param val 
		 */
		override public function set x(val:Number):void
		{
			super.x = val;
			updateReceptorPoints(val, y);
		}

		/**
		 * Set component Y position, update receptor points.
		 * @param val 
		 */
		override public function set y(val:Number):void
		{
			super.y = val;
			updateReceptorPoints(x, val);
		}
		/**
		 * Begin drag on the notebox, setups mouse listener to update as it moves.
		 * @param lockCenter 
		 * @param bounds 
		 */
		override public function startDrag(lockCenter:Boolean = false, bounds:flash.geom.Rectangle = null):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			drag_point.x = x;
			drag_point.y = y;
			super.startDrag(lockCenter, bounds);
		}

		/**
		 * Ends drag on notebox, updates receptor positions.
		 */
		override public function stopDrag():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			last_position.x = -1000;
			last_position.y = -1000;
			super.stopDrag();
			updateReceptorPoints(x, y);
		}

		/**
		 * Listern for mouse movements during a mouse drag, updates receptor positions.
		 * @param e 
		 */
		public function e_mouseMove(e:MouseEvent):void
		{
			if(last_position.x < 0)
			{
				last_position.x = e.stageX;
				last_position.y = e.stageY;
				return;
			}

			var diffX:Number = last_position.x - e.stageX;
			var diffY:Number = last_position.y - e.stageY;

			drag_point.x -= diffX;
			drag_point.y -= diffY;
			updateReceptorPoints(drag_point.x, drag_point.y);
			
			last_position.x = e.stageX;
			last_position.y = e.stageY;
		}
		
		////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Export UIPlayComponent into JSON format.
		 * @param k 
		 * @return Object containing struct.
		 */
		override public function toJSON(k:String):Object
		{
			if(!_canExport) return null;
			return {
				"type": this.type,
				"enabled": true,
				"anchor": 0,
				"anchor_lock": true,
				"alignment": 0,
				"x": this.x,
				"y": this.y
			};
		}
		
		/**
		 * Gets the default configuration for this UIPlayComponent.
		 * @return Object Config.
		 */
		override public function getDefaultConfig():Object
		{
			return DEFAULT_CONFIG;
		}

		/** Default Config Object for this UIPlayComponent */
		private static const DEFAULT_CONFIG:Object = {
			"type": "notebox",
			"enabled": true,
			"anchor": 0,
			"anchor_lock": true,
			"alignment": 0,
			"x": 0,
			"y": 0
		};
	}
}