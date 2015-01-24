package com.flashfla.utils
{
	public class ArrayUtil
	{
		public static function randomize(ar:Array):Array {
			var newarr:Array = new Array(ar.length);
			
			var randomPos:Number = 0;
			for (var i:int = 0; i < newarr.length; i++) {
				randomPos = int(Math.random() * ar.length);
				newarr[i] = ar.splice(randomPos, 1)[0];
			}
			
			return newarr;
		}
		
		public static function in_array(inAr:Array, items:Array):Boolean {
			for (var y:int = 0; y < items.length; y++) {
				for (var x:int = 0; x < inAr.length; x++) {
					if (inAr[x] == items[y]) {
						return true;
					}
				}
			}
			return false;
		}
		
	}
}