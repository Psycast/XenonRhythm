package com.flashfla.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class SpriteUtil
	{
		
		public static function setRegistrationPoint(s:DisplayObject, regx:Number, regy:Number):void
		{
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
		}
		
		public static function getAbsolutePosition(t:DisplayObject):Object
		{
			var aX:Number = t.x;
			var aY:Number = t.y;
			if (t.stage == null)
				return {x: aX, y: aY};
			
			var p:DisplayObjectContainer = t.parent;
			while (!(p is Stage))
			{
				aX += p.x;
				aY += p.y;
				p = p.parent;
			}
			return {x: aX, y: aY};
		}
		
		public static function isVisible(t:DisplayObject):Boolean
		{
			if (t.stage == null)
				return false;
			
			var p:DisplayObjectContainer = t.parent;
			while (!(p is Stage))
			{
				if (!p.visible)
					return false;
				p = p.parent;
			}
			return true;
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