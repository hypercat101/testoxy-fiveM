# oxyrunjob

Drug delivery job for FiveM. Players pick up packages and run them across the map - each drop requires a skill check minigame to get paid.

## What it does

- Package pickup at a fixed start location
- Random delivery points each run
- Skill check (ox_lib) on delivery - pass to get paid, fail and you walk away empty
- Cooldown between runs so players can't spam it
- NPC + blip markers at pickup and dropoff
- Works on ESX and QBCore

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- ESX (`es_extended`) or QBCore (`qb-core`)

## Setup

1. Drop `oxyrunjob` into your `resources` folder
2. Set `Config.Framework` in `config.lua` to `'esx'` or `'qbcore'`
3. Tweak pay, cooldown, and drop locations to your liking
4. Add `ensure oxyrunjob` to `server.cfg`

## Config

| Option | Default | Description |
|--------|---------|-------------|
| `Config.Framework` | `'esx'` | `'esx'` or `'qbcore'` |
| `Config.Cooldown` | `5` | Minutes between runs |
| `Config.DeliveryTimeLimit` | `5` | Time limit per delivery (minutes) |
| `Config.Rewards.money` | `2500` | Payout per successful drop |

Locations and notification strings are also in `config.lua`.

## How It Works

1. Interact with the package at the start marker
2. A random drop point gets assigned and marked
3. Drive to the NPC at the drop location and interact
4. Complete the skill check
5. Pass → get paid. Fail → nothing
6. Cooldown kicks in before you can take another run