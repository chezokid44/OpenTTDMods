class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Called when the script state is saved (e.g., during a savegame)
function MainClass::Save()
{
	GSLog.Info("This is the log for when we are saving");
	return {}; // You can return a table of data here to persist
}

// Called when the script state is loaded
function MainClass::Load(version, tbl)
{
	GSLog.Info("This is the log for when we are loading");

	// You can restore saved data from 'tbl' here
	foreach(key, val in tbl)
	{
	}
}

// Helper function to get the maximum of two values
function max(x1, x2)
{
	return x1 > x2 ? x1 : x2;
}

// Called once the script is fully initialized
function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first

	this.PostInit(); // Do any setup actions here

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, 74 - ticksPassed));
	}
}

// Handle any queued events (e.g., bankruptcies, company changes)
function MainClass::HandleEvents()
{
	while(GSEventController.IsEventWaiting())
	{
		local ev = GSEventController.GetNextEvent();

		if(ev == null)
			return;

		// Handle your events here
	}
}

// Perform setup actions like logging and placing signs
function MainClass::PostInit()
{
	// Output message to the GS log
	GSLog.Info("Hello Tycoons!");

	// Show a news message
	GSNews.Create(
		GSNews.NT_GENERAL,
		GSText(GSText.STR_EMPTY1, "Hello Tycoons!"),
		GSCompany.COMPANY_INVALID,
		GSNews.NR_NONE,
		0
	);

	// Place a sign in the center of the map
	local middleTile = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2, GSMap.GetMapSizeY() / 2);
	GSSign.BuildSign(
		middleTile,
		"Hello Tycoons!"
	);

	// Rename company 0 if it exists
	if(GSCompany.ResolveCompanyID(0) != GSCompany.COMPANY_INVALID) {
		local mode = GSCompanyMode(0);
		GSCompany.SetName("Hello Tycoon Company");
	}
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	// Example: check goal conditions, update company state, etc.
}

// Called when a new company is created
function MainClass::InitNewCompany(cid)
{
	// Example: set initial cash, assign goals, etc.
}

function MainClass::QueryMonitor(ind, cid, cargoType)
{
}

function MainClass::QueryMonitorMultiple(ind, cid, cargoType)
{
}

function MainClass::UpdateMonth(cid)
{
}

function MainClass::CancelMonitors(cid)
{
}

function MainClass::UpdateGoals(cid)
{
}

function MainClass::UpdateGlobal()
{
}
