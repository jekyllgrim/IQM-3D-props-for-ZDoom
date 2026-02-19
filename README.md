## IQM 3D props for ZDoom
by Agent_Ash (aka Jekyll Grim Payne aka jekyllgrim)

## What this is
A pack of 3D models made for Doom mappers, using the [IQM](https://zdoom.org/w/index.php?title=MODELDEF#IQM) model format and coded in [ZScript](https://zdoom.org/w/index.php?title=ZScript). Only compatible with [UZDoom and GZDoom](https://zdoom.org/downloads); minimum ZScript version is 4.14.0.

The models use textures from Doom II which are NOT included in the project itself. The textures will be automatically applied if doom2.wad (or another resource containing textures with the same names) is loaded.

### Licenses and attribution
- Code: [MIT license](PropsZScript/LICENSE.txt). Basically, this means that anyone can use it for any purpose (including modifying and commercial use), as long as Agent_Ash is credited as the original author.
- Models: [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/).
Basically, this means that both the code and the models can be used by anyone for any purpose (even commercially), but Agent_Ash must be credited as the original author.

## Features
- A set of various low-poly 3D props specifically design to easily fit with Doom II environments. The models use the regular Doom II level textures (referencing them or their patches directly by name).
- Props for various environments: office, bathroom, general use. You will find chairs, tables, desks, a toilet and many more.
- Collision rules are customizable via the actor's arguments in the map editor directly: you can set the props to block movement, or attacks, or both, or neither.
- A number of props can be made interactive: turn on the water, flush the toilet, open and close the filing cabinet and a lot more.
- No need to set up textures: just place the models, and they'll automatically reference textures from doom2.wad.

### Special properties
The prop actors come with special customization via actor arguments (accessible at the "Action / Tag / Misc." tab in the actor properties window). The following features are available:
* **Disable gravity** - determines gravity effects
 - `False` (default): the prop will be affected by gravity
 - `True`: the prop will not be affected by gravity
* **Movement collision** - determines how it collides with other actors
 - `None` (default): the prop will not collide with any other actors. (Note, it may still block projectiles if "Attack collision" is set to do so)
 - `Only other props`: the prop will only collide with other props from this pack, as long as their own Movement collision is *not* "None". For example, if you want to place a desk and a PC on top and you don't want them to block movement but also don't want the PC to fall through the desk, make sure both props have Movement collision set to this option.
 - `Full`: the prop will block all movement like a regular Solid actor. (Note, whether it'll block projectiles will be determined by "Attack collision" setting)
* **Attack collision** - determines if prop can block attacks. Note, props cannot be damaged or moved by attacks.
 - `None` (default): hitscan attacks and projectiles will pass through the prop
 - `Only projectiles`: projectiles will explode on the prop, hitscans will pass through
 - `Only hitscans`: projectiles will pass through the prop, hitscans will hit it
 - `Full`: both projectiles and hitscans will hit the prop
* **Interactive** - only used by props that can be interacted with (like a toilet, a filing cabinet, and some others)
 - `True` (default): pressing Use at the prop will make it play animations (this can be done repeatedly)
 - `False`: the prop will not react to pressing Use