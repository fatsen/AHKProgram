;=================================================
;��         ��:  ������
;����˵����������Ϣ�����(���С�ŵ����)
;���� �汾:   Autohotkey v1.1.22.09
;=================================================



#NoTrayIcon
#SingleInstance  force
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ListLines Off
#Include %A_ScriptDir%\..\Lib\GuiButtonIcon.ahk

Gui,  1:Add, Edit, x110 y30 w340 h70 Multi vmain   r3, ��Ҫ����
Gui,  1:Add, Edit, x110 y90 w340 h40 Multi vextra   r5, ��Ҫ����
Gui,  1:Add, Edit, x110 y180 w340 h20 -Multi  limit15 vtitle, ��ʾ
Gui,  1:Add, Edit, x110 y210 w340 h20 -Multi  vwidth +number, 400
Gui,  1:Add, Slider,x110 y240 w310 h20 Range0-20 ReadOnly Right vTimeout gcontroltimeout, 0
Gui,  1:Add, Edit, x420 y242 w30 h20 -Multi  limit15 ReadOnly vtimeoutshow, 0.0
Gui,  1:Font, s11 bold cpurple
Gui,  1:Add, GroupBox, x470 y20 w290 h125 , ��ť���
Gui,  1:Font
Gui,  1:Add, Radio, x490 y40 w100 h20 vbutton1, Ok
Gui,  1:Add, Radio, x490 y64 w100 h20 vbutton2, Yes
Gui,  1:Add, Radio, x490 y88 w100 h20 vbutton3 checked, Yes/No
Gui,  1:Add, Radio, x490 y112 w130 h20 vbutton4, Cancel/Retry/Close

Gui,  1:Add, Radio, x620 y112  w100 h20 vbutton5, All Buttons
Gui,  1:Add, Radio, x620 y64 w100 h20 vbutton6, Retry/Cancel
Gui,  1:Add, Radio, x620 y88 w100 h20 vbutton7, Retry/Close
Gui,  1:Add, Radio,x620 y40 w130 h20 vbutton8, Yes/No/Close
Gui,  1:Font
Gui,  1:Font, s11 bold cpurple
Gui,  1:Add, GroupBox, x470 y150 w290 h200 , ͼ��������
Gui,  1:Font
Gui,  1:Font,bold
Gui,  1:Add, Radio, x490 y170 w100 h20 vicon1, ����
Gui,  1:Add, Radio, x490 y198 w100 h20 vicon2, ����
Gui,  1:Add, Radio, x490 y226 w100 h20 vicon3, ��ʾ
Gui,  1:Add, Radio, x490 y254 w100 h20 vicon4, �ػ�
Gui,  1:Add, Radio,x490 y282 w100 h20 vicon10, �ʺ�
Gui,  1:Font
Gui,  1:Font,  cblue bold
Gui,  1:Add, Radio,  x610 y254 w100 h20 vicon5, ��ɫ
Gui,  1:Font, cFF8000
Gui,  1:Add, Radio, x610 y170 w100 h20 vicon6, ��ɫ
Gui,  1:Font,  cred
Gui,  1:Add, Radio,  x610 y226 w100 h20 vicon7, ��ɫ
Gui,  1:Font,  cgreen
Gui,  1:Add, Radio,  x610 y198w100 h20 vicon8 checked, ��ɫ
Gui,  1:Font,  cgray
Gui,  1:Add, Radio,  x610 y282 w50 h20 vicon9, ��ɫ
Gui,  1:Font,  cblack
Gui,  1:Add, Radio,  x490 y314 w72 h20 vicon11 gcustomicon, �Զ��壺
Gui,  1:Font
Gui,  1:Add, Edit, x560 y314 w180 h20 -Multi  ReadOnly vicon_file_path,
Gui,  1:Font, s11 bold
Gui,  1:Add, Text, x20 y55   w90 h20, ��Ҫ���ݣ�
Gui,  1:Add, Text, x20 y120 w90 h20, ��Ҫ���ݣ�
Gui,  1:Add, Text, x20 y185 w90 h20, �������֣�
Gui,  1:Add, Text, x20 y215 w90 h20 , ���ڿ�ȣ�
Gui,  1:Add, Text, x20 y245 w90 h20 , ��ʱ������
Gui,  1:Font
Gui,  1:font,s13
Gui,  1:Add, Edit, x20 y360 w737 h100   vcontent, �������
Gui,  1:font
Gui,  1:Add, Button, x240 y280 w100 h50 hwndIcon3 gcommand, ����(F2)
Gui,  1:Add, Button, x10 y280 w110 h50 hwndIcon1 gview, Ԥ��TD(F1)
Gui,  1:Add, Button, x130 y280 w100 h50 hwndIcon2 gviewXP, Ԥ��MB
Gui,  1:Add, Button, x350 y280 w100 h50 hwndIcon4 gcopycode, ����(F3)

GuiButtonIcon(Icon1, "shell32.dll", 172, "s32 a0 l5")
GuiButtonIcon(Icon2, "shell32.dll", 3, "s32 a0 l5")
GuiButtonIcon(Icon3, "shell32.dll", 46, "s32 a0 l5")
GuiButtonIcon(Icon4, "shell32.dll", 259, "s32 a0 l5")

Gui,  1:Add, Text, x270 y480 w700 h30 +disabled,�ú�����֧��xp����xpϵͳ����ʾ��ͨ��MsgBox��
Gui,  1:Show, CEnter w780 h500, TaskDialogEx Creator
GuiControl, +Default, ����
return


controltimeout:
GuiControl,  1:, timeoutshow, % (Timeout = 0 ? 0 : Round(Timeout / 2, 1))*2
return

GuiClose:
	ExitApp

f1::
view:
	Gui,  1:Submit, NoHide
	gosub transbuttonandicon
	if icon11
	{
		StringSplit,filepath,icon_file_path,`,
		HICON := LoadIcon(filepath1, filepath2)
		MsgBox,262208,��ʾ, % "��������ǣ�"  TaskDialogEx(main,extra,title,button,hicon,width,-1,timeout)
		return
	}
	MsgBox,262208,��ʾ, % "��������ǣ�"  TaskDialogEx(main,extra,title,button,icon,width,-1,timeout)
return

f2::
command:
	Gui, 1:Submit, NoHide
	gosub transbuttonandicon
	ControlSetText,edit7
	if icon11
	{
		StringSplit,filepath,icon_file_path,`,
		HICON= LoadIcon(%filepath1%, %filepath2%)
		myfunction=
		myfunction=#Include <TaskDialogEx>`r`nTaskDialogUseMsgBoxOnXP(true)`r`nTaskDialogEx("%main%","%extra%","%title%",%button%,%hicon%,%width%,-1,%timeout%)
		;~ msgbox % myfunction
		GuiControl,1:,content,%myfunction%
		return
	}
	if icon=question
		icon="question"
	myfunction=
	myfunction=#Include <TaskDialogEx>`r`nTaskDialogUseMsgBoxOnXP(true)`r`nTaskDialogEx("%main%","%extra%","%title%",%button%,%icon%,%width%,-1,%timeout%)
	;~ msgbox % myfunction
	GuiControl,1:,content,%myfunction%
return

f3::
copycode:
	gosub command
	;clipboard:=myfunction

	SoundBeep, 750, 100
	SoundBeep, 750, 100
return

viewXP:
	Gui, 1:Submit, NoHide
	gosub transbuttonandicon
	TaskDialogUseMsgBoxOnXP(true)
	MsgBox,262208,��ʾ, % "��������ǣ�"  TaskDialogMsgBox(main,extra,title,button,icon,-1,timeout)
return



openahkscript:
	Run http://ahkscript.org/boards/viewtopic.php?f=6&t=4635
return


reloadcreator:
	Reload
return

customicon:
	Gui,2:add, text, x10 y10 w400 h20, ���Ҵ��ļ��е�ͼ�꣺
	Gui,2:add, edit, x10 y30 w300 h20 -Multi vfile
	Gui,2:add, button, x325 y30 w80 h20 gselect, ���(&B)...
	Gui,2:add, text, x10 y55 w400 h20, �������б���ѡ��һ��ͼ�꣺
	Gui,2:Add, ListView, x10 y70 w400 h300 Icon vMyListView gMyListView, id
	Gui,2:add, Button, x10 y380 w180 h30 Default gok, ȷ��
	Gui,2:add, Button, x230 y380 w180 h30 gcancel, ȡ��
	Gui,2: show, , ѡ��ͼ��
	Gui 2:+LastFound +OwnDialogs
	ControlClick,button1
return


select:
	FileSelectFile, file, , %SystemRoot%\system32\SHELL32.dll, ��ѡ��ͼ���ļ�, ͼ��(*.dll;*.ico;*.exe)
	if file
	{
		GuiControl, 2:, file, % file
		ImageListID := IL_Create(,,1)
		LV_SetImageList(ImageListID)
		icon_count := GetIconCount(file)
		LV_Delete()
		Loop % icon_count
			IL_Add(ImageListID, file, A_Index)
		Loop % icon_count
			LV_Add("Icon" . A_Index, A_Index)
	}
	else
		Gui, 2:Destroy
return

cancel:
	Gui, 2:Destroy
return

ok:
MyListView:
	icon := {}
	FocusedRowNumber := LV_GetNext(0, "F")
	if not FocusedRowNumber
	{
		MsgBox, 4144, ��ʾ, ��δѡ���κ�ͼ�꣡
		return
	}
	LV_GetText(id, FocusedRowNumber, 1)
	icon["file"] := file
	icon["id"] := id
	; MsgBox, 64, ��ʾ, % "��ѡ����" """" icon["file"] """" "�ĵ�" icon["id"] "��ͼ��"
	GuiControl,1:,icon_file_path,% icon["file"] "," icon["id"]
	Gui,2: destroy
return

GetIconCount(file)
{
	Menu, test, add, test, handle
	Loop
	{
		try
		{
			id++
			Menu, test, Icon, test, % file, % id
		}
		catch error
		{
			break
		}
	}
	return id-1
}

handle:
return




transbuttonandicon:
	button=
	icon=
	Loop 8
	{
		if button%a_index%=1
		{
			if A_Index = 1
				button = 1
			else if A_Index = 2
				button = 2
			else if A_Index = 3
				button = 6
			else if A_Index = 4
				button = 56
			else if A_Index = 5
				button = 63
			else if A_Index = 6
				button = 24
			else if A_Index = 7
				button = 48
			else if A_Index = 8
				button = 38
			break
		}

	}
	Loop 10
	{
		if icon%a_index%=1
		{
			if a_index=10
				icon=question
			else
				icon:=a_index
			break
		}

	}
return

;=========================================================================
; TaskDialogEx(����,����,����,��ť,ͼ��,���,������,��ʱ)
TaskDialogEx(Main, Extra := "", Title := "��ʾ��", Buttons := 1, Icon := 8, Width := 600, Parent := -1, TimeOut := 0) {
	Static TDCB      := RegisterCallback("TaskDialogCallback", "Fast")
		, TDCSize   := (4 * 8) + (A_PtrSize * 16)
		, TDBTNS    := {OK: 1, YES: 2, NO: 4, CANCEL: 8, RETRY: 16, CLOSE: 32}
		, TDF       := {HICON_MAIN: 0x0002, ALLOW_CANCEL: 0x0008, CALLBACK_TIMER: 0x0800, SIZE_TO_CONTENT: 0x01000000}
		, TDICON    := {1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9
		, WARN: 1, ERROR: 2, INFO: 3, SHIELD: 4, BLUE: 5, YELLOW: 6, RED: 7, GREEN: 8, GRAY: 9
		, QUESTION: 0}
		, HQUESTION := DllCall("User32.dll\LoadIcon", "Ptr", 0, "Ptr", 0x7F02, "UPtr")
		, DBUX      := DllCall("User32.dll\GetDialogBaseUnits", "UInt") & 0xFFFF
		, OffParent := 4
		, OffFlags  := OffParent + (A_PtrSize * 2)
		, OffBtns   := OffFlags + 4
		, OffTitle  := OffBtns + 4
		, OffIcon   := OffTitle + A_PtrSize
		, OffMain   := OffIcon + A_PtrSize
		, OffExtra  := OffMain + A_PtrSize
		, OffCB     := (4 * 7) + (A_PtrSize * 14)
		, OffCBData := OffCB + A_PtrSize
		, OffWidth  := OffCBData + A_PtrSize
	; -------------------------------------------------------------------------------------------------------------------
	if ((DllCall("Kernel32.dll\GetVersion", "UInt") & 0xFF) < 6) {
		if TaskDialogUseMsgBoxOnXP()
			return TaskDialogMsgBox(Main, Extra, Title, Buttons, Icon, Parent, Timeout)
		else {
			MsgBox, 16, %A_ThisFunc%, You need at least Win Vista / Server 2008 to use %A_ThisFunc%().
			ErrorLevel := "You need at least Win Vista / Server 2008 to use " . A_ThisFunc . "()."
			return 0
		}
	}
	; -------------------------------------------------------------------------------------------------------------------
	Flags := Width = 0 ? TDF.SIZE_TO_CONTENT : 0
	if (Title = "")
		Title := A_ScriptName
	BTNS := 0
	if Buttons Is Integer
		BTNS := Buttons & 0x3F
	else
		For Each, Btn In StrSplit(Buttons, ["|", " ", ",", "`n"])
	BTNS |= (B := TDBTNS[Btn]) ? B : 0
	ICO := (I := TDICON[Icon]) ? 0x10000 - I : 0
	if Icon Is Integer
		if ((Icon & 0xFFFF) <> Icon) ; caller presumably passed HICON
			ICO := Icon
	if (Icon = "Question")
		ICO := HQUESTION
	if (ICO > 0xFFFF)
		Flags |= TDF.HICON_MAIN
	AOT := Parent < 0 ? !(Parent := 0) : False ; AlwaysOnTop
	; -------------------------------------------------------------------------------------------------------------------
	PTitle := A_IsUnicode ? &Title : TaskDialogToUnicode(Title, WTitle)
	PMain  := A_IsUnicode ? &Main : TaskDialogToUnicode(Main, WMain)
	PExtra := Extra = "" ? 0 : A_IsUnicode ? &Extra : TaskDialogToUnicode(Extra, WExtra)
	VarSetCapacity(TDC, TDCSize, 0) ; TASKDIALOGCONFIG structure
	NumPut(TDCSize, TDC, "UInt")
	NumPut(Parent, TDC, OffParent, "Ptr")
	NumPut(BTNS, TDC, OffBtns, "Int")
	NumPut(PTitle, TDC, OffTitle, "Ptr")
	NumPut(ICO, TDC, OffIcon, "Ptr")
	NumPut(PMain, TDC, OffMain, "Ptr")
	NumPut(PExtra, TDC, OffExtra, "Ptr")
	if (AOT) || (TimeOut > 0) {
		if (TimeOut > 0) {
			Flags |= TDF.CALLBACK_TIMER
			TimeOut := Round(Timeout * 1000)
		}
		TD := {AOT: AOT, Timeout: Timeout}
		NumPut(TDCB, TDC, OffCB, "Ptr")
		NumPut(&TD, TDC, OffCBData, "Ptr")
	}
	NumPut(Flags, TDC, OffFlags, "UInt")
	if (Width > 0)
		NumPut(Width * 4 / DBUX, TDC, OffWidth, "UInt")
	if !(RV := DllCall("Comctl32.dll\TaskDialogIndirect", "Ptr", &TDC, "IntP", Result, "Ptr", 0, "Ptr", 0, "UInt"))
		return TD.TimedOut ? -1 : Result
	ErrorLevel := "The call of TaskDialogIndirect() failed!`nreturn value: " . RV . "`nLast error: " . A_LastError
	return 0
}
; ================================================================================?======================================
; Call this function once passing 1/True if you want a MsgBox to be displayed instead of the task dialog on Win XP.
; ================================================================================?======================================
TaskDialogUseMsgBoxOnXP(UseIt := "") {
	Static UseMsgBox := False
	if (UseIt <> "")
		UseMsgBox := !!UseIt
	return UseMsgBox
}
; ================================================================================?======================================
; Internally used functions
; ================================================================================?======================================
TaskDialogMsgBox(Main, Extra, Title := "", Buttons := 0, Icon := 0, Parent := 0, TimeOut := 0) {
	Static MBICON := {1: 0x30, 2: 0x10, 3: 0x40, WARN: 0x30, ERROR: 0x10, INFO: 0x40, QUESTION: 0x20}
		, TDBTNS := {OK: 1, YES: 2, NO: 4, CANCEL: 8, RETRY: 16}
	BTNS := 0
	if Buttons Is Integer
		BTNS := Buttons & 0x1F
	else
		For Each, Btn In StrSplit(Buttons, ["|", " ", ",", "`n"])
	BTNS |= (B := TDBTNS[Btn]) ? B : 0
	Options := 0
	Options |= (I := MBICON[Icon]) ? I : 0
	Options |= Parent = -1 ? 262144 : Parent > 0 ? 8192 : 0
	if ((BTNS & 14) = 14)
		Options |= 0x03 ; Yes/No/Cancel
	else if ((BTNS & 6) = 6)
		Options |= 0x04 ; Yes/No
	else if ((BTNS & 24) = 24)
		Options |= 0x05 ; Retry/Cancel
	else if ((BTNS & 9) = 9)
		Options |= 0x01 ; OK/Cancel
	Main .= Extra <> "" ? "`n`n" . Extra : ""
	MsgBox, % Options, %Title%, %Main%, %TimeOut%
	IfMsgBox, OK
		return 1
	IfMsgBox, Cancel
		return 2
	IfMsgBox, Retry
		return 4
	IfMsgBox, Yes
		return 6
	IfMsgBox, No
		return 7
	IfMsgBox, TimeOut
		return -1
	return 0
}
; ================================================================================?======================================
TaskDialogToUnicode(String, ByRef Var) {
	VarSetCapacity(Var, StrPut(String, "UTF-16") * 2, 0)
	StrPut(String, &Var, "UTF-16")
	return &Var
}
; ================================================================================?======================================
TaskDialogCallback(H, N, W, L, D) {
	Static TDM_Click_BUTTON := 0x0466
		, TDN_CREATED := 0
		, TDN_TIMER   := 4
	TD := Object(D)
	if (N = TDN_TIMER) && (W > TD.Timeout) {
		TD.TimedOut := True
		PostMessage, %TDM_Click_BUTTON%, 2, 0, , ahk_id %H% ; IDCANCEL = 2
	}
	else if (N = TDN_CREATED) && TD.AOT {
		DHW := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinSet, AlwaysOnTop, On, ahk_id %H%
		DetectHiddenWindows, %DHW%
	}
	return 0
}


LoadIcon(FullFilePath, IconNumber := 1, LargeIcon := 1) {
	HIL := IL_Create(1, 1, !!LargeIcon)
	IL_Add(HIL, FullFilePath, IconNumber)
	HICON := DllCall("Comctl32.dll\ImageList_GetIcon", "Ptr", HIL, "Int", 0, "UInt", 0, "UPtr")
	IL_Destroy(HIL)
	return HICON
}

/*
GuiButtonIcon(Handle, File, Index := 1, Options := "")
{
RegExMatch(Options, "i)w\K\d+", W), (W="") ? W := 16 :
RegExMatch(Options, "i)h\K\d+", H), (H="") ? H := 16 :
RegExMatch(Options, "i)s\K\d+", S), S ? W := H := S :
RegExMatch(Options, "i)l\K\d+", L), (L="") ? L := 0 :
RegExMatch(Options, "i)t\K\d+", T), (T="") ? T := 0 :
RegExMatch(Options, "i)r\K\d+", R), (R="") ? R := 0 :
RegExMatch(Options, "i)b\K\d+", B), (B="") ? B := 0 :
RegExMatch(Options, "i)a\K\d+", A), (A="") ? A := 4 :
Psz := A_PtrSize = "" ? 4 : A_PtrSize, DW := "UInt", Ptr := A_PtrSize = "" ? DW : "Ptr"
VarSetCapacity( button_il, 20 + Psz, 0 )
NumPut( normal_il := DllCall( "ImageList_Create", DW, W, DW, H, DW, 0x21, DW, 1, DW, 1 ), button_il, 0, Ptr )   ; Width & Height
NumPut( L, button_il, 0 + Psz, DW )     ; Left Margin
NumPut( T, button_il, 4 + Psz, DW )     ; Top Margin
NumPut( R, button_il, 8 + Psz, DW )     ; Right Margin
NumPut( B, button_il, 12 + Psz, DW )    ; Bottom Margin
NumPut( A, button_il, 16 + Psz, DW )    ; Alignment
SendMessage, BCM_SETIMAGELIST := 5634, 0, &button_il,, AHK_ID %Handle%
return IL_Add( normal_il, File, Index )
}
*/