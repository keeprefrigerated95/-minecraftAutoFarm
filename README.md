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
H: double chest
S: charachter starting position

All the blocks in this diagram are at the same Z coordinate
This diagram is viewed from the top, down

 oooooooooo
Sxxxxxxxxxx ---->
Hxxxxxxxxxx  |
Hxxxxxxxxxx  |
Hxxxxxxxxxx  V
 oooooooooo 
Hxxxxxxxxxx
Hxxxxxxxxxx
Hxxxxxxxxxx
Hxxxxxxxxxx
 oooooooooo

 I would recommend leaving 3 or four unobstructed blocks at the end of each row in case the
 script overshoots while you are AFK. As long as the script is allowed to send your character
 the same distance forward and back you should still be able to depisit in the chest.

*************************
 CONTROLLING THE SCRIPT
*************************
The script will make the player harvest and plant crops from right to left,
top to bottom, depositing all the items in the inventory at the beginning of each row.

After running the script, position your character on the top left hand block,
looking straight down, and facing towards the end of the first row. Make sure
That they are facing as straight as possible. When ready, press the 'r' key
to begin

Make sure your inventory is completely empty except for a stack of seeds or crops in
your off hand and optionally, a hoe in your main hand

At any time if you need to kill the script, press the x key

*************************
PARAMETERS
*************************
The script reads parameters from the text file autoFarmData, giving you the ability to customize
the script to your farm layout. These are the following parameters:

sections: A section consists off the rows inbetween two rows of water. In the diagram above there
		  are two sections.
passes: A pass is completed when your character harvests two rows. The variable is passes per section. 
		Divide the number of rows in a single section by two to get the number of passes. The number
		of rows in each section must be the same and must be divisible by 2. In the diagram, passes would
		be 2.
rowLength: The length of each row. In the diagram above, this would be 10. All the rows must have the same
		   length.
stepTime: The time in milliseconds that it takes for your character to move one block
	while crouching.
inventoryX: The coordinates, relative to the minecraft window, where the upper right inventory tile is located
			when opening a a chest or hopper. The default is set to work with double chests in the default
			minecraft windows size. (not full screen)
boxSize: The length in pixels of each inventory slot
