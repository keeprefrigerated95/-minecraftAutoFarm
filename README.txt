~~~~~~~~~~~~~ Auto Farm ~~~~~~~~~~~~~
 An Auto Hot Key script that will
 harvest and replant a field of
 crops in Minecraft
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*************************
 FIELD SETUP
*************************
This script assumes that your field will be set up as follows:

x: tilled soil with crops planted
o: water blocks
H: Hopper/chest/barrel
S: character starting position (standing on top of a hopper/chest/barrel)

All the blocks in this diagram are at the same Z coordinate This diagram is viewed from the top, down

THERE IS A MAJOR BUG IN THE CODE. IF THE PLAYER CROSSES 0 AT THE X OR Z COORDINATES THE SCRIPT WILL BREAK.
I AM WORKING ON FIXING THIS.

 oooooooooo
Sxxxxxxxxxx ---->
Hxxxxxxxxxx ---->
Hxxxxxxxxxx 
Hxxxxxxxxxx 
 oooooooooo 
Hxxxxxxxxxx |
Hxxxxxxxxxx |
Hxxxxxxxxxx |
Hxxxxxxxxxx V
 oooooooooo

*************************
 CONTROLLING THE SCRIPT
*************************
The script will make the player harvest and plant crops from right to left, top to bottom, like
reading the words on this page. After one row is harvested the script walks the player back to the
chest at the beginning of the row and deposits everything in inventory, excluding the hot bar.

After running the script, position your character in the starting position,
looking straight down, and facing towards the end of the first row. Make sure
That they are facing as straight as possible. When ready, press the 'r' key
to run the harvest process.

Make sure your inventory is completely empty and that seeds or crops are in your off hand.
You may optionally hold a hoe in your main hand. Nothing from your hot bar will be deposited,
only items from your inventory.

At any time if you need to kill the script, press the x key. If the x key doesn't work try 
pressing shift and then x.

*************************
PARAMETERS
*************************
The script reads parameters from the text file autoFarmData.txt, giving you the ability to customize
the script to your farm layout. These are the following parameters:

sections: A section consists of the rows in-between two rows of water. In the diagram above there
are two sections.

rowsPerSection: The number of rows in a single section. Every section must have the same number of rows. In the
diagram above this value would be 4.

rowLength: The length of each row. In the diagram above, this would be 10. All the rows must have the same length.

stepTime: The time in milliseconds that it takes for your character to move one block while crouching. Due to the
granularity of the OS's time-keeping system, the script will typically round this up to the nearest multiple
of 10 or 15.6 milliseconds. Sever lag can also effect this. Essentially, no matter how you adjust this variable,
some crops will probably be missed, especially if you have very long rows. If the script had to check the coordinates
at every single block, all the blocks could be harvested, but it would take a very, very long time.

depositContainer: the type of container you will be depositing items in. valid types are single, double, hopper, or barrel

windowName: The name of the Minecraft window. This can usually be found in the title bar of the window (ie. Minecraft 1.21.1 - Singleplayer)
