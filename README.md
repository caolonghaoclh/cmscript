# cmscript
this program is an open-source, cross-platform pakcage whitch consists of some cmake scripts frequently used. 'cmscript' is the abbreviation of "cmake script". It is designed to avoid writing simple cmake script repeatedly.
## Introduction
this package not contains any c++/c source file, For installing, you just need execute the commend "cmake ..&& sudo make install". after that, the cmake configuration files will be generated in the current folder of project.
## Specific Description
* cmake/test this folder in which we can store individual test files is unimportant. however you can write temporary scripts to verify the scripts issued. you can invoke 'bm_script_test()' to make it effective.
* cmscript.cmake contains independent scripts which are widely used.
* cmscript.cmake.in the template for generating configuration file such as 'Findcmscript.cmake'.
* previous.cmake contains previous commands and configurations in the build process.
* globalScript.cmake consists global scripts apply to this package.  
* init.cmake initialization operations after previous.cmake.
* entry.cmake understand this as the logical entry.
* msvc.cmake characteristic configurations for msvc compiler
* packages.cmake find package
* set.cmake 
* target.cmake 
* thirdlib.cmake 
