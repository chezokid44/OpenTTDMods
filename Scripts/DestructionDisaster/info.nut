class Info extends GSInfo {
	function GetAuthor()      { return "Master Hellish"; }
	function GetName()        { return "Destruction Disaster"; }
	function GetDescription() { return ""; }
	function GetVersion()     { return 1; }
	function GetDate()        { return "2026-01-05"; }
	function CreateInstance() { return "MainClass"; }
	function GetShortName()   { return "MHDD"; }
	function GetAPIVersion()  { return "1.5"; }
	function GetURL()         { return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/VehicleCounter"; }

	function GetSettings() {
	}
}

RegisterGS(Info());