# cmscript
this is an open-source, cross-platform library.&nbsp;it basically consists of cmake scripts which are frequently used.</br> the name 'cmscript' is the abbreviation of "cmake script" which is designed to avoid coding simple cmake </br> scripts repeatedly when i need to make a new project.
## Caution
the methods i want to express are suitable for the people who knows the basical knowledge of cmake syntax
## Introduction
this package not includes any c++/c source file, For installing it, you just need execute the command </br> "cmake ..&& sudo make install" at terminal.&nbsp;then the cmake configuration files are generated automatically </br>
under the root folder.&nbsp;specially the file Findcmscript.cmake is copied to the path recorded by the expression </br> "${CMAKE_ROOT}/Modules".
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
