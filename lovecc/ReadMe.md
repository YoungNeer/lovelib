# loveCC
A helper library for LOVE2D to help you with colors in general. While it may not seem much attractive in the first look. Believe me it can save you a *lot* of time. You can also use it as a palette manager. Typically Retro games have a limited color palette. So it could come really handy in such situations. You can think it as a color database (if that helps you understand what exactly is loveCC). Oh and BTW loveCC's full form is "Love Color-Codes" since it allows you to work with hexes (codes)

## Table of Contents:-

- [Context](#context-can-skip)
- [loveCC is now EVEN SIMPLER](#loveCC-is-now-even-simpler)
- [Documentation](#documentation)
    - [How to use loveCC?](#how-to-use-lovecc)
	- [Add your own colors to the palette!](#add-your-own-colors-to-the-palette)
	- [Adding your own palette!](#adding-your-own-palette)
	- [Convert loveCC colors to Love2D colors (if needed)](#convert-lovecc-colors-to-Love2D-colors)
	- [Setting Colors](#setting-colors)
	- [Inverting Colors](#invert-colors)
	- [Debugging and Error Handling](#error-handling)
- [Default Color-Palette used by loveCC](#default-color-palette)
- [Performance Issues (if any)](#performance-issues)
- [Contribution](#contribution)

## Context (can skip)
Let's say you want to print red text on the screen, how would you do that? Set color to the (1,0,0), right? Well that was easy 'cause every-one knows what is red. But what if you wanted a shade of red such as crimson? Well it's still not that difficult you may wikipedia crimson and set the color to the rgb triplet and remember you will have to divide each component by 255 in the newer version. And honestly saying that's not a lot of work - but what if you had several of such colors which had to difficult to remember color code such as 'light red', 'dark red', 'orange red', etc. So you have two good options - either make your own color-palette-manager to keep track of all the colors you are using or you can use loveCC which comes with default color palette - so you don't need to redefine the common colors such as 'lime', 'orange', etc.

### loveCC is now EVEN SIMPLER

Earlier to use the default color-palette you had to either memorize the color names (which may be simple for violet, khaki, etc but little difficult for colors like aliceblue,etc) or go to the palette file and see which color is it that you want to use. But both of that methods are non-visual and are actually *hit-and-try* method. So to save time you can use [ColorPicker](https://github.com/YoungNeer/lovelib/blob/master/lovecc/ColorPicker)  which is a simple tool to make color-picking an easy task. You just left-click a color and the color-name is copied to your clipboard. But you can also get the love2D color-format in your clipboard by simply right-clicking it. So left-clicking red would give you "red" and right-clicking will give you "1,0,0". Isn't that cool. Edit: In the newer versions you can just hover over a color and a tooltip text will appear therby showing you which color you have hovered

![Color Picker](ColorPicker/screens/screen.png "Color Picker in Action")

## Documentation

I may not cover all the aspects of loveCC (for that you need to take a dig at the source-code) so only the most important functions are discussed here.

### How to use loveCC?

Start with making a lovecc object which would be used later to set colors, get colors and reset color, set opacity and do all sorts of things.
```lua
	lovecc=require 'lovecc'
	--i like to do love.colors=require 'lovecc'
```
Now I know it's a little too early but try doing:

```lua
	lovecc.setColor('red')
	--same as love.graphics.setColor(1,0,0,1)
	lovecc.setColor('blue',0.5)
	--same as love.graphics.setColor(0,0,1,1)
```

> Note that loveCC is a package. So you simply copy the folder 'lovecc' to your 'lib' folder and say `require 'lib/lovecc'`. Before using make sure the folder contains the 'init.lua' file.

### Add your own colors to the palette!

loveCC already has most of the colors that you'd want to use and even colors you may not have even heard of. But sometimes you want to add your own color to the color palettes, you can do this using newColor() which accepts both hex and rgb triplet

```lua
	--Overload #1
	lovecc.newColor(colorname,r,g,b)
	--note r,g,b is in the range [0,255]
	
	--Overload #2
	lovecc.newColor(colorname,hex)
```

Examples are :-
```lua
	lovecc.newColor('perchblue',0,0,0.5)
	lovecc.newColor('perchred','#900')
	--same as lovecc.newColor('perchred','900')
	lovecc.newColor('gold','#ffd700')
	--same as lovecc.newColor('gold','ffd700')
```

So now you could use all these colors in `setColor` function.

> NOTE: Do NOT use `newColor` in `love.update` OR `love.draw` for performance reasons

### Adding your own palette!!!

Not just can you add your own colors to palette you can add your own palette. Four palettes are given to you to choose from (BTW loveCC doesn't use all these palettes by default. It only uses the 'default' one). But you could very well add your own palette as well. So let's see how one can add his own palette using lovecc.-

```lua
	lovecc.addPalette(palette_name,[is_hashtable],[is_love_format])
```

So the first parameter is the palette's name. This is the filename of the palette (with .lua removed) and note the file must be in the 'Palette' folder. The second argument tells loveCC whether the table is a hashtable or not- basically whether it is in the format `color={r,g,b}` or `{color,r,g,b}`. Please check the Palette `allcolors` and `xkd` for clarity. The third argument is an optional one which basically tells loveCC whether the format is in default love format or not. If it is then no conversions are to be done which is good if you are on a mobile-like device. And note that other than love's default format loveCC supports the standard (R,G,B) format and the hex format '#rgb' (or 'rgb') as well as '#rrggbb' (or 'rrggbb').

For eg. - If you want to set the 'xkd' palette then you simply have to say this

```lua
	lovecc.addPalette('xkd',true)
```

For your information `xkd` is the biggest database of colors. After adding the palette to you can use some uncommon (yet awesome) colors like 'green_yellow' (a very warm color) along with others.

> For performance reasons `xkd` doesn't come by default. But that shouldn't keep you from using it. Believe me - It has some really awesome colors

### Convert loveCC colors to Love2D colors

As you know Love2D doesn't understand 'red', 'blue', etc so you'll need some interface to convert the loveCC colors to Love2D color format. This is pretty simple.

```lua
	lovecc.getColor(colorname, opacity)
	--opacity is 1 by default
```

Examples are:-
```lua
	love.graphics.setColor(lovecc.getColor('green'))
	--sets color to green and opacity is 1
	love.graphics.setColor(lovecc.getColor('green',0.5))
	--sets color to green and opacity is 0.5
```

> Please note that `love.graphics.setColor(lovecc.getColor('green'),0.5)` won't work (it's Lua's problem not loveCC's btw)

If you want to get more than 1 color then you could use:-

```lua
	lovecc.getColors(color1,op1,...color8,op8)
	--get's n number of colors where 1<=n<=8
```

This could be useful when setting particle colors, for example-
```lua
	ParticleSystem:setColors(lovecc.getColors("red",1,"red",0.5,"blue",1,"blue",0.5))
	
	ParticleSystem:setColors(
		lovecc.getColors(
			"violet",1,"indigo",1,"blue",1,
			"green",1,"yellow",1,"orange",1,
			"red",1,"white",1
		)
	)
```

### Setting colors

Doing love.graphics.setColor(lovecc.getColor .. and all that looks too tacky - so loveCC provides a way to deal with that problem.

Instead of doing-
```lua
	love.graphics.setColor(lovecc.getColor(colorname, opacity))
```
You could do 
```lua
	lovecc.setColor(colorname, opacity)
```

And same for setting the Background Color:-
```lua
	lovecc.setBackgroundColor(colorname, opacity)
```

And if you only want to change the opacity then you could do:-
```lua
	lovecc.setOpacity(a)
	--color is same only opacity is changed
```

And to set particle colors you could do:-
```lua
	lovecc.setParticleColors(psystem,...)
	--Note vararg list shouldn't be nil and must be 8 at the very maximum
```

### Invert Colors

```lua
	lovecc.invert(colorname,opacity)
	--inverts the given color and sets opacity to given value (or 1 if nil)
	lovecc.invert(opacity)
	--inverts the current color and sets opacity to given value (or 1 if nil)
```

So if the current color is black and you used invert() then you will get white color!!

### Error-handling

What if a color doesn't exist? You could check for it yourself with the provided functions:-
```lua
	lovecc.check(...)
	--Returns true if all the colors passed in vararg list exists
	lovecc.assert(...)
	--Instead of returning anything it will throw an error if any color passed doesn't exist
```

### Default Color-Palette

Like I said earlier you don't need to redefine the common colors they are already defined for you- Infact all the CSS colors are defined for you. But sometimes you may not want all the default colors - for performance reasons. So all you have to do is go to mypalette.lua or allcolors.lua depending on which one you are using (By default allcolors.lua is used) and keep only the colors that you are using i.e. remove all the colors you are not using or don't want to use. Also you can make you own color-palette just by looking at mypalette.lua or allcolors.lua

> Edit: As of the latest version loveCC uses a new palette 'default' which is basically 'allcolors' but just in Love's format and not hex so that it'd be useful even for those who choose not to use loveCC - also because of performance reasons. And the 'allcolors' palette is not removed so that it might prove useful for those outside Love (you know like a reference)

### Performance Issues

If you are that concerned about performance then here's a tip! First figure out which color you want to use -- add them to the palette and all that. If you want to use only the default color-palette then you can skip this step. After that whenever you say `lovecc.setColor(some_color)` you can replace that later (when polishing the game) with `love.graphics.setColor()`. And honestly saying I myself never do that - I use some million color codes in my projects and NEVER EVER has the frame-rate dropped even by 1. So all I can say is this trick is for performance-maniacs and it can be a pain to replace every occurence even if you automate the task using some script. So I suggest you 'let-it-be' cause now-a-days everyone has a pretty fast computer and even mobile devices are getting stronger day by day.

### Contribution

Anyone can contribute to loveCC. Just keep in mind - that there are five lua files - one init.lua which is the kernel and others like mypalette.lua, allcolors.lua and so on. So you could contribute to either or both. Adding to mypalette.lua or allcolors.lua is easy - just wikipedia for common colors and if some color is not in the list then you can add it (also add a side comment eg. for crimson you can side comment 'a shade of red').
