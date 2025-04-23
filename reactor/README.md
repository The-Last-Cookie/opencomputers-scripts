# Notes

## Interface framework

Next steps for the framework are adding old ui elements to the framework (like Borderbox) and then writing ReactorScreen.init() --> getting the coordinates and typing them in the new methods etc.

- Think about using `event.pull(program.screenRefreshtime, "touch")` vs `event.listen("touch", interface.handleTouch)`
- screen1 and screen2 should have a screen.init (see template in `ReactorScreen`)
  - then there's screen.update() triggered every `screenRefreshtime`
- move calculateEnergyDelta from `ReactorApi` to `ReactorScreen`
  - OR make thread inside `ReactorApi`
  - OR leave as-is in `ReactorApi`
  - OR change to `reactor.EnergyProducedLastTick()`?
- Move stuff closer to where it's needed and don't pass it down a long path of functions
  - `ReactorInfo` data variable in `ScreenApi` could have been moved locally to `ReactorScreen`
  - Think about a good file structure in general (this can be done after the new framework has been more fleshed out)

```lua
--Would something like this be feasible?

--Main.lua

init()
  interface.clearScreen()
  -- move clearScreen out of clearAllObjects and updateAll and call explicitly?
  -- > might be called twice otherwise and is also more clear in readability

  interface.clearAllObjects()
  if screenManager.activeScreen == 1 then
    reactorScreen.init()
  end

  interface.updateAll()
end

while program.isRunning
  init()

  while screenManager.updateLoop
    -- switchScreen sets updateLoop to false, so the loop exits
    (touchevent, screenRefreshtime?)
    if screenManager.activeScreen == 1 then
      reactorScreen.update()
    end
  end
end


-- does the init() idea here conflict with screenManager.switchScreen(screen) idea?
-- maybe it's best to leave as in the interface demo code with the reactorScreen.init() being left in main.reactorScreen() --> button then just calls main.reactorScreen()
```

Mache erst mal nur mit einem Screen ohne ScreenManager und baue dann darauf auf!

ClearScreen könnte aber vielleicht trotzdem schon raus aus updateAll und clearAllObjects.

## Old framework

- when starting script, all lamps are turned off (this is incorrect)
- "blinking buttons" (hysterises) --> not fast enough rendering? oder drübermalen?

## Other ideas

debug screen mit print(reactor.getActive()) wenn program.DEBUG = true?
(Auch zum testen des Programms geeignet)
