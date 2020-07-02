package classes.engine
{
	import com.flashfla.utils.sprintf;
	import com.flashfla.utils.StringUtil;
	
	public class EnginePlaylist
	{
		public var id:String;
		public var valid:Boolean = false;
		
		public var load_path:String;
		public var preview_load_path:String;
		
		public var song_list:Array;
		public var index_list:Array;
		public var genre_list:Array;
		public var generated_queues:Array;
		
		public var total_genres:int = 0;
		public var total_songs:int = 0;
		public var total_public_songs:int = 0;
		public var isCanon:Boolean = false;
		
		public function EnginePlaylist(id:String)
		{
			this.id = id;
		}
		
		public function parseData(input:String):void
		{
			input = StringUtil.trim(input);
			var data:Object;
			
			// Create Arrays
			song_list = [];
			index_list = [];
			genre_list = [];
			generated_queues = [];
			
			// Create Data Array
			try
			{
				// Data is XML - Legacy Type
				if (input.charAt(0) == "<")
				{
					data = parse_xml_playlist(input);
				}
				// Data is JSON - R^3 Type
				if (input.charAt(0) == "{" || input.charAt(0) == "[")
				{
					data = JSON.parse(input);
				}
			}
			catch (e:Error)
			{
				Logger.log(this, Logger.ERROR, "\"" + id + "\" - Malformed Playlist Format");
				Logger.log(this, Logger.ERROR, e.name, " (" + e.errorID + "): " + e.errorID); 
				return;
			}
			
			// Check that playlist was parsed correctly.
			if (data == null)
			{
				Logger.log(this, Logger.ERROR, "\"" + id + "\" - Playlist is null");
				return;
			}
			
			// Build song_list
			var isExtended:Boolean = (data.songs != null);
			var songItems:Object = (isExtended ? data.songs : data); // Check for extended playlist data.
			var song:EngineLevel;

			for each (var item:Object in songItems)
			{
				// Skip Invalid Levels
				if (!item.level || item.level.toString() == "")
					continue;
				
				// Create Genre-based list.
				var _genre:int = item.genre;
				if (!genre_list[_genre])
				{
					genre_list[_genre] = [];
					generated_queues[_genre] = [];
				}
				
				// Create Song Object
				song = new EngineLevel();
				song.source = id;
				song.id = item.level.toString();
				song.index = genre_list[_genre].length;
				
				if (item.genre)
					song.genre = item.genre;
				if (item.name)
					song.name = item.name;
				if (item.author)
					song.author = item.author;
				if (item.authorURL)
					song.author_url = item.authorURL;
				if (item.stepauthor)
					song.stepauthor = item.stepauthor;
				if (item.style)
					song.style = item.style;
				if (item.releasedate)
					song.release_date = item.releasedate;
				if (item.time)
					song.time = item.time;
				if (item.order)
					song.order = item.order;
				if (item.difficulty)
					song.difficulty = item.difficulty;
				if (item.arrows)
					song.notes = item.arrows;
				if (item.playhash)
					song.play_hash = item.playhash;
				if (item.previewhash)
					song.preview_hash = item.previewhash;
				if (item.prerelease)
					song.prerelease = item.prerelease;
				
				// Optional
				if (item.is_title_only)
					song.is_title_only = item.is_title_only;
				if (item.min_nps)
					song.min_nps = item.min_nps;
				if (item.max_nps)
					song.max_nps = item.max_nps;
				if (item.sync)
					song.sync_frames = item.sync;

				if(isExtended)
				{
					song.details = new EngineLevelDetails(data.stats[song.id]);
					song.details.nps_string = item.nps_data;
				}
				
				// Push Into Arrays
				song_list[song.id] = song;
				index_list.push(song);
				genre_list[_genre].push(song);
				generated_queues[_genre].push(song.id);
			}
			
			valid = true;
		}
		
		public function parse_xml_playlist(data:String):Array
		{
			var xml:XML = new XML(data);
			var nodes:XMLList = xml.children();
			var count:int = nodes.length();
			var songs:Array = [];
			for (var i:int = 0; i < count; i++)
			{
				var node:XML = nodes[i];
				var song:Object = new Object();
				song.source = id;
				
				if (node.@genre)
					song.genre = int(node.@genre.toString());
				if (node.songname != undefined)
					song.name = node.songname.toString();
				if (node.songdifficulty != undefined)
					song.difficulty = int(node.songdifficulty.toString());
				if (node.songstyle != undefined)
					song.style = node.songstyle.toString();
				if (node.songlength != undefined)
					song.time = node.songlength.toString();
				if (node.level != undefined)
					song.level = node.level.toString();
				if (node.order != undefined)
					song.order = int(node.order.toString());
				if (node.arrows != undefined)
					song.arrows = int(node.arrows.toString());
				if (node.songauthor != undefined)
					song.author = node.songauthor.toString();
				if (node.songauthorURL != undefined)
					song.authorURL = node.songauthorURL.toString();
				if (node.songstepauthor != undefined)
					song.stepauthor = node.songstepauthor.toString();
				if (node.songstepauthorurl != undefined)
					song.stepauthorURL = node.songstepauthorurl.toString();
				if (node.secretcredits != undefined)
					song.credits = int(node.secretcredits.toString());
				if (node.price != undefined)
					song.price = int(node.price.toString());
				
				// Optional
				if (node.min_nps != undefined)
					song.min_nps = int(node.min_nps.toString());
				if (node.max_nps != undefined)
					song.max_nps = int(node.max_nps.toString());
				if (node.is_title_only != undefined)
					song.is_title_only = Boolean(node.is_title_only.toString());
				
				if (Boolean(node.arc_sync.toString()))
					song.sync = int(node.arc_sync.toString());
				
				songs.push(song);
			}
			return songs;
		}
		
		public function setLoadPath(song_url:String):void
		{
			this.load_path = song_url;
		}
		
		public function setPreviewPath(song_url:String):void 
		{
			this.preview_load_path = song_url;
		}

		public function getLevelPath(level:EngineLevel):String
		{
			var path:String = sprintf(load_path, level);
			
			// Append Legacy URLs if URL didn't change with song details.
			if (path == load_path)
				path = sprintf(load_path + "level_%(id)s.swf", level);
			
			// Append Session ID when Canon Song
			if (this.isCanon)
				path += "&session=" + Session.SESSION_ID;
				
			return path;
		}
	}
}