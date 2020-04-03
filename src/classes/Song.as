package classes
{
	import classes.chart.NoteChart;
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import com.flashfla.media.MP3Extraction;
	import com.flashfla.utils.TimeUtil;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class Song extends EventDispatcher
	{
		private var core:EngineCore;
		
		public var details:EngineLevel;
		public var chart:NoteChart;
		
		private var _loadFailed:Boolean = false;
		private var _musicLoader:URLLoader;
		private var _loadedMusic:Sound;
		private var _musicChannel:SoundChannel;
		
		public var isMusicLoaded:Boolean = false;
		public var isChartLoaded:Boolean = false;
		
		// Music Variables
		private var _playbackSpeed:Number = 1;
		
		public var musicDelay:Number = 0; // TODO: Only used in Isolation.
		public var musicPausePosition:Number = 0;
		public var musicIsPlaying:Boolean = false;
		public var mp3FrameSync:Number = 0;
		public var mp3Rate:Number = 1;
		
		// Music Rate Variables 
		private static const SAMPLES_PER_CALLBACK:int = 4096; // Should be >= 2048 && < = 8192
		private static var loadedSamples:ByteArray = new ByteArray();
		private var _dynamicSound:Sound;
		private var _samplePhase:Number;
		private var _numSamples:int;
		private var startTime:int;
		
		/**
		 * This is the core song class that contains most the songs logic required for playing.
		 * It handles the playback of music, loading of song and charts, and other small things.
		 * @param	core Engine Core
		 * @param	songDetails Song Details to create the song for
		 */
		public function Song(core:EngineCore, songDetails:EngineLevel)
		{
			this.core = core;
			this.details = songDetails;
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Loads the level data from the server.
		 */
		public function load():void
		{
			var url:String = core.getPlaylist(details.source).getLevelPath(details);
			
			_musicLoader = new URLLoader();
			_musicLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_musicLoader.load(new URLRequest(url));
			
			_musicLoader.addEventListener(Event.COMPLETE, e_musicLoadComplete);
			_musicLoader.addEventListener(IOErrorEvent.IO_ERROR, e_musicLoadError);
			_musicLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, e_musicLoadError);
			_musicLoader.addEventListener(ProgressEvent.PROGRESS, e_musicLoadProgress);
		}
		
		/**
		 * Beings playback of the music.
		 * @param	seek Time of when to start playing.
		 */
		public function start(seek:Number = 0):void
		{
			Logger.log(this, Logger.NOTICE, "Starting Sound Playback");
			if (!musicIsPlaying)
			{
				_dynamicSound = new Sound();
				_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, e_onSampleData);
				
				_samplePhase = 0;
				
				startTime = getTimer();
				
				_musicChannel = _dynamicSound.play();
				_musicChannel.addEventListener(Event.SOUND_COMPLETE, e_soundFinished);
				
				musicIsPlaying = true;
			}
		}
		
		/**
		 * Stops playback of the music.
		 */
		public function stop():void
		{
			Logger.log(this, Logger.NOTICE, "Stopping Sound Playback");
			if (_musicChannel)
			{
				_musicChannel.removeEventListener(Event.SOUND_COMPLETE, e_soundFinished);
				_musicChannel.stop();
				_musicChannel = null;
			}
			musicIsPlaying = false;
		}
		
		/**
		 * Marks a song as though it failed to load, will be removed from the loaded cache.
		 */
		public function markAsFailed():void
		{
			if (!_loadFailed)
			{
				_loadFailed = true;
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Called when music or chart data is loaded to check for completion and dispatch and event if so.
		 */
		private function _doLoadCompleteInit():void
		{
			if (loaded)
			{
				Logger.log(this, Logger.INFO, "\"" + details.name + "\" Loaded with " + chart.Notes.length + " notes, at " + TimeUtil.convertToHHMMSS(chart.Notes[chart.Notes.length - 1].time));
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Called when a failure has happened during the loading of the file or notechart.
		 */
		private function _doLoadFailure():void
		{
			if (!_loadFailed)
			{
				_loadFailed = true;
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Used to determine if a section of the song failed to load or some other error has occured.
		 */
		public function get load_failed():Boolean
		{
			return _loadFailed;
		}
		
		/**
		 * Get the load status of the song file.
		 */
		public function get loaded():Boolean
		{
			return (!load_failed && details && _loadedMusic && isMusicLoaded && chart && isChartLoaded);
		}
		
		/**
		 * Gets the current music playback speed.
		 */
		public function get playback_speed():Number
		{
			return _playbackSpeed;
		}
		
		/**
		 * Sets the playback speed and music source.
		 */
		public function set playback_speed(rate:Number):void
		{
			if (Math.abs(rate) < 0.01)
				rate = 0;
			
			if (rate >= 0)
				_playbackSpeed = rate;
			
			Logger.log(this, Logger.INFO, "Setting playback speed to " + _playbackSpeed);
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handles the completion of the Music loader.
		 * @param	e Event containg the COMPLETE event.
		 */
		private function e_musicLoadComplete(e:Event):void
		{
			var swfData:ByteArray = e.target.data;
			
			// MP3 Extraction from SWF
			var metadata:Object = new Object();
			var bytes:ByteArray = MP3Extraction.extractSound(swfData, metadata);
			
			mp3FrameSync = metadata.frame / 30; // FFR SWF Framerate is 30
			mp3Rate = MP3Extraction.formatRate(metadata.format) / 44100;
			
			// Load Music Bytes
			try
			{
				_loadedMusic = new Sound();
				_loadedMusic.loadCompressedDataFromByteArray(bytes, bytes.length);
				
				_numSamples = int(_loadedMusic.length * 44.1);
				
				isMusicLoaded = true;
			}
			catch (e:Error)
			{
				Logger.log(this, Logger.ERROR, "Music Load Error for \"" + details.name + "\"");
				_doLoadFailure();
				return;
			}
			
			// Chart 
			chart = NoteChart.parseChart(NoteChart.FFR_LEGACY, swfData);
			e_chartLoadComplete(e);
			
			Logger.log(this, Logger.INFO, "Music Load Complete for \"" + details.name + "\"");
			
			_doLoadCompleteInit();
		}
		
		/**
		 * Handles the failure of the Music loader.
		 * @param	e Event containing some type of load failure.
		 */
		private function e_musicLoadError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "Music Load Error for \"" + details.name + "\"");
			_doLoadFailure();
		}
		
		/**
		 * Handles the progress event of the Music loader.
		 * @param	e ProgressEvent
		 */
		private function e_musicLoadProgress(e:ProgressEvent):void
		{
			dispatchEvent(e.clone());
		}
		
		/**
		 * Handles the load completion of the chart data.
		 * @param	e Complete Event
		 */
		private function e_chartLoadComplete(e:Event):void
		{
			if (chart.Notes.length > 0)
			{
				isChartLoaded = true;
				Logger.log(this, Logger.INFO, "Chart Load Complete for \"" + details.name + "\"");
				_doLoadCompleteInit();
			}
			else
			{
				Logger.log(this, Logger.ERROR, "Chart Load Failure for \"" + details.name + "\"");
				_doLoadFailure();
			}
		}
		
		/**
		 * Called when the song has finished playing.
		 */
		private function e_soundFinished(e:Event):void
		{
			Logger.log(this, Logger.INFO, "Finished Sound Playback");
			musicIsPlaying = false;
		}
		
		/**
		 * Sample Data Event for music playback.
		 * @param	event
		 */
		private function e_onSampleData(event:SampleDataEvent):void
		{
			//trace(int((_samplePhase / 44100) * 1000), (getTimer() - startTime), (int((_samplePhase / 44100) * 1000) - (getTimer() - startTime)), _samplePhase);
			
			/** Loaded Samples Byte Position */
			var p:int;
			
			// Clear Samples
			loadedSamples.length = 0;
			
			var initialPhase:int = int(_samplePhase);
			var readSamples:Number;
			
			if (_playbackSpeed > 0)
			{
				readSamples = _loadedMusic.extract(loadedSamples, SAMPLES_PER_CALLBACK * _playbackSpeed, initialPhase);
				loadedSamples.position = 0;
				
				while (loadedSamples.bytesAvailable > 0)
				{
					p = int(_samplePhase - initialPhase) * 8;
					
					if (p < 0)
						return;
					
					if (p < loadedSamples.length - 8 && event.data.length <= SAMPLES_PER_CALLBACK * 8)
					{
						loadedSamples.position = p;
						
						event.data.writeFloat(loadedSamples.readFloat());
						event.data.writeFloat(loadedSamples.readFloat());
						
					}
					else
						loadedSamples.position = loadedSamples.length;
					
					_samplePhase += _playbackSpeed;
					
					if (_samplePhase >= _numSamples) {
					   _samplePhase -= _numSamples;
					}
				}
			}
		}
	}
}