// build@ gcc -g -shared -I$(PYDIR)\include $(FileNameExt) -L$(PYDIR)\libs -lpython25 -o $(FileName).pyd
// build@ python setup.py build
#include "Python.h"

PyObject *f_add(PyObject *self, PyObject *args)
{
    PyObject *result = NULL;
    long a, b;

    if (PyArg_ParseTuple(args, "ii", &a, &b)) {
      result = Py_BuildValue("i", a + b);
    }
    return result;
}

PyMethodDef methods[] = {
  {"add", f_add, METH_VARARGS},
  {NULL, NULL}
};

void initadd()
{
    Py_InitModule("add", methods);
}
