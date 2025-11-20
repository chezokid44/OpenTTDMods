# Boomtown Or Bust

## Description

Boomtown Or Bust is a gameplay focused OpenTTD Game Script where towns gradually shrink over time and can recover through player action. Buildings are removed from towns each day, and players must win certain subsidies to trigger bursts of town growth. The script creates a dynamic environment where towns can decline or expand depending on how players interact with the transport network.

---

## Features

- Reacts to passenger town to town subsidy awards
- Demolishes town buildings each in game day to simulate decline
- Randomly selects towns and tiles for destruction
- Ensures a minimum number of active subsidies
- Triggers rapid town growth when players win eligible subsidies
- Uses Game Script components such as GSController, GSEventController, GSTown, GSTile, GSSubsidy, and GSMap

---

## Parameters

The script includes several settings that let you tune the difficulty and behaviour of town decay and growth:

- towns_per_day - How many towns are affected each day. Higher values mean faster and wider decline across the map.
- buildings_per_town - How many buildings are demolished in each affected town per day. Controls the intensity of daily shrinkage.
- min_active_subsidies - The minimum number of subsidies that must exist at any time. If the number falls below this threshold, new town to town subsidies are created.
- subsidy_growth_iterations - How many growth steps are applied when a qualifying subsidy is awarded. Larger numbers produce much larger growth bursts.
  (0-50 Small, 50-100 medium, 100-300 large, 300+ silly)
- move_viewport_on_town_grow - If enabled, the game view automatically moves to the town when it grows. Useful for visibility and debugging.
- show_news_on_town_grow - If enabled, a news message is shown whenever a town grows.
  These values can be customised through the Game Script settings in OpenTTD, and each has its own easy, medium, hard, and custom defaults.

---

## How It Works

At startup the script posts a news message explaining that towns will shrink unless players earn subsidies. It then enters its continuous loop. Each day it selects a number of towns, looks for valid buildings inside those towns, and demolishes some of them. When a passenger subsidy is awarded between two towns, the script chooses one of those towns and gives it a growth surge. The script also checks how many subsidies exist and creates new ones if the number falls too low.

---

## What's It For?

This script is best suited for:

- Challenging worlds where player activity directly affects town survival
- Dynamic maps where town size changes throughout the game
- Players who want more pressure and variation in their transport routes

---

## Installation

1. Place the `BoomtownOrBust` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **MH Boomtown Or Bust**
3. Start a new game — the script will run automatically:

- A message will appear in the news feed
- Towns will begin shrinking each day
- Winning passenger subsidies will cause rapid town growth

---

## Bug Reporting & Help

To report bugs or get help the best place to go to is the Master Hellish Discord https://discord.masterhellish.net.
Here you can use the "openttd-mod-dev" channel for any conversations relating to this mod. Or you can use the "Help" forum for bug reporting.
If you are unable to use discord You can contact via another method [Master Hellish Links](https://linktr.ee/masterhellish).

---

## Usage & License

You are welcome to:

- Copy, modify, or expand this script
- Use it for public or private projects
- Share it with credit to Master Hellish

**Disclaimer:** Use at your own risk. No guarantees or warranties are provided.

---

## Created By

**Master Hellish**  
Part of the [Master Hellish Modding Projects](https://github.com/MasterHellish)
Part of the [Master Hellish Links](https://linktr.ee/masterhellish)
