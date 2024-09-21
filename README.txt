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
S: character starting position
|: a one, or higher block wall to act as a bumper

All the blocks in this diagram are at the same Z coordinate, with
the exception of the bumper wall. This diagram is viewed from the top, down

 |oooooooooo
|SHxxxxxxxxxx ---->
 |Hxxxxxxxxxx <----
| Hxxxxxxxxxx ---->
 |Hxxxxxxxxxx <----
 |oooooooooo 
| Hxxxxxxxxxx |
 |Hxxxxxxxxxx |
| Hxxxxxxxxxx |
 |Hxxxxxxxxxx V
 |oooooooooo

I would recommend leaving 3 or four unobstructed blocks at the end of each row in case the
script overshoots. As long as the script is allowed to send your character the same distance
forward and back you should still be able to deposit crops in the chest.

*************************
 CONTROLLING THE SCRIPT
*************************
The script will make the player harvest and plant crops in a Z pattern.

After running the script, position your character starting position,
looking straight down, and facing towards the end of the first row. Make sure
That they are facing as straight as possible. When ready, press the 'r' key
to run the harvest process.

Make sure your inventory is completely empty and that seeds or crops are in your off hand.
You may optionally hold a hoe in your main hand. Nothing from your hot bar will be deposited,
only items from your inventory.

At any time if you need to kill the script, press the x key. If the shift key gets stuck, just
click it to reset it.

*************************
PARAMETERS
*************************
The script reads parameters from the text file autoFarmData.txt, giving you the ability to customize
the script to your farm layout. These are the following parameters:

sections: A section consists of the rows in-between two rows of water. In the diagram above there
		  are two sections.
passes: A pass is completed when your character harvests two rows. The variable is passes per section. 
		Divide the number of rows in a single section by two to get the number of passes. The number
		of rows in each section must be the same and must be divisible by 2. In the diagram, passes would
		be 2.
rowLength: The length of each row. In the diagram above, this would be 10. All the rows must have the same length.
stepTime: The time in milliseconds that it takes for your character to move one block while crouching. Due to the
	granularity of the OS's time-keeping system, the script will typically round this up to the nearest multiple
	of 10 or 15.6 milliseconds. Essentially, no matter how you adjust this variable, some crops will probably
	be missed, especially if you have very long rows. The script does it's best to account for this level of
	unpredictability with the bumpers.
inventoryX & inventoryY: The coordinates, in the Minecraft window, where the upper right inventory tile is located
			when opening a chest or hopper.
boxSize: The length in pixels of each inventory slot 
