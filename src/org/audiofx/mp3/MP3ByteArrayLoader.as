/*
   Copyright (c) 2008 Christopher Martin-Sperry (audiofx.org@gmail.com)

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
 */

package org.audiofx.mp3 {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Dispatched when the MP3 data is loaded
	 * @eventType org.audiofx.mp3.MP3SoundEvent.COMPLETE
	 *
	 */
	[Event(name="complete",type="org.audiofx.mp3.MP3SoundEvent")]
	
	/**
	 * Class for loading MP3 files from a FileReference
	 * @author spender
	 * @see flash.net.FileReference
	 */
	public class MP3ByteArrayLoader extends EventDispatcher {
		/**
		 * Constructs an new MP3FileReferenceLoader instance
		 */
		public function MP3ByteArrayLoader() {
		}
		
		/**
		 * When the data is ready, an <code>MP3SoundEvent.COMPLETE</code> event is emitted.
		 * @param inputBytes A Sound ByteArray
		 * @see MP3SoundEvent
		 */
		public function getSound(inputBytes:ByteArray, latencyseek:int = 0, samples:int = -1, sampleRate:int = -1, channels:int = -1):Boolean {
			var formatByte:int;
			if (samples == -1 || sampleRate == -1) {
				var mp3Parser:MP3Parser = new MP3Parser();
				mp3Parser.loadByteArray(inputBytes);
				formatByte = swfFormatByte(mp3Parser.sampleRate, mp3Parser.channels);
				samples = 0;
				while (true) {
					var frame:ByteArraySegment = mp3Parser.getNextFrame();
					if (!frame)
						break;
					samples += 1152;
				}
			} else if (channels == -1)
				formatByte = sampleRate;
			else
				formatByte = swfFormatByte(sampleRate, channels);
			return generateSound(inputBytes, latencyseek, samples, formatByte);
		}

		private function swfFormatByte(sampleRate:int, channels:int):int {
			var sampleRateIndex:uint = 4 - (44100 / sampleRate);
			return (2 << 4) + (sampleRateIndex << 2) + (1 << 1) + (channels - 1);
		}

		private function generateSound(mp3Source:ByteArray, latencyseek:int, samples:int, formatByte:int):Boolean {
			if (mp3Source.length == 0 || samples == 0)
				return false;

			var swfBytes:ByteArray = new ByteArray();
			swfBytes.endian = Endian.LITTLE_ENDIAN;
			for (var i:uint = 0; i < SoundClassSwfByteCode.soundClassSwfBytes1.length; ++i) {
				swfBytes.writeByte(SoundClassSwfByteCode.soundClassSwfBytes1[i]);
			}
			var swfSizePosition:uint = swfBytes.position;
			swfBytes.writeInt(0); //swf size will go here
			for (i = 0; i < SoundClassSwfByteCode.soundClassSwfBytes2.length; ++i) {
				swfBytes.writeByte(SoundClassSwfByteCode.soundClassSwfBytes2[i]);
			}
			var audioSizePosition:uint = swfBytes.position;
			swfBytes.writeInt(0); //audiodatasize+7 to go here
			swfBytes.writeShort(1);
			swfBytes.writeByte(formatByte);
			
			var sampleSizePosition:uint = swfBytes.position;
			swfBytes.writeInt(0); //number of samples goes here
			
			swfBytes.writeByte(latencyseek); //seeksamples
			swfBytes.writeByte(0);
			
			var frameCount:uint = 0;
			
			swfBytes.writeBytes(mp3Source);
			
			var currentPos:uint = swfBytes.position;
			swfBytes.position = audioSizePosition;
			swfBytes.writeInt(mp3Source.length + 9);
			swfBytes.position = sampleSizePosition;
			swfBytes.writeInt(samples);
			swfBytes.position = currentPos;
			for (i = 0; i < SoundClassSwfByteCode.soundClassSwfBytes3.length; ++i) {
				swfBytes.writeByte(SoundClassSwfByteCode.soundClassSwfBytes3[i]);
			}
			swfBytes.position = swfSizePosition;
			swfBytes.writeInt(swfBytes.length);
			swfBytes.position = 0;
			var swfBytesLoader:Loader = new Loader();
			swfBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfCreated);
			swfBytesLoader.loadBytes(swfBytes);
			return true;
		}
		
		private function swfCreated(ev:Event):void {
			var loaderInfo:LoaderInfo = ev.currentTarget as LoaderInfo;
			var soundClass:Class = loaderInfo.applicationDomain.getDefinition("SoundClass") as Class;
			var sound:Sound = new soundClass();
			dispatchEvent(new MP3SoundEvent(MP3SoundEvent.COMPLETE, sound));
		}
	}
}