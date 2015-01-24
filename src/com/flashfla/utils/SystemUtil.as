package com.flashfla.utils {
	import flash.system.Capabilities;
	
	public class SystemUtil {
		public static var OS:String;
		public static var flashMajorVersion:int;
		public static var flashMinorVersion:int;
		public static var flashBuildVersion:int;
		
		private static var isLoaded:Boolean = false;
		
		public static function init():void {
			// Get the player’s version by using the flash.system.Capabilities class.
			var versionNumber:String = Capabilities.version;
			
			// The version number is a list of items divided by ","
			var versionArray:Array = versionNumber.split(",");
			
			// The main version contains the OS type too so we split it in two
			// and we’ll have the OS type and the major version number separately.
			var platformAndVersion:Array = versionArray[0].split(" ");
			
			OS = platformAndVersion[0];
			flashMajorVersion = parseInt(platformAndVersion[1]);
			flashMinorVersion = parseInt(versionArray[1]);
			flashBuildVersion = parseInt(versionArray[2]);
			isLoaded = true;
		}
		
		public static function getMajorVersion():int {
			if (!isLoaded)
				init();
			return flashMajorVersion;
		}
		
		public static function getMinorVersion():int {
			if (!isLoaded)
				init();
			return flashMinorVersion;
		}
		
		public static function getBuildVersion():int {
			if (!isLoaded)
				init();
			return flashBuildVersion;
		}
		
		public static function getOS():String {
			if (!isLoaded)
				init();
			return OS;
		}
		
		public static function getFlashVersion():Object {
			if (!isLoaded)
				init();
				
			return {os: OS, major: flashMajorVersion, minor: flashMinorVersion, build: flashBuildVersion};
		}
		
		public static function isFlashNewerThan(major:int, minor:int = 0, build:int = 0):Boolean {
			if (!isLoaded)
				init();
			if (flashMajorVersion > major)
				return true;
			if (flashMajorVersion < major)
				return false;
			
			if (minor <= 0)
				return true;
			if (flashMinorVersion < minor)
				return false;
			if (build <= 0)
				return true;
			if (flashBuildVersion >= build)
				return true;
			
			return false;
		}
	}
}
