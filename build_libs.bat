::copy microui\src\microui.h microui.h
::copy microui\src\microui.c microui.c

clang -c -g -gcodeview -o microui-windows.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall microui\src\microui.c

mkdir libs
move microui-windows.lib libs

::del microui.h
::del microui.c