#SingleInstance force
#include Acc.ahk

/*
by king(xue_zhe)
*/
WinGet,hWnd,id, ahk_class Notepad
window := Acc_ObjectFromWindow(hWnd) 
MsgBox % window.accChildCount 
children := Acc_Children(window) 
MsgBox % children[2].accValue(0) 