;*########AHK脚本文件########
;#**********忄鱼编辑制作***********#
;#**作者博客：http://poolao.info **#
;#**联系邮箱：love@poolao.info **#
;##########################

#SingleInstance Ignore		;强制重新载入新脚本
#NoEnv									;不检测空变量为环境变量
SetWinDelay, 0
CoordMode,Mouse,Screen
SysGet,Mon,MonitorWorkArea
WorkingX := MonRight - 260
WorkingY := MonBottom - 330
HideX := MonRight - 6
myself = 0
SOH = 0
IniRead,AutoH,Clip.ini,set,AutoHide,0

Gui,-MinimizeBox -MaximizeBox +AlwaysOnTop
Gui,font,s11,微软雅黑
Gui,add,text,x2 y2,①
Gui,add,text,x2 y31,②
Gui,add,text,x2 y61,③
Gui,add,text,x2 y91,④
Gui,add,text,x2 y121,⑤
Gui,add,text,x2 y151,⑥
Gui,add,text,x2 y181,⑦
Gui,add,text,x2 y211,⑧
Gui,add,text,x2 y241,⑨
Gui,add,text,x2 y271,⑩
Gui,font,s9,微软雅黑
Gui,add,button,left x20 y1 w228 h28 vbutt1 gbutt1 -Wrap
Gui,add,button,left x20 y32 w228 h28 vbutt2 gbutt2 -Wrap
Gui,add,button,left x20 y62 w228 h28 vbutt3 gbutt3 -Wrap
Gui,add,button,left x20 y92 w228 h28 vbutt4 gbutt4 -Wrap
Gui,add,button,left x20 y122 w228 h28 vbutt5 gbutt5 -Wrap
Gui,add,button,left x20 y152 w228 h28 vbutt6 gbutt6 -Wrap
Gui,add,button,left x20 y182 w228 h28 vbutt7 gbutt7 -Wrap
Gui,add,button,left x20 y212 w228 h28 vbutt8 gbutt8 -Wrap
Gui,add,button,left x20 y242 w228 h28 vbutt9 gbutt9 -Wrap
Gui,add,button,left x20 y272 w228 h28 vbutt10 gbutt10 -Wrap

Menu,tray,add,显示\隐藏,ShowOrHide
Menu,Tray,Default,显示\隐藏
Menu, Tray, Add,开机启动,AutoRun
Menu,Tray,add,自动隐藏,AutoHide
Menu,Tray,add,退出,ExitIt
Menu,tray,nostandard
Menu,Tray,Click,1
Menu,tray,Icon,Clip.ico
If (AutoH = 1)
Menu,tray,Check,自动隐藏

FileGetSize,size,%A_Startup%\剪贴板记录器.lnk
If errorlevel = 0
{
	Menu,Tray,check,开机启动
	AutoRun = 1
}
Else
{
	Menu,Tray,UnCheck,开机启动
	AutoRun = 0
}
Return

GuiEscape:
Gui,cancel
SOH = 0
Return

GuiClose:
Gui,cancel
SOH = 0
Return

AutoHide:
If (AutoH = 0)
{
	AutoH = 1
	Menu,tray,Check,自动隐藏
	IniWrite,1,Clip.ini,set,AutoHide
}
Else If (AutoH = 1)
{
	AutoH = 0
	Menu,tray,UnCheck,自动隐藏
	IniWrite,0,Clip.ini,set,AutoHide
}
Return

AutoRun:
If (AutoRun = 0)
{
	FileCreateShortcut, %A_ScriptFullPath% ,%A_Startup%\剪贴板记录器.lnk, %A_WorkingDir% , ,剪贴板记录器启动项——http://poolao.info
	Menu,Tray,check,开机启动
	AutoRun = 1
}
Else If (AutoRun = 1)
{
	FileDelete, %A_Startup%\剪贴板记录器.lnk
	Menu,Tray,UnCheck,开机启动
	AutoRun = 0
}
Return

ShowOrHide:
If (SOH = 0)
{
	Gui, Show,  h300 w250 x%WorkingX% y%WorkingY%,剪贴板历史记录
;	WinGet,K_ID,ID,剪贴板历史记录
	SOH = 1
}
Else If (SOH = 1)
{
	Gui,Cancel
	SOH = 0
}
Return

ExitIt:
ExitApp

OnClipboardChange:
If (myself = 1)
	Return
Else If (myself = 0)
{

	ClipPos = 10
	Loop,9
	{
		ClipPos1 := ClipPos - 1
		Clip%ClipPos% := Clip%ClipPos1%
		ClipInfo%ClipPos% := ClipInfo%ClipPos1%
		ClipPeek%ClipPos% := ClipPeek%ClipPos1%
		ClipPeekIt := ClipPeek%ClipPos%
		GuiControl,,butt%ClipPos%,%ClipPeekIt%
		ClipPos := ClipPos - 1
	}
If (A_EventInfo = 1)
{
	Clip1 := Clipboard
	ClipInfo1 := A_EventInfo
	StringLeft,ClipPeek1,Clip1,40
	StringReplace,ClipPeek1,ClipPeek1,%A_Tab%,%A_Space%,All
	StringReplace,ClipPeek1,ClipPeek1,`r`n,%A_Space%,All
	StringLen,ClipLen1,Clip1
	If (ClipLen1 < 1024)
	{
		ClipLen1 := ClipLen1 / 2
		StringLen,CLen,ClipLen1
		Clen := Clen - 7
		StringLeft,ClipLen1,ClipLen1,%Clen%
		ClipLen1 = %ClipLen1%字
	}
	Else If (ClipLen1 >= 1024 and ClipLen < 1048576)
	{
		ClipLen1 := ClipLen1 / 1024
		StringLen,CLen,ClipLen1
		Clen := Clen - 4
		StringLeft,ClipLen1,ClipLen1,%Clen%
		ClipLen1 = %ClipLen1%k
	}
	Else If (ClipLen1 >= 1048576)
	{
		ClipLen1 := ClipLen1 / 1048576
		StringLen,CLen,ClipLen1
		Clen := Clen - 4
		StringLeft,ClipLen1,ClipLen1,%Clen%
		ClipLen1 = %ClipLen1%M
	}
	ClipPeek1 = 【%ClipLen1%】%ClipPeek1%
	ClipPeek = 【保存至桌面】%ClipPeek1%
	GuiControl,,butt1,%ClipPeek%
}
Else If (A_EventInfo = 2)
{
	Clip1 := ClipboardAll
	ClipInfo1 := A_EventInfo
	StringLen,ClipLen1,Clip1
	If (ClipLen1 < 1024)
		ClipLen1 = %ClipLen1%b
	Else If (ClipLen1 > 1048576)
	{
		ClipLen1 := ClipLen1 / 1048576
		StringLen,CLen,ClipLen1
		Clen := Clen - 4
		StringLeft,ClipLen1,ClipLen1,%Clen%
		ClipLen1 = %ClipLen1%M
	}
	Else If (ClipLen1 >= 1024 and ClipLen <= 1048576)
	{
		ClipLen1 := ClipLen1 / 1024
		StringLen,CLen,ClipLen1
		Clen := Clen - 4
		StringLeft,ClipLen1,ClipLen1,%Clen%
		ClipLen1 = %ClipLen1%k
	}
	ClipPeek1 = 【%ClipLen1%】图像或其它媒体格式
	GuiControl,,butt1,%ClipPeek1%
}
}
Return

butt1:
If (ClipInfo1 = 1)
{
	FileAppend,`r`n==========%A_YYYY%年%A_MM%月%A_DD%日%A_Space%%A_Hour%时%A_Min%分%A_Sec%秒%A_Space%快速保存==========`r`n`r`n%Clip1%,%A_Desktop%\%A_YYYY%年%A_MM%月%A_DD%日%A_Hour%时%A_Space%快速保存.txt
Sleep,50
ToolTip,已保存至桌面
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
}
Else If (ClipInfo1 = 2)
{
	ToolTip,暂不支持保存图片格式！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
}
Return

butt2:
myself = 1
Clipboard := Clip2
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt3:
myself = 1
Clipboard := Clip3
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt4:
myself = 1
Clipboard := Clip4
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt5:
myself = 1
Clipboard := Clip5
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt6:
myself = 1
Clipboard := Clip6
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt7:
myself = 1
Clipboard := Clip7
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt8:
myself = 1
Clipboard := Clip8
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt9:
myself = 1
Clipboard := Clip9
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

butt10:
myself = 1
Clipboard := Clip10
Sleep,50
myself = 0
ToolTip,复制成功！
If (AutoH =  1)
{
	Gui,Cancel
	SOH = 0
}
sleep,900
ToolTip,
Return

