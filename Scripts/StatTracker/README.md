# Stat Tracker

## Description

The **Stat Tracker** Game Script for OpenTTD keeps a running record of key in-game statistics such as vehicle counts, crashes, bankruptcies, and mergers. It automatically logs yearly updates to the debug console and can optionally display summary notifications within the game. The script is designed to provide easy visibility of company and world performance without requiring manual tracking.

---

## Features

- Tracks total number of vehicles, towns, and industries
- Records overall and categorized crash counts:
  - Train crashes
  - Road crashes
  - Flood crashes
  - Plane crashes
- Logs company bankruptcies and mergers
- Outputs detailed yearly summaries to the console
- Optionally displays in-game news notifications with key stats
- Fully compatible with save/load functionality
- Simple to configure and extend for custom tracking

---

## How It Works

The script runs once per in-game year. At the end of each year:

1. It gathers statistics from the world and companies using OpenTTD’s GameScript API.
2. It updates internal counters for crashes, bankruptcies, and mergers.
3. It writes a structured summary to the log output using `GSLog.Info`.
4. If enabled, it generates a news article summarizing the year’s performance.
5. The data is saved and reloaded between sessions, ensuring persistent tracking.

This design allows for lightweight monitoring without affecting gameplay balance or performance.

---

## What's It For?

**Stat Tracker** is ideal for:

- Players who want to monitor long-term progress in single-player or sandbox games.
- Content creators who want to display in-game data for videos or streams.
- Scenario or mod developers who need a framework for event-based statistics.
- Anyone interested in analyzing OpenTTD world data in a clean and automated way.

---

## Installation

1. Place the `StatTracker` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Stat Tracker**
3. Once in-game, **click and hold the question mark (?) icon**, then choose **AI/Game Script Debug** to view the log output

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
