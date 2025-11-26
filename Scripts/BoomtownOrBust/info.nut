class InfoClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Boomtown Or Bust"; }
	function GetDescription() 	{ return "Boomtown Or Bust makes towns shrink over time, and players must win subsidies to trigger growth, creating a dynamic cycle of decline and recovery."; }
	function GetVersion()		{ return 2; }
	function GetDate()			{ return "2025/11/26"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHBB"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/BoomtownOrBust"; }

	function GetSettings() {
		AddSetting({
			name = "towns_per_day",
			description = "Towns are affected each day (1 for steady)",
			min_value = 1,
			max_value = 500,
			easy_value = 1,	medium_value = 2, hard_value = 3, custom_value = 1,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "buildings_per_town",
			description = "Destruction per town per day (1 for steady, 500 for town smash)",
			min_value = 1,
			max_value = 500,
			easy_value = 1, medium_value = 2, hard_value = 3, custom_value = 1,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "subsidy_growth_iterations",
			description = "Growth amount when a subsidy is awarded (50 a bit, 500 lots, 2000 silly)",
			min_value = 1, max_value = 2000,
			easy_value = 100, medium_value = 50, hard_value = 25, custom_value = 50,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "min_active_subsidies",
			description = "Minimum number of active subsidies",
			min_value = 0, max_value = 50,
			easy_value = 10, medium_value = 5, hard_value = 3, custom_value = 5,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "min_subsidie_distance",
			description = "Minimum distance for subsidy (1-90%)",
			min_value = 1, max_value = 90,
			easy_value = 1, medium_value = 5, hard_value =10, custom_value = 5,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "max_subsidie_distance",
			description = "Maximum distance for subsidy (10-100%)",
			min_value = 10, max_value = 100,
			easy_value = 10, medium_value = 20, hard_value = 50, custom_value = 20,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		AddSetting({
			name = "show_intro_message",
			description = "Show introduction message on start/load",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});

		AddSetting({
			name = "show_news_on_town_grow",
			description = "Show news when a town grows",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});

		AddSetting({
			name = "move_viewport_on_town_grow",
			description = "Move the screen when a town grows",
			default_value = 0,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});

		AddSetting({
			name = "move_viewport_on_town_smash",
			description = "Move the screen when a town destruction is 100 or more",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});

	}
}

RegisterGS(InfoClass());
