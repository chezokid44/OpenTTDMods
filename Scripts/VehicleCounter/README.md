# Vehicle Count

## Description

A simple OpenTTD Game Script that logs the **total number of vehicles** in the game once every in-game month.  
It’s designed as a lightweight tool for diagnostics, performance tracking, or development insight during gameplay or testing.

---

## Features

- Automatically runs every in-game day
- Detects month changes reliably
- Counts vehicles from **all companies**
- Outputs clean logs to the Game Script log

Example log output:
Number of vehicles in game: 327

---

## How It Works

- The script runs continuously in a daily loop
- Each day it checks if the in-game month has changed
- If the month is new:
  - It gathers all vehicles using `GSVehicleList()`
  - Counts them and logs the total using `GSLog.Info()`

The `last_month` variable ensures logging happens only once per month.

---

## What's It For?

This script is ideal for:
- Tracking how vehicle counts change over time
- Analyzing AI or player company expansion
- Stress-testing performance with large vehicle volumes
- Debugging issues in complex or heavily modded games

---

## Installation
1. Place the `VehicleCounter` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Vehicle Counter**
3. Once in-game, **click and hold the question mark (?) icon**, then choose **AI/Game Script Debug** to view the log output

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
