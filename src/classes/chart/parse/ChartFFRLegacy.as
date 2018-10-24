package classes.chart.parse {
	import classes.chart.BPMSegment;
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import classes.chart.Stop;
	import com.flashfla.utils.StringUtil;
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.flashfla.media.Beatbox;
	
	public class ChartFFRLegacy extends NoteChart {
		public function ChartFFRLegacy(inData:Object, framerate:int = 30):void {
			type = NoteChart.FFR_LEGACY;
			
			super(null, framerate);
			
			parseChart(ByteArray(inData));
		}
		
		override public function noteToTime(note:Note):int {
			return Math.floor(note.time * framerate);
		}
		
		public function parseChart(data:ByteArray):void {
			var beatbox:Array = Beatbox.parseBeatbox(data);
			if (beatbox) {
				for each (var beat:Object in beatbox) {
					var beatPos:int = beat[0];
					Notes.push(new Note(beat[1], beatPos / framerate, beat[2] || "blue"));
				}
			}
		}
	}
}
