class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Stat Tracker"; }
	function GetDescription() 	{ return "A simple script that tracks a number of statistics and logs them each year In the script log."; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/19"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHST"; }
	function GetAPIVersion()	{ return "13"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
