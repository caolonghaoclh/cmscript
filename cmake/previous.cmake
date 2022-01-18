set(BM_SYSTEM_IS_WIN OFF)
set(BM_SYSTEM_IS_LINUX OFF)
set(BM_SYSTEM_IS_FREEBSD OFF)

set(BM_COMPILER_IS_GNU OFF)
set(BM_COMPILER_IS_CLANG OFF)
set(BM_COMPILER_IS_INTEL OFF)
set(BM_COMPILER_IS_MSVC OFF)

# set(BM_DEFAULT_BUILD_TYPE "Release")
set(BM_DEFAULT_BUILD_TYPE "Debug")

include(CMakePackageConfigHelpers)
include(CMakeParseArguments)
include(GNUInstallDirs)
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

enable_language(C)
enable_language(CXX)

set(CMAKE_CXX_EXTENSIONS OFF)
if(CMAKE_SYSTEM_NAME MATCHES "CYGWIN" OR CMAKE_SYSTEM_NAME MATCHES "MSYS")
	# enable compiler extension
	set(CMAKE_CXX_EXTENSIONS ON)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(BM_SYSTEM_IS_LINUX ON)
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(BM_SYSTEM_IS_WIN ON)
elseif (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    set(BM_SYSTEM_IS_FREEBSD ON)
endif()

bm_set()

bm_judge_cxx_compiler()

#if(BM_COMPILER_IS_GNU)
#	set(CMAKE_THREAD_LIBS_INIT "-lpthread")
#	set(CMAKE_HAVE_THREADS_LIBRARY 1)
#	set(CMAKE_USE_WIN32_THREADS_INIT 0)
#	set(CMAKE_USE_PTHREADS_INIT 1)
#	set(THREADS_PREFER_PTHREAD_FLAG ON)
#endif()

bm_check_cxx()

bm_check_cxx20()

bm_get_compiler_version()

bm_check_coroutine()

if(BM_COMPILER_IS_GNU OR BM_COMPILER_IS_CLANG)
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

if(BM_COMPILER_IS_MSVC)
    # msvc global config
    add_definitions(-DNOMINMAX)
    add_definitions(-DUNICODE -D_UNICODE)
    add_definitions(/W3 /wd4996 /wd4995 /wd4355)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS)
endif()

bm_boundary("MAKE ECHO")
message("${MSG_PRE} CMAKE_ROOT is ${CMAKE_ROOT}")
bm_boundary()
