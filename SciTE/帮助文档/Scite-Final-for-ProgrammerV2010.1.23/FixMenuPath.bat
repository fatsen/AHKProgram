set sciteExecutablePath=%~dp0scite.exe
echo exe path is : %sciteExecutablePath%  ....
set sciteExecutablePath=%sciteExecutablePath:\=\\%
rem replace D:\\Scite\\Scite.exe to real path in user's machine:
replace.exe  Open_With_ClassesRoot.reg "E:\\download\\editor\\scite\\wscite\\scite.exe" "%sciteExecutablePath%"
replace.exe  Open_With_Menu_CurrentUser.reg "E:\\download\\editor\\scite\\wscite\\scite.exe" "%sciteExecutablePath%"
replace.exe  Right_Click_Menu_CLASSESROOT.reg "E:\\download\\editor\\scite\\wscite\\scite.exe" "%sciteExecutablePath%"

