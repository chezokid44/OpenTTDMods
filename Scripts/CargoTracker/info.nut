class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Cargo Tracker"; }
	function GetDescription() 	{ return "Description"; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/25"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHHT"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
