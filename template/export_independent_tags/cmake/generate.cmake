# this file can only be used on building stage

function(template_add_dependencies TAG_NAME)
    if("" STREQUAL "${TAG_NAME}")
        return()
    endif()

    list(LENGTH ${PROJECT_NAME}_${TAG_NAME}_DEPENDENCIES DEPENDENCIES_LENGTH)

    if("0" STREQUAL "${DEPENDENCIES_LENGTH}")
	    message("${TAG_NAME} has no dependencies")
    else()
	    add_dependencies(${TAG_NAME} ${${PROJECT_NAME}_${TAG_NAME}_DEPENDENCIES})
    endif()
endfunction()

macro(template_generate_library TAG_NAME SHARED)
    list(LENGTH ARGN SRCS_LEN)
    if(${SRCS_LEN} STRGREATER "0")
      list(APPEND TAG_SRCS ${ARGN})
    else()
      file(GLOB TAG_SRCS "*.cpp" "*.c")
    endif()

    if("OFF" STREQUAL "${SHARED}")
      add_library(${TAG_NAME} STATIC ${TAG_SRCS})
    else()
      add_library(${TAG_NAME} SHARED ${TAG_SRCS})
    endif()

    template_config_target(${TAG_NAME})

    target_include_directories(${TAG_NAME}
        PUBLIC
 	        ${${PROJECT_NAME}_${TAG_NAME}_INCLUDE_DIRS}
 	        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include/>
 	        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        PRIVATE
 	        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>)
    # message("generate ${TAG_NAME} ${${PROJECT_NAME}_${TAG_NAME}_INCLUDE_DIRS}")

    target_link_directories(${TAG_NAME} PUBLIC
        ${${PROJECT_NAME}_${TAG_NAME}_LIBRARY_DIRS})

    if(MSVC)
        target_link_libraries(${TAG_NAME} PUBLIC
            ${${PROJECT_NAME}_${TAG_NAME}_LIBRARIES}
            ${${PROJECT_NAME}_${TAG_NAME}_COMPONENTS})

 	    target_compile_definitions(${TAG_NAME} PRIVATE
 		    ${UP_PROJECT_NAME}_BUILD_DLL
 		    ${UP_PROJECT_NAME}_EXPORT_LIB
 		    _CRT_SECURE_NO_WARNINGS)
    else()
        target_link_libraries(${TAG_NAME} PUBLIC
             -Wl,--start-group
            ${${PROJECT_NAME}_${TAG_NAME}_LIBRARIES}
            ${${PROJECT_NAME}_${TAG_NAME}_COMPONENTS}
             -Wl,--end-group)
    endif()

    target_compile_options(${TAG_NAME} PRIVATE
 	    $<$<CXX_COMPILER_ID:MSVC>:/Zc:__cplusplus>
 	    $<$<NOT:$<C_COMPILER_ID:MSVC>>:-fPIC>
        $<$<CXX_COMPILER_ID:Clang>:-std=c++14>
        $<$<CXX_COMPILER_ID:GNU>:-std=c++14>
        $<$<CXX_COMPILER_ID:MSVC>:/std:c++14>)

    set_target_properties(${TAG_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
    set_target_properties(${TAG_NAME} PROPERTIES VERSION ${${PROJECT_NAME}_VERSION} SOVERSION ${${PROJECT_NAME}_VERSION_MAJOR})
endmacro()
