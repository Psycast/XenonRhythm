package com.flashfla.utils {
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectUtil {
		public static function clone(o:Object):Object {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(o);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * An equivalent of PHP's recursive print function print_r, which displays objects and arrays in a way that's readable by humans
		 * @param obj    Object to be printed
		 * @param level  (Optional) Current recursivity level, used for recursive calls
		 * @param output (Optional) The output, used for recursive calls
		 */
		public static function print_r(obj:*, level:int = 0, output:String = ''):* {
			if (level == 0)
				output = '(' + ObjectUtil.typeOf(obj) + ') {\n';
			else if (level == 10)
				return output;
			
			var tabs:String = '    ';
			for (var i:int = 0; i < level; i++, tabs += '    ') { }
			
			for (var child:*in obj) {
				output += tabs + '[' + child + '] => (' + ObjectUtil.typeOf(obj[child]) + ') ';
				//output += tabs +'['+ child +'] => ';
				
				if (ObjectUtil.count(obj[child]) == 0) {
					if (ObjectUtil.typeOf(obj[child]) == "string")
						output += "\"" + obj[child] + "\"";
					else if (ObjectUtil.typeOf(obj[child]) == "number")
						output += obj[child] + " [0x" + Number(obj[child]).toString(16) + "]";
					else
						output += obj[child];
				}
				
				var childOutput:String = '';
				if (typeof obj[child] != 'xml') {
					childOutput = ObjectUtil.print_r(obj[child], level + 1);
				}
				
				if (childOutput != '') {
					//output += '(' + ObjectUtil.typeOf(obj[child]) + ') {\n' + childOutput + tabs + '}';
					output += '{\n' + childOutput + tabs + '}';
				}
				output += '\n';
			}
			
			if (level == 0)
				return output + '}\n';
			else
				return output;
		}
		
		/**
		 * An extended version of the 'typeof' function
		 * @param 	variable
		 * @return	Returns the type of the variable
		 */
		public static function typeOf(variable:*):String {
			if (variable is Array)
				return 'array';
			else if (variable is Date)
				return 'date';
			else
				return typeof variable;
		}
		
		
		public static function getClass(obj:Object):Class {
			return Object(obj).constructor;
		}
		
		/**
		 * Returns the size of an object
		 * @param obj Object to be counted
		 */
		public static function count(obj:Object):uint {
			if (ObjectUtil.typeOf(obj) == 'array')
				return obj.length;
			else {
				var len:uint = 0;
				for (var item:*in obj) {
					if (item != 'mx_internal_uid')
						len++;
				}
				return len;
			}
		}
		
		/**
		 * Returns an object with all class variables and accessors.
		 * @param	clazz Class of object to get all variables and accessor.
		 * @return	Object containing all variables and accessors.
		 */
		public static function get_class_variables(clazz:*):Object
		{
			var output:Object = { };
			var type:Class = getDefinitionByName(getQualifiedClassName(clazz)) as Class;
			var description:XML = describeType(type);
			for each(var category:XML in description.children())
			{
				for each(var node:XML in category.children())
				{
					if (node.@access.toString() != "writeonly" && (node.localName() == "variable" || node.localName() == "accessor"))
					{
						output[node.@name] = { "name": node.@name.toString(), "value": clazz[node.@name], "type": node.localName() } ;
						
						if(node.@type != null)
							output[node.@name]["class"] = node.@type.toString();
					}
				}
			}
			return output;
		}
		
		/**
		 * Return a gradient given a colour.
		 *
		 * @param color      Base color of the gradient.
		 * @param intensity  Amount to shift secondary color.
		 * @return An array with a length of two colors.
		 */
		public static function fadeColour(color:uint, intensity:int = 20):Array
		{
			var c:Object = hexToRGB(color);
			for (var key:String in c)
			{
				c[key] = Math.max(Math.min(c[key] + intensity, 255), 0);
			}
			return [color, RGBToHex(c)];
		}
		
		/**
		 * Interpolates between 2 given colours based on the percentage.
		 * @param	fromColor
		 * @param	toColor
		 * @param	progress
		 * @return
		 */
		public static function interpolateColour(fromColour:uint, toColour:uint, progress:Number):uint
		{
			var q:Number = 1 - progress;
			var fromA:uint = (fromColour >> 24) & 0xFF;
			var fromR:uint = (fromColour >> 16) & 0xFF;
			var fromG:uint = (fromColour >> 8) & 0xFF;
			var fromB:uint = fromColour & 0xFF;
			
			var toA:uint = (toColour >> 24) & 0xFF;
			var toR:uint = (toColour >> 16) & 0xFF;
			var toG:uint = (toColour >> 8) & 0xFF;
			var toB:uint = toColour & 0xFF;
			
			var resultA:uint = fromA * q + toA * progress;
			var resultR:uint = fromR * q + toR * progress;
			var resultG:uint = fromG * q + toG * progress;
			var resultB:uint = fromB * q + toB * progress;
			return (resultA << 24 | resultR << 16 | resultG << 8 | resultB);
		}
		
		/**
		 * Convert a uint (0x000000) to a colour object.
		 *
		 * @param hex  Colour.
		 * @return Converted object {r:, g:, b:}
		 */
		public static function hexToRGB(hex:uint):Object
		{
			var c:Object = {};
			
			c.a = hex >> 24 & 0xFF;
			c.r = hex >> 16 & 0xFF;
			c.g = hex >> 8 & 0xFF;
			c.b = hex & 0xFF;
			
			return c;
		}
		
		/**
		 * Convert a colour object to uint octal (0x000000).
		 *
		 * @param c  Colour object {r:, g:, b:}.
		 * @return Converted colour uint (0x000000).
		 */
		public static function RGBToHex(c:Object):uint
		{
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, c.r, c.g, c.b, 100);
			return ct.color as uint
		}
	
	}
}