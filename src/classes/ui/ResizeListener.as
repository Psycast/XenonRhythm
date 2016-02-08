package classes.ui
{
	import com.flashfla.utils.ArrayUtil;
	
	/**
	 * Simple stage resize listener and event propagator.
	 */
	public class ResizeListener
	{
		
		private static var items:Array = [];
		
		/**
		 * Subscribes an item to the stage resize listener.
		 * @param	item Item to subscribe.
		 */
		public static function addObject(item:UIComponent):void
		{
			if (!(item in items))
			{
				items.push(item);
			}
		}
		
		/**
		 * Unsubscribes an item from the stage resize listener.
		 * @param	item Item to unsubscribe.
		 */
		public static function removeObject(item:UIComponent):void
		{
			ArrayUtil.remove(item, items);
		}
		
		/**
		 * Removes all items from the stage resize listener.
		 */
		public static function clear():void
		{
			var nItems:Array = [];
			for (var i:int = 0; i < items.length; i++)
			{
				if (items[i] is UIOverlay)
				{
					nItems.push(items[i]);
				}
			}
			items = nItems;
		}
		
		/**
		 * Signels all subscribed that the stage has been resized.
		 */
		public static function signal():void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				items[i].onResize();
			}
		}
	
	}

}