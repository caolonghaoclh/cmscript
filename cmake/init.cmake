
if(MSVC)
	set(FLAGS_ADDITIONAL
		/W4
		/wd4013
		/wd4018
		/wd4028 
		/wd4047 
		/wd4068 
		/wd4090 
		/wd4101 
		/wd4113 
		/wd4133 
		/wd4190 
		/wd4244 
		/wd4267 
		/wd4305 
		/wd4477 
		/wd4996 
		/wd4819
		fp:fast)
endif()

# not use -lpthread
if(BM_COMPILER_IS_GNU)
	set(FLAGS_ADDITIONAL
		-Wall
		-pthread 
		-lm 
		-Wno-sign-compare 
		-Wno-unused-result
		-Wno-unused-parameter
		-Wno-unused-variable
		-Wfatal-errors
		-Wno-deprecated-declarations
		-Wno-write-strings
		-Wno-unknown-pragmas
		-Wno-pedantic
		-Wno-pessimizing-move
		-Wno-deprecated-copy
		-Wno-pedantic
		-Wno-class-memaccess
		-Wno-reorder)
endif()

macro(bm_start)
	bm_boundary("bm_start")
	string(TOUPPER "${PROJECT_NAME}" UP_PROJECT_NAME)
	
	bm_build_type()
	# result is list
	bm_check_compiler_flag("FLAGS_SUPPORT_C" "FLAGS_SUPPORT_CXX" ${FLAGS_ADDITIONAL})
	
	foreach(flag ${FLAGS_SUPPORT_C})
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flag}")
	endforeach()
	foreach(flag ${FLAGS_SUPPORT_CXX})
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${flag}")
	endforeach()
	
	bmf_replace_flags("/Ox" "/O2")
	
	message("${MSG_PRE} CMAKE_C_FLAGS \n ${CMAKE_C_FLAGS}")
	message("${MSG_PRE} CMAKE_CXX_FLAGS \n ${CMAKE_CXX_FLAGS}")
	
	bm_boundary()
endmacro()
