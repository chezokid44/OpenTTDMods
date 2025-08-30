class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "MH Testing Script"; }
	function GetDescription() 	{ return "A script that was done to test a variety of features of the API and see how they work"; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/08/29"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHTS"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
