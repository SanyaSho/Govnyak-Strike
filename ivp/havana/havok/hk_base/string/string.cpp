#include <hk_base/base.h>
#ifndef _WIN32
#include "string.h" //lwss: changed to quotes to stop global string.h loading
#else
#include <string.h>
#endif

int hk_String::strcmp( const char* a, const char* b )
{
	return ::strcmp(a,b);
}

void hk_String::strcpy( char* a, const char* b )
{
	::strcpy(a,b);
}

void hk_String::memcpy( void* a, const void* b, int size )
{
	::memcpy(a,b,size);
}

