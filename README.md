<pre>
  An autohotkey program to change key binds and create extra keyboards.
</pre>

The preset profiles and are HEAVILY "inspired" by the extend layer created by DreymaR [link](https://dreymar.colemak.org/layers-extend.html). Check it out.
If you use this program, i recommend reading about the extend layer, and copying this [Image](https://dreymar.colemak.org/res/div/Extend/Extend-ISO-NoMod-Win_96d-Labels.png) since it is basically the layout of the preset profile. In the future i will create a better way to keep track of which keys are where and what they do.

!WARNING! If you start using the Extend Layer, you will NEVER go back.
The extend layer makes navigation a lot more ergonomic and fast. I highly reccomend learning the shortcuts from the extend layer [WebPage](https://dreymar.colemak.org/layers-extend.html#:~:text=F12%20is%20faster.-,GENERAL,-SHORTCUTS).

My favorite use for the extend layer, is coding in an IDE, for example VsCode. The extend layer really complements the existing shortcuts of VsCode and makes coding a lot faster, more ergonomic and more satisfying. 

# Extend layer
## Quick links
1. [Getting started](#getting-started)
2. [Summary](#summary)
3. [What does Extend-layer do?](#what-does-extend-layer-do)
4. [How to use this program](#how-to-use-this-program)
5. [Functions and how to use them](#functions-and-how-to-use-them)

## Getting started
To run this script, do the following:

1. __Download and install Autohotkey v2.0__ <br>
  There are multiple options for this, the easiest is downloading it with [this .exe file.](https://www.autohotkey.com/download/ahk-v2.exe) <br>
  Alternatively, you can [download it here.](https://www.autohotkey.com/download/) <br>
  Or go to the official [autohotkey website](https://www.autohotkey.com/) and click the download button then choose Download v2.0. <br>

2. __Download and run the script__
   1. Go to [Releases](https://github.com/Osterie/extend-layer/releases/).
   2. Download the source code for the latest version.
   3. After downloading the source code, unzip it to an appropriate location on your computer.
   4. To run the program, run the "Run_this.ahk" file by double clicking it.
   5. If you want, you can right click "Run_this.ahk" and create a shortcut which you can drag to your desktop.
   
3. __How to run script on startup.__<br>
   On Windows:
   1. Use the shortcut Win+R to run windows utility, and then write "shell:startup" and press enter.
   2. Create a shortcut of the "Run_this.ahk" file and drag it to the file explorer tab you just opened with shell:startup

## Summary
1. Remap keys to new keys or new functionalities using a Gui.
2. Create Multiple virtual keyboards.
3. Create your own scripts and run them with a key bind.

## What does Extend-layer do?
### Extra virtual keyboards
Choose a key which can be used to switch to a different layer, by default this key is caps-lock, because what else would you use it for?
### Rebinding keys to a new key
#### Key modifiers
There are a couple key modifiers,
When rebinding a key you have to give a modifier for the original key you are remapping. Lets say you want to rebind "p" to "esc". If you want always want "p" to act as "esc", then you have to specify "*p", (ADD PICTURES FROM GUI!) which will change "p" to "esc" for any modifier, but if you only want Shift+p to act as "esc", then you must specify "+p".
- \*
- \^
- \!
- \+
- \#

### Rebinding keys to special functionalities
There are many premade special functionalities in this program, for example changing screen brightness, traveling to a url, excecuting scripts, and much more.
#### Rebinding a key to a shortcut
#### Rebinding a key to self-created script
#### Rebinding a key to launch a program
#### Creating macros
### Create your own autohotkey script and bind it to a key

## How to use this program?
After following the [getting started guide](#getting-started).
Run ExtraKeyboardsApp.ahk. This will open a gui where you can change you profile and edit keybinds.

### How to change a key bind?

#### Changing a key to a normal key
#### Changing a key to a functionality



## Functions and how to use them
