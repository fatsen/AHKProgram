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
--  �½�ʱĬ�ϲ���UTF-8��BOM���뷽ʽ
    scite.MenuCommand(IDM_ENCODING_UTF8)
--  �½�ʱĬ�ϲ���UTF-8��BOM���뷽ʽ
--  scite.MenuCommand(IDM_ENCODING_UCOOKIE)
  end
  return false;
end