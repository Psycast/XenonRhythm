package com.flashfla.media
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SwfParser
	{
		public static const SWF_TAG_END:int = 0;
		public static const SWF_TAG_SHOWFRAME:int = 1;
		public static const SWF_TAG_DOACTION:int = 12;
		public static const SWF_TAG_DEFINESOUND:int = 14;
		public static const SWF_TAG_STREAMHEAD:int = 18;
		public static const SWF_TAG_STREAMBLOCK:int = 19;
		public static const SWF_TAG_STREAMHEAD2:int = 45;
		public static const SWF_TAG_FILEATTRIBUTES:int = 69;
		
		public static const SWF_ACTION_END:int = 0x00;
		public static const SWF_ACTION_CONSTANTPOOL:int = 0x88;
		public static const SWF_ACTION_PUSH:int = 0x96;
		public static const SWF_ACTION_POP:int = 0x17;
		public static const SWF_ACTION_DUPLICATE:int = 0x4C;
		public static const SWF_ACTION_STORE_REGISTER:int = 0x87;
		public static const SWF_ACTION_GET_VARIABLE:int = 0x1C;
		public static const SWF_ACTION_SET_VARIABLE:int = 0x1D;
		public static const SWF_ACTION_INIT_ARRAY:int = 0x42;
		public static const SWF_ACTION_GET_MEMBER:int = 0x4E;
		public static const SWF_ACTION_SET_MEMBER:int = 0x4F;
		
		public static const SWF_TYPE_STRING_LITERAL:int = 0;
		public static const SWF_TYPE_FLOAT_LITERAL:int = 1;
		public static const SWF_TYPE_NULL:int = 2;
		public static const SWF_TYPE_UNDEFINED:int = 3;
		public static const SWF_TYPE_REGISTER:int = 4;
		public static const SWF_TYPE_BOOLEAN:int = 5;
		public static const SWF_TYPE_DOUBLE:int = 6;
		public static const SWF_TYPE_INTEGER:int = 7;
		public static const SWF_TYPE_CONSTANT8:int = 8;
		public static const SWF_TYPE_CONSTANT16:int = 9;
		
		public static const SWF_CODEC_MP3:int = 2;
		
		public static function readHeader(data:ByteArray):Object
		{
			data.endian = Endian.LITTLE_ENDIAN;
			if (isCompressed(data))
				uncompress(data);
			
			var ret:Object = new Object();
			
			data.position = 3;
			ret.version = data.readUnsignedByte();
			ret.size = data.readInt();
			
			// SWF Rectangle
			data.position += (4 * (data.readUnsignedByte() >>> 3) - 3 + 7) / 8 + 1;
			
			ret.frameRate = data.readUnsignedShort();
			ret.frameCount = data.readUnsignedShort();
			
			return ret;
		}
		
		public static function readTag(data:ByteArray):Object
		{
			var ret:Object = new Object();
			ret.oldposition = data.position;
			var tag:int = data.readUnsignedShort();
			var len:uint = tag & 0x3f;
			ret.tag = (tag >>> 6);
			ret.length = (len == 0x3f ? data.readUnsignedInt() : len);
			ret.position = data.position;
			return ret;
		}
		
		public static function writeTag(data:ByteArray, tag:uint, length:uint = 0):void
		{
			data.writeShort(((tag << 6) & 0xffc0) | (length < 0x3f ? length : 0x3f));
			if (length >= 0x3f)
				data.writeUnsignedInt(length);
		}
		
		public static function readAction(data:ByteArray):Object
		{
			var ret:Object = new Object();
			ret.oldposition = data.position;
			ret.action = data.readUnsignedByte();
			ret.length = (ret.action & 0x80) ? data.readUnsignedShort() : 0;
			ret.position = data.position;
			return ret;
		}
		
		public static function readString(data:ByteArray):String
		{
			var ret:String = new String();
			while (true)
			{
				var read:int = data.readUnsignedByte();
				if (!read)
					break;
				ret += String.fromCharCode(read);
			}
			return ret;
		}
		
		public static function getTagName(r:int):String
		{
			switch(r) {
				case 0: return "TAG_END";
				case 1: return "TAG_SHOWFRAME";
				case 2: return "TAG_DEFINESHAPE";
				case 3: return "TAG_FREECHARACTER";
				case 4: return "TAG_PLACEOBJECT";
				case 5: return "TAG_REMOVEOBJECT";
				case 6: return "TAG_DEFINEBITS";
				case 7: return "TAG_DEFINEBUTTON";
				case 8: return "TAG_JPEGTABLES";
				case 9: return "TAG_SETBACKGROUNDCOLOR";
				case 10: return "TAG_DEFINEFONT";
				case 11: return "TAG_DEFINETEXT";
				case 12: return "TAG_DOACTION";
				case 13: return "TAG_DEFINEFONTINFO";
				case 14: return "TAG_DEFINESOUND";
				case 15: return "TAG_STARTSOUND";
				case 16: return "TAG_STOPSOUND";
				case 17: return "TAG_DEFINEBUTTONSOUND";
				case 18: return "TAG_SOUNDSTREAMHEAD";
				case 19: return "TAG_SOUNDSTREAMBLOCK";
				case 20: return "TAG_DEFINEBITSLOSSLESS";
				case 21: return "TAG_DEFINEBITSJPEG2";
				case 22: return "TAG_DEFINESHAPE2";
				case 23: return "TAG_DEFINEBUTTONCXFORM";
				case 24: return "TAG_PROTECT";
				case 25: return "TAG_PATHSAREPOSTSCRIPT";
				case 26: return "TAG_PLACEOBJECT2";
				case 28: return "TAG_REMOVEOBJECT2";
				case 29: return "TAG_SYNCFRAME";
				case 31: return "TAG_FREEALL";
				case 32: return "TAG_DEFINESHAPE3";
				case 33: return "TAG_DEFINETEXT2";
				case 34: return "TAG_DEFINEBUTTON2";
				case 35: return "TAG_DEFINEBITSJPEG3";
				case 36: return "TAG_DEFINEBITSLOSSLESS2";
				case 37: return "TAG_DEFINEEDITTEXT";
				case 38: return "TAG_DEFINEVIDEO";
				case 39: return "TAG_DEFINEMOVIECLIP";
				case 40: return "TAG_NAMECHARACTER";
				case 41: return "TAG_SERIALNUMBER";
				case 42: return "TAG_DEFINETEXTFORMAT";
				case 43: return "TAG_FRAMELABEL";
				case 45: return "TAG_SOUNDSTREAMHEAD2";
				case 46: return "TAG_DEFINEMORPHSHAPE";
				case 47: return "TAG_GENFRAME";
				case 48: return "TAG_DEFINEFONT2";
				case 49: return "TAG_GENCOMMAND";
				case 50: return "TAG_DEFINECOMMANDOBJ";
				case 51: return "TAG_CHARACTERSET";
				case 52: return "TAG_FONTREF";
				case 56: return "TAG_EXPORTASSETS";
				case 57: return "TAG_IMPORTASSETS";
				case 58: return "TAG_ENABLEDEBUGGER";
				case 59: return "TAG_INITMOVIECLIP";
				case 60: return "TAG_DEFINEVIDEOSTREAM";
				case 61: return "TAG_VIDEOFRAME";
				case 62: return "TAG_DEFINEFONTINFO2";
				case 63: return "TAG_DEBUGID";
				case 64: return "TAG_ENABLEDEBUGGER2";
				case 65: return "TAG_SCRIPTLIMITS";
				case 66: return "TAG_SETTABINDEX";
				case 67: return "TAG_DEFINESHAPE4";
				case 69: return "TAG_FILEATTRIBUTES";
				case 70: return "TAG_PLACEOBJECT3";
				case 71: return "TAG_IMPORTASSETS2";
				case 73: return "TAG_DEFINEFONTINFO3";
				case 74: return "TAG_DEFINETEXTINFO";
				case 75: return "TAG_DEFINEFONT3";
				case 76: return "TAG_AVM2DECL";
				case 77: return "TAG_METADATA";
				case 78: return "TAG_SLICE9";
				case 82: return "TAG_AVM2ACTION";
				case 83: return "TAG_DEFINESHAPE5";
				case 84: return "TAG_DEFINEMORPHSHAPE2";
				case 1023: return "TAG_DEFINEBITSPTR"
				default: return "TAG UNKNOWN " + r;
			}
		}
		
		public static function getActionName(r:int):String
		{
			switch(r) {
				case 0x00: return "ACTION_END";
				case 0x04: return "ACTION_NEXTFRAME";
				case 0x05: return "ACTION_PREVFRAME";
				case 0x06: return "ACTION_PLAY";
				case 0x07: return "ACTION_STOP";
				case 0x08: return "ACTION_TOGGLEQUALITY";
				case 0x09: return "ACTION_STOPSOUNDS";
				case 0x81: return "ACTION_GOTOFRAME";
				case 0x83: return "ACTION_GETURL";
				case 0x8A: return "ACTION_IFFRAMELOADED";
				case 0x8B: return "ACTION_SETTARGET";
				case 0x8C: return "ACTION_GOTOLABEL";
				case 0x0A: return "ACTION_ADD";
				case 0x0B: return "ACTION_SUBTRACT";
				case 0x0C: return "ACTION_MULTIPLY";
				case 0x0D: return "ACTION_DIVIDE";
				case 0x0E: return "ACTION_EQUALS";
				case 0x0F: return "ACTION_LESSTHAN";
				case 0x10: return "ACTION_LOGICALAND";
				case 0x11: return "ACTION_LOGICALOR";
				case 0x12: return "ACTION_LOGICALNOT";
				case 0x13: return "ACTION_STRINGEQ";
				case 0x14: return "ACTION_STRINGLENGTH";
				case 0x15: return "ACTION_SUBSTRING";
				case 0x17: return "ACTION_POP";
				case 0x18: return "ACTION_INT";
				case 0x1C: return "ACTION_GETVARIABLE";
				case 0x1D: return "ACTION_SETVARIABLE";
				case 0x20: return "ACTION_SETTARGETEXPRESSION";
				case 0x21: return "ACTION_STRINGCONCAT";
				case 0x22: return "ACTION_GETPROPERTY";
				case 0x23: return "ACTION_SETPROPERTY";
				case 0x24: return "ACTION_DUPLICATECLIP";
				case 0x25: return "ACTION_REMOVECLIP";
				case 0x26: return "ACTION_TRACE";
				case 0x27: return "ACTION_STARTDRAGMOVIE";
				case 0x28: return "ACTION_STOPDRAGMOVIE";
				case 0x29: return "ACTION_STRINGLESSTHAN";
				case 0x30: return "ACTION_RANDOM";
				case 0x31: return "ACTION_MBLENGTH";
				case 0x32: return "ACTION_ORD";
				case 0x33: return "ACTION_CHR";
				case 0x34: return "ACTION_GETTIMER";
				case 0x35: return "ACTION_MBSUBSTRING";
				case 0x36: return "ACTION_MBORD";
				case 0x37: return "ACTION_MBCHR";
				case 0x8D: return "ACTION_IFFRAMELOADEDEXPRESSION";
				case 0x96: return "ACTION_PUSHDATA";
				case 0x99: return "ACTION_BRANCHALWAYS";
				case 0x9A: return "ACTION_GETURL2";
				case 0x9D: return "ACTION_BRANCHIFTRUE";
				case 0x9E: return "ACTION_CALLFRAME";
				case 0x9F: return "ACTION_GOTOEXPRESSION";
				case 0x3A: return "ACTION_DELETE";
				case 0x3B: return "ACTION_DELETE2";
				case 0x3C: return "ACTION_VAREQUALS";
				case 0x3D: return "ACTION_CALLFUNCTION";
				case 0x3E: return "ACTION_RETURN";
				case 0x3F: return "ACTION_MODULO";
				case 0x40: return "ACTION_NEW";
				case 0x41: return "ACTION_VAR";
				case 0x42: return "ACTION_INITARRAY";
				case 0x43: return "ACTION_INITOBJECT";
				case 0x44: return "ACTION_TYPEOF";
				case 0x45: return "ACTION_TARGETPATH";
				case 0x46: return "ACTION_ENUMERATE";
				case 0x47: return "ACTION_NEWADD";
				case 0x48: return "ACTION_NEWLESSTHAN";
				case 0x49: return "ACTION_NEWEQUALS";
				case 0x4A: return "ACTION_TONUMBER";
				case 0x4B: return "ACTION_TOSTRING";
				case 0x4C: return "ACTION_DUP";
				case 0x4D: return "ACTION_SWAP";
				case 0x4E: return "ACTION_GETMEMBER";
				case 0x4F: return "ACTION_SETMEMBER";
				case 0x50: return "ACTION_INCREMENT";
				case 0x51: return "ACTION_DECREMENT";
				case 0x52: return "ACTION_CALLMETHOD";
				case 0x53: return "ACTION_NEWMETHOD";
				case 0x60: return "ACTION_BITWISEAND";
				case 0x61: return "ACTION_BITWISEOR";
				case 0x62: return "ACTION_BITWISEXOR";
				case 0x63: return "ACTION_SHIFTLEFT";
				case 0x64: return "ACTION_SHIFTRIGHT";
				case 0x65: return "ACTION_SHIFTRIGHT2";
				case 0x87: return "ACTION_SETREGISTER";
				case 0x88: return "ACTION_CONSTANTPOOL";
				case 0x94: return "ACTION_WITH";
				case 0x9B: return "ACTION_DEFINEFUNCTION";
				case 0x54: return "ACTION_INSTANCEOF";
				case 0x55: return "ACTION_ENUMERATEVALUE";
				case 0x66: return "ACTION_STRICTEQUALS";
				case 0x67: return "ACTION_GREATERTHAN";
				case 0x68: return "ACTION_STRINGGREATERTHAN";
				case 0x89: return "ACTION_STRICTMODE";
				case 0x2B: return "ACTION_CAST";
				case 0x2C: return "ACTION_IMPLEMENTS";
				case 0x69: return "ACTION_EXTENDS";
				case 0x8E: return "ACTION_DEFINEFUNCTION2";
				case 0x8F: return "ACTION_TRY";
				case 0x2A: return "ACTION_THROW";
				case 0x2D: return "ACTION_FSCOMMAND2";
				default: return "ACTION UNKNOWN " + r;
			}
		}
		
		private static function isCompressed(bytes:ByteArray):Boolean
		{
			return bytes[0] == 0x43;
		}
		
		private static function uncompress(bytes:ByteArray):void
		{
			var cBytes:ByteArray = new ByteArray();
			cBytes.writeBytes(bytes, 8);
			bytes.length = 8;
			bytes.position = 8;
			cBytes.uncompress();
			bytes.writeBytes(cBytes);
			bytes[0] = 0x46;
			cBytes.length = 0;
		}
	}
}
