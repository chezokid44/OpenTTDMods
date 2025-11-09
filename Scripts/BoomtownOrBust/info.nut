class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "MH Boomtown Or Bust"; }
	function GetDescription() 	{ return ""; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHBB"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
		AddSetting({
			name = "towns_per_day",
			description = "How many towns are affected each day",
			min_value = 1,
			max_value = 100,
			easy_value = 1,	medium_value = 2, hard_value = 3, custom_value = 1,
			flags = CONFIG_NONE,
		});

		AddSetting({
			name = "buildings_per_town",
			description = "How many buildings are demolished per town per day",
			min_value = 1,
			max_value = 500,
			easy_value = 5, medium_value = 10, hard_value = 20, custom_value = 10,
			flags = CONFIG_NONE,
		});

		AddSetting({
			name = "min_active_subsidies",
			description = "Minimum number of active subsidies",
			min_value = 0, max_value = 50,
			easy_value = 2, medium_value = 3, hard_value = 4, custom_value = 3,
			flags = CONFIG_NONE,
		});

		AddSetting({
			name = "subsidy_growth_amount",
			description = "Town growth amount applied per step when a subsidy is awarded",
			min_value = 1, max_value = 500,
			easy_value = 1, medium_value = 1, hard_value = 2, custom_value = 1,
			flags = CONFIG_NONE,
		});

		AddSetting({
			name = "subsidy_growth_iterations",
			description = "Number of growth steps applied when a subsidy is awarded",
			min_value = 1, max_value = 500,
			easy_value = 200, medium_value = 300, hard_value = 400, custom_value = 200,
			flags = CONFIG_NONE,
		});
	}
}

RegisterGS(FMainClass());
