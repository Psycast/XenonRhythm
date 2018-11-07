package classes.chart
{
	import classes.chart.parse.*;
	import classes.engine.EngineLevel;
	
	public class NoteChart
	{
		public static const FFR:String = "ChartFFR";
		public static const FFR_RAW:String = "ChartFFRR";
		public static const FFR_BEATBOX:String = "ChartFFRBeatBox";
		public static const FFR_LEGACY:String = "ChartFFRL";
		public static const FFR_MP3:String = "ChartFFRMP3";
		public static const SM:String = "ChartSM";
		public static const DWI:String = "ChartDWI";
		public static const THIRDSTYLE:String = "ChartTS";
		
		public var type:String;
		public var gap:Number = 0;
		public var BPMs:Vector.<BPMSegment> = new <BPMSegment>[];
		public var Stops:Vector.<Stop> = new <Stop>[];
		public var Notes:Vector.<Note> = new <Note>[];
		public var chartData:Object;
		public var framerate:int = 60;
		protected var frameOffset:int = 0;
		
		public function NoteChart(inData:Object, framerate:int = 60):void
		{
			this.chartData = inData;
			this.framerate = framerate;
		}
		
		/**
		 * Provides a static interface to access the correct parsing engine needed for the chart.
		 *
		 * @param	type		Chart Type
		 * @param	inData		Chart Data
		 * @param	framerate	(Optional) Frame rate to use.
		 *
		 * @return	NoteChart of the type expected.
		 */
		
		public static function parseChart(type:String, inData:Object, framerate:int = 60):NoteChart
		{
			switch (type)
			{
				case THIRDSTYLE: 
					return new ChartThirdstyle(String(inData), framerate);
				
				case SM: 
					return new ChartStepmania(String(inData), framerate);
				
				case FFR_LEGACY: 
					return new ChartFFRLegacy(inData, 30);
				
				case FFR_BEATBOX: 
					return new ChartFFRBeatbox(String(inData), 30);
				
				default: 
					return new ChartFFR(String(inData), 30);
			}
		}
		
		/**
		 * Calculates the frame for all loaded notes.
		 */
		
		protected function notesToFrame():void
		{
			for (var n:String in this.Notes)
			{
				this.Notes[n].setFrame(noteToTime(this.Notes[n]));
			}
		}
		
		/**
		 * Calculates the time this note spawns on.
		 *
		 * @param	n	Note to get the time for.
		 *
		 * @return Second timing of the note provided.
		 */
		public function noteToTime(n:Note):int
		{
			var i:int = 0;
			var totalOff:Number = gap;
			
			while (BPMs[i].end != -1 && n.time >= BPMs[i].end)
			{
				totalOff += BPMs[i].totalTime();
				i++;
			}
			
			totalOff += 240 * (n.time - (BPMs[i].start)) / (BPMs[i].bpm);
			
			for (var j:int = 0; j < Stops.length; j++)
			{
				var f:Stop = Stops[j];
				if (f.time < n.time)
				{
					totalOff += f.length;
				}
			}
			
			return Math.round(totalOff * framerate) + frameOffset;
		}
		
		/**
		 * Offset the chart by a given amount of seconds
		 */
		public function offsetSeconds(seconds:Number):void
		{
			gap += seconds;
			notesToFrame();
		}
	}
}
