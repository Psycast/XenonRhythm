package classes.ui
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import flash.display.Sprite;
	import classes.engine.IEngineTickable;
	
	public class UICore extends Sprite
	{
		protected var tickables:Vector.<IEngineTickable> = new Vector.<IEngineTickable>();
		protected var core:EngineCore;
		private var _INPUT_DISABLED:Boolean = false;
		public var SCENE_SWITCHING:Boolean = false;
		
		public function UICore(core:EngineCore)
		{
			this.core = core;
		}
		
		/**
		 * Abstract init() function.
		 * Called by UI before placement on the stage.
		 */
		public function init():void
		{
		
		}
		
		/**
		 * Abstract destroy() function.
		 * Called by UI before removal from the stage.
		 */
		public function destroy():void
		{
			FormManager.unregisterAll(this);
		}
		
		/**
		 * Abstract destroy() function.
		 * Called by UI after placement on the stage.
		 */
		public function onStage():void
		{
			var bg:sGameBackground = new sGameBackground();
			addChildAt(bg, 0);
			
			position();
			draw();
		}
		
		/**
		 * Abstract onResize() function.
		 * Called by UI when the stage size changes.
		 */
		public function onResize():void
		{
			position();
		}

		/**
		 * Abstract onTick() function. Called onEnterFrame.
		 * @param eclipsedMilliseconds Milliseconds eclipsed since last tick update.
		 */
		public function onTick(currentMilliseconds:Number, eclipsedMilliseconds:Number):void
		{
			if(tickables.length > 0)
			{
				var len:int = tickables.length - 1;
				for(var index:int = len; index >= 0; index--)
				{
					tickables[index].tick(currentMilliseconds, eclipsedMilliseconds);
				}
			}
		}

		/**
		 * Add a tickable object to the list of tickable objects.
		 * @param tickable Tickable to add.
		 * @return If the tickable object was added to the list.
		 */
		public function addTickable(tickable:IEngineTickable):Boolean
		{
			if(tickables.indexOf(tickable) == -1)
			{
				tickables.push(tickable);
				Logger.log(this, Logger.DEBUG, "Added Tickable " + tickable);
				return true;
			}
			return false;
		}

		/**
		 * Removes the tickable from the list of ticking objects.
		 * @param tickable Tickable object to remove from list.
		 * @return If the tickable object was removed.
		 */
		public function removeTickable(tickable:IEngineTickable):Boolean
		{
			var ifr:int = tickables.indexOf(tickable);
			if (ifr > -1) {
				tickables.splice(ifr, 1);
				Logger.log(this, Logger.DEBUG, "Removed Tickable " + tickable);
				return true;
			}
			return false;
		}
		
		/**
		 * Abstract draw() function.
		 */
		public function draw():void
		{
		
		}
		
		/**
		 * Abstract position() function.
		 */
		public function position():void
		{
			
		}
		
		/**
		 * Abstract function to handle action based input.
		 * @param	action String: Action to preform.
		 * @param	index Number: Differs depending on the action. For actions left, right, up, down: Used as the index to determine the the next item to highlight. Where index 0 is the closest.
		 */
		public function doInputNavigation(action:String, index:Number = 0):void 
		{
			if (INPUT_DISABLED)
				return
				
			FormManager.handleAction(action, index);
		}
		
		public function get INPUT_DISABLED():Boolean
		{
			return _INPUT_DISABLED || SCENE_SWITCHING;
		}
		
		public function set INPUT_DISABLED(val:Boolean):void
		{
			_INPUT_DISABLED = val;
		}
		
		/**
		 * Returns the constructor class name.
		 */
		public function get class_name():String
		{
			var t:String = (Object(this).constructor).toString();
			return t.substr(7, t.length - 8);
		}
	}
}