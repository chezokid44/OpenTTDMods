class MainClass extends GSController
{
	data = null;
	companies = [];

	current_date = 0;
	last_date = 0;
	current_month = 0;
	last_month = 0;
	current_year = 0;
	last_year = 0;

	game_was_loaded = false;

	constructor()	{
		this.scorelist = GSList();
	}
	function Process();
	function DailyLoop();
	function MonthlyLoop();
	function YearlyLoop();
	function GetCompanyByID(id);
	function CompanyRemoveByID(companyid);
}

function MainClass::Start() {

	this.Sleep(1);
	this.Init();

	while (true) {
		local loopStartTick = GSController.GetTick();
		this.CheckEvents();
		this.Process();
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
}

function MainClass::Process() {
	this.current_date = GSDate.GetCurrentDate();
	this.current_month = GSDate.GetMonth(this.current_date);
	this.current_year = GSDate.GetYear(this.current_date);

	//Daily loop
	if(this.current_date == this.last_date) {
		return;
	}
	this.last_date = this.current_date;
	this.DailyLoop();

	//Monthly loop
	if(this.current_month == this.last_month) {
		return;
	}
	this.last_month = this.current_month;
	this.MonthlyLoop();

	//Yearly loop
	if(this.current_year == this.last_year) {
		return;
	}
	this.last_year = this.current_year;
	this.YearlyLoop();
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
				this.CompanyRemoveByID(deadcompany.GetCompanyID());
				break;
			}
			case GSEvent.ET_COMPANY_MERGER: {

				local merge = GSEventCompanyMerger.Convert(event);
				this.CompanyRemoveByID(merge.GetOldCompanyID());
				break;
			}
			case GSEvent.ET_COMPANY_NEW: {
				local newcompany = GSEventCompanyNew.Convert(event);
				local cid = newcompany.GetCompanyID();
				this.companies.append( Company(cid) );
				break;
			}
			case GSEvent.ET_VEHICLE_CRASHED: {
				local crash = GSEventVehicleCrashed.Convert(event);
				local victims = crash.GetVictims();
				local companyid = crash.GetVehicleOwner();
				local company = this.GetCompanyByID(companyid);
				if(!company) {
					break;
				}
				break;
			}

		}
	}
}

function MainClass::DailyLoop() {
	GSLog.Info("DailyLoop");
}

function MainClass::MonthlyLoop() {
GSLog.Info("MonthlyLoop");
}

function MainClass::YearlyLoop() {
	GSLog.Info("YearlyLoop");
}

function MainClass::GetCompanyByID(id) {
	foreach(company in this.companies) {
		if(id == company.id) {
			return company;
		}
	}
	return null;
}

function MainClass::CompanyRemoveByID(companyid) {
	for(local i = 0, size = this.companies.len(); i < size; i++) {
		if(this.companies[i].id == companyid) {
			this.companies.remove(i);
			break;
		}
	}
}

function MainClass::Save() {
	GSLog.Info("Saving data");
	this.data = {
		sv_last_month = this.last_month,
		sv_last_year = this.last_year,
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
		if(key == "sv_last_month") this.last_month = val;
		else if(key == "sv_last_year") this.last_year = val;
		else if(key == "sv_companies") {
			foreach(company in val) {
				this.companies.append( Company(company[0], company[1]) );
			}
		}
	}
	this.game_was_loaded = true;
}

class Company
{
	id = INVALID_COMPANY;
	victims = 0;

	constructor(id, victims = 0) {
		this.id = id;
		this.victims = victims;
	}
}
