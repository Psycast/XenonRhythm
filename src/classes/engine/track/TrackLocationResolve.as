package classes.engine.track
{
	
	import classes.engine.EngineSettings;
	import flash.geom.Point;
	import classes.ui.UIAnchor;
	import classes.noteskin.NoteskinEntry;

	public class TrackLocationResolve
	{
		public static function resolveReceptors(track_config:TrackConfigGroup, noteskin_config:NoteskinEntry, settings:EngineSettings):Vector.<Point>
		{
			var cur_lane:TrackConfigLane;
			var cur_anchor:int = 0;
			var recpPoint:Point;
			var recpVariables:Object = {
				"GAP": Math.ceil(settings.receptor_spacing * noteskin_config.gapMultipler),
				"GAP_HALF": Math.ceil((settings.receptor_spacing * noteskin_config.gapMultipler) / 2)
			};
			var receptor_points:Vector.<Point> = new Vector.<Point>(track_config.lane_count, true);
			for(var lane:int = 0; lane < track_config.lane_count; lane++)
			{
				cur_lane = track_config.track_indexs[lane];
				cur_anchor = cur_lane.anchor != 0 ? cur_lane.anchor : track_config.anchor;
				recpPoint = new Point();
				recpPoint.x = UIAnchor.getOffsetH(cur_anchor, Constant.GAME_WIDTH) * -1 + resolve(cur_lane.x, recpVariables);
				recpPoint.y = UIAnchor.getOffsetV(cur_anchor, Constant.GAME_HEIGHT) * -1 + resolve(cur_lane.y, recpVariables);
				receptor_points[lane] = recpPoint;
			}
			return receptor_points;
		}
		
		public static function resolve(position:Array, presetVars:Object):Number
		{
			if (!position)
				return 0;
			
			var nextFunc:Function;
			
			var CURRENT_VALUE:Number = 0;
			var i:int = 0;
			var len:int = position.length;
			
			for (i = 0; i < len; i++)
			{
				nextFunc = TrackLocationResolve["INST_" + position[i][0]];
				
				CURRENT_VALUE = nextFunc.apply(null, [CURRENT_VALUE, REPLACE_VAR(position[i][1], presetVars)]);
			}
			
			return CURRENT_VALUE;
		}
		
		private static function REPLACE_VAR(value:*, vars:Object):Number
		{
			var test:String = value.toString();
			var tokenIndex:Number = test.indexOf("$");
			// Has Token
			if (tokenIndex >= 0)
			{
				var token:String = test.substr(tokenIndex + 1);
				if (test.charAt(0) == "-")
					return -(vars[token]);
				return vars[token];
			}
			return value;
		}
		
		private static function INST_SET(val1:Number, val2:Number):Number
		{
			return val2;
		}
		
		private static function INST_ADD(val1:Number, val2:Number):Number
		{
			return val1 + val2;
		}
		
		private static function INST_SUB(val1:Number, val2:Number):Number
		{
			return val1 - val2;
		}
		
		private static function INST_MUL(val1:Number, val2:Number):Number
		{
			return val1 * val2;
		}
		
		private static function INST_DIV(val1:Number, val2:Number):Number
		{
			return val1 / val2;
		}
	}

}