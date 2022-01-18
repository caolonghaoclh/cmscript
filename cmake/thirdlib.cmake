# find eclipse-paho-mqtt-c support cross platform 
macro(bmp_find_paho_mqtt_c LIB_SUFFIX STR_USE_SSL STR_LIB_SHARED)
	bm_boundary("bmp_find_paho_mqtt_c" ON OFF)
	message("${MSG_PRE} LIB_SUFFIX(${LIB_SUFFIX}) USE_SSL(${STR_USE_SSL}) LIB_SHARED(${STR_LIB_SHARED})")
	
	if(NOT eclipse-paho-mqtt-c_FOUND)
		bmf_string2_bool("${STR_USE_SSL}" "FP_USE_SSL" OFF)
		bmf_string2_bool("${STR_LIB_SHARED}" "FP_LIB_SHARED" OFF)
		
		if(FP_USE_SSL)
			find_package(OpenSSL REQUIRED)
		endif()

		if(BM_SYSTEM_IS_LINUX)
			# can not use "-" to define linux env var
			set(eclipse-paho-mqtt-c_DIR $ENV{eclipse_paho_mqtt_c_DIR})
		else()
			set(eclipse-paho-mqtt-c_DIR $ENV{eclipse-paho-mqtt-c_DIR})
		endif()

		find_package(eclipse-paho-mqtt-c)

		if(NOT DEFINED eclipse-paho-mqtt-c_LIBRARIES)
			set(eclipse-paho-mqtt-c_LIBRARIES "")
		endif()
		if(NOT DEFINED eclipse-paho-mqtt-c_INCLUDE_DIRS)
			set(eclipse-paho-mqtt-c_INCLUDE_DIRS "")
		endif()
		if(NOT DEFINED eclipse-paho-mqtt-c_LIBRARY_DIRS)
			set(eclipse-paho-mqtt-c_LIBRARY_DIRS "")
		endif()

		if(BM_SYSTEM_IS_LINUX)
			if(FP_LIB_SHARED)
				list(APPEND eclipse-paho-mqtt-c_LIBRARIES "libpaho-mqtt3${LIB_SUFFIX}.so")
			else()
				list(APPEND eclipse-paho-mqtt-c_LIBRARIES "libpaho-mqtt3${LIB_SUFFIX}.a")
			endif()
			list(APPEND eclipse-paho-mqtt-c_LIBRARY_DIRS "${eclipse-paho-mqtt-c_DIR}/../..")
			list(APPEND eclipse-paho-mqtt-c_INCLUDE_DIRS "${eclipse-paho-mqtt-c_DIR}/../../../include")
		else()
			if(FP_LIB_SHARED)
				set(PAHO_TAG_NAME "eclipse-paho-mqtt-c::paho-mqtt3${LIB_SUFFIX}")
			else()
				set(PAHO_TAG_NAME "eclipse-paho-mqtt-c::paho-mqtt3${LIB_SUFFIX}-static")
			endif()
			list(APPEND eclipse-paho-mqtt-c_LIBRARIES ${PAHO_TAG_NAME})
			if(FP_USE_SSL)
				list(APPEND eclipse-paho-mqtt-c_LIBRARIES OpenSSL::SSL OpenSSL::Crypto)
			endif()
		endif()

		set(eclipse-paho-mqtt-c_FOUND ON)

		message("${MSG_PRE} eclipse-paho-mqtt-c_LIBRARIES     ===>  ${eclipse-paho-mqtt-c_LIBRARIES}")
		message("${MSG_PRE} eclipse-paho-mqtt-c_INCLUDE_DIRS  ===>  ${eclipse-paho-mqtt-c_INCLUDE_DIRS}")
		message("${MSG_PRE} eclipse-paho-mqtt-c_LIBRARY_DIRS  ===>  ${eclipse-paho-mqtt-c_LIBRARY_DIRS}")
		
		unset(PAHO_TAG_NAME)
		unset(FP_USE_SSL)
		unset(FP_LIB_SHARED)
	else()
		message("${MSG_PRE} has FOUND this package")
	endif()
	bm_boundary("bmp_find_paho_mqtt_c" OFF OFF)
endmacro()

macro(bmp_find_openmp)
	bm_boundary("bmp_find_openmp" ON OFF)
	if(NOT OPENMP_FOUND)
		find_package(OpenMP)
		if(NOT OPENMP_FOUND)
			message(WARNING "${MSG_PRE} not found openmp")
		else()
			message("${MSG_PRE} has found openmp")
			message("${MSG_PRE} OpenMP_C_FLAGS          ${OpenMP_C_FLAGS}")
			message("${MSG_PRE} OpenMP_CXX_FLAGS        ${OpenMP_CXX_FLAGS}")
			message("${MSG_PRE} OpenMP_C_LIB_NAMES      ${OpenMP_C_LIB_NAMES}")
			message("${MSG_PRE} OpenMP_CXX_LIB_NAMES    ${OpenMP_CXX_LIB_NAMES}")
			message("${MSG_PRE} OpenMP_C_LIBRARIES      ${OpenMP_C_LIBRARIES}")
			message("${MSG_PRE} OpenMP_CXX_LIBRARIES    ${OpenMP_CXX_LIBRARIES}")
			message("${MSG_PRE} OpenMP_C_VERSION        ${OpenMP_C_VERSION}")
			message("${MSG_PRE} OpenMP_CXX_VERSION      ${OpenMP_CXX_VERSION}")
			#target_link_libraries(${TARGET_NAME} PRIVATE OpenMP::OpenMP_CXX)
			#target_link_libraries(${TARGET_NAME} PRIVATE OpenMP::OpenMP_C)
			#target_link_libraries(${TARGET_NAME} PUBLIC OpenMP::OpenMP_CXX)
			#target_link_libraries(${TARGET_NAME} PUBLIC OpenMP::OpenMP_C)
		endif()
	endif()
	bm_boundary("bmp_find_openmp" OFF OFF)
endmacro()

macro(bmp_find_libuv is_shared)
	bm_boundary("bmp_find_libuv" ON OFF)
	bmf_string2_bool("${is_shared}" "libuv_SHARED" ON)
	if(NOT libuv_FOUND AND DEFINED ENV{libuv_DIR})
		if(BM_SYSTEM_IS_WIN)
			if(libuv_SHARED)
				set(libuv_LIBRARIES uv)
			else()
				set(libuv_LIBRARIES uv_a)
			endif()
			set(libuv_LIBRARY_DIRS $ENV{libuv_DIR}/lib/${build_type})
		else()
			if(libuv_SHARED)
				set(libuv_LIBRARIES libuv.so)
			else()
				set(libuv_LIBRARIES libuv_a.a)
			endif()
			set(libuv_LIBRARY_DIRS $ENV{libuv_DIR}/lib64 $ENV{libuv_DIR}/lib)
		endif()
		set(libuv_INCLUDE_DIRS $ENV{libuv_DIR}/include)
		set(libuv_FOUND ON)
	endif()
	bm_boundary("bmp_find_libuv" OFF OFF)
endmacro()


# find openssl in windows
# shared - is use dynamic library (optional,ON/OFF)
# vc - is use VC library (optional,ON/OFF)
# ARGV2 - vc library type(optional,one of "MT" "MTd" "MD" "MDd")
function(bmp_find_openssl_win shared vc)
	if(NOT DEFINED ENV{OpenSSL_PATH})
		message(FATAL_ERROR "please set environment variable OpenSSL_PATH ")
	else()
	
		set(OpenSSL_INCLUDE_DIRS $ENV{OpenSSL_PATH}/include PARENT_SCOPE)
	
		if(NOT DEFINED vc OR NOT vc)
		# default not use vc library
			if(NOT DEFINED shared OR shared)
			# default use  dynamic library
				set(OpenSSL_LIBRARY_DIRS $ENV{OpenSSL_PATH}/lib PARENT_SCOPE)
				set(OpenSSL_LIBRARIES libcrypto.lib libssl.lib PARENT_SCOPE)
			else()
				set(OpenSSL_LIBRARY_DIRS $ENV{OpenSSL_PATH}/lib PARENT_SCOPE)
				set(OpenSSL_LIBRARIES libcrypto_static.lib libssl_static.lib PARENT_SCOPE)
			endif()
		elseif(NOT DEFINED ARGV2 OR "" STREQUAL "${ARGV2}")
			message(FATAL_ERROR "please set vc library type")
		else()
			set(has_match OFF)
			set(vc_lib_type "MT" "MTd" "MD" "MDd")

			foreach(type_str ${vc_lib_type})
				if("${ARGV2}" STREQUAL "${type_str}")
					if(NOT has_match)
						set(has_match ON)
					endif()
				endif()
			endforeach()

			if(has_match)
				if(NOT DEFINED shared OR shared)
					set(OpenSSL_LIBRARY_DIRS $ENV{OpenSSL_PATH}/lib/VC PARENT_SCOPE)
					set(OpenSSL_LIBRARIES libcrypto64${ARGV2}.lib libssl64${ARGV2}.lib PARENT_SCOPE)
				else()
					set(OpenSSL_LIBRARY_DIRS $ENV{OpenSSL_PATH}/lib/VC/static PARENT_SCOPE)
					set(OpenSSL_LIBRARIES libcrypto64${ARGV2}.lib libssl64${ARGV2}.lib PARENT_SCOPE)
				endif()
			else()
				message(FATAL_ERROR "param lib_type must in  ${vc_lib_type}")
			endif()

			unset(has_match)
			unset(vc_lib_type)
		endif()
	endif()
endfunction()

macro(bmp_find_laslib)
	if(NOT DEFINED ENV{LASlib_DIR})
		message(FATAL_ERROR "please set environment variable LASlib_DIR ")
	else()
		set(LASlib_DIR $ENV{LASlib_DIR})
		if(WIN32)
			set(LASlib_LIBRARIES LASlib.lib)
			set(LASlib_INCLUDE_DIRS $ENV{LASlib_DIR}/include/LASlib)
			set(LASlib_LIBRARY_DIRS $ENV{LASlib_DIR}/lib/LASlib/Release)
		else()
			set(LASlib_LIBRARIES libLASlib.a)
			set(LASlib_INCLUDE_DIRS $ENV{LASlib_DIR}/include/LASlib)
			set(LASlib_LIBRARY_DIRS $ENV{LASlib_DIR}/lib/LASlib)
		endif()
	endif()
endmacro()

macro(bmp_find_glew)
	bm_boundary("bmp_find_glew" ON OFF)
	if(NOT glew_FOUND)
		# define args keywords
		set(args_optional)
		set(args_one_value)
		set(args_multi_value DIRS_INC DIRS_LIB NAMES_LIB)
		# cmake parse args
		cmake_parse_arguments(glew
			"${args_optional}"
			"${args_one_value}"
			"${args_multi_value}"
			${ARGN})
		# print args
		message("${MSG_PRE} glew_DIRS_INC  =>  ${glew_DIRS_INC}")
		message("${MSG_PRE} glew_DIRS_LIB  =>  ${glew_DIRS_LIB}")
		message("${MSG_PRE} glew_NAMES_LIB  =>  ${glew_NAMES_LIB}")

		set(glew_LIB_NAMES glew GLEW glew32 glew32s)
		if(NOT ("" STREQUAL "${glew_DIRS_LIB}"))
			list(APPEND glew_LIB_NAMES ${glew_NAMES_LIB})
		endif()
		# find targets by multiple path
		if(BM_SYSTEM_IS_WIN)
			if("" STREQUAL "${glew_DIRS_INC}")
				message(WARNING "${MSG_PRE} arg DIRS_INC is empty")
			else()
				FIND_PATH(glew_INCLUDE_DIRS GL/glew.h ${glew_DIRS_INC}
					DOC "The directory where GL/glew.h resides")
			endif()

			if("" STREQUAL "${glew_DIRS_LIB}")
				message(WARNING "${MSG_PRE} arg DIRS_LIB is empty")
			else()
				FIND_LIBRARY(glew_LIBRARIES
					NAMES ${glew_LIB_NAMES}
					PATHS ${glew_DIRS_LIB}
					DOC "The directory where GLEW library resides")
			endif()
		else()
			FIND_PATH(glew_INCLUDE_DIRS GL/glew.h
				${glew_DIRS_INC}
				/usr/include
				/usr/local/include
				/sw/include
				/opt/local/include
				DOC "The directory where GL/glew.h resides")
			FIND_LIBRARY(glew_LIBRARIES
				NAMES ${glew_LIB_NAMES}
				PATHS 
				${glew_DIRS_LIB}
				/usr/lib64
				/usr/lib
				/usr/local/lib64
				/usr/local/lib
				/sw/lib
				/opt/local/lib
				DOC "The directory where GLEW library resides")
		endif()
		if(DEFINED glew_INCLUDE_DIRS-NOTFOUND OR DEFINED glew_LIBRARIES-NOTFOUND)
			set(glew_FOUND OFF)
		else()
			set(glew_FOUND ON)
		endif()
		unset(args_optional)
		unset(args_one_value)
		unset(args_multi_value)
		unset(glew_DIRS_INC)
		unset(glew_DIRS_LIB)
		unset(glew_NAMES_LIB)
	else()
		message("${MSG_PRE} has FOUND glew")
	endif()
	message("${MSG_PRE} glew_LIBRARIES => ${glew_LIBRARIES}")
	message("${MSG_PRE} glew_INCLUDE_DIRS => ${glew_INCLUDE_DIRS}")
	bm_boundary("bmp_find_glew" OFF OFF)
endmacro()

macro(bmp_find_glew_cmake)
	bm_boundary("bmp_find_glew_cmake" ON OFF)
	if(NOT glew_FOUND)
		set(args_optional)
		set(args_one_value TYPE_CTX TYPE_LIB TYPE_FIX)
		set(args_multi_value)

		cmake_parse_arguments(glew_cmake
			"${args_optional}"
			"${args_one_value}"
			"${args_multi_value}"
			${ARGN})

		message("${MSG_PRE} glew_cmake_TYPE_CTX  =>  ${glew_cmake_TYPE_CTX}")
		message("${MSG_PRE} glew_cmake_TYPE_LIB  =>  ${glew_cmake_TYPE_LIB}")
		message("${MSG_PRE} glew_cmake_TYPE_FIX  =>  ${glew_cmake_TYPE_FIX}")
		
		set(glew_cmake_LIB_NAME "libglew${glew_cmake_TYPE_CTX}_${glew_cmake_TYPE_LIB}${glew_cmake_TYPE_FIX}")
		message("${MSG_PRE} glew_cmake_LIB_NAME  =>  ${glew_cmake_LIB_NAME}")

		bmp_find_glew(DIRS_INC $ENV{glew_cmake_DIR}/include
			DIRS_LIB $ENV{glew_cmake_DIR}/lib
			NAMES_LIB ${glew_cmake_LIB_NAME})

		unset(args_optional)
		unset(args_one_value)
		unset(args_multi_value)
	endif()
	bm_boundary("bmp_find_glew_cmake" OFF OFF)
endmacro()

macro(bmp_find_ros_yaml)
	set(ROS_YAML_FOUND OFF)
	if(NOT ("$ENV{ROS_DISTRO}" STREQUAL ""))
		if(BM_SYSTEM_IS_LINUX)
			set(yaml_DIR "/opt/ros/$ENV{ROS_DISTRO}/cmake")
			find_package(yaml)
			set(ROS_YAML_FOUND ON)
		endif()
	endif()
endmacro()
