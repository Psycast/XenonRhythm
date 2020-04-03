package classes.engine.track
{
	
	public class TrackLocationResolve
	{
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
		
		public static function REPLACE_VAR(value:*, vars:Object):Number
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
		
		public static function INST_SET(val1:Number, val2:Number):Number
		{
			return val2;
		}
		
		public static function INST_ADD(val1:Number, val2:Number):Number
		{
			return val1 + val2;
		}
		
		public static function INST_SUB(val1:Number, val2:Number):Number
		{
			return val1 - val2;
		}
		
		public static function INST_MUL(val1:Number, val2:Number):Number
		{
			return val1 * val2;
		}
		
		public static function INST_DIV(val1:Number, val2:Number):Number
		{
			return val1 / val2;
		}
	}

}