
# base make target
function(bmt_build_components lib_shared)
    bm_boundary("bmt_build_components" ON OFF)
    message("${MSG_PRE} lib_shared(${lib_shared}) components(${ARGN})")
    foreach(comp ${ARGN})
        # define name
        set(TAG_NAME "${PROJECT_NAME}_${comp}")
        file(GLOB SRCS "src/${comp}/*.cpp")
        # create target
        if(lib_shared)
            add_library(${TAG_NAME} SHARED ${SRCS})
        else()
            add_library(${TAG_NAME} STATIC ${SRCS})
        endif()
        # target alias
        add_library(${comp} ALIAS ${TAG_NAME})
        # compile definitions
        if(lib_shared AND BM_SYSTEM_IS_WIN)
            target_compile_definitions(${TAG_NAME} PRIVATE
                "${UP_PROJECT_NAME}_BUILD_DLL"
                "${UP_PROJECT_NAME}_EXPORT_LIB")
        endif()
        # compile_options
        target_compile_options(${TAG_NAME} PUBLIC
        	$<$<CXX_COMPILER_ID:MSVC>:/Zc:__cplusplus>
        	$<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-fPIC>)

        # if(BM_SYSTEM_IS_LINUX)
        # solution 1
        # add_definitions("-fPIC")
        # solution 2
        # target_compile_options(${TAG_NAME} PRIVATE -fPIC)
        # solution 3
        # set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fPIC")
        # set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
        # set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fPIC")
        # set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
        # solution 4
        # set_property(TARGET ${TAG_NAME} PROPERTY POSITION_INDEPENDENT_CODE ON)
        # endif()

        # include directories
        if(DEFINED ${TAG_NAME}_INCLUDE_DIRS)
        #    target_include_directories(${TAG_NAME} PUBLIC ${${TAG_NAME}_INCLUDE_DIRS})
        #    message("${MSG_PRE} target(${TAG_NAME}) include dirs: ${${TAG_NAME}_INCLUDE_DIRS}")
          target_include_directories(${TAG_NAME}
            PUBLIC
              $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
              $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
              ${${TAG_NAME}_INCLUDE_DIRS}
            PRIVATE
              $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
              ${${TAG_NAME}_INCLUDE_DIRS})
        else()
          target_include_directories(${TAG_NAME}
            PUBLIC
              $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
              $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
            PRIVATE
              $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>)
        endif()

        # link directories
        if(DEFINED ${TAG_NAME}_LIBRARY_DIRS)
            target_link_directories(${TAG_NAME} PUBLIC ${${TAG_NAME}_LIBRARY_DIRS})
            message("${MSG_PRE} target(${TAG_NAME}) library dirs: ${${TAG_NAME}_LIBRARY_DIRS}")
        endif()
        # link libraries
        if(DEFINED ${TAG_NAME}_EXT_LIBRARIES OR DEFINED ${TAG_NAME}_INT_LIBRARIES)
            if(BM_SYSTEM_IS_LINUX)
                target_link_libraries(${TAG_NAME} PUBLIC
                    -Wl,--start-group
                    ${${TAG_NAME}_EXT_LIBRARIES}
                    ${${TAG_NAME}_INT_LIBRARIES}
                    -Wl,--end-group)
            else()
                target_link_libraries(${TAG_NAME} PUBLIC
                    ${${TAG_NAME}_EXT_LIBRARIES}
                    ${${TAG_NAME}_INT_LIBRARIES})
            endif()
            if(DEFINED ${TAG_NAME}_INT_LIBRARIES)
                add_dependencies(${TAG_NAME} ${${TAG_NAME}_INT_LIBRARIES})
            endif()
            message("${MSG_PRE} target(${TAG_NAME}) extern libraries: ${${TAG_NAME}_EXT_LIBRARIES}")
            message("${MSG_PRE} target(${TAG_NAME}) internal libraries: ${${TAG_NAME}_INT_LIBRARIES}")
        endif()

        if(DEFINED CMAKE_DEBUG_POSTFIX AND NOT ("" STREQUAL "${CMAKE_DEBUG_POSTFIX}"))
          set_target_properties(${TAG_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
        endif()

        if(NOT ("" STREQUAL "${${UP_PROJECT_NAME}_VERSION}"))
          set_target_properties(${TAG_NAME} PROPERTIES VERSION ${${UP_PROJECT_NAME}_VERSION} SOVERSION ${${UP_PROJECT_NAME}_VERSION_MAJOR})
        endif()

        unset(SRCS)
        unset(TAG_NAME)
    endforeach()
    bm_boundary("bmt_build_components" OFF OFF)
endfunction()

macro(bmt_cxx_standard tag_name ver)
    bm_boundary("bmt_cxx_standard" ON OFF)
    message("${MSG_PRE} target(${tag_name}) cxx version(${ver})")
    if("14" STREQUAL "${ver}")
        target_compile_options(${tag_name} PRIVATE
            $<$<CXX_COMPILER_ID:Clang>:-std=c++14>
            $<$<CXX_COMPILER_ID:GNU>:-std=c++14>
            $<$<CXX_COMPILER_ID:MSVC>:/std:c++14>)
    elseif("17" STREQUAL "${ver}")
        target_compile_options(${tag_name} PRIVATE
            $<$<CXX_COMPILER_ID:Clang>:-std=c++17>
            $<$<CXX_COMPILER_ID:GNU>:-std=c++17>
            $<$<CXX_COMPILER_ID:MSVC>:/std:c++17>)
    elseif("20" STREQUAL "${ver}")
        ## version 3
        if(BM_SUPPORT_CXX20)
            message("${MSG_PRE} target(${tag_name}) BM_FLAG_CXX20(${BM_FLAG_CXX20})")
            target_compile_options(${tag_name} PRIVATE ${BM_FLAG_CXX20})
        endif()
        ## version 2
        #if("Clang" STREQUAL "${CXX_COMPILER_ID}")
        #    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "10.0.0")
        #        target_compile_options(${tag_name} PRIVATE -std=c++20)
        #    else()
        #        target_compile_options(${tag_name} PRIVATE -std=c++2a)
        #    endif()
        #elseif("GNU" STREQUAL "${CXX_COMPILER_ID}")
        #    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "10.0.0")
        #        target_compile_options(${tag_name} PRIVATE -std=c++20)
        #    else()
        #        target_compile_options(${tag_name} PRIVATE -std=c++2a)
        #    endif()
        #elseif("MSVC" STREQUAL "${CXX_COMPILER_ID}")
        #    target_compile_options(${tag_name} PRIVATE /std:c++latest)
        #endif()

        ## version 1
        #target_compile_options(${tag_name} PRIVATE
        #    $<$<CXX_COMPILER_ID:Clang>:-std=c++20>
        #    $<$<CXX_COMPILER_ID:GNU>:-std=c++2a>
        #    $<$<CXX_COMPILER_ID:MSVC>:/std:c++latest>)
    else()
        message(FATAL_ERROR "cxx standard error :${tag_name} ${ver}")
    endif()
    bm_boundary("bmt_cxx_standard" OFF OFF)
endmacro()

macro(bmt_c_standard tag_name ver)
    bm_boundary("bmt_c_standard" ON OFF)
    message("${MSG_PRE} target(${tag_name}) c version(${ver})")
    if("11" STREQUAL "${ver}")
        target_compile_options(${tag_name} PRIVATE
            $<$<CXX_COMPILER_ID:Clang>:-std=c11>
            $<$<CXX_COMPILER_ID:GNU>:-std=c11>
            $<$<CXX_COMPILER_ID:MSVC>:/std:c11>)
    elseif("17" STREQUAL "${ver}")
        target_compile_options(${tag_name} PRIVATE
            $<$<CXX_COMPILER_ID:Clang>:-std=c17>
            $<$<CXX_COMPILER_ID:GNU>:-std=c17>
            $<$<CXX_COMPILER_ID:MSVC>:/std:c17>)
    else()
        message(FATAL_ERROR "c standard error :${tag_name} ${ver}")
    endif()
    bm_boundary("bmt_cxx_standard" OFF OFF)
endmacro()

macro(bmt_find_comp pro_name comp_name)
  bm_boundary("bmt_find_comp" ON OFF)
	message("${MSG_PRE} pro_name(${pro_name}) comp_name(${comp_name}) int_comps(${ARGN})")
	if("${pro_name}" STREQUAL "")
		message(WARNING "${MSG_PRE} pro_name is empty")
	elseif("${comp_name}" STREQUAL "")
		message(WARNING "${MSG_PRE} comp_name is empty")
	else()
		if(NOT DEFINED ${pro_name}_${comp_name}_FOUND OR NOT ${pro_name}_${comp_name}_FOUND)
			if(NOT DEFINED ${pro_name}_${comp_name}_FOUND)
				set(${pro_name}_${comp_name}_FOUND OFF)
			endif()
			if(NOT "${ARGN}" STREQUAL "")
            set(${pro_name}_${comp_name}_INT_COMPS ${ARGN})
            foreach(comp ${ARGN})
              list(APPEND ${pro_name}_${comp_name}_INT_TARGETS ${pro_name}::${comp})
              list(APPEND ${pro_name}_${comp_name}_INT_LIBRARIES ${pro_name}_${comp})
            endforeach()
            message("${MSG_PRE} INT_COMPS: ${${pro_name}_${comp_name}_INT_COMPS}")
        else()
          message("${MSG_PRE} ${pro_name}_${comp_name} has no internal components dependency")
        endif()
    else()
      message("${MSG_PRE} FOUND RES: ${${pro_name}_${comp_name}_FOUND}")
		endif()
	endif()
	bm_boundary("bmt_find_comp" OFF OFF)
endmacro()

macro(bmg_install)
    # install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
    bmf_dir_exist("${${PROJECT_NAME}_INCLUDE_DIR}" "inc_dir_exist")
    if(inc_dir_exist)
      file(GLOB COMM_HEADS "${${PROJECT_NAME}_INCLUDE_DIR}/*.h" "${${PROJECT_NAME}_INCLUDE_DIR}/*.hpp")
      install(FILES ${COMM_HEADS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/${${PROJECT_NAME}_INCLUDE_DIR_REL})
    else()
      message(WARNING "include dir(${PROJECT_NAME}_INCLUDE_DIR) not exist ${${PROJECT_NAME}_INCLUDE_DIR}")
    endif()
    
    set(TP_EXPORT_TARGETS "")
    foreach(comp ${ARGN})
        if(inc_dir_exist)
			INSTALL(DIRECTORY ${${PROJECT_NAME}_INCLUDE_DIR}/${comp}/
				DESTINATION ${CMAKE_INSTALL_PREFIX}/${${PROJECT_NAME}_INCLUDE_DIR_REL}/${comp})
        endif()
        list(APPEND TP_EXPORT_TARGETS ${PROJECT_NAME}_${comp})
    endforeach()
    if(NOT ("" STREQUAL "${TP_EXPORT_TARGETS}"))
        INSTALL(TARGETS ${TP_EXPORT_TARGETS}
          EXPORT TP_EXPORT
          LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
          ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
          RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
          
        INSTALL(EXPORT TP_EXPORT
          DESTINATION ${${PROJECT_NAME}_CFG_DIR}
          NAMESPACE ${PROJECT_NAME}::
          FILE ${${PROJECT_NAME}_CFG_FILE_TARGETS})

        write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE_VERSION}" COMPATIBILITY SameMajorVersion)
        
        INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE_VERSION}" DESTINATION "${${PROJECT_NAME}_CFG_DIR}")
    endif()
    unset(TP_EXPORT)
    unset(TP_EXPORT_TARGETS)
    unset(inc_dir_exist)
endmacro()
