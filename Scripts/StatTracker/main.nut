class MainClass extends GSController
{
	_load_data = null;
	last_year = 0;
	stat_bankrupt = 0;
	stat_crashes = 0;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Called once the script is fully initialized
function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

	}
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	//Check for new year
	local current_year = GSDate.GetYear(GSDate.GetCurrentDate());
	if(current_year == this.last_year) {
		return;
	}
	this.last_year = current_year;

	// Get vehicle count
	local count = 0;
	local vehicles= GSVehicleList();
	foreach(id, _ in vehicles) {
		count++;
	}

	// Log it
	GSLog.Info("");
	GSLog.Info("*** " + current_year + " ***");
	GSLog.Info("Number of vehicles in game: " + count);
	GSLog.Info("Number of crashes: " + stat_crashes);
	GSLog.Info("Number of bankruptcies: " + stat_bankrupt);
}

function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		local ev_type = ev.GetEventType();
		switch (ev_type) {
			case GSEvent.ET_COMPANY_BANKRUPT: {
				stat_bankrupt++;
				break;
			}
			case GSEvent.ET_VEHICLE_CRASHED: {
				stat_crashes++;
				break;
			}
		}
	}
}