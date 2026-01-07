class Info extends GSInfo {
	function GetAuthor()      { return "Master Hellish"; }
	function GetName()        { return "Destruction Disaster"; }
	function GetDescription() { return "Tracks how many passengers are lost in vehicle crashes, per company. It publishes those totals into a league table."; }
	function GetVersion()     { return 2; }
	function GetDate()        { return "2026-01-05"; }
	function CreateInstance() { return "MainClass"; }
	function GetShortName()   { return "MHDD"; }
	function GetAPIVersion()  { return "1.5"; }
	function GetURL()         { return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/DestructionDisaster"; }

	function GetSettings() {
	}
}

RegisterGS(Info());