# Hello Tycoons

A minimal example script for OpenTTD Game Scripts, designed to showcase how to send messages and interact with the game world in multiple ways.

This script outputs **"Hello Tycoons!"** to:
- The game log
- The in-game news feed
- A sign placed at the center of the map
- The first company's name (if present)

It's ideal as a **starting point** or **template** for new Game Script developers.

---

## ✨ Features
- ✔️ Logs a message via `GSLog`
- ✔️ Posts a general news item to all players
- ✔️ Places a sign in the centre of the map
- ✔️ Renames the first company to `"Hello Tycoon Company"`

This demonstrates core use of:
- `GSLog.Info()`
- `GSNews.Create()`
- `GSSign.BuildSign()`
- `GSCompany.SetName()`
- `GSMap` and `GSText` basics

---

## 🚀 Getting Started
1. Place the `HelloTycoons` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Hello Tycoons**
3. Start a new game — you’ll see greetings appear automatically:
   - In the game log
   - As a pop-up news item
   - As a sign in the middle of the map
   - (Optional) As the name of the first company

---

## 🛠️ License

MIT License — free to use, extend, and remix  
Contributions welcome!

---

## 🙌 Created By

**Master Hellish**  
Part of the [Master Hellish Modding Projects](https://github.com/MasterHellish)
