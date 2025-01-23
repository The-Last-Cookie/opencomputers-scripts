# OpenComputers scripts

Here, I wanted to list my scripts for the [OpenComputers](https://github.com/MightyPirates/OpenComputers) for Minecraft.

The "hypervisor" [ocelot.desktop](https://ocelot.fomalhaut.me/desktop) allows for emulating lua code for OpenComputers, without the need to have an actual Minecraft world at hand.

You can build on my work if you like to do so.

## Projects

### Reactor

Included are a terminal program and a GUI for controlling a reactor and an induction matrix.[^mods] Like it says in the name, the scripts are for accessing information about a reactor, so that the reactor can be activated on demand. Both versions are the same at their core, with the only difference being that the terminal just displays status information while the GUI also contains buttons to remotely manage the reactor from a computer.

### Related branches

The reactor terminal program is finished, however the GUI version rather resembles a library on the `master` branch at the moment, thus I already uploaded branches for testing an actual reactor control screen.

#### reactor-button-old

Implements buttons that use an action property to register a click. For that, a function could be called on clicking the button.

```lua
local button = buttonAPI.Button()
button.action = function () print("clicked") end
```

In the end, I did not like the syntax that resulted out of this, hence why I left it as a draft.

#### screen-test

First work-in-progress branch to implement a reactor control screen.

I recommend to begin on a new branch when finishing the screen, as the commit history is a bit of a mess.

### Drones

There is also a `drone` branch, as I wanted to experiment with automatic farming drones. Though, this branch is empty so far.

## Tasks

### Documentation

The programs are small, however the structure is rather complex due to the modularisation. Thus, it would be a good idea to add a documentation, especially for the [DrawAPI](/reactor/gui/Screens/UI/DrawAPI.lua). To mention a simple example, the width and height argument for drawing a BorderBox include the border.

Furthermore, the structure of my program allows adding several screens. When running, you can switch between the screens via buttons in a toolbar (see `screen-test` branch). The current [ReactorScreen](/reactor/gui/Screens/ReactorScreen.lua) contains a template for adding a new screen. After this step, the screen would need to be added in the [ScreenManager](/reactor/gui/Screens/ScreenManager.lua) file.

### Lua conventions

While the program gets not any less complex, regardless of what framework is used for the UI, the code itself can be made more readable by sticking to a common convention guide, e.g. that from [LuaRocks](https://github.com/luarocks/lua-style-guide).

### Colour API

For colours that are frequently used, an API could be added to make the colours more consistent.

```lua
General = {
    White = 0xFFFFFF
    Black = 0x000000
    Grey1 = 0x2F4F4F
}
```

### Debug screen

Add a debug screen if the public variable `DEBUG` in [Program.lua](/reactor/gui/Program.lua) is set to "true".

### Bug fixes

> [!IMPORTANT]  
> When working on the `screen-test` branch, please keep in mind that there are still bugs present.

I have not worked on this project for a while, so the information written here may be wrong or outdated. You should be careful about the branch you are on when investigating these. I tried to be as descriptive as possible.

- Lamps are not drawn correctly under certain circumstances. Maybe the width and height needs to be adjusted.
- Some buttons are "blinking". I'm not sure if this is due to the rendering not being fast enough (unlikely) or if there is something drawing over the buttons for a split second.

## See also

Besides my work, there is also a GUI library which I really like and could imagine using in my own scripts called [interface](https://github.com/OpenPrograms/MiscPrograms/tree/master/TankNut) by TankNut. All UI elements are handled in a single instance and referenced via a certain name. My current button structure you can find on the `screen-test` branch would lead to boiler plate code because the properties of a button need to be specified in separate lines. With this framework, the code looks a bit cleaner.

A very basic example of the usage is shown below:

```lua
interface.newButton("s1-2","Screen 2",9,1,8,3,screen2,nil,0x00FF00,0x0000FF,1)

while true do
    interface.processClick(x,y)
end
```

Another library which could be of use is [charts](https://github.com/OpenPrograms/Fingercomp-Programs/tree/master/charts).

If you want to take inspiration from other people's work, there is a listing of OpenComputers scripts available [here](https://openprograms.github.io/), which also contains a few reactor status programs.

[^mods]: Reactor from [Big Reactors](https://ftbwiki.org/Big_Reactors) and induction matrix from [Mekanism](https://wiki.aidancbrady.com/wiki/Main_Page)
