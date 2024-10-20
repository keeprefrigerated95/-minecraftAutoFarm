~~~~~~~~~~~~~ Auto Farm ~~~~~~~~~~~~~
 An Auto Hot Key Version 2 script that will
 harvest and replant a field of
 crops in Minecraft
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*************************
 RUNNING THE SCRIPT
*************************
Download the autoFarm.exe file and the settings.txt file from the GitHub.

https://github.com/keeprefrigerated95/-minecraftAutoFarm/tree/main

Double click the exe file to run the program. Make sure that the .exe file and .txt file are
in the same directory (folder).

The script will make the player harvest and plant crops from right to left, top to bottom, like
reading the words on this page. After one row is harvested the script walks the player back to the
chest at the beginning of the row and deposits everything in inventory, excluding the hot bar.

Before you begin harvesting, position your character in the starting position,
looking straight down, and facing towards the end of the first row. Make sure
That they are facing as straight as possible.

Make sure your inventory is completely empty and that seeds or crops are in your off hand.
You may optionally hold a hoe in your main hand. Nothing from your hot bar will be deposited,
only items from your inventory.

At any time if you need to kill the script, press the X key. To pause the script, press P.

*************************
 FIELD SETUP
*************************
This script assumes that your field will be set up as follows:

x: tilled soil with crops planted
o: water blocks
H: Hopper/chest/barrel
P: character starting position
S: a descending stair block, leading to the next layer
-: an empty space


All the blocks in this diagram are at the same Y coordinate, with the exception of stairs. 
This diagram is viewed from the top, down and represents a single layer

-oooooooooo
Pxxxxxxxxxx ---->
Hxxxxxxxxxx ---->
Hxxxxxxxxxx 
Hxxxxxxxxxx 
-oooooooooo 
-xxxxxxxxxx |
Hxxxxxxxxxx |
Hxxxxxxxxxx |
Hxxxxxxxxxx V
-oooooooooo
-----------
-SSSS------

*************************
SETTINGS
*************************
The script reads settings from the text file settings.txt, giving you the ability to customize
the script to your farm layout. These are the following parameters:

layers: The number of layers of farm fields stacked on top of each other, all layers must be identical

sectionsPerLayer: A section consists of the rows in-between two rows of water. In the diagram above there
are two sections.

rowsPerSection: The number of rows in a single section. Every section must have the same number of rows. In the diagram above this value would be 4.

rowLength: The length of each row. In the diagram above, this would be 10. All the rows must have the same length.

sneakTime: The time in milliseconds that it takes for your character to move one block while crouching, aka sneaking. If ommitted defaults to 772. *see note below

walkTime: The time in milliseconds that it takes for your character to move one block while walking. If ommitted defaults to 231. *see note below

windowName: The name of the Minecraft window. This can usually be found in the title bar of the window (ie. Minecraft 1.21.1 - Singleplayer). If omitted, the program will search for an open window with "Minecraft" at the beginning of the title.

*Due to the granularity of the OS's time-keeping system, the script will typically round these values up to the nearest multiple
of 10 or 15.6 milliseconds. Sever lag can also effect this. Essentially, no matter how you adjust this variable, some crops will
probably be missed, especially if you have very long rows. If the script had to check the coordinates at every single block, all
the blocks could be harvested, but it would take a very, very long time. I sacrificed a little accuracy for a whole lot of speed
