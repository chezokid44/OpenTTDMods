# Boomtown Or Bust

## Description

Boomtown Or Bust is a gameplay focused OpenTTD Game Script where towns gradually shrink over time and can recover through player action. Buildings are removed from towns each day, and players must win certain subsidies to trigger bursts of town growth. The script creates a dynamic environment where towns can decline or expand depending on how players interact with the transport network.

---

## Features

- Reacts to passenger town to town subsidy awards
- Demolishes town buildings each in game day to simulate decline
- Randomly selects towns and tiles for destruction
- Ensures a minimum number of active subsidies
- Applies distance limits when generating new subsidies
- Triggers rapid town growth when players win eligible subsidies
- Optional intro message when the game starts or loads
- Optional viewport movement on town growth or large town smash

---

## Parameters

The script includes several settings that let you tune the difficulty and behaviour of town decay and growth:

- towns_per_day - How many towns are affected each day. 1 for steady long term play, higher values mean faster and wider decline. Range 1 to 500. Defaults are easy 1, medium 2, hard 3, custom 1.
- buildings_per_town - How much destruction in each affected town per day. 1 for steady decline, 500 for town smash. Range 1 to 500. Defaults are easy 1, medium 2, hard 3, custom 1.
- subsidy_growth_iterations - How many growth steps are applied when a qualifying subsidy is awarded. 50 is small, 500 is lots, 2000 is silly. Range 1 to 2000. Defaults are easy 100, medium 50, hard 25, custom 50.
- min_active_subsidies - The minimum number of subsidies that must exist at any time. If the number falls below this threshold, new town to town subsidies are created. Range 0 to 50. Defaults are easy 10, medium 5, hard 3, custom 5.
- min_subsidie_distance - Minimum distance required for subsidy creation, as a percentage of the map. Range 1 to 90. Defaults are easy 1, medium 5, hard 10, custom 5.
- max_subsidie_distance - Maximum distance allowed for subsidy creation, as a percentage of the map. Range 10 to 100. Defaults are easy 10, medium 20, hard 50, custom 20.
- show_intro_message - If enabled, an introduction message is shown when the game starts or loads. Default 1 (enabled).
- show_news_on_town_grow - If enabled, a news message is shown whenever a town grows. Default 1 (enabled).
- move_viewport_on_town_grow - If enabled, the game view automatically moves to the town when it grows. Default 0 (disabled).
- move_viewport_on_town_smash - If enabled, the game view automatically moves to the town when destruction of 100 or more occurs. Default 1 (enabled).

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
