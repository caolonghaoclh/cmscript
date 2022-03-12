cmake_minimum_required(VERSION 3.5)
# define the project name
set(LIB_NAME "template")
set(${LIB_NAME}_VERSION_MAJOR 1)
set(${LIB_NAME}_VERSION_MINOR 0)
set(${LIB_NAME}_VERSION_PATCH 1)
set(${LIB_NAME}_VERSION "${${LIB_NAME}_VERSION_MAJOR}.${${LIB_NAME}_VERSION_MINOR}.${${LIB_NAME}_VERSION_PATCH}")

project(${LIB_NAME} VERSION ${${LIB_NAME}_VERSION} LANGUAGES CXX C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_DEBUG_POSTFIX _d)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install/${CMAKE_BUILD_TYPE}")

set(DIR_CMAKE_INSTALL "${CMAKE_INSTALL_PREFIX}/lib/cmake")
set(FILE_CMAKE_PROJECT "Find${PROJECT_NAME}.cmake")
set(FILE_CMAKE_TARGETS "${PROJECT_NAME}Targets.cmake")
set(FILE_CMAKE_VERSION "${PROJECT_NAME}Version.cmake")

option(USE_SPDLOG "" FALSE)
option(WITH_CORE "" TRUE)
option(BUILD_EXAMPLE "" FALSE)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
	option(USE_PERFTOOLS "Enable profiler of google-perftools" TRUE)
endif()

if(USE_SPDLOG)
	add_definitions(-DTEMPLATE_USE_SPDLOG)
	set(TEMPLATE_USE_SPDLOG ON)
	list(APPEND TEMPLATE_USE_FLAGS "TEMPLATE_USE_SPDLOG")
endif()

if(USE_PERFTOOLS)
	add_definitions(-Dtemplate_USE_PERFTOOLS)
	set(TEMPLATE_USE_PERFTOOLS ON)
	list(APPEND TEMPLATE_USE_FLAGS "TEMPLATE_USE_PERFTOOLS")
endif()

include(CMakePackageConfigHelpers)
include(CMakeDependentOption)
include(CheckCCompilerFlag)
include(GNUInstallDirs)

string(TOUPPER ${PROJECT_NAME} UP_PROJECT_NAME)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake/Modules)

include(cmake/config.cmake)
include(cmake/generate.cmake)

# define a global string variable to record the targets which will be exported
bmg_export_tags_define(${PROJECT_NAME})

template_config_global()

include_directories(include)

add_subdirectory(src/common)
add_subdirectory(src/io)
add_subdirectory(src/core)

if(WITH_CORE)
	add_subdirectory(src/core)
endif()
if(BUILD_EXAMPLE)
	add_subdirectory(example)
endif()

# fetch the global variable
bmg_export_tags_fetch(${PROJECT_NAME})

# print the global variable, the variable has been transformed to a list variable
message("EXPORT_TAGS  ===>  ${${PROJECT_NAME}_EXPORT_TAGS}")

foreach(TAG ${${PROJECT_NAME}_EXPORT_TAGS})
	set_target_properties(${TAG} PROPERTIES FOLDER MODULES)
endforeach()

INSTALL(DIRECTORY ${CMAKE_SOURCE_DIR}/include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

INSTALL(TARGETS ${${PROJECT_NAME}_EXPORT_TAGS}
	EXPORT export_${PROJECT_NAME}
	LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
	ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
	RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

INSTALL(EXPORT export_${PROJECT_NAME} DESTINATION ${DIR_CMAKE_INSTALL} NAMESPACE ${PROJECT_NAME}:: FILE ${FILE_CMAKE_TARGETS})

configure_file(
	"${CMAKE_SOURCE_DIR}/cmake/${PROJECT_NAME}.cmake.in"
	"${DIR_CMAKE_INSTALL}/${FILE_CMAKE_PROJECT}"
	@ONLY)

INSTALL(FILES ${DIR_CMAKE_INSTALL}/${FILE_CMAKE_PROJECT} DESTINATION ${CMAKE_ROOT}/Modules)

write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/${FILE_CMAKE_VERSION}" COMPATIBILITY SameMajorVersion)

INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/${FILE_CMAKE_VERSION}" DESTINATION "${DIR_CMAKE_INSTALL}")
