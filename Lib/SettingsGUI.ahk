;======<变量相关>======
;region 变量赋值及处理
L_Variants:		;region author info
	B_UserInfo =	;作者信息
(
*****************************************
点击相应按钮，即可打开相应文件夹或文件。为使本脚本正常
运行，本文件夹内的子文件夹或文件不要移动或改名。

编程工具：AutoHotKey
官方网站：https://autohotkey.com/
中文论坛：http://ahk8.com/

作者：fatsen
email：582288672@qq.com
修改自：“快捷按钮启动软件，望指正”
原出处： ahk高级群，群号3222783
*****************************************
)

	B_DefaultedShortcutIni = ;无Ini时默认生成
(
; Open the .ini file to edit the destination files or folders or urls
; the defaulted .ini file format is as follows
; [SectionName1]
; Key1=Value1
; Key2=Value2
; [SectionName2]
; Key1=Value1
; Key2=Value2

; SectionName: the name of the GUI tab label
; Key: the name of the GUI button name
; Value: the destination files or folders or urls

; The english semicolon at the head of the line means this line is just a comment.

[Example1]
Notepad	=	Notepad.exe
calc	=	%windir%\system32\calc.exe

[Example2]
googleTranslate = https://translate.google.cn
googleMail = https://mail.google.com/

[Example3]
Cdisk = C:\
ProgramFiles = C:\Program Files
)

return	;endregion author info

L_VariantReplace:	;region 定义替换规则
;使用函数进行替换无效，原因未知
	;替换ahk系统路径
	stringreplace,V_prog,V_prog,`%A_ScriptDir`%,%A_ScriptDir%
	stringreplace,V_prog,V_prog,`%A_WorkingDir`%,%A_WorkingDir%
	stringreplace,V_prog,V_prog,`%A_Desktop`%,%A_Desktop%

	;替换网络盘
	if B_IsReplaceServerPath
	{
		;网络盘不进行替换，因为网络盘的表示形式的区别，Inventor会有各种问题
		; stringreplace,V_prog,V_prog,M:,\\192.168.90.14\research
		; stringreplace,V_prog,V_prog,N:,\\192.168.90.14\common
		; stringreplace,V_prog,V_prog,O:,\\192.168.90.14\backup
		; stringreplace,V_prog,V_prog,W:,\\192.168.90.34\doing
		; stringreplace,V_prog,V_prog,X:,\\192.168.90.14\Design
		; stringreplace,V_prog,V_prog,Y:,\\192.168.90.34\finished
		; stringreplace,V_prog,V_prog,Z:,\\192.168.90.34\Partcenter
	}
	; msgbox % V_prog
return	;endregion L_VariantReplace
;endregion

;======<窗口相关>======
;region 窗口操作
GuiClose:	;region ;如不设置此标签，点击GUI的关闭按钮时，仅仅隐藏GUI
	if A_IsCompiled
		B_IsAlwaysRun=0

	if B_IsAlwaysRun=1
		Gui, Cancel
	else
		ExitApp
return	;endregion

GuiContextMenu:	;region
	Menu, Tray, Show
Return	;endregion
;endregion

;======<标签相关>======
;region 托盘图标
L_TraySettings: ;region
	Menu, Tray, NoStandard

	if A_IsCompiled
	{
		Menu, Tray, Add, Info, L_Info
		Menu, Tray, Add
	}

	if !A_IsCompiled
	{
		Menu, Tray, Add, editScript(&S), L_EditScript
	}


	Menu, Tray, Add, EditIni(&E), L_EditIni
	Menu, Tray, Add, Dir(&D), L_Dir

	Menu, Tray, Add, Reload(&R), L_Reload
	Menu, Tray, Add, eXit(&X), GuiClose

	Menu, Tray, Add
	;region ;定义Defaulted菜单及其子菜单
	Menu, Submenu0, Standard
	Menu, Tray, Add, Defaulted(&D), :Submenu0
	;Menu, Tray, Add
	;endregion

	Menu, Tray, Default, Reload(&R)		;设置默认行为
return ;endregion

L_EditScript:
    if !A_IsCompiled
	{
		IfExist %B_Editor%
		{
			run "%B_Editor%" "%A_ScriptFullPath%"
			run "%B_Editor%" "%A_LineFile%"
		}
		Else
		{
			Edit "%A_ScriptFullPath%"
			edit "%A_LineFile%"
		}
	}
return

L_EditIni:
	IfExist %B_Editor%
		run "%B_Editor%" "%B_SettingFile%"
	Else
		run "%B_SettingFile%"
return

L_Dir:
	run %A_ScriptFullPath%\..\
return

L_Reload:
	Reload
return

L_Info:
	; tmp:=4+256
	; msgbox % tmp
	msgbox,260,作者信息, %B_UserInfo% `r`n`r`n点击“是”，复制本条消息。
	; msgbox, %tmp% , 作者信息 ,		;msgbox后的数字不能为变量，原因未知
return
;endregion 托盘图标

;======<程序主体功能>======
;region 程序主体功能
L_Start:	;region L_start
;设置全局字体
Gui, font, s%B_Size%, %B_Style%

;设置配置文件

ifexist %A_ScriptDir%\%B_Scriptname%.ini
	B_SettingFile = %A_ScriptDir%\%B_Scriptname%.ini
else
	if B_Env =
		B_SettingFile = %A_ScriptDir%\%B_Scriptname%.ini
	else
		B_SettingFile = %A_ScriptDir%\%B_Scriptname%_%B_Env%.ini
if A_IsCompiled
	B_SettingFile = %A_ScriptDir%\%B_Scriptname%.ini

B_TabCount:=0
; 检查配置文件是否存在
if FileExist(B_SettingFile)
{
	; 获取配置文件的section名称
	IniRead, SectionName, %B_SettingFile%
	;msgbox % SectionName

	; 获取标签页的名称并创建标签页
	StringReplace, NewStr, SectionName, `n, |, All
	Tabname = %NewStr%

	if (B_IsSettingVisible=1
	and A_IsCompiled)
	{
		Tabname = %Tabname%|配置
	}

	Gui, Add, Tab2, W%B_Tab2Width% H%B_Tab2Height%, %Tabname%

	Loop, Parse, SectionName, `n
	{
		;对A_LoopField进行判断，根据其名称，进行相应设置，并continue←要不要现在上面单独建立一个循环？

		; 对应标签页下创建按钮
		Gui, Tab, %A_LoopField%
		;msgbox %A_LoopField%	;SectionNames

		; 获取section中的key和value
		; IniRead, P1, %B_SettingFile%, % A_LoopField
		IniRead, P1, %B_SettingFile%, %A_LoopField%
		;msgbox %P1%	;The contents of the section name.

		; 获取并用key名称创建gui button
		Loop, Parse, P1, `n		;divide the contents of the section name with `n.
		{
			B_tmp:=A_Index	;获取循环次数
			Loop, Parse, A_LoopField, =
			{
				if A_Index = 1
				{
					if(mod(B_tmp,B_Columns)=1)	;Button无法设置颜色 from help
						Gui, Add, Button, w%B_Width% h%B_Height% x%B_XPos% y+%B_HeightLap% gL_RunProg cRed, %A_LoopField%	;行首时需换行，需改变y坐标 ;此处将x%B_XPos%换成x-0或x-%B_Width%效果差，原因未知
					else
						Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_RunProg, %A_LoopField%
						;在行中不需要换行，只改变x坐标
				}
			}
		}
	B_TabCount:=B_TabCount+1
	}
}
else	;配置文件不存在时默认创建
{
	FileAppend,%B_DefaultedShortcutIni%, %B_SettingFile%
	Edit %B_SettingFile%
	Reload
}

;配置INI
; Gui, Tab, 配置
; Gui, Add, Button, w%B_Width% h%B_Height% x%B_XPos% y+%B_HeightLap% gL_Reload, 重新载入配置
; Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_EditScript, 编辑脚本
; if B_Columns=2
	; Gui, Add, Button, w%B_Width% h%B_Height% x%B_XPos% y+%B_HeightLap% gL_EditIni, 编辑配置
; else
	; Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_EditIni, 编辑配置

if (B_IsSettingVisible=1
and A_IsCompiled)
{
	Gui, Tab, 配置
	Gui, Add, Button, w%B_Width% h%B_Height% x%B_XPos% y+%B_HeightLap% gL_EditIni, 编辑配置
	Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_EditScript, 编辑脚本
	if B_Columns=2
		Gui, Add, Button, w%B_Width% h%B_Height% x%B_XPos% y+%B_HeightLap% gL_Reload, 重新载入
	else
		Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_Reload, 重新载入

	; Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gL_EditIni, 编辑配置
	; Gui, Add, Button, w%B_Width% h%B_Height% x+%B_HeightLap% gInstruct, 使用说明

	; Gui, Font, s20 underline
	Gui, Font, s14
	Gui, Add, Text, x50 y200 left cTeal, %B_UserInfo% ;x和y是文本的起始位置
}
B_TabCount:=B_TabCount+1
; msgbox % B_DefaultedTab . B_TabCount
; GuiControl, Choose, Tab, %B_DefaultedTab%

;设置主窗口
; Gui, show, AutoSize Center, %B_Scriptname%.exe
; msgbox %B_TabCount%
Gui, show, AutoSize Center, %B_WindowTitle%
sleep 1500
; GuiControl, Choose, Tab, 3	;默认显示第3个tab	;FIXME:需核对
; sleep 1500
; if (B_DefaultedTab<=B_TabCount)
	; GuiControl, Choose, Tab, %B_DefaultedTab%
; GuiControl, Choose, Tab, 2
; 返回以防止误触发标签
return	;endregion  L_start

L_RunProg:	;region 运行标签对应的程序或网址
	IniRead, SectionName, %B_SettingFile%
	Loop, Parse, SectionName, `n
	{
		; 读取按钮名称的key值并运行
		IniRead, V_prog, %B_SettingFile%, %A_LoopField%, %A_GuiControl%
		; msgbox % A_LoopField	;%
		; msgbox % A_GuiControl
		; return
		if V_prog <> ERROR
		{
			; gosub L_VariantReplace		;进行全局替换
			; SnSub_Replace(V_prog)	;此处用函数无效，原因未知


			ifexist %V_prog%	;检查文件夹或者文件是否存在
			{
				; ifinstring, V_prog, \\		;公共盘
					; RunAs %V_prog%,,ERS0827	;会引起后面的控件无法正常打开，原因未知。
				; else
					goto L_RunV
			}
			else				;不存在时
			{
				ifinstring, V_prog, http	;网址
					goto L_RunV
				ifinstring, V_prog, ftp		;网址
					goto L_RunV
				ifinstring, V_prog, \\		;公共盘
					{
						; msgbox 查看公共盘是否已经连接!
						; Run %B_SettingFile%
						; RunAs %V_prog%,,ERS0827	;会引起后面的控件无法正常打开，原因未知。
						; break
						; msgbox %V_prog%
						goto L_RunV
					}
				ifinstring, V_prog, \		;本地盘
					{
						; if B_IsReplaceServerPath = 0	;不替换公共盘时，可能因不存在而出错
						; 因为替换公共盘会有各种问题，故改用#r来进行启动。可能的问题：
							;①更换电脑等导致盘符变化
							;②\\192.168...(映射前的地址)和Y:\(映射后的地址)在某些软件中被认为不同，ex.Inventor
								;因为Inventor的各种问题，所以不进行网络盘的替换
							goto L_RunV
					}

				msgbox Please check the file name or directory or url!
				IfExist %A_WorkingDir%\Notepad++\notepad++.exe
						run "%A_WorkingDir%\Notepad++\notepad++.exe" "%B_SettingFile%"
				Else
					run "%B_SettingFile%"
			}
			break
		}
		else
			continue
	}
return	;endregion

L_RunV:	;region
	ifinstring, V_prog, //		;网页直接打开
		run %V_prog%
	else
	{
		clipbackup:= clipboardall

		sleep 100
		clipboard:= V_prog
		sleep 100
		send #r
		sleep 100
		send ^v
		sleep 100
		send {enter}

		clipboard:=clipbackup
	}
return	;endregion
;endregion

;region 需修改
;======<快捷键>======
;region 如已经编译
#if (!A_IsCompiled)
; #1:: Gui, Show	;此处可能得用Hotkey来做
; !1:: Gui, Show
; F1::
	; KeyWait, F1
    ; KeyWait, F1, D t0.2
    ; If (ErrorLevel=1)	;按一次F1改变状态
		; if B_IsShortcutsOn=1
		; {
			; B_IsShortcutsOn=0
			; tooltip 快捷键关闭
			; msgbox % A_IconTip
			; sleep 1000
			; tooltip
		; }
		; else
		; {
			; B_IsShortcutsOn=1
			; tooltip 快捷键开启
			; msgbox % A_IconTip
			; sleep 1000
			; tooltip
		; }
	; Else				;按两次F1显示状态（记忆：改变两次相当于不变）
	; {
		; if B_IsShortcutsOn=1
			; tooltip 快捷键开启
		; else
			; tooltip 快捷键关闭
		; sleep 1000
		; tooltip
	; }
; return
#if
;endregion

;需修改，设置成指定热键的形式？ex. HotKey, !PgUp, DimUp
; #if B_IsShortcutsOn=1
; and (!A_IsCompiled)
; and WinActive(B_WindowTitle)	;im 窗口标题和文本是区分大小写的!
; and WinActive("ahk_class AutoHotkeyGUI")

; F2::
	; goto L_EditIni
; return
; F3::
	; gosub L_EditScript
	; IfExist %B_Editor%
		; run "%B_Editor%" "%A_Linefile%"
	; Else
		; Edit "%A_Linefile%"
; return
; F5::
	; goto L_Reload
; return

; #if

;region 已弃用
/*
 ~RButton & LButton:: ;因为汇总到fatzen程序中，所以本程序不需要快捷键
	sleep 100
	send {Esc}	;取消右键菜单的显示
	sleep 100
	Gui, Show
return
 */
/*
$Rbutton::	;无法用hotkey命令定义该热键，原因未知
	;参考http://ahk8.com/qa/517?show=519#a519
    KeyWait, Rbutton
    ; KeyWait, Rbutton, D t0.5
    ; KeyWait, Rbutton, D t0.3
    KeyWait, Rbutton, D t0.2
    If (ErrorLevel=1)
		send {Rbutton}
	Else
        Gui, show
Return
 */
;endregion
;endregion
