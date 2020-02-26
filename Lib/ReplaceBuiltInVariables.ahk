ReplaceBuiltInVariables(byref V_ToBeReplaced)		;进行变量替换
{
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_AhkPath`%, %A_AhkPath%
	
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_WorkingDir`%, %A_WorkingDir%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_ScriptDir`%, %A_ScriptDir%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_ScriptFullPath`%, %A_ScriptFullPath%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_LineFile`%, %A_LineFile%

	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_desktop`%, %A_desktop%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_AppData`%, %A_AppData%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_StartMenu`%, %A_StartMenu%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_Startup`%, %A_Startup%
	stringreplace, V_ToBeReplaced, V_ToBeReplaced, `%A_MyDocuments`%, %A_MyDocuments%
	
	; msgbox % V_ToBeReplaced
}