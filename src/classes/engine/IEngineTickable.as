package classes.engine
{
	public interface IEngineTickable
	{
		function getPassedTime():Number;
		
		function tick(time:Number, ms:Number):void;
	}
}