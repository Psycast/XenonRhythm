package classes.input 
{
	public class InputMapControl 
	{
		// Keyboard
		public var KEY:int = 0;
		
		// Controller
		public var DEVICE_INDEX:int = -1;
		public var INPUT_ID:String = "INPUT_0";
		
		public function InputMapControl(struct:Object) 
		{
			this.KEY = struct["key"];
			
			this.INPUT_ID = struct["controller"]["control"];
		}
		
		public function toJSON(k:*):Object
		{
			return {
				"key": this.KEY,
				"controller": {
					"control": this.INPUT_ID
				}
			};
		}
		
	}

}