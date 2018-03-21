
file(GLOB_RECURSE libRedBlackTrees_SRC_C RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.c")
file(GLOB_RECURSE libRedBlackTrees_SRC_M RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.m")
file(GLOB_RECURSE libRedBlackTrees_HEADR RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.h")
file(GLOB_RECURSE libRedBlackTrees_PRIVT RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "Private/*.h")

set(libRedBlackTrees_INC "")
foreach(afile ${libRedBlackTrees_HEADR})
	get_filename_component(dirname "${afile}" PATH)
	if(dirname STREQUAL "")
		list(APPEND libRedBlackTrees_INC ".")
	else()
		list(APPEND libRedBlackTrees_INC "${dirname}")
	endif()
endforeach(afile)
list(REMOVE_DUPLICATES libRedBlackTrees_INC)
include_directories(${libRedBlackTrees_INC})

list(REMOVE_ITEM libRedBlackTrees_HEADR ${libRedBlackTrees_PRIVT})

set_source_files_properties(${libRedBlackTrees_SRC_C} PROPERTIES LANGUAGE C COMPILE_FLAGS "-fblocks -std=gnu99")
set_source_files_properties(${libRedBlackTrees_SRC_M} PROPERTIES LANGUAGE C COMPILE_FLAGS "${objc_flags}")
set_source_files_properties(${libRedBlackTrees_HEADR} PROPERTIES LANGUAGE C COMPILE_FLAGS HEADER_FILE_ONLY YES)
set_source_files_properties(${libRedBlackTrees_PRIVT} PROPERTIES LANGUAGE C COMPILE_FLAGS HEADER_FILE_ONLY YES)

set(ALL_SRC_FILES ${libRedBlackTrees_SRC_C} ${libRedBlackTrees_SRC_M} ${libRedBlackTrees_HEADR} ${libRedBlackTrees_PRIVT})

add_library(libRedBlackTrees_SHARED SHARED ${ALL_SRC_FILES})
target_link_libraries(libRedBlackTrees_SHARED)
set_target_properties(libRedBlackTrees_SHARED PROPERTIES LINKER_LANGUAGE C LINK_FLAGS "${objc_link_flags}" SOVERSION "${RedBlackTrees_VERSION}" VERSION "${RedBlackTrees_VERSION}" OUTPUT_NAME "${CMAKE_PROJECT_NAME}")

install(TARGETS libRedBlackTrees_SHARED libRedBlackTrees_STATIC ARCHIVE DESTINATION lib LIBRARY DESTINATION lib)
install(FILES ${libRedBlackTrees_HEADR} DESTINATION "include/${CMAKE_PROJECT_NAME}")
