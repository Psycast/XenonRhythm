package classes.ui
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FormItems
	{
		public static const NONE:uint = 0;
		public static const ACTIVATION:uint = 1;
		public static const DEACTIVATION:uint = 2;
		public static const MODE_BOTH:uint = 3;
		
		/** UICore / Scene Owner for Form Group */
		public var owner:UICore;
		
		/** Scene + Group Name */
		public var name:String;
		
		/** Group Name */
		public var group_name:String;
		
		/** UIComponents for Form Group */
		public var items:Vector.<UIComponent>;
		
		/** Wrap Mode, uses UIAnchor constants. (LEFT, RIGHT, TOP, BOTTOM, WRAP_VERTICAL, WRAP_HORIZONTAL, WRAP_BOTH) */
		public var wrap_mode:uint = UIAnchor.NONE;
		
		/** ScrollPane for Group, this overrides the global bounds of the group to allow better navigation from form group to form group. Only set with setClipFromComponent()  */
		private var _parent_component:UIComponent;

		private var _handleAction:Function;
		
		/**
		 * Activation Mode:
		 * - NONE: Ignore activate() and deactivate() calls. 
		 * - ACTIVATION: Allow only activate().
		 * - DEACTIVATION: Allow only deactivate().
		 * - BOTH: Allow both activate() and deactivate().
		 */
		public var activation_mode:uint = MODE_BOTH;
		
		/** Last Highlight UIComponent */
		public var last_highlight:UIComponent;
		
		//------------------------------------------------------------------------------------------------//

		/**
		 * Creates a new Form Group. This keeps track of UIComponent of this group and provides function for get the highlighted object or the overall bounds for the form group.
		 * @param	owner UICore / Scene Owner.
		 * @param	group_name Group Name for group.
		 * @param	wrap_mode Uses UIAnchor constants. (LEFT, RIGHT, TOP, BOTTOM, WRAP_VERTICAL, WRAP_HORIZONTAL, WRAP_BOTH)
		 */
		public function FormItems(owner:UICore, group_name:String, wrap_mode:uint = 0, activation_mode:uint = 0)
		{
			this.owner = owner;
			this.group_name = group_name;
			this.name = owner.class_name + "_" + group_name;
			this.wrap_mode = wrap_mode;
			this.activation_mode = activation_mode;
			items = new <UIComponent>[];
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Activates a form group, highlighting the last highlight item if set or the first item in the group.
		 */
		public function activate():void
		{
			if (activation_mode & ACTIVATION)
			{
				if (last_highlight == null && items.length > 0) {
					last_highlight = getHighlightItem();
					
					if(last_highlight == null)
						last_highlight = items[0];
				}
					
				if(last_highlight != null)
					last_highlight.highlight = true;
			}
		}
		
		/**
		 * Deactivates a form group, unhighlights all items.
		 */
		public function deactivate():void
		{
			if (activation_mode & DEACTIVATION)
			{
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.highlight)
						item.highlight = false;
				});
			}
		}
		
		/**
		 * Gets the highlighted item. If multiple are highlighted, only first item is return and the rest are unhighlighted.
		 * @return Highlighted UIComponent.
		 */
		public function getHighlightItem():UIComponent
		{
			if (last_highlight == null)
			{
				var highlight_items:Vector.<UIComponent> = items.filter(_highlightFilter);
				if (highlight_items.length > 0) {
					last_highlight = highlight_items[0];
					
					// Unhighlight everything besides the first item.
					if (highlight_items.length > 1)
						setHighlightItem(highlight_items[0]);
						
					return highlight_items[0];
				}
			}
			return last_highlight;
		}
		
		/**
		 * Sets the highlight item for the form group. This also sets the last_highlight to the item as well.
		 * @param	highlight_item
		 */
		public function setHighlightItem(highlight_item:UIComponent):void 
		{
			items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
				if (item.highlight)
					item.highlight = false;
			});
			highlight_item.highlight = true;
			last_highlight = highlight_item;
		}
		
		// Get Bound Variables
		/**
		 * Gets the Bottom most point of the form group.
		 */
		public function get bottom():Number
		{
			var my:Number = Number.NEGATIVE_INFINITY;
			if(items.length > 0) {
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.y + item.height > my)
						my = item.y + item.height;
				});
			}
			return my;
		}
		
		/**
		 * Gets the upper most / Top point of the form group.
		 */
		public function get top():Number
		{
			var my:Number = Number.POSITIVE_INFINITY;
			if(items.length > 0) {
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.y < my)
						my = item.y;
				});
			}
			return my;
		}
		
		/**
		 * Gets the Left most point of the form group.
		 */
		public function get left():Number
		{
			var mx:Number = Number.POSITIVE_INFINITY;
			if(items.length > 0) {
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.x < mx)
						mx = item.x;
				});
			}
			return mx;
		}
		
		/**
		 * Gets the Right most point of the form group.
		 */
		public function get right():Number
		{
			var mx:Number = Number.NEGATIVE_INFINITY;
			if(items.length > 0) {
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.x + item.width > mx)
						mx = item.x + item.width;
				});
			}
			return mx;
		}
		/**
		 * Gets the Global Bottom most point of the form group.
		 */
		public function get g_bottom():Number
		{
			var my:Number = Number.NEGATIVE_INFINITY;
			if (items.length > 0) {
				var ei:UIComponent;
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.real_y + item.height > my) {
						my = item.real_y + item.height;
						ei = item;
					}
				});
				my = ei.parent.localToGlobal(new Point(0, my)).y;
			}
			return my;
		}
		
		/**
		 * Gets the upper most / Top point of the form group.
		 */
		public function get g_top():Number
		{
			var my:Number = Number.POSITIVE_INFINITY;
			if(items.length > 0) {
				var ei:UIComponent;
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.real_y < my) {
						my = item.real_y;
						ei = item;
					}
				});
				my = ei.parent.localToGlobal(new Point(0, my)).y;
			}
			return my;
		}
		
		/**
		 * Gets the Left most point of the form group.
		 */
		public function get g_left():Number
		{
			var mx:Number = Number.POSITIVE_INFINITY;
			if(items.length > 0) {
				var ei:UIComponent;
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.real_x < mx) {
						mx = item.real_x;
						ei = item;
					}
				});
				mx = ei.parent.localToGlobal(new Point(mx, 0)).x;
			}
			return mx;
		}
		
		/**
		 * Gets the Right most point of the form group.
		 */
		public function get g_right():Number
		{
			var mx:Number = Number.NEGATIVE_INFINITY;
			if(items.length > 0) {
				var ei:UIComponent;
				items.forEach(function(item:UIComponent, index:int, vector:Vector.<UIComponent>):void {
					if (item.real_x + item.width > mx) {
						mx = item.real_x + item.width;
						ei = item;
					}
				});
				mx = ei.parent.localToGlobal(new Point(mx, 0)).x;
			}
			return mx;
		}
		
		/**
		 * Gets the local bounds of the group. This may be inaccurate if the group elements are across multiple parents.
		 * @return Rectangle of the bounds.
		 */
		public function getBounds():Rectangle
		{
			var _x:Number = this.left;
			var _y:Number = this.top;
			var _width:Number = this.right - _x;
			var _height:Number = this.bottom - _y;
			
			return new Rectangle(_x, _y, _width, _height);
		}
		
		/**
		 * Gets the stage bounds of the group. This may be inaccurate if the group elements are across multiple parents.
		 * @return Rectrangle of the bounds.
		 */
		public function getBoundsGlobal():Rectangle
		{
			if (_parent_component)
				return getClipBounds();
			
			var _x:Number = this.g_left;
			var _y:Number = this.g_top;
			var _width:Number = this.g_right - _x;
			var _height:Number = this.g_bottom - _y;
			
			return new Rectangle(_x, _y, _width, _height);
		}
		
		/**
		 * Gets the center point of the FormItems based on global bounds.
		 * @return Point of center.
		 */
		public function getCenterPoint():Point
		{
			var bounds:Rectangle = (_parent_component ? getClipBounds() : getBoundsGlobal());
			
			return new Point(bounds.x + (bounds.width / 2), bounds.y + (bounds.height / 2));
		}
		
		/**
		 * Gets the global bounds when a parent scrollpane is set using the scrollRect, or the clipping area of the scrollpane.
		 * @return
		 */
		private function getClipBounds():Rectangle 
		{
			var gp:Point = _parent_component.localToGlobal(new Point(_parent_component.scrollRect.x, _parent_component.scrollRect.y));
			return new Rectangle(gp.x, gp.y, _parent_component.scrollRect.width, _parent_component.scrollRect.height);
		}
		
		/**
		 * Sets the FormItems to use as an override for the global bounds, this will make 
		 * the getBoundsGlobal() and getCenterPoint() use the global position of the clipping
		 * bounds instead of the actual position and dimensions of the form group.
		 * @param	comp Component to use as an override.
		 */
		public function setClipFromComponent(comp:UIComponent):void 
		{
			_parent_component = comp;
		}

		/**
		 * Sets a custom handler for actions. This is called in FormManger with the following
		 * arguments pass onto the handler function: (active_group, action, index)
		 * This function is expected to return an array containing 2 elements.
		 * 
		 * The first is a boolean, if true the handler will return the UIComponent found in element 2.
		 * If the value is false, then the FormManger will continue with it's normal operation.
		 * 
		 * example: [true, items[0]]
		 * @param func Call Function
		 */
		public function setHandleAction(func:Function):void
		{
			_handleAction = func;
		}
		
		/**
		 * Get Custom Handler Function.
		 * @return 
		 */
		public function getHandleAction():Function
		{
			return _handleAction;
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Filter function for getHighlightItem().
		 */
		private static function _highlightFilter(item:UIComponent, index:int, vector:Vector.<UIComponent>):Boolean {
			return item.highlight;
		}
	}
}