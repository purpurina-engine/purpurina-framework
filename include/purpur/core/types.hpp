
#ifndef _PURPURINA_FRWK_TYPES_HPP_
#define _PURPURINA_FRWK_TYPES_HPP_

namespace ppr {
	////////////////////////////////////////////////////////////
	// Define portable fixed-size types
	////////////////////////////////////////////////////////////

	// All "common" platforms use the same size for char, short and int
	// (basically there are 3 types for 3 sizes, so no other match is possible),
	// we can use them without doing any kind of check

	/// 8 bits integer types
	typedef signed char int8;
	typedef unsigned char uint8;

	/// 16 bits integer types
	typedef signed short int16;
	typedef unsigned short uint16;

	/// 32 bits integer types
	typedef signed int int32;
	typedef unsigned int uint32;

/// 64 bits integer types
#if defined(_MSC_VER)
	typedef signed __int64 int64;
	typedef unsigned __int64 uint64;
#else
	typedef signed long long int64;
	typedef unsigned long long uint64;
#endif

	/// Byte representation
	typedef uint8 byte;

	typedef const char * cstr; //<! C-string

} // namespace ppr

#endif
