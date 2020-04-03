package classes.input
{
	import flash.utils.Dictionary;
	
	public class InputMapManager
	{
		public var dictionary:Dictionary = new Dictionary();
		
		[Embed(source = "input_map.json", mimeType = "application/octet-stream")]
		private static const JSON_CONTROLLERS:Class;
		
		public static var INPUT_TYPES:Array = [];
		
		public function InputMapManager():void
		{
			var mappingData:Object = JSON.parse(String(new JSON_CONTROLLERS()).replace(/\/\*.*?\*\//sg, ""));
			for each (var controlGroup:Object in mappingData)
			{
				dictionary[controlGroup["name"]] = new InputMap(controlGroup);
			}
		}
		
		public function getMapping(mappingType:String):InputMap
		{
			return dictionary[mappingType] != null ? dictionary[dictionary] : null;
		}
	
	}

}