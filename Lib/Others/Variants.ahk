Variants()
{
;脚本起始处为自动执行代码段。
;region -----------整体环境变量----------------
;在不同的环境中，只需修改B_Env即可，其他设置均为提前设置好的。
B_Env=2			;环境变量
;脚本所处的环境，暂定1为办公室，2为笔记本，3为ERS
;4为其他（缺少Appended Files文件夹中的常用的软件，用系统默认的程序运行文件）。
ifexist C:\Program Files (x86)\Tencent\QQIntl\Bin\QQ.exe
	B_Env=2
else
	B_Env=3
; if(B_Env<3)		;因办公室系统为64bit，而笔记本系统为32bit，为避免反复修改该变量，设置成根据系统位数自动判断。
	; if A_Is64bitOS=1
		; B_Env=1	;64位系统时，设置成办公室
	; else
		; B_Env=2	;32位系统时，设置成笔记本
; B_IsSpecial=0		;Special
B_IsRemap=1			;Remap
B_IsPunctEN=1		;PunctuationEnglish
B_IsOverWrite=0		;OverWrite
;region 省略某些按键，并且相互冲突（注意启用其中一个时，需要将另一个取消）
B_IsAltOmit=0		;AltOmit
B_IsCtrlOmit=0		;CtrlOmit
B_IsWinOmit=0		;WinOmit
;endregion
;region Flag标识
FlagSpec=0		;特殊按键标识，默认值为0，即不是特殊按键
;endregion
;region 某些按键是否处于一直按下的状态
B_IsAltDown=0	
B_IsCtrlDown=0	
B_IsWinDown=0	
B_IsShiftDown=0	
;endregion
StringTrimRight, B_ScriptName, A_ScriptName, 4	;脚本名称
;region 鼠标默认位置
B_MouseXPos=0		;鼠标默认X位置
B_MouseYPos=0		;鼠标默认Y位置
;endregion
;region 缩放窗口的ID
B_DownID:=
B_UpID:=
;endregion
;region 剪贴板相关
B_ClipSpec:=	;默认特殊剪贴板内容为空。需要清空时，重启脚本即可
B_ClipEnd:=		;剪贴板末尾内容。此处赋初值
B_ClipStart:=	;剪贴板开头内容。此处赋初值
;ClipBackup。不对ClipBackup赋初值，现在#Warn已启用。如果ClipBackup在使用时没有被赋值，
;则会报错，从而保证每次使用ClipBackup时，剪贴板内容都被备份。
;endregion
;region ;获取系统语言
B_IsChinese:=0	;默认不是中文

if (A_Language=0404)
or (A_Language=0804)
; or (A_Language=0c04)	;香港的语言代号，通不过默认的错误检查
or (A_Language=1004)
or (A_Language=1404)
	B_IsChinese:=1
; B_IsChinese:=1-B_IsChinese	;used when debugging
; Msgbox Warning				;used when debugging
;endregion
;endregion
;region ----------时间间隔----------------
;时间间隔，很重要！！！很多地方出错都是因为gap过小导致，而gap过大会导致反应过慢
gap:=50			;因为很多步骤都是在该时间间隔的基础上反复调试得到的，不要更改该值！！！（目前为50）
gap2:=gap*2
gap3:=gap*3
gap4:=gap*4
gap5:=gap*5
gap6:=gap*6
gap7:=gap*7
gap8:=gap*8
gap9:=gap*9
gap10:=gap*10

gap1min:=60*1000
gap10min:=gap1min*10
gap20min:=gap1min*20
gap30min:=gap1min*30
gap40min:=gap1min*40
gap50min:=gap1min*50
gap60min:=gap1min*60
;endregion
;=====================================================================
; 通过赋值为空可以释放大变量占用的内存, 例如 Var := "".  from help
;dir_为文件夹路径的前缀，exe_为可执行程序变量的前缀，str_为字符串的前缀, ahk_为ahk脚本，url_网址，non_为不定前缀
;虽然使用{}可以在SciTE4AHK中进行折叠，使脚本的查看更加清晰；但{}之间的变量赋值无法实现，貌似{}内的变量认为是局部变量，
;只能{}外的变量获取{}内的变量，而不能并行的{A}中的变量获取并行的{B}中的变量（不会报错，但会认为该变量不存在）
;region ---directories---
;为统一形式，本脚本中的dir最后都不带“\”
;字符串变量得写成“dir_explorer2=F:\BaiduYunDownload”或“dir_explorer2:="F:\BaiduYunDownload"”的形式
;脚本文件夹内
dir_ahkProgram=%A_LineFile%\..\..\..\ahk program
dir_ahkScripts1=%A_LineFile%\..\..\Portable Softwares\Q-Dir\Favourite\ahk.qdr
dir_ahkScripts2=%A_LineFile%\..\..\Includes
dir_ahkScripts3:=dir_ahkScripts2
dir_ahkScripts:=dir_ahkScripts%B_Env%
dir_Includes=%A_LineFile%\..\..\Includes
dir_Special=%A_LineFile%\..\..\Includes\Special
dir_ComputerSkills = %A_LineFile%\..\..\..\ComputerSkills
;本地文件夹
dir_explorer1=Z:\3D共用文件\Content Center Files2009(CN)
dir_explorer2=F:\BaiduYunDownload
dir_explorer3:=dir_explorer1
dir_explorer:=dir_explorer%B_Env%
;endregion
;region ---executable programs---
;installed
; exe_bluetooth = C:\Program Files\IVT Corporation\BlueSoleil\BlueSoleil.exe
exe_browser1 = %A_LineFile%\..\..\Portable Softwares\SogouExplorerPortable\SogouExplorer.exe
exe_browser2 = C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
exe_browser3 := exe_browser2
exe_browser  := exe_browser%B_Env%

exe_Foxmail = D:\Program Files\Foxmail\Foxmail.exe
exe_inventor = C:\Program Files\Autodesk\Inventor 2010\bin\Inventor.exe
exe_kugou = D:\Program Files\KuGou\KGMusic\KuGou.exe
exe_qq = C:\Program Files (x86)\Tencent\QQIntl\Bin\QQ.exe
exe_Hdownload = D:\Program Files\BaiduYunGuanjia\baiduyunguanjia.exe
exe_ebwin = C:\Program Files (x86)\EBWin\EBWin.exe
exe_Lingoes = %A_LineFile%\..\..\Portable Softwares\lingoes_portable_2.9.2_cn\Lingoes.exe
exe_wink = D:\Program Files (x86)\DebugMode\Wink\Wink.exe

exe_everything1 = D:\Program Files (x86)\Everything\Everything.exe
exe_everything2 = C:\Program Files (x86)\Everything\Everything.exe
exe_everything3 = C:\Program Files\Everything\Everything.exe
exe_everything := exe_everything%B_Env%

exe_Typora1 = C:\Program Files\Typora\Typora.exe
exe_Typora2 = C:\Program Files\Typora\Typora.exe
exe_Typora3 = C:\Program Files\Typora\Typora.exe
exe_Typora := exe_Typora%B_Env%

;portable
exe_altRun = %A_LineFile%\..\..\Portable Softwares\ALTRun\ALTRun.exe

exe_AntRenamer1 = %A_LineFile%\..\..\Portable Softwares\AntRenamerPortable\AntRenamerPortable.exe
exe_AntRenamer2 = %A_LineFile%\..\..\Portable Softwares\AntRenamerPortable\AntRenamerPortable.exe
exe_AntRenamer3 = %A_LineFile%\..\..\Portable Softwares\AntRenamer2\Renamer.exe
exe_AntRenamer := exe_AntRenamer%B_Env%

exe_dict = %A_LineFile%\..\..\Portable Softwares\YodaoDict_NoAD_XP85\YodaoDict.exe
exe_ditto32 = %A_LineFile%\..\..\Portable Softwares\Ditto\x86\Ditto.exe
exe_ditto64 = %A_LineFile%\..\..\Portable Softwares\Ditto\x64\Ditto.exe
exe_locate32 = %A_LineFile%\..\..\Portable Softwares\Locate32_cnnnc\locate32.exe
exe_npp = %A_LineFile%\..\..\Portable Softwares\Notepad++\notepad++.exe
; exe_scite = %A_LineFile%\..\..\..\ahk program\SciTE\SciTE.exe
exe_scite = E:\ahk code\AHK Program\SciTE\SciTE.exe
exe_StrokePlus = %A_LineFile%\..\..\Portable Softwares\StrokesPlus_x86\StrokesPlus.exe
exe_SpeedCrunch = %A_LineFile%\..\..\Portable Softwares\SpeedCrunchPortable\SpeedCrunchPortable.exe
exe_qdir = %A_LineFile%\..\..\Portable Softwares\Q-Dir\Q-Dir.exe
exe_snapshot = %A_LineFile%\..\..\Portable Softwares\SnapShot.exe
; exe_video = %A_LineFile%\..\..\Portable Softwares\PotPlayer\PotPlayer\PotPlayerPortable.exe
exe_video = C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe

exe_winmerge1 = %A_LineFile%\..\..\Portable Softwares\WinMergePortable\WinMergePortable.exe
exe_winmerge2 = %A_LineFile%\..\..\Portable Softwares\WinMergePortable\WinMergePortable.exe
exe_winmerge3 = C:\Program Files\WinMerge\WinMergeU.exe
exe_winmerge := exe_winmerge%B_Env%

exe_PDFTools = %A_LineFile%\..\..\Portable Softwares\PDF-ToolsPortable\PDF-ToolsPortable.exe
exe_Edraw = %A_LineFile%\..\..\Portable Softwares\EdrawMindMapPortable\Edraw.exe
exe_Listary = %A_LineFile%\..\..\Portable Softwares\ListaryPortable\Listary.exe
exe_VirtuaWin = %A_LineFile%\..\..\Portable Softwares\VirtuaWinPortable\VirtuaWinPortable.exe
exe_Dsync = %A_LineFile%\..\..\Portable Softwares\DSynchronizePortable\DSynchronizePortable.exe
exe_FreeAlarmClock = %A_LineFile%\..\..\Portable Softwares\FreeAlarmClock\Free Alarm Clock 3.0\FreeAlarmClock.exe

exe_wps1 = %A_LineFile%\..\..\Portable Softwares\KingsoftOfficePortable\KingsoftWriterPortable.exe
exe_wps2 = C:\Users\fatsen\AppData\Local\Kingsoft\WPS Office\10.1.0.6391\office6\wps.exe
exe_wps3 = C:\Users\3885148\AppData\Local\Kingsoft\WPS Office\10.1.0.6930\office6\wps.exe
exe_wps := exe_wps%B_Env%

exe_wpp1 = %A_LineFile%\..\..\Portable Softwares\KingsoftOfficePortable\KingsoftPresentationPortable.exe
exe_wpp2 = C:\Users\fatsen\AppData\Local\Kingsoft\WPS Office\10.1.0.6391\office6\wpp.exe
exe_wpp3 = C:\Users\3885148\AppData\Local\Kingsoft\WPS Office\10.1.0.6930\office6\wpp.exe
exe_wpp := exe_wpp%B_Env%

exe_et1 = %A_LineFile%\..\..\Portable Softwares\KingsoftOfficePortable\KingsoftSpreadsheetsPortable.exe
exe_et2 = C:\Users\fatsen\AppData\Local\Kingsoft\WPS Office\10.1.0.6391\office6\et.exe
exe_et3 = C:\Users\3885148\AppData\Local\Kingsoft\WPS Office\10.1.0.6930\office6\et.exe
exe_et := exe_et%B_Env%
;endregion
;region ---ahk scripts---
ahk_Operations = %A_LineFile%\..\..\Includes\Operations.ahk				;只能写成左侧形式
	; ahk_Operations := %A_LineFile%\..\..\Includes\Operations.ahk		;编译无法通过
	; ahk_Operations := "%A_LineFile%\..\..\Includes\Operations.ahk"	;编译能够通过，但是SnSub_OpenWith(exe_npp, ahk_Operations)无法正常作用
ahk_OperationsIf = %A_LineFile%\..\..\Includes\OperationsIf.ahk
ahk_OperationsIfWinActive = %A_LineFile%\..\..\Includes\OperationsIfWinActive.ahk
ahk_OperationsIfWinExist = %A_LineFile%\..\..\Includes\OperationsIfWinExist.ahk
ahk_OperationsTry = %A_LineFile%\..\..\Includes\OperationsTry.ahk
ahk_Variants = %A_LineFile%\..\..\Includes\Variants.ahk
ahk_StartAuto = %A_LineFile%\..\..\Includes\StartAuto.ahk
ahk_Hotstrings = %A_LineFile%\..\..\Includes\Hotstrings.ahk
ahk_SettingsTray = %A_LineFile%\..\..\Includes\SettingsTray.ahk
ahk_MyWinKill = %A_LineFile%\..\..\Includes\MyWinKill.ahk
ahk_MyClipboard = %A_LineFile%\..\..\Includes\MyClipboard.ahk
ahk_MyWinSet = %A_LineFile%\..\..\Includes\MyWinSet.ahk
ahk_Reload = %A_LineFile%\..\..\Includes\Reload.ahk

ahk_DimMonitor = %A_LineFile%\..\..\Includes\DimMonitor.ahk
ahk_Dim2Monitor = %A_LineFile%\..\..\Includes\Dim2Monitor.ahk
;ahk启动程序
ahk_AntRenamer = %A_LineFile%\..\..\Includes\RunEXE\AntRenamer.ahk
; ahk_StrokePlus = %A_LineFile%\..\..\Includes\RunEXE\StrokePlus.ahk
ahk_Inventor = %A_LineFile%\..\..\Includes\RunEXE\Inventor.ahk
ahk_EBWin = %A_LineFile%\..\..\Includes\RunEXE\EBWin.ahk
ahk_Lingoes = %A_LineFile%\..\..\Includes\RunEXE\Lingoes.ahk
ahk_dict = %A_LineFile%\..\..\Includes\RunEXE\有道.ahk
ahk_QQ = %A_LineFile%\..\..\Includes\RunEXE\QQ.ahk
;ahk启动文件夹
ahk_PortableSoftwares = %A_LineFile%\..\..\Includes\RunDir\Portable Softwares.ahk
;ahk Special
ahk_日语词典查词=%A_LineFile%\..\..\Includes\Special\日语词典查词.ahk
;ahk工具
ahk_WindowMessage = %A_LineFile%\..\..\Tools\WindowMessage.ahk
ahk_EnhancedPaste = %A_LineFile%\..\..\Tools\EnhancedPaste.ahk

ahk_OpenWith = %A_LineFile%\..\..\Lib\SnSub_OpenWith.ahk

ahk_Special = %A_LineFile%\..\..\Special.ahk
ahk_Try = %A_LineFile%\..\..\Try.ahk
ahk_Try2 = %A_LineFile%\..\..\Try2.ahk
;ahk笔记
ahk_memo = %A_ScriptDir%\ToolFiles\memo.ahk
ahk_tip = %A_ScriptDir%\ToolFiles\tip.ahk
ahk_quicknote = %A_ScriptDir%\ToolFiles\quicknote.ahk

;endregion
;region ---vb scripts---
vb_tmp = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp.vb
vb_tmp2 = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp2.vb
vb_tmp3 = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp3.vb
vb_compare1 = %A_LineFile%\..\..\ToolFiles\TempFiles\compare1.vb
vb_compare2 = %A_LineFile%\..\..\ToolFiles\TempFiles\compare2.vb
vb_note = %A_LineFile%\..\..\..\ComputerSkills\VBA\VBNote.vb
;endregion
; py_tmp = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp.py
py_tmp = C:\Users\fatsen\Desktop\tmp.py
;region ---other files---
chm_ahk = %A_LineFile%\..\..\..\ahk program\AutoHotkey.chm
chm_Etymology = %A_LineFile%\..\..\Portable Softwares\etymology dictionary.chm

txt_tmp = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp.txt
txt_tmp2 = %A_LineFile%\..\..\ToolFiles\TempFiles\tmp2.txt
txt_memo = %A_ScriptDir%\ToolFiles\memo.txt
txt_改 = %A_Desktop%\笔记本修改.txt
txt_杂 = %A_LineFile%\..\..\ToolFiles\TempFiles\杂记灵思.txt

cs_CSharp = D:\Coding\C#\cSharpNote.cs
cs_Winform = D:\Coding\C#\Winform.cs

pdf_菜谱 = %A_Desktop%\菜谱.pdf

jpg_菜谱 = %A_Desktop%\菜谱.jpg
png_菜谱 = %A_Desktop%\菜谱.png

doc_memo = F:\作图 相关\not yet\从断面导出的cad图 断面相关 RGW066其他\memo.doc
doc_tool = %A_LineFile%\..\..\ToolFiles\tool.doc

xls_inventorShortcut = F:\软件学习\CAD Inventor快捷键\inventor cad快捷键(已修改).xls
xls_tool = %A_LineFile%\..\..\ToolFiles\tool.xls
xls_nihonn = D:\搜狗高速下载\日语学习\词典Dict\日汉成语谚语词典.xls
xls_VBAStudy = %A_LineFile%\..\..\..\ComputerSkills\VBA\VBAStudy.xls
xls_Regex = %A_LineFile%\..\..\..\ComputerSkills\ComputerSkillsAppendices\0 Regex\NPPAndSciTERegex.xls

xlsx_DrawingSkills = %A_LineFile%\..\..\..\ComputerSkills\InventorCADStudy\InventorCADShortcuts\InventorDrawingSkills.xlsx
xlsx_Everyday1 = %A_LineFile%\..\..\..\Job\EverydayJob.xlsx
xlsx_Everyday2 = %A_LineFile%\..\..\..\Life\EverydayLife.xlsx
xlsx_Everyday3 := xlsx_Everyday1
xlsx_Everyday := xlsx_Everyday%B_Env%
xlsx_ComputerSkills = %A_LineFile%\..\..\..\ComputerSkills\ComputerSkills.xlsx
; xlsx_Tanngo = %A_LineFile%\..\..\..\ComputerSkills\TanngoAndVocabulary.xlsx
xlsx_Vocabulary = %A_LineFile%\..\..\..\ComputerSkills\TanngoAndVocabulary.xlsx
txt_Journal = %A_LineFile%\..\..\..\Job\Journal.txt

ppt_tool = %A_LineFile%\..\..\ToolFiles\tool.ppt
;endregion
;region ;---url---
url_oa = http://oa.ytebara.com.cn/EFNET/
url_HomePage = http://123.sogou.com/

url_Qzone = http://user.qzone.qq.com/582288672
url_ZhongGuoJingQiXianSheng = http://ac.qq.com/Comic/ComicInfo/id/511915
url_鼠绘 = http://www.ishuhui.com/

url_cnki = http://dict.cnki.net/
url_沪江小D = http://dict.hjenglish.com/jp/
url_YahooDict = http://dic.yahoo.co.jp/
url_exciteDict = http://www.excite.co.jp/world/jc_dictionary/

url_Weibo = http://weibo.com/mygroups?gid=3442435823165413&wvr=6&leftnav=1
url_hjclass = http://class.hujiang.com/home
url_EnglishOrigin = http://www.etymonline.com/index.php
url_NHKEasy = http://www3.nhk.or.jp/news/easy/
url_JapDict= http://dict.hjenglish.com/jp/

url_email= http://mail.qq.com/cgi-bin/frame_html?sid = Y0Ovg4YeD7rYe1kN&r=a38386307a51a1549862706afa04da6f

url_usual := ["http://ac.qq.com/Comic/ComicInfo/id/511915", "http://weibo.com/mygroups?gid=3442435823165413&wvr=6&leftnav=1", "http://ac.qq.com/Comic/comicInfo/id/531490", "http://ac.qq.com/Comic/comicInfo/id/546776", "http://ac.qq.com/Comic/comicInfo/id/540149", "http://ac.qq.com/Comic/comicInfo/id/548781", "http://ac.qq.com/Comic/comicInfo/id/532055"]
;endregion
;region ;---无前缀---
non_email1 = %exe_Foxmail%
non_email2 = %url_email%
non_email3 = https://mail.google.com/mail/u/0/#inbox
non_email := non_email%B_Env%

non_japanese1 = %A_LineFile%\..\..\Portable Softwares\Q-Dir\Favourite\z Japanese.qdr
non_japanese2 = E:\日语
non_japanese3:= non_japanese2
non_japanese := non_japanese%B_Env%
;endregion
;=====================================================================
}