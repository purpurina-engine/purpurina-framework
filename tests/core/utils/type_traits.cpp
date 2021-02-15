
#include <catch2/catch.hpp>

#include <purpur/core/utils/type_traits.hpp>

namespace {
	template <class T>
	void swap(T& a, T& b) {
		T tmp(ppr::move(a));
		a = ppr::move(b);
		b = ppr::move(tmp);
	}

	template <class T>
	void swapMacro(T& a, T& b) {
		T tmp(MOV(a));
		a = MOV(b);
		b = MOV(tmp);
	}


	class DummyMoveClass {
		public:
		int value = 42;
		DummyMoveClass(int val): value(val) {}
	};
}

TEST_CASE( "move", "[core:utils:type_traits:move]" ) {

	SECTION("swap entities") {
		DummyMoveClass a(64);
    	DummyMoveClass b(128);

		swap(a, b);

		REQUIRE(a.value == 128);
		REQUIRE(b.value == 64);

		swap(a, b);

		REQUIRE(a.value == 64);
		REQUIRE(b.value == 128);
    }

	SECTION("swap entities with MOV macro") {
		DummyMoveClass a(64);
    	DummyMoveClass b(128);

		swapMacro(a, b);

		REQUIRE(a.value == 128);
		REQUIRE(b.value == 64);

		swapMacro(a, b);

		REQUIRE(a.value == 64);
		REQUIRE(b.value == 128);
    }

}