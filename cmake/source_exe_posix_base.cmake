include("${CMAKE_MODULE_PATH}/common_functions.cmake")
include("${CMAKE_MODULE_PATH}/source_posix_base.cmake")

MacroRequired(SRCDIR)
MacroRequired(OUTBINNAME)
MacroRequired(OUTBINDIR)

set( IS_LIB_PROJECT "1")

add_definitions( -DEXENAME=${OUTBINNAME} )

if(WIN32 AND MSVC)
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE") # Use more than 2 gigabytes of memory on windows
	set(CMAKE_WIN32_EXECUTABLE ON) # Sets subsystem to WINDOWS
endif()

add_executable(${OUTBINNAME})

if(WIN32)
	set_target_properties(${OUTBINNAME} PROPERTIES OUTPUT_NAME "${OUTBINNAME}.exe")
else()
	set_target_properties(${OUTBINNAME} PROPERTIES OUTPUT_NAME "${OUTBINNAME}")
endif()
set_target_properties(${OUTBINNAME} PROPERTIES SUFFIX "")
set_target_properties(${OUTBINNAME} PROPERTIES PREFIX "")

message("Adding executable target: ${OUTBINNAME}\n")

set_target_properties( ${OUTBINNAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${OUTBINDIR}"
        LIBRARY_OUTPUT_DIRECTORY "${OUTBINDIR}"
        RUNTIME_OUTPUT_DIRECTORY "${OUTBINDIR}"
        )

if( LINUXALL AND NOT DEDICATED AND NOT WIN32)
    #// In order to get the Valve standard allocator memory alignment (16-byte
    #// alignment for objects that are a multiple of 16 bytes) we use tcmalloc.
    #// Using -l will ask the linker to use it, but if there are no references
    #// to malloc/free then it may not actually use it. Wrapping the flag in the
    #// as-needed controls forces it to be pulled in (from libtcmalloc_minimal.so).
    target_compile_options(${OUTBINNAME} PRIVATE "-Wl,--no-as-needed -ltcmalloc_minimal -Wl,--as-needed")
endif()

if( NOSKELETONBASE )
    message(STATUS "Not including Skeleton base.")
else()
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/memoverride.cpp")
endif()

if( LINUXALL AND NOT DEDICATED AND NOT WIN32)
    if( LINUX64 )
            target_link_libraries(${OUTBINNAME} tcmalloc_minimal)
    else()
        #$ImpLibExternal	"$SRCDIR/thirdparty/gperftools-2.0/.libs/tcmalloc_minimal" [$LINUX32]
        message(FATAL_ERROR "linux32 not supported in cmake")
    endif()
endif()
