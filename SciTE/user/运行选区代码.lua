-- �˺����������pipe������ahk����ѡ������
function GetSelText_IfSelNotEmpty()
	local AHK=props["AutoHotkey"].." /CP65001 "
				AHK=string.gsub(AHK,"\\","\/")		-- б����Ҫת��һ��
	local selText=editor:GetSelText()
	local checkEmpty=string.gsub(selText, "%s", "")
	local empty=[[
								MsgBox, û���κδ��뱻ѡ��!
								ExitApp
							]]
	if checkEmpty=="" then
		os.execute(AHK..empty)		-- ������Ҫ��pipe���β���
	else
		os.execute(AHK..selText)
	end
end