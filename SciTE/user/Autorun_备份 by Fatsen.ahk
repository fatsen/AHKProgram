; SciTE4AutoHotkey v3 user autorun script
;
; You are encouraged to edit this script!
;

#NoEnv
#NoTrayIcon

公用:
	SetWorkingDir, %A_ScriptDir%
	oSciTE := ComObjActive("SciTE4AHK.Application")
	SciTE_Hwnd := oSciTE.SciTEHandle

	gosub, 中文帮助友好提示
	gosub, 智能Tab

	;随SciTE退出
	WinWaitClose, ahk_id %SciTE_Hwnd%
	ExitApp
return

;在帮助文件不存在，按F1没反应的情况下，友好的提示使用者该怎么做。
中文帮助友好提示:
	;由于修改了按“F1”时调用帮助文件的名称，所以在这里做一个友好提示，让按F1没反应的人知道是怎么回事。
	;之所以不直接使用“#If (FileExist(abc))”，是因为那样会报错。
	中文帮助是否存在:=FileExist(oSciTE.SciTEDir . "\..\AutoHotkey_CN.chm")
return

#If (中文帮助是否存在="")
F1::
	MsgBox, 262160, 没有找到中文帮助文件因此F1功能失效, 请自行于论坛或QQ群下载一份帮助文件并`n命名为“AutoHotkey_CN.chm”`n存放于“AutoHotkey.exe”同目录下。
return
#If

;单词自动完成时使用TAB键，可自动补全命令、函数等，并设好参数。此时若继续按TAB则可以在参数间跳跃，高效连贯的完成输入。
;BUG：
;	逗号左边不能是转义符或者引号。
;	有时会莫名打开文件夹。
智能Tab:
	标记 := 0
return
/*
;Ctrl+Enter总能跳到下一行
#If !WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
$^Enter::
	Send, {End}
	Send, {Enter}
Return
*/
;自动完成状态下,使用Tab将展开缩略语,并选中第一个参数
#If (标记=0) and WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
~$Tab::
	;SendInput 发送快捷键是不一定生效的，所以全部使用 Send 代替。
	Send, ^b											;展开缩略语
	Send, ^+{Right}											;在缩略语文件中已经设置过光标位置为单词前,所以这里直接选择下一单词就是了
	标记 := 1
	ToolTip, 智能Tab 已启用
return

;使用Tab在参数间跳跃
#If  (标记=1) and !WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
$Tab::
	if (oSciTE.Selection<>"")									;当前已有选中文字,则发送右箭头取消选择状态
		Send, {Right}
	Loop,25
	{
		Send, ^+{Right}										;选中右面单词
		选中文本 := oSciTE.Selection								;获取被选中的内容
		if (选中文本="")									;最后一行
		{
			Send, {Right}
			Send, {Enter}
			标记 := 0
			ToolTip,
			return
		}
		else if (SubStr(选中文本, 1, 2)="`r`n" or SubStr(选中文本, -1, 2)="`r`n")		;行末
		{
			Send, ^{Left}
			Send, {Enter}
			标记 := 0
			ToolTip,
			return
		}
		else if (SubStr(选中文本, 0, 1)=")")							;带闭括号的行末
		{
			Send, {Right}
			continue
		}
		else if (SubStr(RTrim(选中文本, " `t`r`n`v`f"), 0, 1)=",")				;逗号后面的参数
		{
			Send, {Right}
			Send, ^+{Right}
			return
		}
		else if (Trim(SubStr(选中文本, -3, 4), " `t`r`n`v`f")="in")				;专为 for 设置
		{
			Send, {Right}
			Send, ^+{Right}
			return
		}
	}
	标记 := 0
	ToolTip,
return

$NumpadEnter::
$Enter::
	if (oSciTE.Selection<>"")									;当前已有选中文字,则发送右箭头取消选择状态
		Send, {Right}
	Send, !+{End}											;选中文字到行末
	if (SubStr(RTrim(oSciTE.Selection, " `t`r`n`v`f"), 0, 1)=")")					;检查行最后一个非空白字符是否是闭括号,是则补一个闭括号
		Send, )
	Send, {Enter}
	标记 := 0
	ToolTip,
return
#If