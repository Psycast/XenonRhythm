package classes.user
{
	import classes.user.User;
	import com.flashfla.utils.ArrayUtil;
	
	public class UserPermissions
	{
		//- Constants
		public static const ADMIN_ID:Number = 6;
		public static const BANNED_ID:Number = 8;
		public static const CHAT_MOD_ID:Number = 24;
		public static const FORUM_MOD_ID:Number = 5;
		public static const MULTI_MOD_ID:Number = 44;
		public static const MUSIC_PRODUCER_ID:Number = 46;
		public static const PROFILE_MOD_ID:Number = 56;
		public static const SIM_AUTHOR_ID:Number = 47;
		public static const VETERAN_ID:Number = 49;
		
		//- Variables
		public var isActiveUser:Boolean;
		public var isGuest:Boolean;
		public var isVeteran:Boolean;
		public var isAdmin:Boolean;
		public var isForumBanned:Boolean;
		public var isGameBanned:Boolean;
		public var isProfileBanned:Boolean;
		public var isModerator:Boolean;
		public var isForumModerator:Boolean;
		public var isProfileModerator:Boolean;
		public var isChatModerator:Boolean;
		public var isMultiModerator:Boolean;
		public var isMusician:Boolean;
		public var isSimArtist:Boolean;
		
		public function UserPermissions(user:User = null)
		{
			if (user != null)
			{
				setup(user);
			}
		}
		
		public function setup(user:User):void
		{
			this.isGuest 			= user.id == 2;
			this.isVeteran 			= ArrayUtil.in_array(user.info.forum_groups, [VETERAN_ID]);
			this.isAdmin 			= ArrayUtil.in_array(user.info.forum_groups, [ADMIN_ID]);
			this.isForumBanned 		= ArrayUtil.in_array(user.info.forum_groups, [BANNED_ID]);
			this.isModerator 		= ArrayUtil.in_array(user.info.forum_groups, [ADMIN_ID, FORUM_MOD_ID, CHAT_MOD_ID, PROFILE_MOD_ID, MULTI_MOD_ID]);
			this.isForumModerator 	= ArrayUtil.in_array(user.info.forum_groups, [FORUM_MOD_ID, ADMIN_ID]);
			this.isProfileModerator = ArrayUtil.in_array(user.info.forum_groups, [PROFILE_MOD_ID, ADMIN_ID]);
			this.isChatModerator 	= ArrayUtil.in_array(user.info.forum_groups, [CHAT_MOD_ID, ADMIN_ID]);
			this.isMultiModerator 	= ArrayUtil.in_array(user.info.forum_groups, [MULTI_MOD_ID, ADMIN_ID]);
			this.isMusician 		= ArrayUtil.in_array(user.info.forum_groups, [MUSIC_PRODUCER_ID]);
			this.isSimArtist 		= ArrayUtil.in_array(user.info.forum_groups, [SIM_AUTHOR_ID]);
		}
	}

}