package classes.engine
{
	import com.adobe.serialization.json.JSONManager;
	import com.adobe.utils.StringUtil;
	import com.flashfla.utils.ObjectUtil;
	import com.flashfla.utils.sprintf;
	
	public class EnginePlaylist
	{
		public var id:String;
		public var valid:Boolean = false;
		
		public var load_path:String;
		
		public var song_list:Array;
		public var index_list:Array;
		public var genre_list:Array;
		public var generated_queues:Array;
		
		public var total_genres:int = 0;
		public var total_songs:int = 0;
		public var total_public_songs:int = 0;
		
		public function EnginePlaylist(id:String)
		{
			this.id = id;
		}
		
		public function parseData(input:String):void
		{
			input = StringUtil.trim(input);
			var data:Object;
			
			// Create Arrays
			song_list = new Array();
			index_list = new Array();
			genre_list = new Array();
			generated_queues = new Array();
			
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
					data = JSONManager.decode(input);
				}
			}
			catch (e:Error)
			{
				trace("3:[EnginePlaylist] \"" + id + "\" - Malformed Playlist Format");
				return;
			}
			
			// Check that playlist was parsed correctly.
			if (data == null)
			{
				trace("3:[EnginePlaylist] \"" + id + "\" - Playlist is null");
				return;
			}
			
			// Build song_list
			var song:EngineLevel;
			for each (var item:Object in data)
			{
				// Create Genre-based list.
				var _genre:int = item.genre;
				if (!genre_list[_genre])
				{
					genre_list[_genre] = [];
					generated_queues[_genre] = [];
				}
				
				// Create Song Object
				song = new EngineLevel();
				song.id = item.level.toString();
				song.index = genre_list[_genre].length;
				song.genre = item.genre;
				song.name = item.name;
				song.author = item.author;
				song.author_url = item.authorURL;
				song.stepauthor = item.stepauthor;
				song.style = item.style;
				song.release_date = item.releasedate;
				song.time = item.time;
				song.order = item.order;
				song.difficulty = item.difficulty;
				song.notes = item.arrows;
				song.play_hash = item.previewhash;
				song.preview_hash = item.previewhash;
				song.prerelease = item.prerelease;
				
				// Optional
				if (item.min_nps)
					song.min_nps = item.min_nps;
				if (item.max_nps)
					song.max_nps = item.max_nps;
				if (item.sync)
					song.sync_frames = item.sync;
				
				// Push Into Arrays
				song_list[song.id] = song;
				index_list.push(song);
				genre_list[_genre].push(song);
				generated_queues[_genre].push(song.id);
			}
			
			valid = true;
		}
		
		public function parse_xml_playlist(data:String, engine:Object = null):Array
		{
			var xml:XML = new XML(data);
			var nodes:XMLList = xml.children();
			var count:int = nodes.length();
			var songs:Array = new Array();
			for (var i:int = 0; i < count; i++)
			{
				var node:XML = nodes[i];
				var song:Object = new Object();
				song.genre = int(node.@genre.toString());
				song.name = node.songname.toString();
				song.difficulty = int(node.songdifficulty.toString());
				song.style = node.songstyle.toString();
				song.time = node.songlength.toString();
				song.level = node.level.toString();
				song.order = int(node.order.toString());
				song.arrows = int(node.arrows.toString());
				song.author = node.songauthor.toString();
				song.authorURL = node.songauthorURL.toString();
				song.stepauthor = node.songstepauthor.toString();
				song.stepauthorURL = node.songstepauthorurl.toString();
				song.min_nps = int(node.min_nps.toString());
				song.max_nps = int(node.max_nps.toString());
				song.credits = int(node.secretcredits.toString());
				song.price = int(node.price.toString());
				song.engine = engine;
				
				if (Boolean(node.arc_sync.toString()))
					song.sync = int(node.arc_sync.toString());
				else if (engine && engine.sync)
					song.sync = engine.sync(song);
				
				songs.push(song);
			}
			return songs;
		}
		
		public function setLoadPath(song_url:String):void
		{
			this.load_path = song_url;
		}
		
		public function getLevelPath(level:EngineLevel):String
		{
			return sprintf(this.load_path, level);
		}
	}

}