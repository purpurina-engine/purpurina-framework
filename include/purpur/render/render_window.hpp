
#ifndef _PURPURINA_FRWK_RENDER_WINDOW_HPP_
#define _PURPURINA_FRWK_RENDER_WINDOW_HPP_

#include <purpur/platform/native_window.hpp>
#include <purpur/platform/window.hpp>
#include <purpur/render/export.hpp>

namespace ppr {

	class PPR_RENDER_API RenderWidow : public Window {
	public:
		RenderWidow(NativeWindow * nativeWindow);
		static RenderWidow * create();
	};

} // namespace ppr

#endif
