# base make find package
# ARGV0 (required) package name 
# ARGV1 (optional) if find required  
# ARGV2 (optional) if set package DIR
# ARGV3 (optional) package version string
macro(bmp_find_package)
	bm_boundary("bmp_find_package" ON OFF)
	message("${MSG_PRE} arg num(${ARGC}) package(${ARGV0}) FOUND(${${ARGV0}_FOUND}) required(${ARGV1}) set_DIR(${ARGV2}) version(${ARGV3})")
	if(NOT ("" STREQUAL "${ARGV0}"))
		# TRUE,ON express has found package
		bmf_string2_bool("${${ARGV0}_FOUND}" "FP_HAS_FOUND" OFF)
		if(NOT FP_HAS_FOUND)
			# empty,TRUE,ON express required
			bmf_string2_bool("${ARGV1}" "FP_IS_REQ" ON)
			# empty,TRUE,ON express set package dir
			bmf_string2_bool("${ARGV2}" "FP_IS_SET_DIR" ON)
			
			if(FP_IS_SET_DIR)
				set(${ARGV0}_DIR $ENV{${ARGV0}_DIR})
				message("${MSG_PRE} set ${ARGV0}_DIR $ENV{${ARGV0}_DIR}")
			endif()
			
			if(NOT FP_HAS_FOUND)
				# avoid find package repeat
				if(NOT FP_IS_REQ)
					find_package(${ARGV0} ${ARGV3})
				else()
					find_package(${ARGV0} ${ARGV3} REQUIRED)
				endif()
			endif()
			
			set(${ARGV0}_FOUND ON)
			string(TOUPPER ${ARGV0} UP_PACK_NAME)
			add_definitions(-DUSE_${UP_PACK_NAME})

			unset(FP_IS_REQ)
			unset(FP_IS_SET_DIR)
			unset(UP_PACK_NAME)
		else()
			message("${MSG_PRE} has FOUND ${ARGV0}")
		endif()
		unset(FP_HAS_FOUND)
	else()
		message(WARNING "${MSG_PRE} please set package name")
	endif()
	bm_boundary("bmp_find_package" OFF OFF)
endmacro()

# deprecate
macro(find_spdlog)
	bmp_find_package(spdlog ${ARGV0} ${ARGV1})
	if(NOT DEFINED ${PROJECT_NAME}_dependencies)
		set(${PROJECT_NAME}_dependencies spdlog::spdlog)
	else()
		list(APPEND ${PROJECT_NAME}_dependencies spdlog::spdlog)
	endif()
endmacro()

# deprecate
macro(find_jsoncpp)
	bmp_find_package(jsoncpp ${ARGV0} ${ARGV1})
	if(NOT DEFINED ${PROJECT_NAME}_dependencies)
		set(${PROJECT_NAME}_dependencies jsoncpp_static)
	else()
		list(APPEND ${PROJECT_NAME}_dependencies jsoncpp_static)
	endif()
endmacro()

# deprecate
macro(find_pcl)
	if(NOT DEFINED PCL_VTK_USE)
		set(PCL_VTK_USE ON)
	endif()
	bmp_find_package(PCL ${ARGV0} ${ARGV1})
endmacro()

# deprecate
macro(find_vtk)
	set(PCL_VTK_USE OFF)
	bmp_find_package(VTK ${ARGV0} ${ARGV1})
endmacro()

# deprecate
macro(find_gflags)
	bmp_find_package(gflags ${ARGV0} ${ARGV1})
	if(NOT DEFINED ${PROJECT_NAME}_dependencies)
		set(${PROJECT_NAME}_dependencies gflags_static)
	else()
		list(APPEND ${PROJECT_NAME}_dependencies gflags_static)
	endif()
endmacro()
