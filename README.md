# MiddleClickDragScroll.spoon

This Hammerspoon tool lets you scroll by holding down the middle mouse button and dragging it, the same as it works on Windows.
Especially useful to quickly scroll to the top or bottom of a page, if you don't have a Magic Mouse.

<video src="https://user-images.githubusercontent.com/19309705/236555947-c8a37ddf-8a1f-4b74-9285-89c317f88688.mp4"></video>

> [!NOTE]
> Due to OS limitations, it always scrolls the window currently below the mouse, not the window below the position
> where the dragging started, like it works on Windows. You therefore need to take some care to stay inside the window.

## Installation

This tool requires [Hammerspoon](https://www.hammerspoon.org/) to be installed and running.

### Option 1: Download from the releases page

Download the latest version by clicking [here](https://github.com/benediktwerner/MiddleClickDragScroll.spoon/releases/download/v1.0.0/MiddleClickDragScroll.zip)
(or going to the [Releases page](https://github.com/benediktwerner/MiddleClickDragScroll.spoon/releases)), unzip it, and double-click the unzipped `MiddleClickDragScroll.spoon`.
Note, double-clicking only does something if you already have Hammerspoon installed. Alternatively, you can also just move the `MiddleClickDragScroll.spoon` directory to `~/.hammerspoon/Spoons/`.

Either way, continue with the Usage section.

### Option 2: Use Git

In the Terminal:

```bash
mkdir -p ~/.hammerspoon/Spoons
git clone https://github.com/benediktwerner/MiddleClickDragScroll.spoon.git ~/.hammerspoon/Spoons/MiddleClickDragScroll.spoon
```

And then continue with the Usage section.

## Usage

After you installed MiddleClickDragScroll, add this to your `~/.hammerspoon/init.lua` file:

```lua
local MiddleClickDragScroll = hs.loadSpoon("MiddleClickDragScroll"):start()
```

Then reload your Hammerspoon configuration. This will start MiddleClickDragScroll with the default settings. To adjust the configuration, see the Configuration section below.

You can temporarily stop the spoon by calling `MiddleClickDragScroll:stop()` and then restart it by calling `MiddleClickDragScroll:start()` again.
For example, you could set up a hotkey to pause it like this:

```lua
hs.hotkey.bind({"cmd", "alt"}, "S", function() -- Cmd + Alt + S
  if MiddleClickDragScroll:isEnabled() then MiddleClickDragScroll:stop()
  else MiddleClickDragScroll:start() end
end)
```

### Configuration

```lua
local MiddleClickDragScroll = hs.loadSpoon("MiddleClickDragScroll"):configure{
  excludedFrontmostApps = {"Some App", "Other"},    -- Don't activate scrolling if the frontmost app has any of these names
  excludedApps = {"Some App", "Other app"},         -- Don't activate scrolling if the mouse is above a window of an app with these names. Prefer using `excludeFrontmostApps` if possible for better performance.
  excludedWindows = {"^Some Window Title$"},        -- Don't activate scrolling in windows with these names (supports regex, for exact match, use "^title$")
  excludedUrls = {"^https://geogebra.calculator$"}, -- Don't activate scrolling when the active window is on these URLs (supports regex, only works in Chrome and Safari, asks for extra permissions on first trigger)
  indicatorSize = 25,   -- Size of the scrolling indicator in pixels
  indicatorAttributes = -- Attributes of the scrolling indicator. Takes any specified on https://www.hammerspoon.org/docs/hs.canvas.html#attributes. Alternatively, you can pass a custom canvas, see the explenation below.
  {
    type = "circle",
    fillColor = { red = 0, green = 0, blue = 0, alpha = 0.3 },
    strokeColor = { red = 1, green = 1, blue = 1, alpha = 0.5 },
  },
  startDistance = 15,       -- Minimal distance to drag the mouse before scrolling is triggered.
  scrollMode = "pixel",     -- Whether the scroll speed is in "line"s or "pixel"s. Scrolling by lines has smooting in some applications
                            -- and therefore works with reduced frequency but it offers much less precise control.
  scrollFrequency = 0.01,   -- How often to trigger scrolling (in seconds)
  scrollAccelaration = 30,  -- How fast scrolling accelerates based on the mouse distance from the initial location. Larger is faster.
  scrollSpeedFn =           -- How scrolling accelerates based on the mouse distance from the initial location.
                            -- The default is dist^2 / scrollAcceleration^2. You can pass a custom function that recieves `self` as the first argument
                            -- and the absolute distance as the second and returns the resulting speed (in pixels or lines, depending on the scrollMode setting).
  function(self, x)
    return (x ^ 2) / (self.scrollAccelaration ^ 2)
  end
}:start()
```

Unspecified keys are unchanged. You can call `configure` multiple times to dynamically change it but changing `indicatorAttributes` and `indicatorSize` only works when `MiddleClickDragScroll` is stopped.

Instead of `indicatorSize` and `indicatorAttributes`, you can also pass a custom canvas to `configure` or set it directly to have more control over the indicator style:

```lua
  MiddleClickDragScroll.canvas = hs.canvas.new{ w = 25, h = 25}:insertElement{
    type = "circle",
    fillColor = { red = 0, green = 0, blue = 0, alpha = 0.3 },
    strokeColor = { red = 1, green = 1, blue = 1, alpha = 0.5 },
  }
```
