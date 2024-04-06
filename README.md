<pre>
  An autohotkey program to change key binds and create extra keyboards.
</pre>

# Extend layer

The preset profiles are HEAVILY "inspired" by the [extend layer](https://dreymar.colemak.org/layers-extend.html) created by DreymaR. Check it out.
If you use this program i recommend reading about the extend layer and copying this [Image](https://dreymar.colemak.org/res/div/Extend/Extend-ISO-NoMod-Win_96d-Labels.png) since it is basically the layout of the preset profile. In the future i will create a better way to keep track of which keys are where and what they do, since the extend layer i have created is not identical to the DreymaR extend layer.

!WARNING! If you start using the Extend Layer, you will NEVER go back.
The extend layer makes navigation a lot more ergonomic and fast. I highly reccomend learning the shortcuts from the extend layer [WebPage](https://dreymar.colemak.org/layers-extend.html#:~:text=F12%20is%20faster.-,GENERAL,-SHORTCUTS).

My favorite use for the extend layer, is coding in an IDE, for example VsCode. The extend layer really complements the existing shortcuts of VsCode and makes coding a lot faster, more ergonomic and more satisfying. 


## Quick links
1. [Getting started](#getting-started)
2. [Summary](#summary)
3. [What does Extend-layer do?](#what-does-extend-layer-do)
4. [How to use this program](#how-to-use-this-program)

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

## What does Extend layer do?
### Extra virtual keyboards
Extend layer allows you to create multiple virtual keyboards. This is useful if you have a keyboard with a limited amount of keys, or if you want to create a keyboard for a specific program. For example, you can create a keyboard for a game, a keyboard for coding, a keyboard for browsing, etc. You can switch between these keyboards with a chosen keybind. By default the keybind is "CapsLock" to switch to a second keyboard layer and "Capslock + Shift" to switch to a third keyboard layer. You can change these keybinds to whatever you want.

### Rebinding keys to another key or a special action
The program allows you to rebind keys to other keys or special actions. 
For example, you can rebind the [I, J, K, L] keys to [Up, Left, Down, Right] to easily switch to navigating without having to move your right hand across half the universe to reach the arrow keys.

Additionally, you can rebind the keys, for example "a" to a special action like changing screen brightness, traveling to a url, excecuting a script, and much more.


## How to use this program?

1. [Add/Create a new profile](#how-to-add/create-a-new-profile?)
2. [Add/Modify/Delete a key bind](#how-to-add/modify/delete-a-key-bind?)
3. [What does Extend-layer do?](#what-does-extend-layer-do)
4. [How to use this program](#how-to-use-this-program)

After following the [getting started guide](#getting-started).
Run ExtraKeyboardsApp.ahk. This will open a gui where you can add some premade profiles, or create your own profile, and edit keybinds.

### How to add/create a new profile?

1. Click the "Add Profile" button.
![Add profile button image](../images/assets/READMEImages/AddProfileHighlighted.png?raw=true)

2. A dialog will open where you can select a predefined profile and choose a name for the profile.
![Choose a profile image](../images/assets/READMEImages/AddProfileDialogOpen.png?raw=true)

3. After selecting a profile, and giving it a unique name, click "Add Profile".

There are some predefined profiles to choose between, but if you want to create your own profile from scratch you can select "EmptyProfile".

Some profiles have a suffix like "_en" or "_no" which means that the profile is created for a specific keyboard layout. For example, "_en" is for the english keyboard layout and "_no" is for the norwegian keyboard layout.
![Create your own profile image](../images/assets/READMEImages/AddProfileCreatingOwnProfile.png?raw=true)


4. All done! You have created a new profile. You can now edit the keybinds and add new keybinds to your liking for this profile.


### How to add/modify/delete a key bind?

1. Select the profile you want to edit.
![The current profile highlighted](../images/assets/READMEImages/CurrentProfileHighlighted.png?raw=true)

2. Click on the "Keyboards" tab. This will show all the keyboard layers for the selected profile.
![Different keyboard layers highlighted](../images/assets/READMEImages/KeyboardLayersHighlighted.png?raw=true)

3. Click on the keyboard layer you want to edit. This will show all the keybinds for the selected keyboard layer. From here you can add, edit or delete keybinds. 

If you haven't selected an existing keybind, only the "add" keybind button is enabled. If you select an existing keybind, the "edit" and "delete" keybind buttons are enabled.

![buttons for adding, editing or deleting a hotkey highlighted](../images/assets/READMEImages/AddEditDeleteHotkeyHighlighted.png?raw=true)

4. Add, edit or delete a keybind by clicking the corresponding button.
- [Add a keybind](#add-a-keybind)
- [Edit a keybind](#edit-a-keybind)
- [Delete a keybind](#delete-a-keybind)

#### Add a keybind
1. After following the steps above, click the above highlighted "Add" button. (Alternatively you can press enter if the focused element is the different layers section (left side with GlobalLayer-Hotkeys and such))

2. A dialog will open where you have to have to set the hotkey and the action. The hotkey is the key you want to bind to a new action. The action is what you want the hotkey to do. Action can be a special action or a new key.

![Dialog for adding a hotkey](../images/assets/READMEImages/AddHotkeyDialog.png?raw=true)

##### Set Hotkey
1. Click the "Set Hotkey" button.

2. A dialog will open where you can set the hotkey. There are two different modes to this. [*Simple*](#simple) and [*advanced*](#advanced), which can be switched between by clicking the "Advanced mode" button.

3. Follow the guide [*Simple*](#simple) or [*advanced*](#advanced) hotkey setting.

4. Remember to also set an [action!](#set-action)

###### *Simple*

To set the hotkey you want, simply select the highlighted input field and press the key you want to bind to the action. You can also press key modifiers like shift, alt and ctrl, however not Win.

After choosing a keybind, press the save button.
![Setting a hotkey simple method](../images/assets/READMEImages/SetHotkeySimple.png?raw=true)


###### *Advanced*

To create a hotkey you need to:
- Select the modifier keys you want to use.
- Select the key you want to from the dropdown menu.
- If you want, change if the keybind should activate when the key is pressed down, or released.
- Save!


![Setting a hotkey advanced method](../images/assets/READMEImages/SetHotkeyAdvanced.png?raw=true)

##### Set Action

1. Click the "Set Action" button.

2. A dialog will open where you can set the Action. You can either set the action to a new key, or a special action.

3. Follow the guide [*Special Action*](#special-action) or follow parts of the [*Set Hotkey*](#set-hotkey) guide. When setting the new action to be a new key it is pretty much the same as the guide for setting a new hotkey (the image below is for setting a new key)

![Setting an action to a new key](../images/assets/READMEImages/SetActionNewKey.png?raw=true)

###### Special Action

To set the action to a special action, you need to select the action you want from the dropdown menu. After selecting the action, press the save button.

After selecting an action you will get an some information:
1. Action description: describes what the selected action does. 
2. Action to do: what the action does.
3. Action parameters: what parameters the action takes. For example, if the action is to change screen brightness, the parameter could be a number between 0 and 100, where 0 is the lowest brightness and 100 is the highest brightness. You yourself must fill out the parameters for an action to your liking.

After you have selected an action an filled out it's parameters, save!

![Setting an action to a special action](../images/assets/READMEImages/SetActionSpecialAction.png?raw=true)


#### Edit a keybind

1. Follow first the general steps for [adding/editing/deleting](how-to-add/modify/delete-a-key-bind?) a keybind, which is just finding which key you want to edit.
2. After having selected the keybind you want to delete, click the "Edit" button.
3. A dialog will open where you can edit the hotkey and the action. Follow the guide for [adding a keybind](#add-a-keybind) to set the hotkey and the action.


#### Delete a keybind

1. Follow first the general steps for [adding/editing/deleting](how-to-add/modify/delete-a-key-bind?) a keybind, which is just finding which key you want to delete.
2. After having selected the keybind you want to delete, click the "Delete" button.
3. The keybind will be deleted!
