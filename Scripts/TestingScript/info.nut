class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Testing Script"; }
	function GetDescription() 	{ return "A script that was done to test a variety of features of the API and see how they work. Warning: this script may be a mess"; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/08/29"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHTS"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/TestingScript"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
