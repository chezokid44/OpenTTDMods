# Destruction Disaster

## Description

Destruction Disaster is a lightweight OpenTTD Game Script that tracks how many passengers are lost in vehicle crashes, per company. It publishes those totals into a League Table so players can see, at a glance, which company has caused the most destruction.

---

## Features

- Crash victim tracking per company
- Live League Table scoreboard
- Handles company lifecycle events
- Save and load support

---

## How It Works

On game start, the script scans existing companies and sets up a League Table (fresh games only).
The script then runs continuously in a once-per-day loop (1 OpenTTD day is treated as 74 ticks).
It listens for Game Script events and reacts accordingly:
- Vehicle crashed: adds victims to the owning company’s total and updates that company’s League Table score.
- Company new: adds the company and creates a League Table entry.
- Company renamed: updates the League Table label.
- Company bankrupt / merged: removes the League Table entry and removes the company from tracking.
On save, it stores [company_id, victims] for all tracked companies. On load, it restores them and continues tracking.

---

## What's It For?

This script is for players who want a simple, always-on “disaster scoreboard” in a session.
It does not change gameplay mechanics, it only observes events and reports scores.

---

## Installation

1. Place the `Destruction Disaster` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Destruction Disaster**
3. To view the scores open the league table.

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

**The Dude**
This particular script was created on top of a proof of concept that was developed by **The Dude**. Thank you very much to The Dude for creating the original script and all and for all of their support.

**Master Hellish**  
Part of the [Master Hellish Modding Projects](https://github.com/MasterHellish)
Part of the [Master Hellish Links](https://linktr.ee/masterhellish)
