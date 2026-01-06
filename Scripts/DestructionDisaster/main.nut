class MainClass extends GSController
{
	data = null;
	companies = [];
	game_was_loaded = false;
	table_id = 0;
	company_league_table_element_ids = {};

	constructor(){}
	function GetCompanyByID(id);
}

function MainClass::Start() {

	this.Sleep(1);
	this.Init();

	while (true) {
		local loopStartTick = GSController.GetTick();
		this.CheckEvents();
		//this.Process();
		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep((74 - ticksPassed) > 1 ? (74 - ticksPassed) : 1);
	}
}

function MainClass::Init()
{
	GSLog.Info("****************************");
	GSLog.Info("*** Destruction Disaster ***");
	GSLog.Info("****************************");
	GSLog.Info("");

	if(!this.game_was_loaded) {
		for(local id = 0; id < 16; id++) {
			if(GSCompany.ResolveCompanyID(id) != GSCompany.COMPANY_INVALID) {
				this.companies.append( Company(id) );
			}
		}
	}

	// Create the league table
	if (!this.game_was_loaded) {
		this.table_id = GSLeagueTable.New(
			GSText(GSText.STR_TABLE_TITLE),
			"",
			""
		);
	};
}

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
				GSLeagueTable.RemoveElement(company_id);
				delete this.company_league_table_element_ids[company_id]
				this.companies.remove(company_id);
				break;
			}
			case GSEvent.ET_COMPANY_MERGER: {
				local merge = GSEventCompanyMerger.Convert(event);
				local old_company_id = merge.GetOldCompanyID()
				GSLeagueTable.RemoveElement(old_company_id);
				delete this.company_league_table_element_ids[old_company_id]
				this.companies.remove(old_company_id);
				break;
			}
			case GSEvent.ET_COMPANY_NEW: {
				local newcompany = GSEventCompanyNew.Convert(event);
				local company_id = newcompany.GetCompanyID();
				this.companies.append( Company(company_id) );
				local company = this.GetCompanyByID(company_id);
				local company_name = GSCompany.GetName(company.id);
				this.company_league_table_element_ids[company.id] <- GSLeagueTable.NewElement(
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
					this.company_league_table_element_ids[company_id],
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
					this.company_league_table_element_ids[company.id],
					company.victims,
					"" + company.victims
				);

				break;
			}

		}
	}
}

function MainClass::GetCompanyByID(id) {
	foreach(company in this.companies) {
		if(id == company.id) {
			return company;
		}
	}
	return null;
}

function MainClass::Save() {
	GSLog.Info("Saving data");
	this.data = {
		sv_companies = [],
	};
	foreach(company in this.companies){
		this.data.sv_companies.append([company.id, company.victims]);
	}

	return this.data;
}

function MainClass::Load(version, tbl) {
	GSLog.Info("Loading data");
	foreach(key, val in tbl) {
		if(key == "sv_companies") {
			foreach(company in val) {
				this.companies.append( Company(company[0], company[1]) );
			}
		}
	}
	this.game_was_loaded = true;
}

class Company
{
	id = 0xFF;
	victims = 0;

	constructor(id, victims = 0) {
		this.id = id;
		this.victims = victims;
	}
}
