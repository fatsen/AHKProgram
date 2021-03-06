; SettingsSpecial(ByRef Is_HotkeyOn=1,ByRef V_editor="",exe_try="")
SettingsSpecial(ByRef Is_HotkeyOn=1,ByRef V_icon="",ByRef V_editor="")
{
;======<整体设置>======
; SetWorkingDir, %A_ScriptDir%\..\..
SetWorkingDir, %A_ScriptDir%
#SingleInstance force	;Reload
#Persistent	;读取完脚本不退出,脚本持续运行

gosub L_SetEditor
; V_editor = %A_LineFile%\..\..\..\Appended Files\Portable Softwares\Notepad++\notepad++.exe
; V_editor = %A_LineFile%\..\..\..\Appended Files\Portable Softwares\Notepad++
; run % V_editor
; exe_try = %A_LineFile%\..\..\..\Appended Files\Portable Softwares\Notepad++\notepad++.exe

; ifexist %V_editor%
	; msgbox 1
; else
	; msgbox 0
;======<托盘设置>======
if V_icon=
{
	V_icon=%A_WorkingDir%\Icons\special.ico
	IfExist %V_icon%
		Menu, Tray, Icon, %V_icon%
	V_icon=%A_WorkingDir%\special.ico
	IfExist %V_icon%
		Menu, Tray, Icon, %V_icon%
}
else
{
	;V_icon只是个名字时，默认文件夹进行加载。如果含有路径时，直接加载
	IfExist %V_icon%
		Menu, Tray, Icon, %V_icon% ;添加任务栏图标，该语句需在其他Tray操作之前方可有效
}
Menu, Tray, NoStandard
Menu, Tray, Add, Suspend(&S), Script_Suspend
Menu, Tray, Add, Dir(&D), Script_Dir
Menu, Tray, Add, Edit(&E), Script_Edit
Menu, Tray, Add, Reload(&R), Script_Reload
Menu, Tray, Add, eXit(&X), Script_Exit

; Menu, Tray, Default, Edit(&E)
Menu, Tray, Default, Reload(&R)
Menu, Tray, Click, 1				;将对托盘的双击更改为单击

;======<启动行为>======
; Is_HotkeyOn=1	;脚本启动时默认为快捷键开启

tooltip "%A_ScriptName%" has been opened
sleep 200
tooltip

;======<热键指定>======
Hotkey, F1, L_ToggleHotkey
; Hotkey, ~LButton & F1, L_ToggleHotkey
Hotkey, ^Esc, L_ExitApp

;======<变量指定>======
; #Include *i %A_ScriptDir%\..\Variants.ahk		;因为本文件是以函数的形式写的，函数中定义的变量无法向外传递
;自动代码段结束
return	;自动代码段结束后，加上一条return语句，以防止误触发后面的语句
L_SetEditor:
	V_editor = %A_LineFile%\..\..\..\PortableSoftware\Notepad++\notepad++.exe
return
;======<托盘设置>======
Script_Suspend:
	Suspend
Return
Script_Dir:
	Run %A_ScriptDir%
Return
Script_Edit:
	; V_editor = %A_LineFile%\..\..\..\Appended Files\Portable Softwares\Notepad++\notepad++.exe
	gosub L_SetEditor
	
	If (A_IsCompiled=1)
		Msgbox Execuable file can't be edited!
	else
		ifexist %V_editor%
			Run %V_editor% "%A_ScriptFullPath%"
			; msgbox %V_editor%	
				;如果不使用ByRef将V_editor设为全局变量，则必须在本标签开始处对V_editor进行赋值
				;否则的话，即使在别处进行赋值，也只是局部变量，随时被丢弃，无法正常作用。
				;即使把ByRef将V_editor设为全局变量，如果不是通过外部传递进来，而只是在函数开始处赋值的话，此处也无法正常作用
		else
			; msgbox %V_editor%
			run "%A_LineFile%\..\..\..\"
			; edit "%A_ScriptFullPath%"
	; run %A_LineFile%\..\..\..\Appended Files\Portable Softwares\Notepad++
Return
Script_Reload: 
	Reload
Return
Script_Exit:
	Exitapp
Return

;======<功能段>======
L_ToggleHotkey:
	KeyWait, F1
	KeyWait, F1, D t0.2	
	If (ErrorLevel=1)	;按一次F1改变状态
		if Is_HotkeyOn=1
		{
			Is_HotkeyOn=0
			tooltip %A_ScriptName%快捷键关闭
			; msgbox % A_IconTip
			sleep 1000
			tooltip
		}
		else
		{
			Is_HotkeyOn=1
			tooltip %A_ScriptName%快捷键开启
			; msgbox % A_IconTip
			sleep 1000
			tooltip
		}		
	Else				;按两次F1显示状态（记忆：改变两次相当于不变）
	{
		if Is_HotkeyOn=1
			tooltip %A_ScriptName%快捷键开启
		else
			tooltip %A_ScriptName%快捷键关闭
		sleep 1000
		tooltip
	}
	; msgbox %A_ScriptFullPath%
return
L_ExitApp:
	ExitApp
Return
}