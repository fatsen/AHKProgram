; SciTE4AutoHotkey v3 user autorun script
;
; You are encouraged to edit this script!
;

#NoEnv
#NoTrayIcon

����:
	SetWorkingDir, %A_ScriptDir%
	oSciTE := ComObjActive("SciTE4AHK.Application")
	SciTE_Hwnd := oSciTE.SciTEHandle

	gosub, ���İ����Ѻ���ʾ
	gosub, ����Tab

	;��SciTE�˳�
	WinWaitClose, ahk_id %SciTE_Hwnd%
	ExitApp
return

;�ڰ����ļ������ڣ���F1û��Ӧ������£��Ѻõ���ʾʹ���߸���ô����
���İ����Ѻ���ʾ:
	;�����޸��˰���F1��ʱ���ð����ļ������ƣ�������������һ���Ѻ���ʾ���ð�F1û��Ӧ����֪������ô���¡�
	;֮���Բ�ֱ��ʹ�á�#If (FileExist(abc))��������Ϊ�����ᱨ��
	���İ����Ƿ����:=FileExist(oSciTE.SciTEDir . "\..\AutoHotkey_CN.chm")
return

#If (���İ����Ƿ����="")
F1::
	MsgBox, 262160, û���ҵ����İ����ļ����F1����ʧЧ, ����������̳��QQȺ����һ�ݰ����ļ���`n����Ϊ��AutoHotkey_CN.chm��`n����ڡ�AutoHotkey.exe��ͬĿ¼�¡�
return
#If

;�����Զ����ʱʹ��TAB�������Զ���ȫ��������ȣ�����ò�������ʱ��������TAB������ڲ�������Ծ����Ч�����������롣
;BUG��
;	������߲�����ת����������š�
;	��ʱ��Ī�����ļ��С�
����Tab:
	��� := 0
return
/*
;Ctrl+Enter����������һ��
#If !WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
$^Enter::
	Send, {End}
	Send, {Enter}
Return
*/
;�Զ����״̬��,ʹ��Tab��չ��������,��ѡ�е�һ������
#If (���=0) and WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
~$Tab::
	;SendInput ���Ϳ�ݼ��ǲ�һ����Ч�ģ�����ȫ��ʹ�� Send ���档
	Send, ^b											;չ��������
	Send, ^+{Right}											;���������ļ����Ѿ����ù����λ��Ϊ����ǰ,��������ֱ��ѡ����һ���ʾ�����
	��� := 1
	ToolTip, ����Tab ������
return

;ʹ��Tab�ڲ�������Ծ
#If  (���=1) and !WinExist("ahk_class ListBoxX") and WinActive("ahk_id " . SciTE_Hwnd)
$Tab::
	if (oSciTE.Selection<>"")									;��ǰ����ѡ������,�����Ҽ�ͷȡ��ѡ��״̬
		Send, {Right}
	Loop,25
	{
		Send, ^+{Right}										;ѡ�����浥��
		ѡ���ı� := oSciTE.Selection								;��ȡ��ѡ�е�����
		if (ѡ���ı�="")									;���һ��
		{
			Send, {Right}
			Send, {Enter}
			��� := 0
			ToolTip,
			return
		}
		else if (SubStr(ѡ���ı�, 1, 2)="`r`n" or SubStr(ѡ���ı�, -1, 2)="`r`n")		;��ĩ
		{
			Send, ^{Left}
			Send, {Enter}
			��� := 0
			ToolTip,
			return
		}
		else if (SubStr(ѡ���ı�, 0, 1)=")")							;�������ŵ���ĩ
		{
			Send, {Right}
			continue
		}
		else if (SubStr(RTrim(ѡ���ı�, " `t`r`n`v`f"), 0, 1)=",")				;���ź���Ĳ���
		{
			Send, {Right}
			Send, ^+{Right}
			return
		}
		else if (Trim(SubStr(ѡ���ı�, -3, 4), " `t`r`n`v`f")="in")				;רΪ for ����
		{
			Send, {Right}
			Send, ^+{Right}
			return
		}
	}
	��� := 0
	ToolTip,
return

$NumpadEnter::
$Enter::
	if (oSciTE.Selection<>"")									;��ǰ����ѡ������,�����Ҽ�ͷȡ��ѡ��״̬
		Send, {Right}
	Send, !+{End}											;ѡ�����ֵ���ĩ
	if (SubStr(RTrim(oSciTE.Selection, " `t`r`n`v`f"), 0, 1)=")")					;��������һ���ǿհ��ַ��Ƿ��Ǳ�����,����һ��������
		Send, )
	Send, {Enter}
	��� := 0
	ToolTip,
return
#If