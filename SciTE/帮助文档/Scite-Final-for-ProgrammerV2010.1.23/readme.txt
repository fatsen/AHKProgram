Scite Final for Programmer V2010.1.1

It is an editor for programmer on win32 platform. Its a combination of executables and scripts of Scite-Ru, Scite-Debug, 
and some customization config.

----------Features-------------------------------:
1. support debug of c/c++/python/lua  (integrate Scite debug) out of box.
  (oh, you need to install compiler/intepreter and add them to PATH).

2. many tools from Scite-ru:
Color Picker, Hex editor, ASCII table, Side bar; (Ctrl + F1 to hide/show sidebar, the shortcut is configurable)

3. Side bar with FileManageer, Function/Bookmark browser, Abbreviation browser

4. Automatically save recently opened file, and open these files Automatically the next time you start scite.

5. Automatically spell completion support. When you type "aut" in this file, it will suggest "automatic", "Automatically". 

6. Automatically completion for functions in c/c++, python, perl, lua, and many others languages out of box.
    e.g. When you type "hex(" in python, it will prompt "hex(number) -> string".
	When you type "chop(" in perl, it will prompt "chop(VARIABLE) Chops off the last character of a string ....

7. Support Of automatic open file, add menu under "Open With" and right click menu by registry install.  
There are 2 _optional_ method to register Scite to right click menu and to Open With menu, each illustracted in 7.1 and 7.2.

7.1 Automatically Register (recommended):
Double Click FixMenuPath.bat to fix path in each .reg file, and then double click each .reg files one by one.

7.2 Manually register (if you are not lucky enough to register by Automatically Register, try manaually) : 
To register right click menu "Open With Scite",  just open file Right_Click_Menu_CLASSESROOT.reg by scite, replace the path of scite.exe in Right_Click_Menu_CLASSESROOT.reg, 
and double click Right_Click_Menu_CLASSESROOT.reg to install the registry file.

To register a menu under "Open With", just replace the path in Open_With_ClassesRoot.reg and Open_With_Menu_CurrentUser.reg, and run the 2 files.

After step 7.1 OR 7.2 (depends on your choice), you will see a right click menu "Open With Scite". 
Also when you right click a file(maybe Shift + RightClick),  and click "open with", you can choose scite as your default editor for the file type.

Of course you don't need to register the menu (step 7.1 OR 7.2), but if you don't, and right click a text file and click "Open With" -> "Choose Program",
and you choose scite.exe, then your session in scite would be lost if scite was not opened before you open this file.

Note: when you use the following command to open a file,  your session would be lost due to scite's implementation flaw.
c:\> SciTE.exe  myfile

But if you open the file with option of  -save.session=0 , your session would not be lost when you start scite alone:
c:\> SciTE.exe -save.session=0 -save.recent=0  myfile

So I added several registry entry to avoid the headache of lost session
(a session contain files you opened in the last run of Scite).

----------SciTE output (lua) usage---------------:

1. use $ to evaluate variable
$FilePath
$FileName
$SciteDefaultHome 

2.when in debugging,  you can type debugger commands directly into the output pane.

3.output pane would evaluate lua expression by default.

4.output pane can execute shell command by starting with > :
>dir
>echo hello world


---------- Acknowledgment---------------:
Many Thanks to Scite, Scite-Debug, Scite-Ru project, they make my life easier.

Any comments or improvement idea about "Scite Final for programmer" is welcome, 
you may contact my by gmail or MSN by david_ullua at hotmail.com

David Lv, david.ullua at gmail.com , 2009/12/30