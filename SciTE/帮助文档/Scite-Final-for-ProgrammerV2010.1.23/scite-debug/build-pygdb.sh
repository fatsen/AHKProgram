set PYINC=/usr/include/python2.4
cd tests
gcc -g -shared -fPIC $PYINC add.c -o add.so
cd ..
cd pgdb
gcc -g -shared -fPIC $PYINC pdbgl.c -o pdbgl.so
cd ..


