// build@ gcc -g -shared -I$(PYDIR)\include $(FileNameExt) -L$(PYDIR)\libs -lpython25 -o $(FileName).pyd
// build@ python setup.py build
#include "Python.h"

PyObject *f_break(PyObject *self, PyObject *args)
{
    return Py_BuildValue("i",0);
}

PyObject *f_addr(PyObject *self, PyObject *args)
{
    PyObject *obj;
    PyCFunction fun;
    const char* res;
    char buff[80];
    if (PyArg_ParseTuple(args,"O",&obj)) {
        if (! PyCFunction_Check(obj)) {
            res = "<not a function>";
        } else {
            fun = PyCFunction_GetFunction(obj);
            sprintf(buff,"0x%X",(unsigned int)fun);
            res = buff;
        }
        return Py_BuildValue("s",res);
    } else
        return NULL; // error: throws an exceptionj
}

PyMethodDef methods[] = {
  {"addr", f_addr, METH_VARARGS},
  {"debug_break",f_break,METH_VARARGS},
  {NULL, NULL}
};

void initpdbgl()
{
    Py_InitModule("pdbgl", methods);
}
