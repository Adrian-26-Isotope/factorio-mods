> **The spiritual successor to the upcycler mod, which was the spirital successor to the awesome sink.**

### Introduction

The vanilla quality upscaling is slow: Constantly repeating crafting and recycling, mixed with complex logics and logistics. This mod shall simplify this process, but keeping the original upgrade rates.

Those familair with old minecraft modpacks might recognize the energy condenser,
in which you could set a target item and everything inside will slowly convert to that.

The Quality Condenser is similar. All the items inside will slowly combine and upgrade to the next quality tier over time. The common variant returns 25% of all input items (identical to the recycler), tho it does not return the inputs ingredients, but the input items themselves. It also has 4 module slots to put quality modules in (same as recycler). In contrast to the vanilla recycler the Quality Condenser can process a large amount of items simultaneously. This comes at the cost of a huge energy consumption (500MW).

| Feature | Quality Condenser | Vanilla Recycler |
|---|---:|---:|
| Module slots | 4 | 4 |
| Output rate | 25%–50% (quality-dependent) | 25% (fixed) |
| Output items | same as input | components |
| processing amount | many item stacks at once | 1 at a time |
| Energy consumption | very high (500 MW) | very low |
| Crafting speed | very slow (600s) | very fast |

A honorable mention to the [Augmentor](https://mods.factorio.com/mod/augmentor) mod by [khoanguyen0497](https://mods.factorio.com/user/khoanguyen0497),
that mod released whilst this mod was still being developed over the span of a month with similar functionality,
notable differences are that mine does not require taking the item out and back in, and its not data stage based.

### Functionality

The quality condenser uses a probabilistic re-creation system where items are consumed and potentially re-created based on the condenser's quality level:

**Item retention rates (by condenser quality):**
- **Normal**: 25% re-created / 75% consumed
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

**Quality Modules are Essential:** The quality modules determine the upgrade chance for re-created items. Without quality modules, items will still be consumed and re-created based on the condenser's quality level, but they won't upgrade to higher quality tiers.

Once the machine has items, it will process them through the consumption/re-creation cycle. You can leave the result items in to process them further, or extract them for use elsewhere. The condenser only goes idle when its inventory is completely empty.

**Extract items** at the desired quality level, or else the will likely be consumed by the next crafting cycle.

Higher qualities of the machine itself:
- Retain more items during each cycle (up to 50% for legendary)
- Are faster

### Configurability

In the startup settings you are able to change the module slots and energy consumption.

### Credits

- "Disruptor" (later named) "Research Center" graphics by [Hurricane046](https://mods.factorio.com/user/Hurricane046)
- [Quezler](https://github.com/Quezler) creating the [inital implementation](https://github.com/Quezler/glutenfree/tree/main/mods_2.0/050_quality-condenser) this variant is based on.
