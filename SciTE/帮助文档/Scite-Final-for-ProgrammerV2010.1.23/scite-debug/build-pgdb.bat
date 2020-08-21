rem change PYPATH to your Python directory; quote if it has spaces!
set PYPATH=C:\Python26
set PYINC=-I%PYPATH%\include
set PYLIB=-L%PYPATH%\libs -lpython26
cd tests
gcc -g -shared %PYINC% add.c %PYLIB% -o add.pyd
cd ..
cd pgdb
gcc -g -shared %PYINC% pdbgl.c %PYLIB% -o pdbgl.pyd
cd ..
