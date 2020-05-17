package classes.chart.parse {
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import flash.utils.ByteArray;
	import com.flashfla.media.Beatbox;
	
	public class ChartFFRLegacy extends NoteChart {
		private static const DIRECTION_MAP:Object = {
			"L": "left",
			"R": "right",
			"D": "down",
			"U": "up"
		};

		public function ChartFFRLegacy(inData:Object, framerate:int = 30):void {
			type = NoteChart.FFR_LEGACY;
			
			super(null, framerate);
			
			parseChart(ByteArray(inData));
		}
		
		public function parseChart(data:ByteArray):void {
			var beatbox:Array = Beatbox.parseBeatbox(data);
			if (beatbox) {
				for each (var beat:Object in beatbox) {
					var beatPos:int = beat[0];
					Notes.push(new Note(DIRECTION_MAP[beat[1]], beatPos / framerate, beat[2] || "blue"));
				}
			}
		}
	}
}
