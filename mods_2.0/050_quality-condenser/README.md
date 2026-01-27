> **The spiritual successor to the upcycler mod, which was the spirital successor to the awesome sink.**

### Introduction

Those familair with old minecraft modpacks might recognize the energy condenser,
in which you could set a target item and everything inside will slowly convert to that.

The quality condenser is roughly similar, set a target quality (or leave it uncapped),
then all the items inside will slowly combine and upgrade to the next quality tier over time.

A honorable mention to the [Augmentor](https://mods.factorio.com/mod/augmentor) mod by [khoanguyen0497](https://mods.factorio.com/user/khoanguyen0497),
that mod released whilst this mod was still being developed over the span of a month with similar functionality,
notable differences are that mine does not require taking the item out and back in, and its not data stage based.

### Functionality

The quality condenser uses a probabilistic re-creation system where items are consumed and potentially re-created based on the condenser's quality level:

**Item retention rates (by condenser quality):**
- **Normal (Common)**: 25% re-created / 75% consumed
- **Uncommon**: 28% re-created / 72% consumed
- **Rare**: 33% re-created / 67% consumed
- **Epic**: 40% re-created / 60% consumed
- **Legendary**: 50% re-created / 50% consumed

Re-created items then roll for quality upgrades based on the quality modules installed in the condenser. Upgrades follow Factorio's normal chaining mechanics, meaning an item can jump multiple quality tiers in a single cycle (e.g., normal → rare).

**Key Features:**
- Each item has an independent chance to be re-created based on the condenser's quality
- Re-created items roll for quality upgrades using module effects
- Quality upgrades can chain through multiple tiers in one cycle
- Spoilage percentage is preserved on re-created items
- The condenser only goes idle when its inventory is completely empty

## Balance

The quality condenser now uses a quality-dependent probabilistic system that differs from the recycler:
- Recyclers have 4 module slots and a fixed 25% output chance
- The quality condenser defaults to 4 module slots and has variable item retention based on its own quality (25%-50%)
- Higher quality condensers retain more items, making legendary condensers particularly efficient
- Output is probabilistic rather than guaranteed, adding variability to the process

### Usage

After researching (which is free) craft and place the device. It consists of two parts: the center entity is the crafter where you can install modules, and the outer edge of the selection box provides access to the container for items.
(Note: you cannot put items in the machine from the crafter GUI, use inserters/loaders)

**Quality Modules are Essential:** The quality modules determine the upgrade chance for re-created items. Without quality modules, items will still be consumed and re-created based on the condenser's quality level, but they won't upgrade to higher quality tiers.

Once the machine has items, it will process them through the consumption/re-creation cycle. You can leave the result items in to process them further, or extract them for use elsewhere. The condenser only goes idle when its inventory is completely empty.

Higher qualities of the machine itself:
- Retain more items during each cycle (up to 50% for legendary)
- Are faster
- Have more upgrade slots

### Configurability

In the startup settings you are able to change the module slots, base quality (per quality),
and even set which technologies unlock additional bonus quality ontop of the base quality,
some notable options to explain the format and serve as examples:

Base quality: (has access to lua's math helper)
- `0` (no base quality)
- `10 * (quality.level)` (no base quality, then 10% per quality)
- `10 * (quality.level + 1)` (10% base quality, then 10% per quality)

Technology effects: (flat value ontop of the base quality)
- `""` (no additional base quality)
- `planet-discovery-fulgora=10,planet-discovery-gleba=10,planet-discovery-vulcanus=10,planet-discovery-aquilo=20` (extra quality per known planet)
- `speed-module=-1,speed-module-2=-1.5,speed-module-3=-2.5` (want to punish some technology choices? you can)

### Number 3

This is the third mod in my quality upgrading serries:
1) https://mods.factorio.com/mod/awesome-sink
2) https://mods.factorio.com/mod/upcycler
3) https://mods.factorio.com/mod/quality-condenser

This mod was born due limitations in the first two mods and user requested features,
the most notable changes are in terms of throughput and performance, this mod is just better.

The quality condenser is capable of completely emulating the first two mods:
- for the awesome sink, just set module slots to 4
- for the upcycler, set the module slots to 0 and divide 100 by your "items per next quality" and set that as base quality

For a comparison table check out the previous version of this readme here:
https://github.com/Quezler/glutenfree/blob/main/mods_2.0/050_quality-condenser/README_1.md
(notable mentions: this mod does respect spoil percentages and does not kidnap inserted legendary items)

### Credits

- "Disruptor" (later named) "Research Center" graphics by [Hurricane046](https://mods.factorio.com/user/Hurricane046)
