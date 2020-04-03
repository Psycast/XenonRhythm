package classes.input 
{
	public class InputMap 
	{
		private var _name:String;
		private var _inputs:Array;
		private var _controls:Object;
		private var _index:Vector.<InputMapControl>
		
		public function InputMap(struct:Object):void 
		{
			_inputs = [];
			_controls = {};
			_index = new Vector.<InputMapControl>();
			
			_name = struct["name"];
			
			for (var action:String in struct["map"])
			{
				var control:InputMapControl = new InputMapControl(struct["map"][action]);
				
				_inputs.push(action);
				_controls[action] = control;
				_index.push(control);
			}
		}
		
		public function toJSON(k:*):Object
		{
			return {
				"name": this._name,
				"map": this._controls
			};
		}
		
	}

}