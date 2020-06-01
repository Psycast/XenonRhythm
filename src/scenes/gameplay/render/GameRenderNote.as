package scenes.gameplay.render
{
	import classes.engine.track.TrackConfigLane;
	import classes.engine.track.TrackConfigGroup;
	import classes.chart.Note;
	import flash.geom.Point;
	import classes.engine.EngineSettings;

	public class GameRenderNote
	{
		public var laneGroup:TrackConfigLane;
		public var receptor:Point;

		public var x:Number = 0;
		public var y:Number = 0;
		public var bitmapIndex:int = 0;

		public var time:Number = 0;
		public var direction:int = 1;
		public var vertex:int = 0;
		public var note_speed:Number = 1;

		public function setData(note:Note, receptorPoints:Vector.<Point>, laneConfig:TrackConfigGroup, settings:EngineSettings):void
		{
			laneGroup = laneConfig.track_lanes[note.direction];
			bitmapIndex = laneGroup.index + note.color * laneConfig.lane_count;
			receptor = receptorPoints[laneGroup.index];
			direction = laneGroup.direction;
			vertex = laneGroup.vertex;
			time = note.time;
			note_speed = settings.scroll_speed * 300; // 300px Per Second at 1x Rate

			// Fixed Postion
			if(vertex === 1) // X Axis Movement
				this.y = receptor.y;
			else
				this.x = receptor.x;
		}

		public function update(currentTime:Number):void
		{
			// X Axis Movement
			if(vertex === 1)
				this.x = receptor.x - (direction * (note_speed * (time - currentTime)));
			
			// Y Axis Movement
			else
				this.y = receptor.y - (direction * (note_speed * (time - currentTime)));

			
		}
	}
}