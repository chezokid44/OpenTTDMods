class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;
	last_month = 0;

	// Constructor – runs once at the start of the script
	constructor()
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
		this.DoDayLoop();       // Your main game logic

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, 74 - ticksPassed));
	}
}

function MainClass::PostInit()
{
	// At some point we are going to need to know what cargo we are tracking, this will help

	// local list = GSCargoList()
	// foreach(key, value in list)
    // {
    //     GSLog.Info("Key: " + key);
    //     GSLog.Info("value: " + value);
    //     GSLog.Info("GetName: " + GSCargo.GetName(key));
    //     GSLog.Info("--------");
    // }
}

function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {

		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		// We are going to need to do some things when there are some events
		// for now we will just have this empty one here
		local ev_type = ev.GetEventType();
		switch (ev_type) {
			case GSEvent.ET_COMPANY_BANKRUPT: {
				break;
			}
		}
	}
}

function MainClass::DoDayLoop()
{
	// Check for new month
	local current_month = GSDate.GetMonth(GSDate.GetCurrentDate());
	if(current_month == this.last_month) {
		return;
	}
	this.last_month = current_month;
	DoMonthLoop();
}

function MainClass::DoMonthLoop()
{
	for (local cid = GSCompany.COMPANY_FIRST; cid < GSCompany.COMPANY_LAST; cid++) {
		if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {

			// Check company has HQ
			local tile_index  = GSCompany.GetCompanyHQ(0)
			if (tile_index == GSMap.TILE_INVALID){
				return;
			}

			// Get and log Town Delivery Amount
			local town_id = GSTile.GetClosestTown(tile_index)
			local cargoDeliveryAmount = GSCargoMonitor.GetTownDeliveryAmount(
				cid,
				0,
				town_id,
				true
			);
			GSLog.Info("Company ID " + cid + " Delivered: " + cargoDeliveryAmount);
		}
	}
}


