package classes.engine
{
	import com.zehfernando.signals.SimpleSignal;

	public class EngineTickableTimer implements IEngineTickable
	{
		private var _isRunning:Boolean = true;

		/** Time to complete each loop. */
		private var _time:int = 0;

		/** Delay to remove before eclipsed resumes. */
		public var delay:int = 0;

		/** Eclipsed time since last loop or start. */
		private var _eclipsed:Number = 0;

		/** Current loop iteration. */
		private var _repeat:int = 0;

		/** Max loops before completion. */
		private var _repeatCount:int = 0;

		/**
		 * Array of functions to be called every timer tick, with the getPassedTime() value as the argument.
		 */
		public var onTick:SimpleSignal = new SimpleSignal();

		/**
		 * Array of functions to be called once the eclipsed reaches the specified time and starts over.
		 * Passes the current repeat count as a paramater to the functions.
		 */
		public var onRepeat:SimpleSignal = new SimpleSignal();

		/**
		 * Array of functions to be called once the timer has finished the amount of request loops.
		 * Note: This isn't called if repeatCount = 0.
		 */
		public var onComplete:SimpleSignal = new SimpleSignal();

		/**
		 * Create a timer similar to the official Timer, but is advanced in our gameplay loop.
		 * Works using milliseconds
		 * @param time Time per loop.
		 * @param start_running Begin the timer tracking time or not.
		 * @param repeatCount Amount of loops before completion. A vlue of 0 will repeat forever.
		 */
		public function EngineTickableTimer(time:Number, start_running:Boolean = true, repeat_count:int = 0)
		{
			_time = time;
			_repeatCount = repeat_count;
			_isRunning = start_running;
		}

		public function getTime():Number
		{
			return _time;
		}

		public function getPassedTime():Number
		{
			return _eclipsed;
		}

		public function tick(time:Number, ms:Number):void
		{
			if(!_isRunning)
				return;

			// Reduce Delay
			if(delay > 0) delay -= ms;
			if(delay < 0) delay = 0;
			if(delay > 0) return;

			// Increment Time
			_eclipsed += ms;

			// Dispatch Tick Events
			onTick.dispatch(getPassedTime());

			// Check for Loop Time
			if(_eclipsed > _time)
			{
				while(_eclipsed > _time)
				{
					_eclipsed -= _time;
					if(_repeatCount > 0)
					{
						_repeat++;
						if(_repeatCount == _repeat)
						{
							onComplete.dispatch();
							_isRunning = false;
						}
						else
							onRepeat.dispatch(_repeat);
					}
					else
					{
						onRepeat.dispatch(_repeat);
					}
				}
			}
		}

		public function clear():void
		{
			_isRunning = false;
			_repeat = 0;
			onTick.removeAll();
			onRepeat.removeAll();
			onComplete.removeAll();
		}

		public function reset(isRunning:Boolean = false):void
		{
			_repeat = 0;
			_isRunning = isRunning;
		}

		public function start():void
		{
			_isRunning = true;
		}

		public function stop():void
		{
			_isRunning = false;
		}
	}
}