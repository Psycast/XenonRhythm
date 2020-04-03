package classes
{
	import classes.engine.EngineLevel;
	
	public class zRanking
	{
		public static var DELTA_VALUES:Vector.<Number>;
		public static var TOP_EQ_SHAPE:Array = [0.2404, 0.1860, 0.1435, 0.1105, 0.0848, 0.0647, 0.0491, 0.0370, 0.0275, 0.0202, 0.0144, 0.0099, 0.0065, 0.0038, 0.0017];
		
		public static const ALPHA:Number = 9.9750396740034;
		public static const BETA:Number = 0.0193296437339205;
		public static const LAMBDA:Number = 18206628.7286425;
		
		public static const D1:Number = 17678803623.9633;
		public static const D2:Number = 733763392.922176;
		public static const D3:Number = 28163834.4879901;
		public static const D4:Number = -434698.513947563;
		public static const D5:Number = 3060.24243867853;
		
		// Static Init
		{
			generateDeltaValues();
		}
		
		static public function generateDeltaValues(numDifficulties:int = 120):void
		{
			DELTA_VALUES = new Vector.<Number>(numDifficulties + 1, true);
			
			for (var i:int = 0; i <= numDifficulties; i++)
				DELTA_VALUES[i] = D1 + D2 * i + D3 * Math.pow(i, 2) + D4 * Math.pow(i, 3) + D5 * Math.pow(i, 4);
		}
		
		static public function getSongWeight(song:EngineLevel, result:Object):Number
		{
			var rawgoods:Number = getRawGoods(result);
			var songweight:Number = 0;
			var delta:Number = D1 + D2 * song.difficulty + D3 * Math.pow(song.difficulty, 2) + D4 * Math.pow(song.difficulty, 3) + D5 * Math.pow(song.difficulty, 4);
			if (delta - rawgoods * LAMBDA > 0)
			{
				songweight = Math.pow((delta - rawgoods * LAMBDA) / delta * Math.pow(song.difficulty + ALPHA, BETA), 1 / BETA) - ALPHA;
			}
			if (songweight < 0 || result.score <= 0 || song.engine != null) songweight = 0; // TODO: song.engine
			return songweight;
		}
		
		static public function getRawGoods(result:Object):Number
		{
			return (result.good) + (result.average * 1.8) + (result.miss * 2.4) + (result.boo * 0.2);
		}
	
	}
}