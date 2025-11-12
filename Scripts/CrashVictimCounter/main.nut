scriptInstance <- null;
const INVALID_COMPANY = 0xFF; //invalid company id
const BREAKDAYS = 10; //daily process period in days
const DAYTICKS = 74;


// This is the main Class
class MainClass extends GSController
{
	data = null; //data to save
	companies = []; //company pool
	current_leader = INVALID_COMPANY;

	last_date = 0;
	sleeptime = 74; //refresh
	from_save = false; //flag to cancel things doing only in map generation
	current_month = 0;
	current_year = 0;
	last_month = 0;
	current_date = 0;
	flow_days = 0;
	game_length = 0;

	townlist = null;

	goals = []; //goals pool
	scorelist = null; //score pool

	story = []; //storypage ids
	storyElement = []; //storypage elements ids
	el_num = 0;

	constructor()	{
		this.scorelist = GSList();
	}

	function Process();
	function DailyLoop();
	function MonthlyLoop();
	function YearlyLoop();

	function GetCompanyByID(id);
	function CompanyRemoveByID(companyid);
	function CompanyIncome(companyid);
	function CompanyCargo(companyid);
	function GameTimeCheck();
	function StoryStart(companyid = -1);
	function Story();
}

function MainClass::Start() {

	this.game_length  = GSController.GetSetting("gamelength");

	/* load settings */
	if(this.from_save == false) {
		//if there are alrady some companies and goals at start, fill pools
		for(local id = 0; id < 16; id++) {
			if(GSCompany.ResolveCompanyID(id) != GSCompany.COMPANY_INVALID) {
				this.companies.append( Company(id) );
			}
		}

		this.ClearGoals();
	}

	//this.StoryStart();

	// day tick = 74
	// 31 ticks ~= 1 second,	 1 game day ~= 2,3s, 1 game month ~= 75s

	while (true) {
		this.Process();
		this.Sleep(DAYTICKS);
	}
}

function MainClass::Process() {
	this.current_date = GSDate.GetCurrentDate();
	this.current_month = GSDate.GetMonth(this.current_date);
	this.current_year = GSDate.GetYear(this.current_date);

	this.CheckEvents();

	//daily loop
	if(this.current_date != this.last_date) {
		this.flow_days += (this.current_date - this.last_date);
	}

	this.last_date = this.current_date;

	//every x days
	if(this.flow_days >= BREAKDAYS) {
		this.DailyLoop();
		this.flow_days = 0;
	}

	//monthly loop
	if(this.current_month == this.last_month) {
		return;
	}

	this.last_month = this.current_month;
	this.MonthlyLoop();

	//yearly loop
	if(this.current_month == 1) {
		this.YearlyLoop();
	}
}

function MainClass::CheckEvents() {

	/* company pool changes */
	while(GSEventController.IsEventWaiting()) {
		local event = GSEventController.GetNextEvent();
		if(event == null) {
			continue;
		}
		local eventType = event.GetEventType();
		switch(eventType) {
			case GSEvent.ET_COMPANY_BANKRUPT:	{
				// Delete the company from the company pool and unclaim town
				local deadcompany = GSEventCompanyBankrupt.Convert(event);
				this.CompanyRemoveByID(deadcompany.GetCompanyID());
				GSLog.Info("Found bankrupted company!");
				break;
			}
			case GSEvent.ET_COMPANY_MERGER: {
				// Merge the companies, remove old company and unclaim town
				local merge = GSEventCompanyMerger.Convert(event);
				this.CompanyRemoveByID(merge.GetOldCompanyID());
				GSLog.Info("Company merge of company " + merge.GetOldCompanyID() + " into " + GSCompany.GetName(merge.GetNewCompanyID()));
				break;
			}
			case GSEvent.ET_COMPANY_NEW: {
				//new company
				local newcompany = GSEventCompanyNew.Convert(event);
				local cid = newcompany.GetCompanyID();
				//if company already exists, do not add it to list. Can happen with scenarios
				if(this.GetCompanyByID(cid)) {
					continue;
				}
				this.companies.append( Company(cid) );

				GSLog.Info("Found new company! " + cid);
				break;
			}
			case GSEvent.ET_VEHICLE_CRASHED: {
				//new company
				local crash = GSEventVehicleCrashed.Convert(event);

				local victims = crash.GetVictims();
				//local vehicle_id = crash.GetVehicleID();
				local reason = crash.GetCrashReason();
				local companyid = crash.GetVehicleOwner();

				/*if(!GSVehicle.IsValidVehicle(vehicle_id)) {
					break;
				}*/

				//local companyid = GSVehicle.GetOwner(vehicle_id);

				local company = this.GetCompanyByID(companyid);
				if(!company) {
					break;
				}

				/*
				GSEventVehicleCrashed::CrashReason
				The reasons for vehicle crashes.

				Enumerator
				CRASH_TRAIN Two trains collided.
				CRASH_RV_LEVEL_CROSSING Road vehicle got under a train.
				CRASH_RV_UFO Road vehicle got under a landing ufo.
				CRASH_PLANE_LANDING Plane crashed on landing.
				CRASH_AIRCRAFT_NO_AIRPORT Aircraft crashed after it found not a single airport for landing.
				CRASH_FLOODED Vehicle was flooded.
				*/
				switch(reason) {
					case GSEventVehicleCrashed.CRASH_TRAIN: company.victims_train += victims; break;
					case GSEventVehicleCrashed.CRASH_RV_UFO:
					case GSEventVehicleCrashed.CRASH_RV_LEVEL_CROSSING: company.victims_road += victims; break;
					case GSEventVehicleCrashed.CRASH_AIRCRAFT_NO_AIRPORT:
					case GSEventVehicleCrashed.CRASH_PLANE_LANDING: company.victims_plane += victims; break;
					case GSEventVehicleCrashed.CRASH_FLOODED: company.victims_flood += victims; break;
				}

				company.score += victims;

				break;
			}

		}
	}
}

function MainClass::DailyLoop() {
	//this.Story();
	this.GoalUpdate();
}

function MainClass::MonthlyLoop() {
	//this.Story();
}

function MainClass::YearlyLoop() {
	//this.Story();
	this.GameTimeCheck();
}

function MainClass::GoalUpdate() {
	//clear goals to show new info
	for (local i = 0; i < this.goals.len(); i++) {
		if(GSGoal.IsValidGoal(this.goals[i])) {
			GSGoal.Remove(this.goals[i]);
		}
	}
	this.goals.clear();

	//main goal

	//Clear Score to make new one
	scorelist.Clear();

	foreach(company in this.companies) {
		scorelist.AddItem(company.id, company.score);
	}

	scorelist.Sort(GSList.SORT_BY_VALUE, GSList.SORT_DESCENDING); //sort by best

	local rank = 1, company, textobj, maximum = 0, goal_progress = 0, leader = INVALID_COMPANY, leader_score = 0;

	foreach (companyid, score in scorelist) {
		company = GetCompanyByID(companyid);

		if(!company) {
			continue;
		}

		if(rank == 1) {
			maximum = score;
			leader = companyid;
			leader_score = score;
		}

		textobj = GSText(GSText.STR_SCORE_GOAL, rank, company.id, score, company.victims_train, company.victims_road, company.victims_plane, company.victims_flood);

		local goal_id = GSGoal.New(GSCompany.COMPANY_INVALID, textobj, GSGoal.GT_COMPANY, company.id);

		if(maximum > 0) {
			goal_progress = 100 * score / maximum;
			GSGoal.SetProgress(goal_id, GSText(GSText.STR_GOAL_PROGRESS, goal_progress));
		}

		this.goals.append(goal_id);

		rank++;

		goal_id = GSGoal.New(company.id, GSText(GSText.STR_GOAL_GUI_GLOBAL), GSGoal.GT_NONE, 0);
		this.goals.append(goal_id);
	}

	if(leader != INVALID_COMPANY && leader_score > 0 && leader != this.current_leader) {
		GSNews.Create(GSNews.NT_GENERAL, GSText(GSText.STR_LEADER_NEWS, leader, leader_score), GSCompany.COMPANY_INVALID, GSNews.NR_NONE, 0);
		this.current_leader = leader;
	}
}

function MainClass::ClearGoals() {
	for(local id = 0; id < 256; id++) {
		if(GSGoal.IsValidGoal(id)) {
			GSGoal.Remove(id);
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

function MainClass::CompanyRemoveByID(companyid) {
	for(local i = 0, size = this.companies.len(); i < size; i++) {
		if(this.companies[i].id == companyid) {
			/*foreach(id, element in this.storyElement[company.id]){
				this.storyElement[company.id].remove(id);
			}
			this.story.remove(company.storyid);*/
			this.companies.remove(i);
			break;
		}
	}
}

//stats from previous 4 quarters, when on 1st Jan, it equals previous year
function MainClass::CompanyIncome(companyid) {
	local sum = 0;
	for(local i = 1; i <= 4; i++) { //previous 4 quaters
		sum += GSCompany.GetQuarterlyIncome(companyid, i);
	}
	return sum;
}

function MainClass::CompanyCargo(companyid) {
	local sum = 0;
	for(local i = 1; i <= 4; i++) { //previous 4 quaters
		sum += GSCompany.GetQuarterlyCargoDelivered(companyid, i);
	}
	return sum;
}

//vehicle sum for selected company
function MainClass::CompanyVehicles(companyid) {
	//local vehicles= GSVehicleList(IsVehicleOwner, company.id); //only in 14.x
	//return vehicles.Count();

	local sum = 0;
	local vehicles= GSVehicleList();
	foreach(id, _ in vehicles) {
		if(GSVehicle.GetOwner(id) == companyid) {
			sum++;
		}
	}
	return sum;
}

//check if game_lenght was defined and when yes and end year was reached -> pause game
function MainClass::GameTimeCheck() {
	local year_run_time = this.current_year - GSGameSettings.GetValue("game_creation.starting_year");
	//GSLog.Info("year run " + year_run_time + "   GL " + this.game_length);
	if(this.game_length > 0 && year_run_time >= this.game_length) {
		GSGame.Pause();
	}
}

/* story page */
//function to prepare story page on script start/load
function MainClass::StoryStart(companyid = -1) {

	//GSLog.Info("Start story");

	//populate storyelemnt witt empty arrays upto company_max
	for(local i = 0; i < 16; i++) {
		this.storyElement.append([]);
	}

	foreach(company in this.companies) {
		if(companyid != -1 && companyid != company.id) {
			continue;
		}

		//only add goal progress page when there is none
		if(company.storyid == -1 || !GSStoryPage.IsValidStoryPage(company.storyid)) {
			local storyid = GSStoryPage.New(company.id, GSText(GSText.STR_STORY_TITLE));
			this.story.append(storyid);
			company.storyid = storyid;
		}
		//if exists, just add to internal list
		else {
			this.story.append(company.storyid);
			local elemList = GSStoryPageElementList(company.storyid);
			this.storyElement[company.id] = [];
			foreach(elemid, _ in elemList) {
				this.storyElement[company.id].append(elemid);
			}
		}
	}
}

//feed yearly progress
function MainClass::Story(){

	foreach(company in this.companies) {
		if(!GSStoryPage.IsValidStoryPage(company.storyid)) {
			this.StoryStart(company.id);
		}

		//GSLog.Info("cv cur " + GSCompany.GetQuarterlyCompanyValue(company.id, GSCompany.CURRENT_QUARTER));
		//GSLog.Info("cv prv " + GSCompany.GetQuarterlyCompanyValue(company.id, 1));

		local value = GSCompany.GetQuarterlyCompanyValue(company.id, 1); //previous quarter

		local income = this.CompanyIncome(company.id);
		local cargo = this.CompanyCargo(company.id);

		local world_pop = 0;
		foreach(townid, _ in townlist) {
			world_pop += GSTown.GetPopulation(townid);
		}

		local vcount = this.CompanyVehicles(company.id);

		/*
		GetLoanAmount()
		GetBankBalance(id)
		GetQuarterlyIncome (CompanyID company, int quarter)
		GetQuarterlyExpenses (CompanyID company, int quarter)
		GetQuarterlyCargoDelivered (CompanyID company, int quarter)
		*/

		//GSLog.Info("Company " + company.id + "  money " + value + "  dif " + diff);

		this.el_num++;

		local newElementId = GSStoryPage.NewElement(
			this.story[company.storyid],
			GSStoryPage.SPET_TEXT,
			0,
			GSText(GSText.STR_STORY_PROGRESS_SHORT,
				this.current_year,
				value,
				income,
				cargo,
				world_pop,
				vcount
			)
		);

		this.storyElement[company.id].append(newElementId);

		if(this.storyElement[company.id].len() > 24){
			foreach(id, element in this.storyElement[company.id]){
				this.storyElement[company.id].remove(id);
				GSStoryPage.RemoveElement(element);
			  break;
			}
		}
	}
}

/* 	Save and Load functions  */
function MainClass::Save() {
	GSLog.Info("Saving data");
	this.data = {
		sv_game_length = this.game_length,
		sv_last_month = this.last_month,
		sv_leader = this.current_leader,
		sv_companies = [],
		sv_goals = [],
	};

	foreach(company in this.companies){
		data.sv_companies.append([company.id, company.storyid, company.score, company.victims_plane, company.victims_train, company.victims_road, company.victims_flood]);
	}

	foreach(goal_id in this.goals){
		data.sv_goals.append(goal_id);
	}

	return this.data;
}

function MainClass::Load(version, tbl) {
	GSLog.Info("Loading data");

	foreach(key, val in tbl) {
		if(key == "sv_game_length")  this.game_length = val;
		else if(key == "sv_last_month")	  this.last_month = val;
		else if(key == "sv_leader")	  this.current_leader = val;
		else if(key == "sv_companies") {
			foreach(company in val) {
				//GSLog.Info("Loading data C " + company[0] + "  " + company[1] + "  " + company[2] + "  " + company[3] + "  " + company[4] + "  " + company[5] + "  " + company[6]);
				this.companies.append( Company(company[0], company[1], company[2], company[3], company[4], company[5], company[6]) );
			}
		}
		else if(key == "sv_goals"){
			foreach(goal_id in val){
				this.goals.append(goal_id);
			}
		}
	}
	this.from_save = true;
}

function IsVehicleOwner(vehicle_id, companyid) {
	return GSVehicle.GetOwner(vehicle_id) == companyid;
}

/* company class */
class Company
{
	id = INVALID_COMPANY;
	storyid = -1;
	score = 0;

	victims_plane = 0;
	victims_train = 0;
	victims_road = 0;
	victims_flood = 0;

	constructor(id, storyid = -1, score = 0, train = 0, road = 0, plane = 0, flood = 0) {
		this.id = id;
		this.storyid = storyid;

		this.score = score;
		this.victims_plane = plane;
		this.victims_train = train;
		this.victims_road = road;
		this.victims_flood = flood;
	}
}
