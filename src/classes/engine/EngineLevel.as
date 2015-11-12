package classes.engine
{
	import com.flashfla.utils.StringUtil;
	import com.flashfla.utils.StringUtil;
	
	public class EngineLevel
	{
		public var id:String;
		public var index:int;
		public var genre:int;
		
		public var name:String;
		public var author:String;
		public var author_url:String;
		private var _stepauthor:String;
		private var _stepauthor_with_url:String;
		
		public var style:String;
		public var release_date:int;
		private var _time:String;
		private var _time_secs:int;
		public var order:int;
		public var difficulty:int;
		private var _notes:int;
		public var sync_frames:int = 0;
		
		private var _score_raw:int;
		private var _score_combo:int;
		
		public var min_nps:Number = 0;
		public var max_nps:Number = 0;
		
		public var play_hash:String;
		public var preview_hash:String;
		public var prerelease:Boolean;
		
		// Author
		public function get author_with_url():String
		{
			if (author_url != "" && author_url.length > 7)
			{
				return "<a href=\"" + StringUtil.htmlEscape(author_url) + "\">" + author + "</a>";
			}
			return author;
		}
		
		// Stepauthor and URL versions.
		public function set stepauthor(auth:String):void
		{
			_stepauthor = auth;
			
			//- Create URL
			// Multiple Step Authors
			if (auth.indexOf(" & ") !== false)
			{
				var stepAuthors:Array = auth.split(" & ");
				_stepauthor_with_url = "<a href=\"http://www.flashflashrevolution.com/profile/" + StringUtil.htmlEscape(stepAuthors[0]) + "\">" + stepAuthors[0] + "</a>";
				for (var i:int = 1; i < stepAuthors.length; i++)
				{
					_stepauthor_with_url += " & <a href=\"http://www.flashflashrevolution.com/profile/" + StringUtil.htmlEscape(stepAuthors[i]) + "\">" + stepAuthors[i] + "</a>";
				}
			}
			else
			{
				_stepauthor_with_url = "<a href=\"http://www.flashflashrevolution.com/profile/" + StringUtil.htmlEscape(auth) + "\">" + auth + "</a>";
			}
		}
		
		public function get stepauthor():String
		{
			return _stepauthor;
		}
		
		public function get stepauthor_with_url():String
		{
			return _stepauthor_with_url;
		}
		
		// Time
		public function get time():String
		{
			return _time;
		}
		
		public function set time(time:String):void
		{
			var pieces:Array = time.split(":");
			_time = time;
			_time_secs = (int(pieces[0]) * 60) + int(pieces[1]);
		}
		
		public function get time_secs():int
		{
			return _time_secs;
		}
		
		// Notes
		public function get notes():int
		{
			return _notes;
		}
		
		public function set notes(total:int):void
		{
			_notes = total;
			_score_raw = total * 50;
			_score_combo = total * 1550;
		}
		
		// Scores
		public function get score_raw():int
		{
			return _score_raw;
		}
		
		public function get score_combo():int
		{
			return _score_combo;
		}
	
	}

}