package classes
{
	import classes.chart.NoteChart;
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import com.flashfla.media.MP3Extraction;
	import com.flashfla.media.SwfSilencer;
	import com.flashfla.utils.TimeUtil;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.audiofx.mp3.MP3ByteArrayLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	
	public class Song extends EventDispatcher
	{
		private var core:EngineCore;
		
		public var details:EngineLevel;
		public var music:Sound;
		public var background:MovieClip;
		public var chart:NoteChart;
		
		private var _loadFailed:Boolean = false;
		private var _musicLoader:URLLoader;
		
		public var isMusicLoaded:Boolean = false;
		public var isChartLoaded:Boolean = false;
		
		// Music Variables
		public var mp3Frame:int = 0;
		public var mp3Rate:Number = 1;
		
		// Music Rate Variables
		private var rateReverse:Boolean = false;
		private var rateRate:Number = 1;
		private var rateSound:Sound;
		private var rateSample:int = 0;
		private var rateSampleCount:int = 0;
		private var rateSamples:ByteArray = new ByteArray();
		
		public function Song(core:EngineCore, songDetails:EngineLevel)
		{
			this.core = core;
			this.details = songDetails;
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
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
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Called when music or chart data is loaded to check for completion and dispatch and event if so.
		 */
		private function _doLoadCompleteInit():void
		{
			if (loadFailed)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			if (loaded)
			{
				Logger.log(this, Logger.INFO, "\"" + details.name + "\" Loaded with " + chart.Notes.length + " notes, at " + TimeUtil.convertToHHMMSS(chart.Notes[chart.Notes.length - 1].time));
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Used to determine if a section of the song failed to load or some other error has occured.
		 */
		public function get loadFailed():Boolean
		{
			return _loadFailed;
		}
		
		/**
		 * Get the load status of the song file.
		 */
		public function get loaded():Boolean
		{
			return (!loadFailed && details && music && isMusicLoaded && chart && isChartLoaded);
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
			var loader:MP3ByteArrayLoader = new MP3ByteArrayLoader();
			loader.addEventListener(MP3SoundEvent.COMPLETE, e_mp3ExtractComplete);
			if (!loader.getSound(bytes, metadata.seek, metadata.samples, metadata.format))
			{
				Logger.log(this, Logger.ERROR, "Unabled to extract sound.");
				_loadFailed = true;
				_doLoadCompleteInit();
				return;
			}
			mp3Frame = metadata.frame - 2;
			mp3Rate = MP3Extraction.formatRate(metadata.format) / 44100;
			
			// Background Extraction from SWF
			var mloader:Loader = new Loader();
			var mbytes:ByteArray = SwfSilencer.stripSound(swfData);
			mloader.contentLoaderInfo.addEventListener(Event.COMPLETE, e_mp3BackgroundComplete);
			if (!mbytes)
			{
				Logger.log(this, Logger.ERROR, "Unabled to extract background.");
				_loadFailed = true;
				_doLoadCompleteInit();
				return;
			}
			mloader.loadBytes(mbytes);
			
			// Chart 
			chart = NoteChart.parseChart(NoteChart.FFR_LEGACY, swfData);
			e_chartLoadComplete(e);
			
			Logger.log(this, Logger.INFO, "Music Load Complete for \"" + details.name + "\"");
		}
		
		/**
		 * Handles the failure of the Music loader.
		 * @param	e Event containing some type of load failure.
		 */
		private function e_musicLoadError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "Music Load Error for \"" + details.name + "\"");
			_loadFailed = true;
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
		 * Handles the completion of the load of the extracted MP3 sound.
		 * @param	e MP3SoundEvent containing the extracted sound object.
		 */
		private function e_mp3ExtractComplete(e:MP3SoundEvent):void
		{
			music = e.sound as Sound;
			
			if (rateRate != 1 || rateReverse)
			{
				rateSound = music;
				music = new Sound();
				if (rateReverse)
					music.addEventListener("sampleData", onReverseSound);
				else
					music.addEventListener("sampleData", onRateSound);
			}
			
			isMusicLoaded = true;
			_doLoadCompleteInit();
		}
		
		/**
		 * Handles the extraction of the background from the SWF.
		 * @param	e Complete Event
		 */
		private function e_mp3BackgroundComplete(e:Event):void
		{
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			background = info.content as MovieClip;
			
			_doLoadCompleteInit();
		}
		
		/**
		 * Handles the load completion of the chart data.
		 * @param	e Complete Event
		 */
		private function e_chartLoadComplete(e:Event):void {
			isChartLoaded = true;
			
			Logger.log(this, Logger.INFO, "Chart Load Complete for \"" + details.name + "\"");
			
			_doLoadCompleteInit();
		}
		
		
		private function onRateSound(e:*):void
		{
			var osamples:int = 0;
			while (osamples < 4096)
			{
				var sample:int = (e.position + osamples) * rateRate;
				var sampleDiff:int = sample - rateSample;
				while (sampleDiff < 0 || sampleDiff >= rateSampleCount)
				{
					rateSample += rateSampleCount;
					rateSamples.position = 0;
					sampleDiff = sample - rateSample;
					var seekExtract:Boolean = (sampleDiff < 0 || sampleDiff > 8192);
					rateSampleCount = (rateSound as Object).extract(rateSamples, 4096, seekExtract ? sample * mp3Rate : -1);
					if (seekExtract)
					{
						rateSample = sample;
						sampleDiff = sample - rateSample;
					}
					
					if (rateSampleCount <= 0)
						return;
				}
				rateSamples.position = 8 * sampleDiff;
				e.data.writeFloat(rateSamples.readFloat());
				e.data.writeFloat(rateSamples.readFloat());
				osamples++;
			}
		}
		
		private function onReverseSound(e:*):void
		{
			var osamples:int = 0;
			while (osamples < 4096)
			{
				var sample:int = (e.position + osamples) * rateRate;
				sample = (chart.Notes[chart.Notes.length - 1].getFrame() * 1470) - sample + (63 - mp3Frame) * 1470 / rateRate;
				if (sample < 0)
					return;
				var sampleDiff:int = sample - rateSample;
				if (sampleDiff < 0 || sampleDiff >= rateSampleCount)
				{
					rateSample += rateSampleCount;
					rateSamples.position = 0;
					sampleDiff = sample - rateSample;
					var seekPosition:int = sample - 4095;
					rateSampleCount = (rateSound as Object).extract(rateSamples, 4096, seekPosition * mp3Rate);
					rateSample = seekPosition;
					sampleDiff = sample - rateSample;
					
					if (rateSampleCount < 4096)
					{
						rateSamples.position = rateSampleCount * 8;
						for (var i:int = rateSampleCount; i < 4096; i++)
						{
							rateSamples.writeFloat(0);
							rateSamples.writeFloat(0);
						}
						rateSampleCount = 4096;
					}
				}
				rateSamples.position = 8 * sampleDiff;
				e.data.writeFloat(rateSamples.readFloat());
				e.data.writeFloat(rateSamples.readFloat());
				osamples++;
			}
		}
	}

}