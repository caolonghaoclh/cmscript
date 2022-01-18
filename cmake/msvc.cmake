# modify msvc runtime library
# ARGV0 the new runtime library (required)
# ARGV1 the runtime library be replaced (optional)
# msvc default runtime library is /MD
# if want modify global runtime library can use CMAKE_USER_MAKE_RULES_OVERRIDE
# can not use defined to judge ARGV0
macro(bmvc_modify_runtime_library)
    message("macro [bmvc_modify_runtime_library] arg num(${ARGC}) new flag(${ARGV0}) old flag(${ARGV1})")
    if("" STREQUAL "${ARGV0}")
        message(FATAL_ERROR "please set the new msvc runtime library")
    endif()
    set(FLAG_ORG "/MD")
    set(FLAG_NEW ${ARGV0})
    if("" STREQUAL "${ARGV1}")
        message("the msvc runtime library which will be replaced is /MD")
    else()
        set(FLAG_ORG ${ARGV1})
    endif()

    SET(CCXX_FLAGS
        CMAKE_C_FLAGS 
        CMAKE_C_FLAGS_DEBUG 
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_MINSIZEREL 
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS 
        CMAKE_CXX_FLAGS_DEBUG 
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL 
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
    )

    # ${flag} express variable,${${var}} express the string value of variable
    foreach(flag ${CCXX_FLAGS})
        if(${flag} MATCHES "${FLAG_ORG}")
            string(REGEX REPLACE "${FLAG_ORG}" "${FLAG_NEW}" ${flag} "${${flag}}")
        endif()
    endforeach()
    unset(CCXX_FLAGS)
    message("macro [bmvc_modify_runtime_library] end")
endmacro()

macro(bmvc_ignore_default_lib tag_name)
    bm_boundary("bmvc_ignore_default_lib")
    message("${MSG_PRE} tag_name(${tag_name}) ignore_libs(${ARGN})")
    if(NOT ("" STREQUAL "${tag_name}") AND NOT ("" STREQUAL "${ARGN}"))
        foreach(ign_lib ${ARGN})
            set_property(TARGET ${tag_name} APPEND PROPERTY LINK_FLAGS "/NODEFAULTLIB:${ign_lib}")
        endforeach()
    endif()
    bm_boundary()
endmacro()
