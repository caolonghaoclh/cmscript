cmake_minimum_required(VERSION 3.0)
project(cmscript VERSION "2.0.0")

# include the entry file
include(${CMAKE_SOURCE_DIR}/cmake/entry.cmake)

# import all necessary files
bm_import(${CMAKE_SOURCE_DIR})

# execute scripts for test
bm_script_test()

bm_start()

bm_configure()

install(FILES "cmake/${PROJECT_NAME}.cmake" DESTINATION ${CMAKE_ROOT}/Modules)

bm_finish()
