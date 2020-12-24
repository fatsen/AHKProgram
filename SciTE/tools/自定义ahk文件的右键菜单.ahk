/*
AutoHotkey �汾: 1.x
����ϵͳ:    WinXP
����:        �׿ǳ�<jdchenjian@gmail.com>
����:        http://hi.baidu.com/jdchenjian
�ű�˵����   �˹��������޸� AutoHotkey �ű����Ҽ��˵������������� AutoHotkey ��װ�桢��ɫ�档
�ű��汾��   2009-01-21

�޸����ߣ�	����
����˵����
2010.01.09	֮ǰĳ��ʱ�䣬�޸�AHK·�����༭��·����������·����Ĭ��ȫ���ڵ�ǰĿ¼��Ѱ��
2010.01.09	ȥ��Ĭ�����½��˵��Ĺ�
2010.06.21	���SCITEΪĬ�ϱ༭�������Ƹ��������ļ���SciTEUser.properties����%USERPROFILE%
2010.06.25	������#NoEnvʹ%USERPROFILE%����ֱ��������Ч
2016.04.18	ɾ����2010.06.21���ĸĶ�
*/

#NoEnv
#SingleInstance, force
SendMode Input
SetWorkingDir %A_ScriptDir%

; �汾(��������ʾ��
Script_Version=v1.0.3.2

; AutoHotkey ԭ��������Ϣд��ע���HKCR�����У�
; �����ǵ�ǰ�û�����Ȩ�����ü��������Ȩ����HKCR���������û�����
; ��ͨ������ע���HKCU����ʵ�ֽ���ǰ�û�����AHK�ű���
IsLimitedUser:=0
RegWrite, REG_SZ, HKCR, .test
if ErrorLevel
	IsLimitedUser:=1
RegDelete, HKCR, .test
if ErrorLevel
	IsLimitedUser:=1

if IsLimitedUser=0 ; �������û�����HKCR��
{
	RootKey=HKCR
	Subkey=
}
else ; �����û�����HKCU��
{
	RootKey=HKCU
	Subkey=Software\Classes\ ; <-- Ϊ�򻯺���Ľű������Ӽ����ԡ�\����β
}

; ����Ƿ����AHKע�����
RegRead, FileType, %RootKey%, %Subkey%.ahk
if FileType<>
{
	RegRead, value, %RootKey%, %Subkey%%FileType%\Shell\Open\Command ;AHK·��
	AHK_Path:=PathGetPath(value)
	RegRead, value, %RootKey%, %Subkey%%FileType%\Shell\Edit\Command ;�༭��·��
	Editor_Path:=PathGetPath(value)
	RegRead, value, %RootKey%, %Subkey%%FileType%\Shell\Compile\Command ;������·��
	Compiler_Path:=PathGetPath(value)
	RegRead, Template_Name, %RootKey%, %Subkey%.ahk\ShellNew, FileName ;ģ���ļ���
}
else
	FileType=AutoHotkeyScript

if AHK_Path=
{
	IfExist, %A_ScriptDir%\AutoHotkey.exe
		AHK_path=%A_ScriptDir%\AutoHotkey.exe
}

if Editor_Path=
{
	IfExist, %A_ScriptDir%\SciTE\SciTE.exe
		Editor_Path=%A_ScriptDir%\SciTE\SciTE.exe
}

if Compiler_Path=
{
	IfExist, %A_ScriptDir%\Compiler\Ahk2Exe.exe
		Compiler_Path=%A_ScriptDir%\Compiler\Ahk2Exe.exe
}

if Template_Name=
	Template_Name=Template.ahk

Gui, Add, Tab, x10 y10 w480 h250 Choose1, ����|˵��
	Gui, Tab, 1
		Gui, Add, GroupBox, x20 y40 w460 h50 , �����нű��������� AutoHotkey
		Gui, Add, Edit, x35 y60 w340 h20 vAHK_Path, %AHK_path%
		Gui, Add, Button, x385 y60 w40 h20 gFind_AHK, ���

		Gui, Add, GroupBox, x20 y100 w460 h50 , ���༭�ű��������ı༭��
		Gui, Add, Edit, x35 y120 w340 h20 vEditor_Path, %Editor_Path%
		Gui, Add, Button, x385 y120 w40 h20 gChoose_Editor, ���
		Gui, Add, Button, x430 y120 w40 h20 gDefault_Editor, Ĭ��

		Gui, Add, GroupBox, x20 y160 w460 h50 , ������ű��������ı�����
		Gui, Add, Edit, x35 y180 w340 h20 vCompiler_Path, %Compiler_Path%
		Gui, Add, Button, x385 y180 w40 h20 gChoose_Compiler, ���
		Gui, Add, Button, x430 y180 w40 h20 gDefault_Compiler, Ĭ��

		Gui, Add, Checkbox, x35 y230 w270 h20 gNew_Script vNew_Script, �Ҽ����½����˵������ӡ�AutoHotkey �ű���
		Gui, Add, Button, x310 y230 w80 h20 vEdit_Template gEdit_Template, �༭�ű�ģ��
		Gui, Add, Button, x400 y230 w80 h20 vDelete_Template gDelete_Template, ɾ���ű�ģ��

	Gui, Tab, 2
		Gui, Font, bold
		Gui, Add, Text,, AutoHotkey �ű���������  ScriptSetting %Script_Version%
		Gui, Font
		Gui, Font, CBlue underline
		Gui, Add, Text, gWebsite, ���ߣ��׿ǳ� <jdchenjian@gmail.com>`n`n���ͣ�http://hi.baidu.com/jdchenjian
		Gui, Font
		Gui, Add, Text, w450, �˹��������޸� AutoHotkey �ű����Ҽ��˵������������� AutoHotkey ��װ�桢��ɫ�档
		Gui, Add, Text, w450, �������������޸�Ĭ�Ͻű��༭�������������޸�Ĭ�ϵ��½��ű�ģ�塣���ú����Ҽ��˵�����ӡ����нű��������༭�ű�����������ű����͡��½� AutoHotkey �ű�����ѡ�
		Gui, Add, Text, w450, Ҫȡ���ű���ϵͳ�������밴��ж�ء���ע�⣺ж�غ������޷�ͨ��˫�������нű���Ҳ����ͨ���Ҽ��˵��������ű��༭��...

Gui, Tab
Gui, Add, Button, x100 y270 w60 h20 Default gInstall, ����
Gui, Add, Button, x200 y270 w60 h20 gUninstall, ж��
Gui, Add, Button, x300 y270 w60 h20 gCancel, ȡ��

Gui, Show, x250 y200 h300 w500 Center, ScriptSetting %Script_Version%
GuiControl, Disable, Edit_Template ; ʹ���༭�ű�ģ�塱��ť��Ч
IfNotExist, %A_WinDir%\ShellNew\%Template_Name%
	GuiControl, Disable, Delete_Template ; ʹ��ɾ���ű�ģ�塱��ť��Ч

; �����ָ������ʱ��ָ��������
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE")
return

; �ı����ָ��Ϊ����
WM_MOUSEMOVE(wParam,lParam)
{
	global hCurs
	MouseGetPos,,,,ctrl
	if ctrl in static2
		DllCall("SetCursor","UInt",hCurs)
	return
}
return

GuiClose:
GuiEscape:
Cancel:
	ExitApp

	; ���� AutoHotkey ������
Find_AHK:
	Gui +OwnDialogs
	FileSelectFile, AHK_Path, 3, , ���� AutoHotkey.exe, AutoHotkey.exe
	if AHK_Path<>
		GuiControl,,AHK_Path, %AHK_Path%
	gosub Default_Compiler
return

; ѡ��ű��༭��
Choose_Editor:
	Gui +OwnDialogs
	FileSelectFile, Editor_Path, 3, , ѡ��ű��༭��, ����(*.exe)
	if Editor_Path<>
		GuiControl,,Editor_Path, %Editor_Path%
return

; Ĭ�Ͻű��༭��
Default_Editor:
	IfExist, %A_ScriptDir%\SciTE\SciTE.exe
		Editor_Path=%A_ScriptDir%\SciTE\SciTE.exe
	else ifExist, %A_WinDir%\system32\notepad.exe
			Editor_Path=%A_WinDir%\system32\notepad.exe
	GuiControl,, Editor_Path, %Editor_Path%
return

; ѡ��ű�������
Choose_Compiler:
	Gui +OwnDialogs
	FileSelectFile, Compiler_Path, 3, , ѡ��ű�������, ����(*.exe)
	if Compiler_Path<>
		GuiControl,,Compiler_Path, %Compiler_Path%
return

; Ĭ�Ͻű�������
Default_Compiler:
	GuiControlGet, AHK_Path
	SplitPath, AHK_Path, ,AHK_Dir
	IfExist, %AHK_Dir%\Compiler\Ahk2Exe.exe
	{
		Compiler_Path=%AHK_Dir%\Compiler\Ahk2Exe.exe
		GuiControl,, Compiler_Path, %Compiler_Path%
	}
return

; ����
Install:
	Gui, Submit
	IfNotExist, %AHK_Path%
	{
		MsgBox, 16, ScriptSetting %Script_Version%, AutoHotkey ·������ ��
		return
	}

	IfNotExist, %Editor_Path%
	{
		MsgBox, 16, ScriptSetting %Script_Version%, �༭��·������ ��
		return
	}

	IfNotExist, %Compiler_Path%
	{
		MsgBox, 16, ScriptSetting %Script_Version%, ������·������ ��
		return
	}

	; д��ע���
	RegWrite, REG_SZ, %RootKey%, %Subkey%.ahk,, %FileType%
	if New_Script=1
	{
		RegWrite, REG_SZ, %RootKey%, %Subkey%.ahk\ShellNew, FileName, %Template_Name%
		IfNotExist, %A_WinDir%\ShellNew\%Template_Name%
			gosub Create_Template
	}
	else
	{
		RegDelete, %RootKey%, %Subkey%.ahk\ShellNew
		IfExist, %A_WinDir%\ShellNew\%Template_Name%
			gosub Delete_Template
	}

	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%,, AutoHotkey �ű�
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\DefaultIcon,, %AHK_Path%`,1
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell,, Open
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Open,, ���нű�
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Open\Command,, "%AHK_Path%" "`%1" `%*
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Edit,, �༭�ű�
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Edit\Command,, "%Editor_Path%" "`%1"
	RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Compile,, ����ű�
	IfInString, Compiler_Path, Ahk2Exe.exe
		RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Compile\Command,, "%Compiler_Path%" /in "`%1"
	else
		RegWrite, REG_SZ, %RootKey%, %Subkey%%FileType%\Shell\Compile\Command,, "%Compiler_Path%" "`%1"

	/*		�°��scite����Ҫ����SciTEUser.properties�����ڡ�USERPROFILE��Ŀ¼����
	if Editor_Path=%A_ScriptDir%\SciTE\SciTE.exe
	{
		EnvGet,USERPROFILE,USERPROFILE
		FileCopy,%A_ScriptDir%\SciTE\SciTEUser.properties,%USERPROFILE%\SciTEUser.properties,1
	}
	*/

	MsgBox, 64, ScriptSetting %Script_Version%, ������� ��
	ExitApp

	; ж��
Uninstall:
	MsgBox, 36, ScriptSetting %Script_Version%
		, ע�⣺ж�غ������޷�ͨ��˫�������нű���Ҳ����ͨ���Ҽ��˵��������ű��༭��...`n`nȷ��Ҫȡ�� AHK �ű���ϵͳ������ ��
	IfMsgBox, Yes
	{
		RegDelete, %RootKey%, %Subkey%.ahk
		RegDelete, %RootKey%, %Subkey%%FileType%
		gosub Delete_Template
		ExitApp
	}
return

; �༭�ű�ģ��
Edit_Template:
	GuiControlGet, Editor_Path
	IfNotExist, %Editor_Path%
	{
		MsgBox, 64, ScriptSetting %Script_Version%, �ű��༭��·������ ��
		return
	}
	IfNotExist, %A_WinDir%\ShellNew\%Template_Name%
		gosub Create_Template
	Run, %Editor_Path% %A_WinDir%\ShellNew\%Template_Name%
return

; ʹ�༭�ű�ģ�尴ť��Ч/��Ч
New_Script:
	GuiControlGet, New_Script
	if New_Script=0
		GuiControl, Disable, Edit_Template
	else
		GuiControl, Enable, Edit_Template
return

; �½��ű�ģ��
Create_Template:
	GuiControlGet, AHK_Path
	FileGetVersion, AHK_Ver, %AHK_Path%

	FileAppend,
	(
/*
AutoHotkey �汾: %AHK_Ver%
����ϵͳ:    %A_OSVersion%
����:        %A_UserName%
��վ:        http://www.AutoHotkey.com
�ű�˵����
�ű��汾��   v1.0
*/

#NoEnv
SendMode Input
SetWorkingDir `%A_ScriptDir`%

	), %A_WinDir%\ShellNew\%Template_Name%

	GuiControl, Enable, Delete_Template ; ʹ��ɾ���ű�ģ�塱��ť��Ч
return

; ɾ���ű�ģ��
Delete_Template:
	MsgBox, 36, ScriptSetting %Script_Version%
		, Ҫɾ����ǰ�� AHK �ű�ģ���� ��`n`n�ű�ģ�屻ɾ�����Կ�ͨ���������ؽ�ģ�塣
	IfMsgBox, Yes
		FileDelete, %A_WinDir%\ShellNew\%Template_Name%
	GuiControl, Disable, Delete_Template ; ʹ��ɾ���ű�ģ�塱��ť��Ч
return

; ����վ
Website:
	Run, http://hi.baidu.com/jdchenjian
return

; ��ע���ֵ�ַ�������ȡ·��
PathGetPath(pSourceCmd)
{
	local Path, ArgsStartPos = 0
	if (SubStr(pSourceCmd, 1, 1) = """")
		Path := SubStr(pSourceCmd, 2, InStr(pSourceCmd, """", False, 2) - 2)
	else
	{
		ArgsStartPos := InStr(pSourceCmd, " ")
		if ArgsStartPos
			Path := SubStr(pSourceCmd, 1, ArgsStartPos - 1)
		else
			Path = %pSourceCmd%
	}
	return Path
}