package classes.engine.input
{
    public class InputConfigGroup 
	{
		public var id:String;
		public var name:String;
		
		public var input_groups:Object = {};
		public var key_actions:Object = {};
		
		public var input_sets:Vector.<String>;
		public var input_count:int = 0;
		
		/**
		 * Loads JSON object into structure.
		 * @param	input
		 */
		public function load(input:Object):void
		{
			input_sets = new Vector.<String>();

			this.id = input.id;
			this.name = input.name;
			
			var trackObj:InputConfigSet;
			for (var track:String in input.controls) 
			{
				trackObj = new InputConfigSet();
				trackObj.track = track;
				trackObj.keyCode = input.controls[track];
				
				key_actions[trackObj.keyCode] = trackObj;
				input_groups[track] = trackObj;
				input_sets.push(track);
			}

			input_sets.fixed = true;
			input_count = input_sets.length;
		}

		public function isPressed(action:String, keyCode:int):Boolean
		{
			return (input_groups[action] as InputConfigSet).keyCode == keyCode;
		}

		public function isAction(keyCode:int):String
		{
			return key_actions[keyCode] != null ? (key_actions[keyCode] as InputConfigSet).track : null;
		}

		public function setAction(action:String, keyCode:int):void
		{
			if (input_sets.indexOf(action) >= 0)
			{
				var set:InputConfigSet = input_groups[action];
				key_actions[set.keyCode] = null;
				key_actions[keyCode] = set;
				set.keyCode = keyCode;
			}
		}
	}
}