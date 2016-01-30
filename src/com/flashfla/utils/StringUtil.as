/**
 * @author Jonathan (Velocity)
 */

package com.flashfla.utils {
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	public class StringUtil {
		public static const KEY_ARRAY:Array = [
			"", "", "", "", "", "", "", "", "Backspace", "", "", "", "", 
			"Enter", "", "", "Shift", "Ctrl", "Alt", "Pause", "Capslock", 
			"", "", "", "", "", "", "Esc", "", "", "", "", "Space", "PgUp", 
			"PgDown", "End", "Home", "Left", "Up", "Right", "Down", "", "", 
			"", "", "Insert", "Delete", "", "0", "1", "2", "3", "4", "5", "6", 
			"7", "8", "9", "", "", "", "", "", "", "", "A", "B", "C", "D", 
			"E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", 
			"R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", "", "", 
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "+", "", "-", ".", "/", 
			"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", 
			"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"", "", "Sc Lk", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"", "", "", "", "", "", "", "", "", ";", "=", ", ", "-", ".", "/", 
			"`", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"", "", "", "", "", "", "", "", "", "", "[", "\\", "]", "'"
		];
		
		public static const STR_PAD_LEFT:String = "LeftPad";
		public static const STR_PAD_RIGHT:String = "RightPad";
		
		public static function fromCharArray(hexArray:Array):String {
			var output:String = "";
			for each (var char:uint in hexArray) {
				output += String.fromCharCode(char);
			}
			return output;
		}
		
		public static function toHex(input:String):String {
			var out:String = "";
			for (var c:uint = 0; c < input.length; c++) {
				out += "0x" + pad(Number(input.charCodeAt(c)).toString(16).toUpperCase(), 2, "0", STR_PAD_LEFT) + ",";
			}
			return out.substr(0, out.length - 1);
		}
		
		public static function pad(input:String, pad_length:uint, pad_string:String = " ", pad_type:String = null):String {
			var ret:String = input;
			
			if (pad_type == null)
				pad_type = STR_PAD_LEFT;
				
			if (pad_string == "")
				return input;
				
			if (pad_type == STR_PAD_LEFT)
				while (ret.length < pad_length)
					ret = pad_string + ret;
			
			else if (pad_type == STR_PAD_RIGHT)
				while (ret.length < pad_length)
					ret += pad_string;
			
			return ret;
		}
		
		public static function upperCase(str:String) : String {
			return str.substr(0, 1).toUpperCase() + str.substr(1, str.length);
		}
		
		public static function keyCodeChar(input:uint):String {
			return KEY_ARRAY[input] || ("[" + input.toString() + "]");
		}
		
		public static function htmlEscape(str:String):String {
			return XML( new XMLNode( XMLNodeType.TEXT_NODE, str ) ).toXMLString();
		}
		
		public static function getURLPieces(urlStr:String):Array {
			return splitMultiple(urlStr.replace(/http(s|):\/\//, "").toLowerCase(), ["/", ".", "?", "&", "="]);
		}
		
		public static function splitMultiple(str:String, delimiters:Array):Array {
			if (delimiters.length > 1) {
				for (var i:int = 1; i < delimiters.length; i++) {
					str = str.split(delimiters[i]).join(delimiters[0]);
				}
			}
			return str.split(delimiters[0]);
		}
		
		/**
		*	Does a case insensitive compare or two strings and returns true if
		*	they are equal.
		* 
		*	@param s1 The first string to compare.
		*
		*	@param s2 The second string to compare.
		*
		*	@returns A boolean value indicating whether the strings' values are 
		*	equal in a case sensitive compare.	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function stringsAreEqual(s1:String, s2:String, 
											caseSensitive:Boolean):Boolean
		{
			if(caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}
		
		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		* 
		*	@param input The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns A String with whitespace removed from the begining and end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function trim(input:String):String
		{
			return ltrim(rtrim(input));
		}

		/**
		*	Removes whitespace from the front of the specified string.
		* 
		*	@param input The String whose beginning whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the begining	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		*	Removes whitespace from the end of the specified string.
		* 
		*	@param input The String whose ending whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}

		/**
		*	Determines whether the specified string begins with the spcified prefix.
		* 
		*	@param input The string that the prefix will be checked against.
		*
		*	@param prefix The prefix that will be tested against the string.
		*
		*	@returns True if the string starts with the prefix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0, prefix.length));
		}	

		/**
		*	Determines whether the specified string ends with the spcified suffix.
		* 
		*	@param input The string that the suffic will be checked against.
		*
		*	@param prefix The suffic that will be tested against the string.
		*
		*	@returns True if the string ends with the suffix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}	

		/**
		*	Removes all instances of the remove string in the input string.
		* 
		*	@param input The string that will be checked for instances of remove
		*	string
		*
		*	@param remove The string that will be removed from the input string.
		*
		*	@returns A String with the remove string removed.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function remove(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}

		/**
		*	Replaces all instances of the replace string in the input string
		*	with the replaceWith string.
		* 
		*	@param input The string that instances of replace string will be 
		*	replaces with removeWith string.
		*
		*	@param replace The string that will be replaced by instances of 
		*	the replaceWith string.
		*
		*	@param replaceWith The string that will replace instances of replace
		*	string.
		*
		*	@returns A new String with the replace string replaced with the 
		*	replaceWith string.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:Number = input.length;
			var rLen:Number = replace.length;

			for (var i:Number = 0; i < sLen; i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for(var j:Number = 0; j < rLen; j++)
					{
						if(!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if(found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			return sb;
		}
		
		static public function containsHtml(text:String):Boolean 
		{
			return text && (text.indexOf("<") >= 0 && text.indexOf(">") >= 0 && text.indexOf("</") >= 0);
		}
	}
}
