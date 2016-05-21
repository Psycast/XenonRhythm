package classes.ui
{
	
	public class UIAnchor
	{
		public static const NONE:int = 0;
		public static const TOP:int = 1;
		public static const MIDDLE:int = 2;
		public static const BOTTOM:int = 4;
		public static const LEFT:int = 8;
		public static const CENTER:int = 16;
		public static const RIGHT:int = 32;
		
		public static const TOP_LEFT:int = 9;
		public static const TOP_CENTER:int = 17;
		public static const TOP_RIGHT:int = 33;
		public static const MIDDLE_LEFT:int = 10;
		public static const MIDDLE_CENTER:int = 18;
		public static const MIDDLE_RIGHT:int = 34;
		public static const BOTTOM_LEFT:int = 12;
		public static const BOTTOM_CENTER:int = 20;
		public static const BOTTOM_RIGHT:int = 36;
		
		public static const ALIGNMENTS_A:Array = [TOP_LEFT, TOP_CENTER, TOP_RIGHT, MIDDLE_LEFT, MIDDLE_CENTER, MIDDLE_RIGHT, BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT];
		public static const ALIGNMENTS_V:Array = [TOP, MIDDLE, BOTTOM];
		public static const ALIGNMENTS_H:Array = [LEFT, CENTER, RIGHT];
	}

}