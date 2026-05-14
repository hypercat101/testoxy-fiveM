<div align="center">

# OXY-DELIVERY-FIVEM-RESOURCE


![last commit](https://img.shields.io/github/last-commit/hypercat101/oxy-delivery-FiveM-Resource?label=last%20commit&color=blue)
![lua](https://img.shields.io/badge/lua-100.0%25-blue)
![languages](https://img.shields.io/badge/languages-1-gray)

*Built with:*

![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

</div>

-----

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
	- [Usage](#usage)
	- [Testing](#testing)
- [Configuration](#configuration)
- [Permissions](#permissions)

-----

## Overview

**OXY-DELIVERY-FIVEM-RESOURCE** is a lightweight FiveM delivery job script where players pick up a package, drive to a server-assigned drop location, complete a skill check, and receive a cash payout.

**Key Features:**

- 📦 Package pickup and randomized delivery routes
- 🔒 Server-validated payouts with active-run, cooldown, and location checks
- ⏱️ Delivery time limit and cooldown protection
- ⚙️ Configurable framework mode, rewards, blips, and notifications

-----

## Getting Started

### Prerequisites

- A FiveM server running **FXServer**
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- Either **ESX** (`es_extended`) or **QBCore** (`qb-core`)

### Installation

1. Download this repository.
1. Place the folder in your server's `resources` directory.
1. Add the following to your `server.cfg`:

```cfg
ensure oxy-delivery-FiveM-Resource
```

### Usage

Once installed:

1. Go to the configured start location.
1. Interact with the delivery package.
1. Drive to the assigned drop-off marker.
1. Interact with the drop NPC and pass the skill check.
1. Receive your configured payout.

### Testing

1. Start your FiveM server with the resource enabled.
1. Start one delivery and verify route + drop NPC spawn.
1. Complete the skill check and confirm payout is awarded.
1. Try starting a new run during cooldown and confirm it is blocked.
1. Let a run expire and confirm it fails with timeout feedback.

-----

## Configuration

The configuration file is located at `config.lua`.

|Option|Description|Default|
|---------------------------|------------------------------------------------------------|----------------|
|`Config.Framework`|Framework integration mode|`esx`|
|`Config.Debug`|Enable console debug logging|`false`|
|`Config.Cooldown`|Minutes between completed deliveries|`5`|
|`Config.DeliveryTimeLimit`|Minutes allowed to complete each delivery|`5`|
|`Config.Rewards.money`|Cash payout amount|`2500`|
|`Config.Locations.start`|Start location vector|`vector3(-103.5, 6330.5, 31.5)`|
|`Config.Locations.delivery`|List of possible drop-off locations|`10 locations`|
|`Config.Notifications`|Client-facing notification strings|*(see `config.lua`)*|
|`Config.Blip`|Route blip sprite/color/scale configuration|*(see `config.lua`)*|

-----

## Permissions

No custom ACE permission is required by default.

Access control is handled by your framework/player economy setup (ESX or QBCore), and payout validation is enforced server-side.

-----

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request on GitHub.

-----

## License

This project is open source. See the repository for details.

-----

<div align="center">
	<sub>Made by <a href="https://github.com/hypercat101">hypercat101</a> · Hypers Development</sub>
</div>