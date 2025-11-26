class Info extends GSInfo {
	function GetAuthor()      { return "Master Hellish"; }
	function GetName()        { return "Crash Victim Counter"; }
	function GetDescription() { return ""; }
	function GetVersion()     { return 0; }
	function GetDate()        { return "2025-11-12"; }
	function CreateInstance() { return "MainClass"; }
	function GetShortName()   { return "MHVC"; }
	function GetAPIVersion()  { return "1.5"; }
	function GetURL()         { return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/VehicleCounter"; }

	function GetSettings() {
	}
}

RegisterGS(Info());