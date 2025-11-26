class MainClass extends GSController
{
	// Last calendar date we processed in DoDayLoop. Used to avoid double work within the same in-game day.
	last_processed_date = -1;

	// Cargo types used when creating and gating subsidies. Filled by the game script config.
	SUBSIDY_CARGO = 0;
	PASSENGER_CARGO = 0;

    invalid_subsidy_question_shown = false;

	constructor()
	{
		// Nothing to initialize yet. Fields are set above.
	}
}

function MainClass::Start()
{
	// Give the game a tick to fully initialize before we start our loop.
	this.Sleep(1);

	this.PostInit();

	// Main controller loop. Runs forever with a controlled sleep to target ~75 ticks per iteration.
	while (true) {
		// Capture loop start to compute how long work took, then sleep the remainder.
		local loopStartTick = GSController.GetTick();

		this.HandleEvents();   // Consume and react to pending GS events.
		this.DoDayLoop();      // Perform once-per-day logic, guarded by last_processed_date.

        // Keep loop pacing stable at roughly 75 ticks per cycle.
        local ticksPassed = GSController.GetTick() - loopStartTick;
        local sleepTicks = 74 - ticksPassed;
        if (sleepTicks < 1) sleepTicks = 1;

        this.Sleep(sleepTicks);
	}
}

function MainClass::HandleEvents()
{
	// Drain the event queue completely each loop.
	while(GSEventController.IsEventWaiting())
	{
		local ev = GSEventController.GetNextEvent();

		if(ev == null)
			continue;

        switch (ev.GetEventType()) {
            case GSEvent.ET_SUBSIDY_AWARDED: {
                // A town-to-town subsidy was just awarded. Potentially trigger a growth burst
                // when the awarded cargo is passengers and both endpoints are towns.
                local event = GSEventSubsidyAwarded.Convert(ev);
				local event_id = event.GetSubsidyID();

                if (GSSubsidy.GetCargoType(event_id) == PASSENGER_CARGO &&
                    GSSubsidy.GetSourceType(event_id) == GSSubsidy.SPT_TOWN &&
                    GSSubsidy.GetDestinationType(event_id) == GSSubsidy.SPT_TOWN) {

                    // Identify the two towns in the awarded route.
                    local ta = GSSubsidy.GetSourceIndex(event_id);
                    local tb = GSSubsidy.GetDestinationIndex(event_id);
                    local company_id  = GSSubsidy.GetAwardedTo(event_id);

					// Pull growth tuning from settings so it is script configurable.
					local grow_loop = GSController.GetSetting("subsidy_growth_iterations");

					// Randomly choose one endpoint to receive the growth explosion.
					local chosen = (GSBase.RandRange(2) == 0) ? ta : tb;
                    local town_location = GSTown.GetLocation(chosen);

                    local move_viewport_on_town_grow = GSController.GetSetting("move_viewport_on_town_grow");
                    if (move_viewport_on_town_grow){
                        GSViewport.ScrollEveryoneTo(town_location);
                    }

                    local show_news_on_town_grow = GSController.GetSetting("show_news_on_town_grow");
                    if (show_news_on_town_grow){
                        GSNews.Create(
                            GSNews.NT_GENERAL,
                            GSText(GSText.STR_SUBSIDY_AWARDED, company_id, chosen),
                            GSCompany.COMPANY_INVALID,
                            GSNews.NR_TOWN,
                            chosen
                        );
                    }

					this.TownGrowthExplosion(chosen, grow_loop);
                }
                break;
            }
		}
	}
}

function MainClass::PostInit()
{
	local show_intro_message = GSController.GetSetting("show_intro_message");
    if (show_intro_message){
    	// One time info message to set the scenario narrative.
    	GSNews.Create(
    	GSNews.NT_GENERAL,
    	GSText(GSText.STR_GAME_START_TOWNS),
    	GSCompany.COMPANY_INVALID,
    	GSNews.NR_NONE,
    	0
    	);
    }
}

function MainClass::DoDayLoop()
{
    // Enforce once-per-day execution using in-game date.
    local today = GSDate.GetCurrentDate();
    if (this.last_processed_date == today) return;

	// Daily tuning knobs. How many towns to affect and how many buildings per town.
	local towns_per_day = GSController.GetSetting("towns_per_day");
	local buildings_per_town = GSController.GetSetting("buildings_per_town");

    // Apply the decay mechanic by demolishing buildings across random towns.
    this.SmashBuildingsAcrossTowns(towns_per_day, buildings_per_town);

    // Record that we processed this date.
    this.last_processed_date = today;

	// Keep a minimum number of subsidies active to nudge players toward recovery routes.
	local min_subs = GSController.GetSetting("min_active_subsidies");
    EnsureSubsidies(min_subs);
}

function MainClass::SmashBuildingsAcrossTowns(town_count, buildings_per_town)
{
    // No work if either parameter is zero or negative.
    if (town_count <= 0 || buildings_per_town <= 0) return;

    // Choose distinct towns uniformly at random.
    local towns = GetRandomDistinctTownIds(town_count);

    // For each selected town, attempt to demolish a number of valid town buildings.
    foreach (tid in towns) {
        SmashInSingleTown(tid, buildings_per_town);
    }
}

function GetRandomDistinctTownIds(n)
{
    // Build a list of all towns, then shuffle using Fisher-Yates.
    local list = GSTownList();
    if (list.IsEmpty()) return [];

    local arr = [];
    for (local t = list.Begin(); !list.IsEnd(); t = list.Next()) arr.append(t);

    // In place Fisher-Yates shuffle over [0..len-1].
    for (local i = arr.len() - 1; i > 0; i--) {
        local j = GSBase.RandRange(i + 1) - 0; // j in 0..i
        local tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
    }

    // Take first k items after shuffle.
    local k = n < arr.len() ? n : arr.len();
    local out = [];
    for (local i = 0; i < k; i++) out.append(arr[i]);
    return out;
}

function SmashInSingleTown(town_id, buildings_per_town)
{
    if (town_id == null) return;

    // Start from the town center tile to sample nearby candidates.
    local town_tile = GSTown.GetLocation(town_id);
    if (!GSMap.IsValidTile(town_tile)) return;

    local move_viewport_on_town_smash = GSController.GetSetting("move_viewport_on_town_smash");
    local buildings_per_town = GSController.GetSetting("buildings_per_town");
    if (move_viewport_on_town_smash && buildings_per_town >=100){
        GSViewport.ScrollEveryoneTo(town_tile);
        this.Sleep(3 * 37); // Three second pause to begin with (assuming 12 minutes per year and 74 ticks a day)
    }

    local pop = GSTown.GetPopulation(town_id);
    local radius = floor(pop / 1000).tointeger() * 2 + 10;

    // Try to demolish up to buildings_per_town structures. Each has up to 100 attempts to find a valid target.
    for (local k = 0; k < buildings_per_town; k++) {
        local tries = 0;
        while (tries++ < 10) {
            local t = GetRandomNearbyTile(town_tile, radius);
            if (!GSMap.IsValidTile(t)) continue;
            if (!IsTownBuildingTile(t, town_id)) continue;

            // Attempt demolition. If it succeeded, move to the next building.
            if (GSTile.DemolishTile(t)) break;
        }
    }
    if (move_viewport_on_town_smash && buildings_per_town >=100){
        this.Sleep(3 * 37); // Three second pause to begin with (assuming 12 minutes per year and 74 ticks a day)
    }
}

function GetRandomNearbyTile(center_tile, radius)
{
    // Sample a tile uniformly from a square of side 2r+1 centered on center_tile.
    local cx = GSMap.GetTileX(center_tile);
    local cy = GSMap.GetTileY(center_tile);

    local dx = GSBase.RandRange(radius * 2 + 1) - radius;
    local dy = GSBase.RandRange(radius * 2 + 1) - radius;

    local nx = cx + dx;
    local ny = cy + dy;

    // Clamp to map bounds to avoid invalid indices.
    if (nx < 0) nx = 0;
    if (ny < 0) ny = 0;
    local max_x = GSMap.GetMapSizeX();
    local max_y = GSMap.GetMapSizeY();
    if (nx > max_x) nx = max_x;
    if (ny > max_y) ny = max_y;

    return GSMap.GetTileIndex(nx, ny);
}

function IsTownBuildingTile(tile, town_id)
{
    if (!GSMap.IsValidTile(tile)) return false;

    // Must be within this town's influence radius.
    if (!GSTile.IsWithinTownInfluence(tile, town_id)) return false;

    // Filter out infrastructure and transport tiles.
    if (GSTile.IsStationTile(tile)) return false;
    if (GSRail.IsRailTile(tile)) return false;
    if (GSRoad.IsRoadTile(tile)) return false;
    if (GSTile.HasTransportType(tile, GSTile.TRANSPORT_WATER)) return false;

    // Filter out natural or special purpose terrain that should not be smashed.
    if (GSTile.IsWaterTile(tile) || GSTile.IsRiverTile(tile) || GSTile.IsSeaTile(tile)) return false;
    if (GSTile.IsFarmTile(tile)) return false;
    if (GSTile.HasTreeOnTile(tile)) return false;
    if (GSTile.IsRoughTile(tile) || GSTile.IsRockTile(tile)) return false;

    // Skip industries entirely.
    local ind = GSIndustry.GetIndustryID(tile);
    if (GSIndustry.IsValidIndustry(ind)) return false;

    // Skip empty buildable ground. We only want actual buildings.
    if (GSTile.IsBuildable(tile)) return false;

    // Positive passenger acceptance is a strong signal that this is a house or civic building.
    if (PASSENGER_CARGO != null) {
        if (GSTile.GetCargoAcceptance(tile, PASSENGER_CARGO, 1, 1, 0) <= 0) return false;
    }

    // Passed all filters. Treat as a demolishable town building.
    return true;
}

function EnsureSubsidies(min_count)
{
    // Keep trying to create new subsidies until the minimum active count is met or attempts run out.
    if (min_count <= 0) return;

    local current =  CountUnawardedPassengerSubsidies();
    if (current >= min_count) return;

    local attempts = 0;
    while (current < min_count && attempts++ < 20) {
        if (CreateTownSubsidy()) {
            current++;
        }
    }
}

function CountUnawardedPassengerSubsidies()
{
    local lst = GSSubsidyList();
    local n = 0;

    for (local s = lst.Begin(); !lst.IsEnd(); s = lst.Next()) {

        if (GSSubsidy.IsAwarded(s)) continue;

        // only passenger subsidies count
        if (GSSubsidy.GetCargoType(s) != SUBSIDY_CARGO) continue;

        n++;
    }
    return n;
}

function CreateTownSubsidy()
{
    local min_distance_per = GSController.GetSetting("min_subsidie_distance");
    local max_distance_per = GSController.GetSetting("max_subsidie_distance");
    // Validation: min must be strictly less than max
    if (min_distance_per >= max_distance_per) {
        // Only show the info box once while broken
        if (!this.invalid_subsidy_question_shown) {
            this.invalid_subsidy_question_shown = true;
            GSGoal.Question(
                1001,
                0,
                "Invalid subsidy distance settings: Minimum must be less than maximum. Open the Game Script settings and fix Minimum distance for subsidy and Maximum distance for subsidy.",
                GSGoal.QT_WARNING,
                GSGoal.BUTTON_OK
            );
        }

        return false;
    }
    this.invalid_subsidy_question_shown = false;

    local manhattan_map_size = GSMap.GetMapSizeX() + GSMap.GetMapSizeY();
    local min_dist = manhattan_map_size * (min_distance_per.tofloat() / 100.0);
    local max_dist = manhattan_map_size * (max_distance_per.tofloat() / 100.0);

    // Create a single town-to-town subsidy for SUBSIDY_CARGO if possible.
    // Approach:
    // 1. Shuffle towns to get random ordering.
    // 2. Iterate distinct pairs and create a subsidy if none exists in either direction.
    local towns = GSTownList();
    if (towns.IsEmpty()) return false;

    local arr = [];
    for (local t = towns.Begin(); !towns.IsEnd(); t = towns.Next()) arr.append(t);

    // Shuffle towns for unbiased pairing.
    for (local i = arr.len() - 1; i > 0; i--) {
        local j = GSBase.RandRange(i + 1);
        local tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
    }

    // Try each unordered pair a,b. Attempt a->b first, then b->a if still not present.
    for (local i = 0; i < arr.len(); i++) {
        for (local j = i + 1; j < arr.len(); j++) {
            local a = arr[i];
            local b = arr[j];
            if (a == b) continue;

            // Distance check
            local loc_a = GSTown.GetLocation(a);
            local loc_b = GSTown.GetLocation(b);
            local manhattan_distance = GSMap.DistanceManhattan(loc_a, loc_b);

            // If not within the requested distance range, skip this pair.
            if (manhattan_distance <= min_dist || manhattan_distance >= max_dist) {
                continue;
            }

            // Skip if we already have a subsidy in either direction.
            if (HasTownTownSubsidy(a, b, SUBSIDY_CARGO)) continue;

            // Try a -> b
            if (GSSubsidy.Create(SUBSIDY_CARGO, GSSubsidy.SPT_TOWN, a, GSSubsidy.SPT_TOWN, b)) {
                return true;
            }

            // If still no subsidy, try b -> a
            if (!HasTownTownSubsidy(a, b, SUBSIDY_CARGO) &&
                GSSubsidy.Create(SUBSIDY_CARGO, GSSubsidy.SPT_TOWN, b, GSSubsidy.SPT_TOWN, a)) {
                return true;
            }
        }
    }
    return false;
}

function HasTownTownSubsidy(a, b, cargo_id)
{
    // Scan active subsidies for either direction between towns a and b for the given cargo.
    local lst = GSSubsidyList();
    for (local s = lst.Begin(); !lst.IsEnd(); s = lst.Next()) {
        if (GSSubsidy.GetSourceType(s) != GSSubsidy.SPT_TOWN) continue;
        if (GSSubsidy.GetDestinationType(s) != GSSubsidy.SPT_TOWN) continue;
        if (GSSubsidy.GetCargoType(s) != cargo_id) continue;

        local sa = GSSubsidy.GetSourceIndex(s);
        local sb = GSSubsidy.GetDestinationIndex(s);

        if ((sa == a && sb == b) || (sa == b && sb == a)) return true;
    }
    return false;
}

function MainClass::TownGrowthExplosion(town_id, looper)
{
	// Example usage: this.TownGrowthExplosion(0, 1, 1000)
	// town_id: town to grow
	// looper: number of times to apply growth, allows large bursts

	this.Sleep(3 * 37); // Three second pause to begin with (assuming 12 minutes per year and 74 ticks a day)

    local sleep_ticks = floor(5.0 * (1000.0 - looper) / 990.0).tointeger();
    if (sleep_ticks < 0) sleep_ticks = 0;
    if (sleep_ticks > 5) sleep_ticks = 5;

    for (local i = 0; i < looper; i++) {
        GSTown.ExpandTown(town_id, 1);
        if (sleep_ticks > 0) this.Sleep(sleep_ticks);
    }
}