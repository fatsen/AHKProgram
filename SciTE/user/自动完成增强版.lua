-- �Զ������ǿ�� v1.4
-- base on AutoComplete v0.8 by Lexikos
-- https://gist.github.com/Lexikos/bc17b8d55ae8a8102e35

-- ������־��
-- 1.4
-- �ϲ����Թ��ܡ�
-- 1.3
-- �����ļ������⹦�ܡ�
-- 1.2
-- �ϲ�fincs��Lexikos����ʽ��
-- 1.1
-- �޸��Ѿ������ļ����½����ĵ�ʱ�Զ���ɹ���ʧЧ�����⡣bug #1
-- 1.0
-- �޸���Lexikos�Ĺؼ��ֿ�ͷ��ȡ�ʳ��Ȳ���ȷ��api�ļ������ڻᱨ���bug��
-- ʵ�������ġ�Ӣ�ģ�Ӧ��Ҳ�����������ĵȣ��ؼ��ֵ���ʾ��
-- ʵ����ʵʱ��ȡ�ؼ��֣�ԭ����ڴ��ļ�ʱ��ȡ���������ʵʱ��ȡ�ؼ��ֵ��������⡣
-- �Ľ����Զ���ɿ����˸���⡣
-- ʵ���˿��ļ��ؼ��ֹ�����Ĭ�Ϲر���������ܡ�
-- luaҲ�����Զ���ɡ�

-- ���Լ����Ľ��ĵط���
-- �Զ���ɿ���ʾ�������ݲ��䣨����������ı仯����ν���������������Ϳ��Բ�ˢ�¡��⽫��һ��������˸���⡣
-- ��������ʵʱ��ȡ�ؼ���Ӧ����ʵʱȫ�ļ����£������������������⡣
-- �Ƚ����Եķ�ʽ��ץȡ�ļ����б��޸ĵĵ��У�Ȼ����д�����Ŀǰ����������
-- ԭ�����Զ���ɿ���ֱ��ƥ�䡰.����ͷ�Ĺؼ��֣�����ֻ�ܼ��ƥ�䡣

-- List of styles per lexer that autocomplete should not occur within.
-- ����������ʽ�б�����ȡ�ؼ��֡����л������Զ�������
local IGNORE_STYLES = { -- Should include comments, strings and errors.
    [SCLEX_AHK1] = {1,2,3,6,20},
    [SCLEX_AHK2] = {1,2,3,5,15},
    [SCLEX_LUA]  = {1,2,3,6,7,8,12}
}

local DEBUG_MODE = false   -- ����ģʽ��
local SHARING_KEYWORDS_BETWEEN_FILES = false   -- ���ļ��ؼ��ֹ�������ͬʱ��A��B�����ļ���A�ļ���ץ���Ĺؼ��֡�haha������B�ļ���Ҳ������ʾ��
local INCREMENTAL = true    -- ���ݹؼ��ֱ仯���ϼ����Զ�����б����ݡ�false���SciTEԭ��һ�£�ֻ�䶯��꣬���ı��б�
local IGNORE_CASE = true    -- �ؼ���ƥ��ʱ���Դ�Сд
local CASE_CORRECT = true   -- �Զ�������Сд
local CASE_CORRECT_INSTANT = false
local WRAP_ARROW_KEYS = false
local CHOOSE_SINGLE = props["autocomplete.choose.single"]

-- Number of chars to type before the autocomplete list appears:
local MIN_PREFIX_LEN = 1    -- �������뼸���ַ��󣬿�ʼƥ���Զ�����б�
-- Length of shortest word to add to the autocomplete list:
local MIN_IDENTIFIER_LEN = 3    -- ��ӵ��Զ�����б�Ĺؼ��ֵ���С���ȣ���Ӱ��ӡ�ahk.api����ӹؼ��ֵĳ��ȣ���
-- List of regex patterns for finding suggestions for the autocomplete menu:
-- ������ʽ�ı��ʣ�����ͨ���ų�ASCII�����ַ���������һ���ַ��顣
-- �ر�ע�⣬������ʽ�Ǹ���editor:findtext()��ʹ�õģ���ô������Ӧ����ѭSciTE�������﷨��
-- ����ʵ�������ǵ��õ�lua������Ĭ�ϴ�Сд�����У���ʹָ����SCFIND_REGEXP������Ҳ��ˣ�����
-- ��˻���Ҫ�ֶ����ϡ�SCFIND_MATCHCASE����������������������������������������������������
-- [^\1-\64\91-\94\96\123-\127] ��ASCII����е��� [a-zA-Z_] ����Ϊʹ�����ų�����ʽ�����Կ���ƥ�䵽���ġ�
-- [^\1-\47\58-\64\91-\94\96\123-\127] ��ASCII����е��� [a-zA-Z0-9_] ����Ϊʹ�����ų�����ʽ�����Կ���ƥ�䵽���ġ�
-- ����������ʽ����˼����{"[a-zA-Z_�������ĺ���][a-zA-Z0-9_�������ĺ���]+"}
-- ��Ҫע����ǣ������SciTE�༭����ʹ��������ʽ����Ҫ��\1�滻Ϊ\x00��
-- ԭ����\0 Ҳ���ǿ��ַ�����lua�������luaʹ��������ʽ�ͱ����\1��ʼ��
-- ��һ����Ҫע��ĵط��ǣ�������ʽ��ͬ��ƥ�䵽���ĵı�㣬���硰�����������ȵȡ�
-- ֮������������ƥ�䵽����ԭ���ǣ�lua��scite����֧��unicode�ַ���ƥ�䣬������Ե���ֻƥ�人�֡�
-- ��һ��ԭ�����ǣ�ʵ�����ڴ����У����ǿ��������ı����Ϊ�������ģ����ϱ��ʽ������Ϊ����ע�͵ȵط�ƥ�䣬���ȷʵ����ƥ�䵽��ȷ�����
-- ����SciTE�༭����Ctrl+Fʹ�õİ汾 {"[^\x00-\x40\x5B-\x5E\x60\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E\x60\x7B-\x7F]+"}
local IDENTIFIER_PATTERNS = {"[^\1-\64\91-\94\96\123-\127][^\1-\47\58-\64\91-\94\96\123-\127]+"}

-- Override settings that interfere with this script:
props["autocomplete.ahk1.start.characters"] = ""
props["autocomplete.ahk2.start.characters"] = ""

-- This feature is very awkward when combined with automatic popups:
props["autocomplete.choose.single"] = "0"


-- �����ִ�Сд�Ļ���normalize������ֱ�Ӵ�дȡ�����ַ���
-- ����д����ַ���Ϊkey�����Ա����ظ���¼��word�� ��Word�������ĵ��ʡ�
local normalize
if IGNORE_CASE then
    normalize = string.upper
else
    normalize = function(word) return word end
end


local shouldIgnorePos -- init'd by buildNames().
local function setLexerSpecificStuff()
    -- Disable collection of words in comments, strings, etc.
    -- Also disables autocomplete popups while typing there.
    if IGNORE_STYLES[editor.Lexer] then
        -- Define a function for calling later:
        shouldIgnorePos = function(pos)
            return isInTable(IGNORE_STYLES[editor.Lexer], editor.StyleAt[pos])
        end
    else
        -- Optional: Disable autocomplete popups for unknown lexers.
        shouldIgnorePos = function(pos) return true end
    end
end


local names = {}
local unique = {}   -- ��unique�־õĴ������ݡ������������unique["key"]=value ��ʽ����ֵ�ģ�����key����Ψһ�ġ�
local function unique2names()
    names = {}
    for _,name in pairs(unique) do
        table.insert(names, name)
    end
    table.sort(names, function(a,b) return normalize(a) < normalize(b) end)
end
local function loadCache()
    names = buffer.namesForAutoComplete
    unique = buffer.uniqueForAutoComplete
end
local function saveCache()
    buffer.namesForAutoComplete = names
    buffer.uniqueForAutoComplete = unique
end
local function buildNamesFromPos(_startPos, _endPos)
    setLexerSpecificStuff()   -- ��ȡ��Ҫ���Ե���ʽ�����꣬��������ע�Ͳ��ֵ����ꡣ
    local startPos, endPos
    endPos = _startPos - 1   -- �޸���Lexikos��bug��������� -1 ����������ץ���Ĺؼ��ֻᱻ��ͷ��msgbox���䡰sgbox����
    -- Collect all words matching the given patterns. ���ݹ�����ȡ�ؼ��֡�
    for i, pattern in ipairs(IDENTIFIER_PATTERNS) do
        while true do
            -- SCFIND_REGEXP ��ʾʹ��������ʽȥƥ�䡣Ĭ�ϴ�Сд�����У������Ҫ�ֶ����ϴ�Сд���еĲ��� SCFIND_MATCHCASE��
            startPos, endPos = editor:findtext(pattern, SCFIND_REGEXP + SCFIND_MATCHCASE, endPos + 1)
            if (not startPos) or (endPos > _endPos) then
                break
            end
            -- ƥ�䵽�����ݲ���ע����
            if not shouldIgnorePos(startPos) then
                if endPos-startPos >= MIN_IDENTIFIER_LEN then   -- �޸���Lexikos��bug��ԭ���ǡ�endPos-startPos+1����
                    -- Create one key-value pair per unique word:
                    local name = editor:textrange(startPos, endPos)
                    if DEBUG_MODE then print("����ȡ���Ĺؼ��֣�"..name) end
                    unique[normalize(name)] = name    -- normalize �ں��Դ�Сд������£�ʵ�����ǰ����е��������һ�飬�Ա����ظ���ӵ��ʡ�
                end
            end
        end
    end
end
local function buildApiNames()  -- �ӡ�ahk.api���͡�user\user.ahk.api���ļ���ȡ�ؼ��֡�
    local apiFiles = props["APIPath"] or ""
    apiFiles:gsub("[^;]+", function(apiFile) -- For each in ;-delimited list. ɾ����;��֮����ַ���Ҳ����ɾ��ֻʣ�ָ�����;���ˡ�
        if FileExists(apiFile) then   -- �ļ������ٽ��в�������Ȼ�ᱨ���Ҳ����ļ���
            for name in io.lines(apiFile) do
                name = name:gsub("[\(, ].*", "") -- Discard parameters/comments. ɾ����(, �������š����š��ո�������ȫ���ַ���
                if string.len(name) > 0 then
                    unique[normalize(name)] = name    -- This also "case-corrects"; e.g. "gui" -> "Gui".
                end
                if string.sub(name, 0, 1) == "." then   -- �ѡ�.MaxIndex��֮�����.���Ĺؼ����ٴ�һ�顰MaxIndex����ʽ�ġ�
                    name = string.sub(name, 2)
                    unique[normalize(name)] = name
                end
            end
        end
    end)
end
local function buildDocNames()
    buildNamesFromPos(0, editor.TextLength)
end
local function buildNames()
    unique = {}
    -- ��API�ļ������ؼ���
    buildApiNames()
    -- �ӵ�ǰ���ļ������ؼ���
    buildDocNames()
    -- ���ؼ���תΪ�Զ�����б�
    unique2names()
end


local notempty = next
local lastAutoCItem = 0 -- Used by handleKey().
local menuItems
local list_old = ""   -- ����ɵ�list��ֵ�����ں��µ�list���Աȣ�û�仯�Ͳ�ˢ���б�������˸��
local function handleChar(char, calledByHotkey)
    -- This function should only run when the Editor pane is focused.
    if not editor.Focus then return false end
    if DEBUG_MODE then print("--------------------") end
    -- ʵ���ϣ������SciTEʱû���κ��ļ����򿪣���ô��ʱOnOpen�¼��ǻᱻ����ġ�
    -- ������ľ����Ѿ������ļ�����ʱ�½��ļ���OnOpen�¼��ֲ��ᱻ���
    -- ��ʱ OnClear() ��Ψһ���ڴ������ļ�ʱ��������¼���
    -- ���Ǽ�����¼�ʱ��buffer��û�б���գ�ֵ����ǰһ���ļ��ġ�
    -- Ҳ����˵��Ψһ�ܹ����ಶ�񴴽����ļ����¼��У�û�����κ��¡�
    -- ���ֻ���ڴ˴���֤�������ؼ����б�bug #1
    if not buffer.namesCache then
        if DEBUG_MODE then print("OnNewFile_no_cache|   endpos:"..editor.TextLength) end
        -- Otherwise, build a new list.
        buildNames()
        saveCache()
        buffer.namesCache = true
    end
    if not INCREMENTAL and editor:AutoCActive() then
        -- Nothing to do.
        return false
    end

    -- ��ģʽ��������ǡ����ؼ����ڻ��к�ͱ�ʵʱ������ͬʱ�ֲ�����Ϊÿ�θ��¹ؼ��ֶ���ȫ�ĸ��¶�����������⡣
    -- ȱ�����������������ʵ�����ǻ�ȡ�ļ����б��޸ĵ��У�Ȼ����ȡ��Щ�еĹؼ��֡�
    -- ��Ŀǰ����������ȡ���˻س�����һ�У��⵱Ȼ�����˴󲿷ִ��뱻�޸ĵ����������Ȼ�޸�ĳ�к������ߵ����û���������ڡ�
    if char == "\n" then
        -- ��ȡ���»س�ʱ�����е���β���ꡣ
        local line_num = editor:LineFromPosition(editor.CurrentPos)
        local line_start = editor:PositionFromLine(line_num-1)
        local line_end = editor.LineEndPosition[line_num-1]
        -- �����Ǹ���unique�����Բ�Ҫȥ���unique��
        buildNamesFromPos(line_start, line_end)
        unique2names()
        saveCache()
        -- �Զ�����
        local prevStyle = editor.StyleAt[getPrevLinePos()]
        if not isInTable(IGNORE_STYLES[editor.Lexer], prevStyle) then
            return AutoIndent_OnNewLine()   -- fincsԭ��������õ�return��
        end
    elseif char == "{" then
        local curStyle = editor.StyleAt[editor.CurrentPos-2]
        if not isInTable(IGNORE_STYLES[editor.Lexer], curStyle) then
            AutoIndent_OnOpeningBrace()
        end
    elseif char == "}" then
        local curStyle = editor.StyleAt[editor.CurrentPos-2]
        if not isInTable(IGNORE_STYLES[editor.Lexer], curStyle) then
            AutoIndent_OnClosingBrace()
        end
    end

    local pos = editor.CurrentPos
    local startPos = editor:WordStartPosition(pos, true)
    local len = pos - startPos
    if len < MIN_PREFIX_LEN then
        if editor:AutoCActive() then
            if len == 0 then
            if DEBUG_MODE then print(1) end
                -- Happens sometimes after typing ")".
                editor:AutoCCancel()
                return
            end
            -- Otherwise, autocomplete is already showing so may as well
            -- keep it updated even though len < MIN_PREFIX_LEN.
        else
            if char then
            if DEBUG_MODE then print(2) end
                -- Not enough text to trigger autocomplete, so return.
                return
            end
            -- Otherwise, we were called explicitly without a param.
        end
    end
    if not editor:AutoCActive() then
    if DEBUG_MODE then print(3) end
        -- �����Զ���ɿ���ͨ�������������� ��;{enter}����;{tab}��ȫ������ȷ�ʽ��ɡ�
        -- Ϊ�˱���bugҲΪ�˱��⵽��ȥ���list_old�����ͳһ��ֻҪû���Զ���ɿ�ʱ����վɱ�����
        list_old = ""
        if shouldIgnorePos(startPos) and not calledByHotkey then
        -- User is typing in a comment or string, so don't automatically
        -- pop up the auto-complete window.
            return
        end
    end
    local prefix = normalize(editor:textrange(startPos, pos))
    menuItems = {}
    for i, name in ipairs(names) do
        local s = normalize(string.sub(name, 1, len))
        -- �����ַ���ʼ�����Զ���ɿ��ˡ�
        -- �ַ����ǿ��ԱȽϴ�С�ģ���ABC���Ǵ��ڡ�ABB���ġ�
        -- ���������롰ms��ʱ��names�ᱻ������ֱ����Multi��ʱͣ�£���Ϊ��names�У�Multi����MsgBox����һ���ؼ��֡�
        -- ֮����Ҫ����һ���ؼ��ֵĵط�ͣ�£�����Ϊ�б������������Ϊ��������ȡ���С�gui����ͷ�Ĺؼ��֣���ô�͵��ڡ�guj��ͣ�¡�
        if s >= prefix then   -- ���ڵ����õú��������ʱ ����ؼ���ƥ�䣬����ʱ ����ƥ�����ˣ�����������
            if s == prefix then
                table.insert(menuItems, name)   -- �����Ѿ�������ƥ��Ĺؼ���ȫ������menuItems�ˡ�
            else
                break -- There will be no more matches.
            end
        end
    end
    if DEBUG_MODE then print("3.1|ƥ���б�"..table.concat(menuItems, "\1")) end
    if notempty(menuItems) then
    if DEBUG_MODE then print(4) end
        -- Show or update the auto-complete list.
        local list = table.concat(menuItems, "\1")
        editor.AutoCIgnoreCase = IGNORE_CASE
        editor.AutoCCaseInsensitiveBehaviour = 1 -- Do NOT pre-select a case-sensitive match
        editor.AutoCSeparator = 1
        editor.AutoCMaxHeight = 5
        -- if not editor:AutoCActive() then   -- ��һ�ֽ�����˸�ķ�ʽ����SciTEԭ��һ����ֻҪ�Զ���ɿ�����ˣ���ֻ��תλ�ö���ˢ�¡�
        if list~=list_old then    -- �����Զ���ɿ����˸��ֻ��ƥ��Ĺؼ��ַ����仯ʱ��ˢ�¡�
        if DEBUG_MODE then print(5) end
            editor:AutoCShow(len, list)
            list_old=list
        end
        -- Check if we should auto-auto-complete.
        if normalize(menuItems[1]) == prefix and not calledByHotkey then
            -- User has completely typed the only item, so cancel.
            if CASE_CORRECT then
                if CASE_CORRECT_INSTANT or #menuItems == 1 then
                if DEBUG_MODE then print(6) end
                    -- Make sure the correct item is selected.
                    editor:AutoCShow(len, menuItems[1])
                    editor:AutoCComplete()
                end
                if #menuItems > 1 then
                if DEBUG_MODE then print(7) end
                    editor:AutoCShow(len, list)
                end
            end
            if #menuItems == 1 then
            if DEBUG_MODE then print(8) end
                editor:AutoCCancel()
                return
            end
        end
        lastAutoCItem = #menuItems - 1
        if lastAutoCItem == 0 and calledByHotkey and CHOOSE_SINGLE then
        if DEBUG_MODE then print(9) end
            editor:AutoCComplete()
        end
    else
        -- No relevant items.
        if editor:AutoCActive() then
        if DEBUG_MODE then print(10) end
            editor:AutoCCancel()
        end
    end
    -- ��������OnChar�����������������������Ĺؼ�����ʾ����ϡ�
    return true
end


local function handleKey(key, shift, ctrl, alt)
    if key == 0x20 and ctrl and not (shift or alt) then -- ^Space
        handleChar(nil, true)
        return true
    end
    if alt or not editor:AutoCActive() then return end
    if key == 0x8 then -- VK_BACK
        if not ctrl then
            -- Need to handle it here rather than relying on the default
            -- processing, which would occur after handleChar() returns:
            editor:DeleteBack()
            handleChar()
            return true
        end
    elseif key == 0x25 then -- VK_LEFT
        if not shift then
            if ctrl then
                editor:WordLeft() -- See VK_BACK for comments.
            else
                editor:CharLeft() -- See VK_BACK for comments.
            end
            handleChar()
            return true
        end
    elseif key == 0x26 then -- VK_UP
        if editor.AutoCCurrent == 0 then
            -- User pressed UP when already at the top of the list.
            if WRAP_ARROW_KEYS then
                -- Select the last item.
                editor:AutoCSelect(menuItems[#menuItems])
                return true
            end
            -- Cancel the list and let the caret move up.
            editor:AutoCCancel()
        end
    elseif key == 0x28 then -- VK_DOWN
        if editor.AutoCCurrent == lastAutoCItem then
            -- User pressed DOWN when already at the bottom of the list.
            if WRAP_ARROW_KEYS then
                -- Select the first item.
                editor:AutoCSelect(menuItems[1])
                return true
            end
            -- Cancel the list and let the caret move down.
            editor:AutoCCancel()
        end
    elseif key == 0x5A and ctrl then -- ^z
        editor:AutoCCancel()
    end
end


local function checkCodepage()
    if props['FileExt']=="ahk" then
        if editor.CodePage ~= 65001 then
            local FileNameExt = props['FileNameExt']
            -- 3.5.6��ʼ��֧��editor:EncodedFromUTF8()����
            -- editor:EncodedFromUTF8(FileNameExt)
            -- print("ע�⣺��ǰ�ļ� "..FileNameExt.." ���벻�ǡ�UTF-8��BOM����\nAHK���������Ϊ����ı���������Է��ֵ� Bug��\nͬʱ��ҲӰ��TillaGoto����ת���Զ������ǿ������Ĺؼ��ֵ�֧�֡�\n����ǿ�ҽ����㽫�ļ�����ת��Ϊ��UTF-8��BOM����")
            print("ע�⣺��ǰ�ļ����벻�ǡ�UTF-8��BOM����\nAHK���������Ϊ����ı���������Է��ֵ� Bug��ͬʱ��ҲӰ�� TillaGoto ����ת���Զ������ǿ������Ĺؼ��ֵ�֧�֡�\n����ǿ�ҽ����㽫�ļ�����ת��Ϊ��UTF-8��BOM����")
        end
    end
end


-- Event handlers
local events = {
    OnChar          = handleChar,
    OnKey           = handleKey,
    OnSwitchFile    = function()
        -- ��ͬ�ļ���bufferֵ��Ψһ�ģ���������������Ӧ�ļ��Ĺؼ��֡�
        if not buffer.namesCache then
            -- �򿪻��л�һ���ļ�ʱ���������¼�˳����OnOpen��OnSwitchFile��
            -- ������SciTEʱ���Ѿ�����һ��lua�ļ�����ô�¼��������˳�����OnSwitchFile��OnOpen��
            -- ����OnSwitchFile�ȱ������ʱeditor.TextLength��ֵ�ͻ���0��
            -- ���Դ�ʱbuildNames()�޷������ȷ�����
            -- �����Ҫ��������OnOpen�¼����ٴ���
            if editor.TextLength > 0 then
                if DEBUG_MODE then print("OnSwitchFile_no_cache|   endpos:"..editor.TextLength) end
                -- Otherwise, build a new list.
                buildNames()
                saveCache()
                buffer.namesCache = true
            end
        else
            if DEBUG_MODE then print("OnSwitchFile_have_cache|   endpos:"..editor.TextLength) end
            loadCache()
        end
    end,
    OnOpen          = function()
        -- Ensure the document is styled first, so we can filter out
        -- words in comments and strings.
        editor:Colourise(0, editor.Length)
        -- Then do the real work.
        checkCodepage()
        if not buffer.namesCache then
            if DEBUG_MODE then print("OnOpen_no_cache|   endpos:"..editor.TextLength) end
            -- Otherwise, build a new list.
            buildNames()
            saveCache()
            buffer.namesCache = true
        else
            if DEBUG_MODE then print("OnOpen_have_cache|   endpos:"..editor.TextLength) end
            loadCache()
        end
    end
}
-- Add event handlers in a cooperative fashion:
for evt, func in pairs(events) do
    local oldfunc = _G[evt]
    if oldfunc then
        _G[evt] = function(...) return func(...) or oldfunc(...) end
    else
        _G[evt] = func
    end
end
