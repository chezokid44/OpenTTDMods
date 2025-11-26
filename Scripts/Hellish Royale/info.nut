class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName() 			{return "Hellish Royale";}
	function GetDescription() 	{ return "Coming Soon"; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHHR"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://masterhellish.net"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
