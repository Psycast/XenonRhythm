package scenes.debug 
{
	public class TestModSetting
	{
		public var name:String;
		
		public function TestModSetting(mod:String) 
		{
			this.name = mod;
		}
		
		public function isEnabled():Boolean
		{
			return true;
		}
	}
}