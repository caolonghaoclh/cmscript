
if(NOT LASTools_FOUND)
    FIND_PATH(LASTools_INCLUDE_DIRS NAMES LASlib/laszip.hpp PATHS
        ${LASTools_PATH}/include
        $ENV{LASTools_PATH}/include
        /usr/local/include
        /usr/include)
    if(MSVC)
        FIND_PATH(LASTools_LIBRARY_DIRS NAMES LASlib.lib PATHS
            ${LASTools_PATH}/lib/LASlib/Debug
            $ENV{LASTools_PATH}/lib/LASlib/Debug)
        set(LASTools_LIBRARIES LASlib.lib)
    else()
        FIND_PATH(LASTools_LIBRARY_DIRS NAMES libLASlib.a PATHS
            ${LASTools_PATH}/lib/LASlib
            $ENV{LASTools_PATH}/lib/LASlib
            ${LASTools_PATH}/lib/LASlib/Debug
            $ENV{LASTools_PATH}/lib/LASlib/Debug
            /usr/local/lib
            /usr/lib)
        set(LASTools_LIBRARIES libLASlib.a)
    endif()
    if(LASTools_INCLUDE_DIRS AND LASTools_LIBRARY_DIRS)
        set(LASTools_FOUND ON)
    else()
        message(WARNING "cmake has not find LASTools")
    endif()
endif()
