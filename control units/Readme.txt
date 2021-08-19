Author:	Poul Bak
Copyright © 2001-2002 : BakSoft-Denmark (Poul Bak). All rights reserved.
http://home11.inet.tele.dk/BakSoft/
Mailto: baksoft-denmark@dk2net.dk

Component Version: 4.00.00.00

PBPathList is a component that makes it easier to use to the Windows built-in shellfolders.
Depending on your Windows version it makes a list with 20-50 paths. The individual paths can be called like: PBPathList1['%PERSONAL%'].
The component can simulate paths not present on the system.
Included is the free 'SHFolder.dll' which let you access shell-folders on older systems - even those not defined.
You can build system-independent paths like '%PERSONAL%\MyFolder' and get the actual path at runtime.
You decide the case of the returned paths: pcDontCare, pcLower, pcUpper, pcUpperName (First letter upper - the rest lower).
Also included are some functions to work with paths: 'DisplayPath', 'FullPath', 'CreateShellfolder' and 'UpperName'.
Version 3.00.00.00 can also get the displaynames of virtual folders.
Version 4.00.00.00 has been optimized by dynamically loading 'SHFollder.dll' and only making one list even if you have several PBPathList components in your application.

Context-sensitive help is included.

PBPathList is a substitute for PBSystemPath that used the registry to get the paths. Since that could be a problem on Windows NT/2000 I have developed PBPathList that doesn´t use the registry at all.
PBPathList should work on all windows versions.

Legal stuff:
------------
PBPathList is Freeware. Use it any way, you like. There is no timelimit or 'nag-screens'. Applications developed using this component are yours alone, Baksoft-Denmark have no rights to it.

PBPathList is provided 'as-is' and Baksoft-Denmark is under no circumstances responsible for any damage, what soever, that it might cause to anyone or anything.

Installation:
-------------
1. Unzip all files to a folder of your choice.
Note for Delphi 3/4: All forms are saved as text format. To convert them into Delphi 3/4 binary format: Open the folder where you have unzipped the files. Doubleclick 'Convert_Forms.bat'. Now the forms are in Delphi 3/4 format. When you later open the forms, Delphi might tell you that 'Property does not exist'. Just ignore.

2. Start Delphi (if you haven't done so).
3. Choose menu 'Component', 'Install Component...', browse to the folder that contains the unzipped files, choose 'PBPathList.pas' and open the file. Press 'Ok'. Press 'Yes' to confirm rebuild. PBPathList is now Registered. Close the window (save the changes).

Now you have a new Palette-page named 'PB' with the new component.

Install context-sensitive help:
-------------------------------
1. Move or copy 'PBPathList.hlp' and 'PBPathList.cnt' to ..\Delphi x\Help folder.
2. Doubleclick 'Delphi.cnt' and 'Microsoft Help Workshop' starts. Click 'Index Files', 'add'. Type 'PBPathList' as Help title and 'PBPathList.hlp' as Help filename. Click 'Ok'.
3. Include 'PBPathList.cnt' on the main page (Insert above).
4. Exit 'Microsoft Help Workshop' and save the changes.

Now you have full context-sensitive help for the PBPathList component.
--------------------------------
I have included a small demo: PBPathListDemo.exe to show the basics. Load and run.

If you find any bugs, have any great ideas or just a comment or question, feel free to e-mail.