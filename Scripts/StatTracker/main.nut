class MainClass extends GSController
{
	_loaded_data = null;
	data = null; //data to save
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

	this.Init();

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

	}
}

function MainClass::Init()
{
	if (this._loaded_data != null) {
		this.last_year = this._loaded_data["last_year"];
		this.stat_bankrupt = this._loaded_data["stat_bankrupt"];
		this.stat_crashes = this._loaded_data["stat_crashes"];
		GSLog.Info("Loaded last_year: " + this.last_year);
		GSLog.Info("Loaded crashes: " + this.stat_crashes);
		GSLog.Info("Loaded bankruptcies: " + this.stat_bankrupt);
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

function MainClass::Save() {
	this.data = {
		last_year = this.last_year,
		stat_bankrupt = this.stat_bankrupt,
		stat_crashes = this.stat_crashes,
	};
	return this.data;
}

function MainClass::Load(version, tbl) {
	this._loaded_data = {}
   	foreach(key, val in tbl) {
		this._loaded_data.rawset(key, val);
	}
}