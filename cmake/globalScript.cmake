# the scripts in this file belong to the internal bm system
# 
# 
# 

macro(bm_set)
    string(TOUPPER "${CMAKE_CXX_COMPILER_ID}" UP_CXX_COMPILER_ID)
	# my script test directory
    set(DIR_SCRIPT_TEST "${CMAKE_SOURCE_DIR}/cmake/test")
endmacro()

macro(bm_unset)
    unset(SCRIPT_TEST)
    unset(DIR_SCRIPT_TEST)
    unset(UP_BUILD_TYPE)
    unset(UP_PROJECT_NAME)
    unset(UP_CXX_COMPILER_ID)
    unset(${PROJECT_NAME}_CFG_MODE)
    unset(${PROJECT_NAME}_CFG_FILE)
    unset(${PROJECT_NAME}_CFG_FILE_IN)
    unset(${PROJECT_NAME}_CFG_DIR)
    unset(${PROJECT_NAME}_CFG_FILE_TARGETS)
    unset(${PROJECT_NAME}_CFG_FILE_VERSION)
    unset(${PROJECT_NAME}_VERSION_FILE)
endmacro()

macro(bm_finish)
    bm_unset()
endmacro()

macro(bm_build_type)
    bm_boundary("bm_build_type")
	
	if(NOT DEFINED CMAKE_BUILD_TYPE OR "" STREQUAL "${CMAKE_BUILD_TYPE}")
		set(CMAKE_BUILD_TYPE ${BM_DEFAULT_BUILD_TYPE})
	endif()
	
	string(TOUPPER "${CMAKE_BUILD_TYPE}" UP_BUILD_TYPE)

	set(BM_BUILD_DEBUG OFF)
	set(BM_BUILD_RELEASE OFF)
	if("DEBUG" STREQUAL "${UP_BUILD_TYPE}")
		set(BM_BUILD_DEBUG ON)
	elseif("RELEASE" STREQUAL "${UP_BUILD_TYPE}")
		set(BM_BUILD_RELEASE ON)
	else()
		set(BM_BUILD_NONE ON)
	endif()
	
    if("" STREQUAL "${CMAKE_BUILD_TYPE}")
        set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install)
	else()
		 set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install/${CMAKE_BUILD_TYPE})
    endif()
	
	# the directory which deposits cmake config file of current project
    set(${PROJECT_NAME}_CFG_DIR "${CMAKE_INSTALL_PREFIX}/lib/cmake")
	# the cmake targets config file name of current project
    set(${PROJECT_NAME}_CFG_FILE_TARGETS "${PROJECT_NAME}Targets.cmake")
	# the cmake version config file name of current project
    set(${PROJECT_NAME}_CFG_FILE_VERSION "${PROJECT_NAME}Version.cmake")
	
	if(BM_BUILD_DEBUG AND DEFINED CMAKE_DEBUG_POSTFIX)
		set(${PROJECT_NAME}_LIB_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
        message("${MSG_PRE} set ${PROJECT_NAME}_LIB_POSTFIX = ${${PROJECT_NAME}_LIB_POSTFIX}")
	endif()
	
    if(MSVC)
        if(BM_BUILD_DEBUG)
            add_definitions(-DITERATOR_DEBUG_LEVEL=2)
        elseif(BM_BUILD_DEBUG)
            add_definitions(-DITERATOR_DEBUG_LEVEL=0)
        endif()
    endif()
	
    message("${MSG_PRE} build type: ${CMAKE_BUILD_TYPE}")
    message("${MSG_PRE} install prefix : ${CMAKE_INSTALL_PREFIX}")
    bm_boundary()
endmacro()

macro(bm_script_test)
    bm_boundary("bm_script_test")
    if(DEFINED SCRIPT_TEST AND NOT ("${SCRIPT_TEST}" STREQUAL ""))
        set(PATH_SCRIPT_TEST "${DIR_SCRIPT_TEST}/${SCRIPT_TEST}.cmake")
	    if(NOT EXISTS PATH_SCRIPT_TEST)
		    message(WARNING "${MSG_PRE} test file not exist: ${PATH_SCRIPT_TEST}")
	    else()
		    include(${PATH_SCRIPT_TEST})
            message("${MSG_PRE} test script file is: ${PATH_SCRIPT_TEST}")
	    endif()
	    unset(PATH_SCRIPT_TEST)
    else()
        message("${MSG_PRE} not test script file")
    endif()
    bm_boundary()
endmacro()

macro(bm_configure)
    bm_boundary("bm_configure")
    message("${MSG_PRE} use find mode: ${ARGV0}")
    bmf_string2_bool("${ARGV0}" "USE_FIND_MODE" ON)

	set(${PROJECT_NAME}_CFG_FILE_IN "${PROJECT_NAME}.cmake.in")
	set(TP_FILE_CFG_IN "${CMAKE_SOURCE_DIR}/cmake/${${PROJECT_NAME}_CFG_FILE_IN}")
	
	message("${MSG_PRE} config file template: ${TP_FILE_CFG_IN}")
	
    if(NOT EXISTS ${TP_FILE_CFG_IN})
        message(FATAL_ERROR "${MSG_PRE} config file not exists")
	else()
		if(USE_FIND_MODE)
			set(${PROJECT_NAME}_CFG_MODE ON)
			set(${PROJECT_NAME}_CFG_FILE "Find${PROJECT_NAME}.cmake")
		else()
			set(${PROJECT_NAME}_CFG_MODE OFF)
			bms_pro_dir()
			set(${PROJECT_NAME}_CFG_FILE "${PROJECT_NAME}Config.cmake")
		endif()
		set(TP_FILE_CFG_OUT "${${PROJECT_NAME}_CFG_DIR}/${${PROJECT_NAME}_CFG_FILE}")
		file(MAKE_DIRECTORY "${${PROJECT_NAME}_CFG_DIR}/")
		message("${MSG_PRE} config file install: ${TP_FILE_CFG_OUT}")
		configure_file(
			"${TP_FILE_CFG_IN}"
			"${TP_FILE_CFG_OUT}"
			@ONLY)
		
		if(USE_FIND_MODE)
			install(FILES ${TP_FILE_CFG_OUT} DESTINATION ${CMAKE_ROOT}/Modules)
		endif()
    endif()
	
	unset(USE_FIND_MODE)
	unset(TP_FILE_CFG_IN)
	unset(TP_FILE_CFG_OUT)
    bm_boundary()
endmacro()