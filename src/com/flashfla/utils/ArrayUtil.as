package com.flashfla.utils
{
	
	public class ArrayUtil
	{
		/**
		 *	Remove first of the specified value from the array,
		 *
		 * 	@param arr The array from which the value will be removed
		 *
		 *	@param value The object that will be removed from the array.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function remove(value:Object, arr:Array):Boolean
		{
			if (!arr || arr.length == 0)
				return false;
				
			var ind:int;
			if ((ind = arr.indexOf(value)) != -1)
			{
				arr.splice(ind, 1);
				return true;
			}
			return false;
		}
		
		/**
		 *	Remove all instances of the specified value from the array,
		 *
		 * 	@param arr The array from which the value will be removed
		 *
		 *	@param value The object that will be removed from the array.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeValue(value:Object, arr:Array):void
		{
			var len:uint = arr.length;
			
			for (var i:Number = len; i > -1; i--)
			{
				if (arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}
		}
		
		public static function count(ar:Array):uint
		{
			var len:uint = 0;
			for (var item:* in ar)
			{
				if (item != 'mx_internal_uid')
					len++;
			}
			return len;
		}
		
		/**
		 * This method reigns in a value to keep it between
		 * the supplied minimum and maximum limits.
		 * Useful for wrapping number values
		 * (particularly paginated interfaces).
		 * Returns the reigned-in result.
		 */
		public static function index_wrap(value:Number, min:Number, max:Number):Number
		{
			return (value > max ? min : (value < min ? max : value));
		}
		
		/**
		 * Randomizes an array by changing the indexes. Returns new array.
		 * @param	ar Input Array
		 * @return	array Randomized Array
		 */
		public static function randomize(ar:Array):Array
		{
			var newarr:Array = new Array(ar.length);
			
			var randomPos:Number = 0;
			for (var i:int = 0; i < newarr.length; i++)
			{
				randomPos = int(Math.random() * ar.length);
				newarr[i] = ar.splice(randomPos, 1)[0];
			}
			
			return newarr;
		}
		
		public static function in_array(inAr:Array, items:Array):Boolean
		{
			for (var y:int = 0; y < items.length; y++)
			{
				for (var x:int = 0; x < inAr.length; x++)
				{
					if (inAr[x] == items[y])
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Provides a way to find the next valid index within an array that follows certain conditions.
		 * @param	dir (true) Search towards 0 index. (false) Search towards array.length index.
		 * @param	startIndex Starting Index to start searching from, inclusive.
		 * @param	searchArray Array to search through.
		 * @param	condition Condition for index to be found valid.
		 * @return 	int Next Valid Index in array or startIndex if none found.
		 */
		public static function find_next_index(dir:Boolean, startIndex:int, searchArray:Array, condition:Function):int
		{
			var indexMove:int = dir ? -1 : 1;
			var indexTotal:int = searchArray.length - 1;
			var toCheck:int = searchArray.length; // Prevents Hangs if no valid items found.
			var newIndex:int = index_wrap(startIndex, 0, indexTotal);
			while (toCheck-- > 0)
			{
				if (searchArray[newIndex] != null && condition(searchArray[newIndex]))
					break;
				newIndex = index_wrap(newIndex + indexMove, 0, indexTotal);
			}
			return newIndex;
		}
	
	}
}