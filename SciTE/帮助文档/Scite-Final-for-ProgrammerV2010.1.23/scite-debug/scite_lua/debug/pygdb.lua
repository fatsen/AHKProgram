-- GDB-style interface for Python
scite_require 'gdb.lua'
local find = string.find
local match = string.match

local GTK = scite_GetProp('PLAT_GTK')

-- the convention with cli debug is that all Windows filenames are lowercase!
local function canonical(file)
    if not GTK then file = file:lower() end
    return file
end

local function fpath(file)
    return canonical(fullpath(file))
end

function slashify(s)
    return s:gsub('\\','\\\\')
end

-- note: other extensions possible here?
local function file_is_python (file)
    return extension_of(file) == 'py'
end

local info_line_success = '^Line %d+ of'
local info_line_error = '^No line number information available'

function info_line_handler(line,dbg)
    local success = line:find(info_line_success)
    if success then -- we can set a temporary breakpoint
        spawner_command('tbreak *'..dbg.addr)
        dbg.addresses[dbg.addr] = true     
    end
    -- either way, we want to get out of GDB mode at the earliest opportunity!
    spawner_command('continue')
end

PGdb = class(Gdb)

-- this allows scite-debug to discriminate between regular Python debugger and hosted pgdb.
function PGdb.discriminator(target)
    return find(target,'^:pgdb') == 1
end

function PGdb:init (root)
    Gdb.init(self,root)
    self.root = root
    self.target_dir = canonical(props['FileDir'])
    self.no_target_ext = false
    
    self.gpdb_path = join(extman_Path(),'pgdb'):gsub('\\','/')
    self.gpdb_debugger = self.gpdb_path..'/gpdb.py'
    
    self.skip_system_extension = ".py"	
    self.deferred_stack = {}
    
    self.postprocess_command['info line'] = {pattern=info_line_success,
        action=info_line_handler, alt_pat=info_line_error}
    
    self.addresses = {}
    self.mode = 'gdb'
    
    -- GDB likes forward slashes, on both platforms...
    local dbgl_file = self.gpdb_path.."/pdbgl.c"
    
    -- this is a persistent event handler which monitors every program break,
    -- and keeps track of whether we are in GDB or gpdb. Will raise
    -- the events 'gdb' and 'py' accordingly.
    self:set_event('break',function(file,line)
        local new_mode
        local lf = file_is_python(file)
        -- don't respond to any breaks in pdbgl.c
        if not lf and file == dbgl_file then
            return true,true
        end
        if self.mode ~= 'py' and lf then
            new_mode = 'py'
        end
        if self.mode == 'py' and not lf then
            new_mode = 'gdb'
        end
        if new_mode then
            self.mode = new_mode
            self:raise_event(new_mode)
        end
        return true
    end)
    
end

function PGdb:check_breakpoint (b)
    return not file_is_python(b.file)
end

function PGdb:parameter_string ()
    local parms = Gdb.parameter_string(self)
    -- if the target isn't Python, then we assume it's a program that has embedded Python and that
    --  there's an explicit gpdb initialization somewhere in a user Python script.
    if self.not_python then
        cmdline = ''    
    else
        cmdline = '-i ' .. self.gpdb_debugger .. ' -G ' .. self.python_target
    end
    print('*',cmdline)
    return cmdline..' '..parms
end

function PGdb:command_line(target)
    local gtarget,ltarget = target:match('^:pgdb;([^;]+);(.*)')
    self.python_target = ltarget
    local idx = gtarget:find('%[h%]$')
    if idx then
        gtarget = gtarget:sub(1,idx-1)
        self.not_python = true
    end
    --- we are going to embed a PDB session inside a GDB session, so it's
    --- necessary to explicitly create the .pdbrc file. This folows the 
    --- sequence in create_existing_breakpoints() in debugger.lua
    local lua_cmd = join(self.root,'.pdbrc')
    local out = io.open(lua_cmd,'w')
    for b in Breakpoints() do
        if file_is_python(b.file) then
            out:write('break '..canonical(b.file)..':'..b.line..'\n')
        end
    end
    out:close()
    return  Gdb.command_line(self,gtarget)
end

-- need to put at least one breakpoint into the system, so that we can drop into
-- gdb mode when necessary.  Under Windows, you definitely do not want a separate
-- console window, since we want to capture the result of running gpdb inside GDB.
function PGdb:special_debugger_setup(out)
    Gdb.special_debugger_setup(self,out)
    if not GTK then
        out:write('set new-console off\n')
    end
    out:write('directory ',slashify(self.gpdb_path),'\n')
    -- gpdb will use this break to get us into gdb
    out:write('break pdbgl.c:7\n')    
end

function PGdb:set_breakpoint(file,lno)
    local lf = file_is_python(file)
    -- gpdb works best with absolute paths
    if lf then file = fullpath(file) end
    -- if we are in the wrong mode, then the actual setting of a breakpoint
    -- needs to happen when we next switch to the correct mode.
    if (self.mode == 'py') ~= lf then
        local function set_break ()
            Gdb.set_breakpoint(self,file,lno)
        end        
        if self.mode == 'py' then
            --spawner_command('debugbreak') ???
            self:set_event('break',set_break)
            self:queue_command 'continue'
        else
            self:set_event('py',set_break)
        end
    else
        Gdb.set_breakpoint(self,file,lno)
    end
end

function PGdb:find_execution_break(line)
    local _,_,file,lineno = find(line,self.break_line)
    if _ and file ~= '<string>' then -- a little hack necessary....
        return file,lineno
    else
        -- gpdb emits this pattern when Python is entering a C function (see line 29)
        -- we have to check whether this function has any debug symbols
        -- before trying to step into it. 
        local addr = match(line,'/@//(.+)')
        if addr then
            self.addr = strip_eol(addr)
            -- at this point, we have entered GDB at debug_break (forced by gpdb)
            local cached = self.addresses[self.addr]
            if cached == nil then
                -- haven't met this function before; check for line info.
                -- info_line_handler() above will process the output...
                self:set_event('break',function()                    
                    dbg_command('info line','*'..self.addr)                    
                end)                        
            elseif cached == true then
                --we know this function has line numbers defined
                self:set_event('break',function()
                    self:queue_command('tbreak *'..self.addr)
                    self:queue_command('continue')
                end)
            end
            return ''-- that is, don't dump this line!
        end
        if  find(line,'^Breakpoint %d+, f_break %(') then
            return ''
        end
    end
end

register_debugger('pgdb','py',PGdb)
