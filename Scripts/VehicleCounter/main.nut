class MainClass extends GSController
{
	_load_data = null;
	last_month = 0;

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

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		local max  = 1 > 74 - ticksPassed ? 1 : 74 - ticksPassed
		this.Sleep(max);
	}
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	//Check for new month
	local current_month = GSDate.GetMonth(GSDate.GetCurrentDate());
	if(current_month == this.last_month) {
		return;
	}
	this.last_month = current_month;

	// Get vehicle count
	local count = 0;
	local vehicles= GSVehicleList();
	foreach(id, _ in vehicles) {
		count++;
	}

	// Log it
	GSLog.Info("Number of vehicles in game: " + count);
}