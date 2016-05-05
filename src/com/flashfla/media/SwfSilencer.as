package com.flashfla.media {
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SwfSilencer {
		public static function stripSound(data:ByteArray, metadata:Object = null):ByteArray {
			var odata:ByteArray = new ByteArray();
			odata.endian = Endian.LITTLE_ENDIAN;

			var header:Object = SWFParser.readHeader(data);
			odata.writeBytes(data, 0, data.position);

			if (header.version < 9)
				odata[3] = 9;

			var firstTag:Boolean = true;
			var done:Boolean = false;
			while (data.bytesAvailable > 0 && !done) {
				var tag:Object = SWFParser.readTag(data);
				switch (tag.tag) {
					case SWFParser.SWF_TAG_STREAMBLOCK:
					case SWFParser.SWF_TAG_STREAMHEAD:
					case SWFParser.SWF_TAG_STREAMHEAD2:
					case SWFParser.SWF_TAG_DEFINESOUND:
						break;
					case SWFParser.SWF_TAG_END:
						done = true;
						break;
					case SWFParser.SWF_TAG_FILEATTRIBUTES:
						SWFParser.writeTag(odata, tag.tag, tag.length);
						var position:int = odata.position;
						odata.writeBytes(data, tag.position, tag.length);
						odata[position] |= 0x08;
						break;
					default:
						if (firstTag) { // Insert a FileAttributes tag
							SWFParser.writeTag(odata, SWFParser.SWF_TAG_FILEATTRIBUTES, 4);
							odata.writeUnsignedInt(0x00000008);
						}
						SWFParser.writeTag(odata, tag.tag, tag.length);
						if (tag.length > 0)
							odata.writeBytes(data, tag.position, tag.length);
						break;
				}
				data.position = tag.position + tag.length;
				firstTag = false;
			}
			SWFParser.writeTag(odata, SWFParser.SWF_TAG_END);

			if (metadata) {
			}

			return odata;
		}
	}
}
