#### DISK RECOVERY

Recovering from RAW to previous type of partition

 * RAW can't be seen by MSWIN, but try to mount & backup data under linux.
   In my case gparted after resizing and moving FAT32 partition created one, that was seen by some tools as FAT32 and others as RAW.
   I could see and copy data under linux majaro, though not under MSWIN

 * use TestDisk to recover

   * run the tool
   * pick 'no log' at initial screen
   * pick your device & proceed
   * pick 'Intel' for partition table
   * pick 'Advanced' section, you should be able to see information about bad boot sector for fat32 partition
   * pick required partition and Boot option, you should have info about boot and backup sectors
     in my case for both I had 'bad' notification

   * pick 'Rebuild BS'
   * when done 'List' to check if your files are there
   * if everything is OK pick 'Write' and you are done, then quit 
		
[Reference](https://www.cgsecurity.org/wiki/TestDisk_Step_By_Step)

