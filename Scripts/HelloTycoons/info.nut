class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "HelloTycoons"; }
	function GetDescription() 	{ return "A minimal OpenTTD Game Script template that demonstrates how to send messages to the game log, news feed, map sign, and company name. It outputs Hello Tycoons! in all four places and serves as a simple starting point for new Game Script developers."; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHHT"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/HelloTycoons"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
