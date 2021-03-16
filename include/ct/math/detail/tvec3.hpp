
#include <ct/math/detail/setup.hpp>
#include <ct/core/utils/type_info.hpp>

namespace ct {

	template <typename T>
	struct tvec3 {
		using value_type = T;

		T x;
		T y;
		T z;

		// Default constructors

		CONSTEXPR tvec3();
		CONSTEXPR tvec3(const tvec3<T> & other) = default;

		// Explicit constructors

		CONSTEXPR tvec3(T x, T y, T z);
		CONSTEXPR explicit tvec3(T scalar);

		// Conversion constructors

		CONSTEXPR tvec3(const tvec2<T> & vec2);
		CONSTEXPR tvec3(const tvec2<T> & vec2, T z);

		template <typename X, typename Y, typename Z>
		CONSTEXPR tvec3(X x, Y y, Z z);

		template <typename U>
		CONSTEXPR tvec3(const tvec2<U> & vec2);

		template <typename U>
		CONSTEXPR tvec3(const tvec2<U> & vec2, U z);

		template <typename U, typename Z>
		CONSTEXPR tvec3(const tvec2<U> & vec2, Z z);

		template <typename U>
		CONSTEXPR tvec3(const tvec3<U> & vec3);


	};

}
