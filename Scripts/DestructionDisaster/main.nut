class MainClass extends GSController
{
	data = null;
	companies = [];
	game_was_loaded = false;
	table_id = 0;
	company_league_table_elements = {};

	constructor(){}
	function GetCompanyByID(id);
}

/* Start()
	Purpose: Main controller loop for the script.
	Notes:
		- Runs event-driven: state changes are handled via CheckEvents().
		- Uses tick pacing so the loop effectively runs once per in-game day (74 ticks).
*/
function MainClass::Start() {

	this.Sleep(1); // Small delay before initialisation
	this.Init();

	// Main controller loop
	while (true) {
		local loopStartTick = GSController.GetTick();
		this.CheckEvents(); // Handle queued game events
		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		// Sleep for the remainder of the "day tick budget"
		this.Sleep((74 - ticksPassed) > 1 ? (74 - ticksPassed) : 1);
	}
}

/* Init()
	Purpose: One-time initialisation for new games.
	Notes:
		- Guarded by game_was_loaded so Load() state is not overwritten.
		- Discovers existing companies and creates the league table on fresh start only.
*/
function MainClass::Init()
{
	GSLog.Info("****************************");
	GSLog.Info("*** Destruction Disaster ***");
	GSLog.Info("****************************");
	GSLog.Info("");

	// Initial discovery only on new games - on load, companies are restored from Save()
	if(!this.game_was_loaded) {
		for(local id = 0; id < 16; id++) {
			if(GSCompany.ResolveCompanyID(id) != GSCompany.COMPANY_INVALID) {
				this.companies.append( Company(id) );
			}
		}
	}

	// League table created only on new games - on load, table_id is restored
	if (!this.game_was_loaded) {
		GSLog.Info("Creating league table");
		this.table_id = GSLeagueTable.New(
			GSText(GSText.STR_TABLE_TITLE),
			"",
			""
		);
	};
}

/* CheckEvents()
	Purpose: Drain and handle the event queue.
	Notes:
		- Keeps local company registry and league table elements in sync with game events.
		- Updates "victims" score on vehicle crashes and pushes score to the league table.
*/
function MainClass::CheckEvents() {
	while(GSEventController.IsEventWaiting()) {
		local event = GSEventController.GetNextEvent();
		if(event == null) {
			continue;
		}
		local eventType = event.GetEventType();
		switch(eventType) {
			case GSEvent.ET_COMPANY_BANKRUPT:	{
				local deadcompany = GSEventCompanyBankrupt.Convert(event);
				local company_id = deadcompany.GetCompanyID();
				this.CompanyRemoveByID(company_id);
				break;
			}
			case GSEvent.ET_COMPANY_MERGER: {
				local merge = GSEventCompanyMerger.Convert(event);
				local old_company_id = merge.GetOldCompanyID()
				this.CompanyRemoveByID(old_company_id);
				break;
			}
			case GSEvent.ET_COMPANY_NEW: {
				local newcompany = GSEventCompanyNew.Convert(event);
				local company_id = newcompany.GetCompanyID();
				this.companies.append( Company(company_id) );
				local company = this.GetCompanyByID(company_id);
				local company_name = GSCompany.GetName(company.id);
				GSLog.Info("creating new table_element with key: " + company.id);
				this.company_league_table_elements[company.id] <- GSLeagueTable.NewElement(
					this.table_id,
					0,
					company.id,
					company_name,
					"" + 0,
					GSLeagueTable.LINK_COMPANY,
					company.id
				);

				break;
			}
			case GSEvent.ET_COMPANY_RENAMED: {
				local event = GSEventCompanyRenamed.Convert(event);
				local company_id = event.GetCompanyID()
				local company = this.GetCompanyByID(company_id);
				if(!company) {
					break;
				}
				local company_name = event.GetNewName()
				GSLeagueTable.UpdateElementData(
					this.company_league_table_elements[company_id],
					company_id,
					company_name,
					GSLeagueTable.LINK_COMPANY,
					company_id
				)
				break;
			}
			case GSEvent.ET_VEHICLE_CRASHED: {
				local crash = GSEventVehicleCrashed.Convert(event);
				local victims = crash.GetVictims();
				local company_id = crash.GetVehicleOwner();
				local company = this.GetCompanyByID(company_id);
				if(!company) {
					break;
				}
				company.victims += victims;

				// Update the league table
				GSLeagueTable.UpdateElementScore(
					this.company_league_table_elements[company.id],
					company.victims,
					"" + company.victims
				);

				break;
			}

		}
	}
}

/* GetCompanyByID(id)
	Purpose: Retrieve a tracked Company by company ID.
	Returns: Company instance, or null if not present in this.companies.
*/
function MainClass::GetCompanyByID(id) {
	foreach(company in this.companies) {
		if(id == company.id) {
			return company;
		}
	}
	return null;
}

/* CompanyRemoveByID(company_id)
	Purpose: Remove a company from tracking and remove its league table row.
	Notes:
		- Also deletes the element handle from company_league_table_elements to avoid stale references.
*/
function MainClass::CompanyRemoveByID(company_id) {
	GSLog.Info("Removing company: " + company_id);
	for(local i = 0, size = this.companies.len(); i < size; i++) {
		if(this.companies[i].id == company_id) {
			this.companies.remove(i);
			break;
		}
	}
	GSLeagueTable.RemoveElement(company_id);
	delete this.company_league_table_elements[company_id]
}

/* Save()
	Purpose: Serialize script state into a table for savegame persistence.
	Returns: A table containing companies + victims, league table id, and element handle mapping.
*/
function MainClass::Save() {
	GSLog.Info("Saving data");
	this.data = {
		sv_companies = [],
		sv_table_id = this.table_id,
		sv_company_league_table_elements = this.company_league_table_elements,
	};
	foreach(company in this.companies){
		this.data.sv_companies.append([company.id, company.victims]);
	}

	return this.data;
}

/* Load(version, tbl)
	Purpose: Restore script state from saved data.
	Notes:
		- Sets game_was_loaded to prevent Init() from rebuilding state.
*/
function MainClass::Load(version, tbl) {
	GSLog.Info("Loading data");
	foreach(key, val in tbl) {
		if (key == "sv_table_id") this.table_id = val;
		if (key == "sv_company_league_table_elements") this.company_league_table_elements = val;
		if(key == "sv_companies") {
			foreach(company in val) {
				this.companies.append( Company(company[0], company[1]) );
			}
		}
	}
	this.game_was_loaded = true;
}

/* Company(id, victims = 0)
	Purpose: Small data holder for company scoring.
	Params:
		- id: OpenTTD company ID
		- victims: starting score (restored from Save data on load)
*/
class Company
{
	id = 0xFF;
	victims = 0;

	constructor(id, victims = 0) {
		this.id = id;
		this.victims = victims;
	}
}
