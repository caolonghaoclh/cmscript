
macro(bm_import SRC_DIR)
	set(cmscript_components
		"set"
		"target" 
		"packages"
		"msvc"
		"thirdlib")
	
	if(DEFINED cmscript_FIND_OPTIONAL_COMPONENTS)
		list(LENGTH cmscript_FIND_OPTIONAL_COMPONENTS OPT_COMP_LEN)
		if("${OPT_COMP_LEN}" GREATER  "0")
			list(REMOVE_ITEM cmscript_components ${cmscript_FIND_OPTIONAL_COMPONENTS})
		endif()
		unset(OPT_COMP_LEN)
	endif()
	
	include(${SRC_DIR}/cmake/cmscript.cmake)
	include(${SRC_DIR}/cmake/globalScript.cmake)
	include(${SRC_DIR}/cmake/previous.cmake)
	include(${SRC_DIR}/cmake/init.cmake)
	
	foreach(comp ${cmscript_components})
		if(("${comp}" STREQUAL "msvc") AND NOT MSVC)
			message("[cmscript] auto filter msvc component")
		else()
			include(${SRC_DIR}/cmake/${comp}.cmake)
			message("[cmscript] import cmake file ${SRC_DIR}/cmake/${comp}.cmake")
		endif()
	endforeach()
endmacro()
