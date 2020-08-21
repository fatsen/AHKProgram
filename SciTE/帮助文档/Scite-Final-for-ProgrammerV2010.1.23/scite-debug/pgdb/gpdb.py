# A modified main pdb debugger loop (see pdb.py in the Python library!)
# The idea here is to present a GDB-compatible interface; we also
# override trace_dispatch because we are interested in calls to C functions.

from pdb import *
from bdb import *
import sys,os,traceback
import pdbgl

kount = 1
addresses = {}

class Gpdb(Pdb):
    
    # GDB compatible output!
    def do_p(self,arg):
        global kount
        val = repr(self._getval(arg))
        try:
            print >>self.stdout, "$%r = %s" % (kount,val)
            kount = kount + 1
        except:
            pass
    do_print = do_p
    
    # it turns out that 'c_call' is NEVER passed to the usual trace function,
    # but it will be passed to a profile function. We make sure that we don't
    # take any action until the debugger is up and running, and override set_quit
    # so that we can remove the profiler later.
    #
    # The trick here is to print out the actual address of the C function in
    # a distinct form for the front-end, and then call debug_break where the
    # front-end has previously set a pending breakpoint. This allows the
    # front-end to ask GDB for a temporary breakpoint for that function!
    def profile_dispatch(self, frame, event, arg):
        global addresses
        if event == 'c_call' and not self._wait_for_mainpyfile and self.stopframe == None:
            addr = pdbgl.addr(arg)
            if not addresses.has_key(addr):
                addr = '/@//' + addr
                print >>self.stdout,addr
                pdbgl.debug_break()
            else:
                addresses[addr] = True
        return self.profile_dispatch        
        
    def set_quit(self):
        Bdb.set_quit(self)
        sys.setprofile(None)
        
    def format_file_line(self,frame,lineno):
        filename = self.canonic(frame.f_code.co_filename)
        # GDB is particular about this!
        filename = filename.replace('\\','/')
        return '%s:%r' % (filename, lineno)

    def format_stack_entry(self, frame_lineno, lprefix=''):
        import repr
        frame, lineno = frame_lineno        
        if frame.f_code.co_name:
            s = frame.f_code.co_name
        else:
            s = "<lambda>"
        if '__args__' in frame.f_locals:
            args = frame.f_locals['__args__']
        else:
            args = None
        if args:
            s = s + repr.repr(args)
        else:
            s = s + '()'
        if '__return__' in frame.f_locals:
            rv = frame.f_locals['__return__']
            s = s + '->'
            s = s + repr.repr(rv)
        return s + ' at ' + self.format_file_line(frame,lineno)
    
    # Emacs is particular about this format; scite-debug is more relaxed.
    def print_stack_entry(self, frame_lineno, prompt_prefix=''):
        frame, lineno = frame_lineno
        print >>self.stdout,'\x1A\x1A' + self.format_file_line(frame,lineno) + ':beg:0x000000'
        
    # this prints a GDB semi-compatible stack trace, in the opposite order to pdb's.
    def print_stack_trace(self):
        try:
            i = 0
            stack = self.stack[:]
            stack.reverse()
            for frame_lineno in stack:
                print >>self.stdout,'#%r %s' % (i,self.format_stack_entry(frame_lineno))
                i = i + 1
        except KeyboardInterrupt:
            pass

    def do_frame(self, arg):
        idx = int(arg)
        if idx >= len(self.stack):
            print >>self.stdout, '*** No such frame'
        else:
            idx = len(self.stack) - idx - 1  # relative to our _reversed_ stack, see above!
            self.curindex = idx
            self.curframe = self.stack[self.curindex][0]
            self.print_stack_entry(self.stack[self.curindex])
            self.lineno = None
    do_f = do_frame

def main():
    gprompt = False
    if sys.argv[1] == '-G':
        gprompt = True
        del sys.argv[1]
    mainpyfile =  sys.argv[1]     # Get script filename
    if not os.path.exists(mainpyfile):
        print 'Error:', mainpyfile, 'does not exist'
        sys.exit(1)

    del sys.argv[0]         # Hide "pdb.py" from argument list
    # Replace pdb's dir with script's dir in front of module search path.
    sys.path[0] = os.path.dirname(mainpyfile)

    pdb = Gpdb()
    if gprompt:
        pdb.prompt = '(GDB)\n'
    else:
        pdb.prompt = '(pdb) '
    # not an infinite loop!
    try:
        # looking for c_call events with the profiler
        sys.setprofile(pdb.profile_dispatch)
        pdb._runscript(mainpyfile)
        if pdb._user_requested_quit:
            return
        print "The program finished and will not be restarted"
    except SystemExit:
        # In most cases SystemExit does not warrant a post-mortem session.
        print "The program exited via sys.exit(). Exit status: ",
        print sys.exc_info()[1]
    except:
        traceback.print_exc()
        print "Uncaught exception. Entering post mortem debugging"
        t = sys.exc_info()[2]
        while t.tb_next is not None:
            t = t.tb_next
        pdb.interaction(t.tb_frame,t)


# When invoked as main program, invoke the debugger on a script
if __name__=='__main__':
    main()
    # under Windows, we need to run Python w/ the -i flag; this ensures that we die!
    sys.exit(0)

