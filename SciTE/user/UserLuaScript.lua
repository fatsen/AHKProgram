-- UserLuaScript.lua
-- =================

-- This file contains user-defined Lua functions
-- You are encouraged to add your own custom functions here!
-- sunwind��1576157���Ѽ�����
-- event OnClear ��������½��ļ�ʱĬ�ϵ��ļ�����
local oldOnClear = OnClear
function OnClear()
  if oldOnClear ~= nil then
     if oldOnClear() then
         return true
     end
  end
  if props['FileName'] == "" then
--~       �½�ʱĬ�ϲ���UTF-8��BOM���뷽ʽ
       scite.MenuCommand(IDM_ENCODING_UTF8)
--~       �½�ʱĬ�ϲ���UTF-8��BOM���뷽ʽ
--~       scite.MenuCommand(IDM_ENCODING_UCOOKIE)
  end
  return false;
end

--~ �Զ����() {} [ ]  " "  %% ' '��
--~ local toClose = { ['('] = ')', ['{'] = '}', ['['] = ']', ['"'] = '"', ["'"] = "'" , ["%"] = "%" }
--~ function OnChar(charAdded)
--~     if toClose[charAdded] ~= nil then
--~        editor:InsertText(editor.CurrentPos,toClose[charAdded])
--~     end
--~ end