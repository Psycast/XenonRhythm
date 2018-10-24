package classes.ui
{
	import by.blooddy.crypto.MD5;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import scenes.home.SceneTitleScreen;
	import scenes.songselection.SceneSongSelection;
	
	public class FormManager
	{
		/** Dictionay contain form groups. */
		public static var groups:Dictionary = new Dictionary();
		
		/** The current active form group. */
		public static var active_group:FormItems;
		
		//------------------------------------------------------------------------------------------------//
		
		/**
		 * Creates a new group for the scene. Sets the active group to the created group if none previously set.
		 * @param	scene Scene to register the group to.
		 * @param	group_name Group Name to create.
		 * @param	wrap_mode Sets the wrap mode for groups. Default: UIAnchor.WRAP_BOTH. Uses UIAnchor constants. (LEFT, RIGHT, TOP, BOTTOM, WRAP_VERTICAL, WRAP_HORIZONTAL, WRAP_BOTH)
		 * @param	activation_mode Sets the activation mode for groups. Default: FormItems.MODE_BOTH. Uses FormItems constants. (NONE, ACTIVATION, DEACTIVATION, MODE_BOTH)
		 */
		static public function registerGroup(scene:UICore, group_name:String, wrap_mode:uint = 45, activation_mode:uint = 3):FormItems
		{
			removeGroup(scene, group_name);
			
			groups[scene.class_name + "_" + group_name] = new FormItems(scene, group_name, wrap_mode, activation_mode);
			
			// Set Active Group if not set.
			if (active_group == null)
				active_group = groups[scene.class_name + "_" + group_name];
			
			//Logger.log("FormManager", Logger.INFO, "Registered group: " + (scene.class_name + "_" + group_name));
			return getGroup(scene, group_name);
		}
		
		/**
		 * Removes a group from the scene.
		 * @param	scene Scene to use for list.
		 * @param	group_name Group name to remove.
		 */
		static public function removeGroup(scene:UICore, group_name:String):void
		{
			var item:FormItems;
			if ((item = getGroup(scene, group_name)) != null)
			{
				// Clear Active Group
				if (active_group == item)
					active_group = null;
				
				//Logger.log("FormManager", Logger.INFO, "Removed group: " + (scene.class_name + "_" + group_name));
				delete groups[scene.class_name + "_" + group_name];
			}
		}
		
		/**
		 * Removes all groups from the scene. Clears the active group if removed.
		 * @param	scene Scene to use for the list.
		 */
		static public function unregisterAll(scene:UICore):void
		{
			//Logger.log("FormManager", Logger.INFO, "Removed All Groups for: " + scene.class_name);
			for each (var item:FormItems in groups)
			{
				if (item.owner == scene)
				{
					if (item == active_group)
						active_group = null;
					
					delete groups[item.name];
				}
			}
		}
		
		/**
		 * Gets a FormItems object match the scene and group name.
		 * @param	scene Scene to use for the list.
		 * @param	group_name Group name for list.
		 * @return FormItems or Null if no group found.
		 */
		static public function getGroup(scene:UICore, group_name:String):FormItems
		{
			if (groups[scene.class_name + "_" + group_name] != null)
				return groups[scene.class_name + "_" + group_name] as FormItems;
			
			return null;
		}
		
		/**
		 * Selects a form group, deactivating the last group is needed and sets the active group.
		 * @param	scene  Scene to use for the list.
		 * @param	group_name Group Name for list.
		 * @return FormItems: The selected group or Null is not group found.
		 */
		static public function selectGroup(group_name:String, scene:UICore = null):FormItems
		{
			var g:FormItems;
			if ((g = getGroup(scene ? scene : active_group.owner, group_name)) != null)
			{
				if (g == active_group)
					return active_group;
					
				if (active_group)
					active_group.deactivate();
				
				active_group = g;
				active_group.activate();
				return active_group;
			}
			return null;
		}
		
		/**
		 * Adds a UIComponent to a FormItems group. By default this will use the active groups UICore group list.
		 * @param	component Component to add to Group
		 * @param	group_name Group name
		 * @param	scene Optional: UICore to use as owner for group.
		 * @return FormItems component was added to or Null if no group found.
		 */
		static public function addToGroup(component:UIComponent, group_name:String, scene:UICore = null):FormItems
		{
			if (!scene && (!active_group || !active_group.owner))
				return null;
				
			if (getGroup(scene ? scene : active_group.owner, group_name) != null)
			{
				var item:FormItems = getGroup(scene ? scene : active_group.owner, group_name) as FormItems;
				item.items.push(component);
				return item;
			}
			return null;
		}
		
		/**
		 * Handles an action for forms. This can either be movement around the forms or simulating certain input.
		 * @param	action Action to handle.
		 * @param	index
		 * @return  UIComponent of the new highlight item for movement actions. Null for anything else.
		 */
		static public function handleAction(action:String, index:Number = 0):UIComponent
		{
			if (!active_group || active_group.items.length == 0)
				return null;
			
			// Get Highlighted Item
			var highlight_item:UIComponent = active_group.getHighlightItem();
			
			if (!highlight_item)
				return null;
			
			if (action == "click")
				highlight_item.doClickEvent();
			
			// Do Move Action
			else if (_isDirection(action))
			{
				var searchPoint:Point = new Point(highlight_item.x, highlight_item.y);
				
				var validItems:Vector.<UIComponent>;
				
				switch (action)
				{
				case "up": 
					validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
					{
						return !item.highlight && item.enabled && item.y < searchPoint.y;
					});
					
					if (validItems.length == 0)
					{
						// Wrap Top
						if (active_group.wrap_mode & UIAnchor.TOP)
						{
							searchPoint.y = active_group.bottom;
							validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
							{
								return !item.highlight && item.enabled && item.y < searchPoint.y;
							});
						}
						
						// Find Next Form Group Above
						if (validItems.length == 0)
							return _getNewFormGroup(UIAnchor.TOP);
					}
					break;
				case "down": 
					validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
					{
						return !item.highlight && item.enabled && item.y > searchPoint.y;
					});
					
					if (validItems.length == 0)
					{
						// Wrap Bottom
						if (active_group.wrap_mode & UIAnchor.BOTTOM)
						{
							searchPoint.y = active_group.top - 1;
							validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
							{
								return !item.highlight && item.enabled && item.y > searchPoint.y;
							});
						}
						
						// Find Next Form Group Below
						if (validItems.length == 0)
							return _getNewFormGroup(UIAnchor.BOTTOM);
					}
					break;
				case "left": 
					validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
					{
						return !item.highlight && item.enabled && item.x < searchPoint.x;
					});
					
					// Wrap Left
					if (validItems.length == 0)
					{
						if (active_group.wrap_mode & UIAnchor.LEFT)
							
						{
							searchPoint.x = active_group.right;
							validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
							{
								return !item.highlight && item.enabled && item.x < searchPoint.x;
							});
						}
						
						// Find Next Form Group Left
						if (validItems.length == 0)
							return _getNewFormGroup(UIAnchor.LEFT);
					}
					break;
				case "right": 
					validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
					{
						return !item.highlight && item.enabled && item.x > searchPoint.x;
					});
					
					// Wrap Right
					if (validItems.length == 0)
					{
						if (active_group.wrap_mode & UIAnchor.RIGHT)
						{
							searchPoint.x = active_group.left - 1;
							validItems = active_group.items.filter(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean
							{
								return !item.highlight && item.enabled && item.x > searchPoint.x;
							});
						}
						
						// Find Next Form Group Right
						if (validItems.length == 0)
							return _getNewFormGroup(UIAnchor.RIGHT);
					}
					break;
				}
				if (validItems.length > 0)
				{
					validItems.sort(function(item1:UIComponent, item2:UIComponent):Number
					{
						var d1:Number = _distanceItem(searchPoint, item1);
						var d2:Number = _distanceItem(searchPoint, item2);
						return d1 - d2;
					});
					
					var arr_index:int = Math.min(validItems.length - 1, index);
					active_group.setHighlightItem(validItems[arr_index]);
					
					return validItems[arr_index];
				}
			}
			
			return null;
		}
		
		/**
		 * Sets the highlight of a UIComponent. This also changes the active group to the group containing the highlight item.
		 * @param	group_name
		 * @param	highlight_item
		 * @param	scene
		 */
		static public function setHighlight(group_name:String, highlight_item:UIComponent, scene:UICore = null):void
		{
			if (getGroup(scene ? scene : active_group.owner, group_name) != null)
			{
				// Set Active Group
				if (active_group.name != group_name)
					active_group = getGroup(scene ? scene : active_group.owner, group_name);
				
				active_group.setHighlightItem(highlight_item);
			}
		}
		
		/**
		 * Gets the last highlited item from the active group.
		 * @return UIComponent that was highlighted, or null if not set.
		 */
		static public function getLastHighlight():UIComponent 
		{
			if (active_group && active_group.last_highlight)
				return active_group.last_highlight;
				
			return null;
		}
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Measures the distance between a point and a UIComponent coords.
		 * @param	point
		 * @param	item
		 * @return Distance in pixels between the Point and UIComponent.
		 */
		static private function _distanceItem(point:Point, item:UIComponent):Number
		{
			var dx:Number = point.x - item.x;
			var dy:Number = point.y - item.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Find the next FormGroup in the requested direction.
		 * @param	direction UIAnchor constants. (LEFT,RIGHT,TOP,BOTTOM)
		 * @return null
		 */
		static private function _getNewFormGroup(direction:int):UIComponent
		{
			var pos:Number;
			var newGroup:FormItems;
			var item:FormItems;
			var validItems:Vector.<FormItems> = new Vector.<FormItems>();
			
			switch (direction)
			{
			case UIAnchor.LEFT: 
				pos = active_group.g_left;
				for each (item in groups)
					if (item.g_left < pos)
						validItems.push(item);
				break;
			case UIAnchor.RIGHT: 
				pos = active_group.g_right;
				for each (item in groups)
					if (item.g_right > pos)
						validItems.push(item);
				break;
			case UIAnchor.TOP: 
				pos = active_group.g_top;
				for each (item in groups)
					if (item.g_top < pos)
						validItems.push(item);
				break;
			case UIAnchor.BOTTOM: 
				pos = active_group.g_bottom;
				for each (item in groups)
					if (item.g_bottom > pos)
						validItems.push(item);
				break;
			}
			if (validItems.length > 0)
			{
				var origin:Point = active_group.getCenterPoint();
				validItems.sort(function(item1:FormItems, item2:FormItems):Number
				{
					return Point.distance(origin, item1.getCenterPoint()) - Point.distance(origin, item2.getCenterPoint());
				});
				
				active_group.deactivate();
				
				active_group = validItems[0];
				active_group.activate();
			}
			return null;
		}
		
		
		/**
		 * Determines of an action is a direction.
		 * @param	action Action to check against.
		 */
		static private function _isDirection(action:String):Boolean 
		{
			return action == "up" || action == "down" || action == "left" || action == "right";
		}
		
		
		CONFIG::debug
		{
			static private var debugSprite:Sprite;
			
			static public function debugFormViewerSprite():Sprite
			{
				debugUpdate();
				return debugSprite;
			}
			
			static public function debugUpdate():void
			{
				if (!debugSprite)
				{
					debugSprite = new Sprite();
					debugSprite.mouseEnabled = false;
				}
				debugSprite.graphics.clear();
				for each (var item:FormItems in groups)
				{
					var color:uint = parseInt("0x" + MD5.hash(item.name).substr(0, 6));
					var rect:Rectangle = item.getBoundsGlobal();
					debugSprite.graphics.lineStyle(2, color, 1, true);
					debugSprite.graphics.beginFill(0, 0);
					debugSprite.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					debugSprite.graphics.endFill();
				}
			}
		}
	
	}
}