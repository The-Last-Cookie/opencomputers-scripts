# Reactor methods

Reactor: br_reactor

For getting the methods and their documentation, `component` can be useful: [Component API](https://ocdoc.cil.li/api:component), e.g. `component.doc()` or `component.methods()`

Notice: Using too many calls at once *may* impact performance when drawing on screen in short intervals!

[This](https://github.com/ZeroNoRyouki/ExtremeReactors2/blob/master/src/main/java/it/zerono/mods/extremereactors/gamecontent/multiblock/reactor/computer/ReactorComputerPeripheral.java) seems to be the relevant source code. I did not find any other source backing this document up, so a lot of guess-work had to be done. Values, units or descriptions **may be incorrect** as a result of this!

## Unusable

Methods which are not implemented or where their use is unclear.

- help
- isMethodAvailable

## Helper methods

The function header suggests that these methods are helper methods.

- mbGetMaximumCoordinate
- mbGetMinimumCoordinate
- mbGetMultiblockControllerTypeName
- mbIsAssembled
- mbIsConnected
- mbIsDisassembled
- mbIsPaused

## Meta information

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getMaximumCoordinate() | Point in the multiblock structure furthest from the world's origin | number |
| getMinimumCoordinate() | Point in the multiblock structure closest to the world's origin | number |
| getMultiblockAssembled() | Whether the reactor is correctly assembled | bool |
| getActive() | Whether the reactor is active | bool |
| setActive(bool) | Set the reactor active/inactive |  |
| getConnected() | Whether the computer is connected to the reactor | bool |

## Control rod management

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getControlRodLevel() | | |
| getControlRodLocation() | | |
| getControlRodName() | | |
| getControlRodsLevels() | | |
| getNumberOfControlRods() | | |
| setAllControlRodLevels() | | |
| setControlRodLevel() | | |
| setControlRodName() | | |
| setControlRodsLevels() | | |

## Cooling

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| isActivelyCooled() | Whether the reactor is cooled | bool |
| getCoolantAmount() | Collant currently in the reactor in mB | number (integer) |
| getCoolantAmountMax() | Maximum storable coolant? |  |
| getCoolantFluidStats() | Aggregation of related values | { fluidAmount, fluidCapacity } |
| getCoolantType() | Type of coolant used in the reactor |  |
| getCasingTemperature() | Casing temperature in °C | number (integer) |

## Fuel

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getFuelAmount() | Fuel currently in the reactor in mB | number (integer) |
| getFuelAmountMax() | Maximum storable fuel in mB | number (integer) |
| getFuelConsumedLastTick() | Fuel consumed last tick in mB (/t) | number (integer) |
| getFuelReactivity() | Fuel reactivity in % | number (integer) |
| getFuelStats() | Aggregation of related values | { fuelAmount, fuelCapacity, fuelConsumedLastTick, fuelTemperature, fuelReactivity } |
| getFuelTemperature() | Fuel temperature in °C | number (integer) |

fuelCapacity means likely the same as fuelAmountMax, etc.

## Hot fluid

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getHotFluidAmount() | Hot fluid currently in the reactor in mB | number (integer) |
| getHotFluidAmountMax() | Maximum storable hot fluid in mB | number (integer) |
| getHotFluidProducedLastTick() | Hot fluid produced in the last tick in mB (/t) | number (float) |
| getHotFluidStats() | Aggregation of related values | { fluidAmount, fluidCapacity, fluidProducedLastTick } |
| getHotFluidType() | Type of hot fluid used in the reactor |  |

## Energy statistics

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getEnergyCapacity() | Maximum storable energy? |  |
| getEnergyProducedLastTick() | Energy produced last tick in RF (/t) | number (float) |
| getEnergyStats() | Aggregation of related values | { energyCapacity, energyProducedLastTick, energyStored } |
| getEnergyStored() | Stored energy in RF | number (integer) |

## Reactor maintenance

| Method (Parameter) | Description | Return type |
| :-- | :-- | :-: |
| getWasteAmount() | mB | number (integer) |
| doEjectFuel() | Eject fuel |  |
| doEjectWaste() | Eject waste |  |
