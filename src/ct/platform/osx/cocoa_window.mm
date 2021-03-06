
#import <ct/platform/osx/autorelease_pool.h>
#import <ct/platform/osx/ct_application.h>
#import <ct/platform/osx/ct_window.h>
#import <ct/platform/osx/ct_window_delegate.h>

#include <ct/platform/window_style.hpp>
#include <ct/platform/osx/cocoa_window.hpp>

#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_12
	#define NSWindowStyleMaskTitled NSTitledWindowMask;
#endif

/// From: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaDrawingGuide/AdvancedDrawing/AdvancedDrawing.html
@interface GradientView : NSView
@end

@implementation GradientView

////////////////////////////////////////////////////////////
-(void)drawRect:(NSRect)dirtyRect
{
	NSRect        bounds = [self bounds];

    NSBezierPath*    clipShape = [NSBezierPath bezierPath];
    [clipShape appendBezierPathWithRoundedRect:bounds xRadius:40 yRadius:30];


    NSGradient* aGradient = [[[NSGradient alloc]
                    initWithColorsAndLocations:[NSColor redColor], (CGFloat)0.0,
                                            [NSColor orangeColor], (CGFloat)0.166,
                                            [NSColor yellowColor], (CGFloat)0.33,
                                            [NSColor greenColor], (CGFloat)0.5,
                                            [NSColor blueColor], (CGFloat)0.75,
                                            [NSColor purpleColor], (CGFloat)1.0,
                                            nil] autorelease];

    [aGradient drawInBezierPath:clipShape angle:0.0];
}

@end

namespace ct {

	namespace internal {

		NSUInteger parseStyleMask(uint32 style) {
			NSUInteger styleMask = NSWindowStyleMaskMiniaturizable;

			if (style & WindowStyle::Borderless) {
				styleMask |= NSWindowStyleMaskBorderless;
			} else {

				if (style & WindowStyle::Title) {
					styleMask |= NSWindowStyleMaskTitled;
				}

				if (style & WindowStyle::Close) {
					styleMask |= NSWindowStyleMaskClosable;
				}

				if (style & WindowStyle::Resize) {
					styleMask |= NSWindowStyleMaskResizable;
				}

			}

			return styleMask;
		}

		CocoaWindow::CocoaWindow(WindowHandle handle, WindowDelegate delegate)
		:
		handle(handle)
		{
			[delegate setup:this];
			this->delegate = delegate;
		}


		CocoaWindow::~CocoaWindow() {
            [handle setDelegate:nil];
            [delegate release];
            delegate = nullptr;
            [handle release];
            handle = nullptr;
		}

		bool CocoaWindow::is_visible() const {
			@autoreleasepool {
    			return [handle isVisible];
    		}
		}

		WindowHandle CocoaWindow::get_handle() const {
			return handle;
		}

		void CocoaWindow::set_visible(bool visible) {
			@autoreleasepool {
				if (visible) {
					[handle orderFront:nil];
				} else {
					[handle orderOut:nil];
				}
			}
		}

		void CocoaWindow::focus() {
			 @autoreleasepool {
				// Make us the active application
				// HACK: This is here to prevent applications using only hidden windows from
				//       being activated, but should probably not be done every time any
				//       window is shown
				[NSApp activateIgnoringOtherApps:YES];
				[handle makeKeyAndOrderFront:nil];
			}
		}

		void CocoaWindow::center() {
			CGFloat x = NSWidth([[handle screen] frame])/2 - NSWidth([handle frame])/2;
			CGFloat y = NSHeight([[handle screen] frame])/2 - NSHeight([handle frame])/2;
			[handle setFrame:NSMakeRect(x, y, NSWidth([handle frame]), NSHeight([handle frame])) display:YES];
		}

		CocoaWindow * CocoaWindow::create(const WindowProperties & props) {
			@autoreleasepool {
				// checkAutoreleasePool();

				CTWindowDelegate * windowDelegate = [[CTWindowDelegate alloc] init];
				// TODO: handle windowDelegate error properly
				if (windowDelegate == nil) {
					printf("Failed to create CTWindowDelegate");
					return nullptr;
				}

				NSUInteger styleMask = parseStyleMask(props.style);
				NSRect contentRect = NSMakeRect(0, 0, props.width, props.height);
				CTWindow * window = [[CTWindow alloc] initWithContentRect:contentRect
													  styleMask:styleMask
													  backing:NSBackingStoreBuffered
													  defer:NO];
				// TODO: handle window error properly
				if (window == nil) {
					printf("[ct] ERROR: Failed to create CTWindow at platform::CocoaWindow.");
					return nullptr;
				}

				// TODO: set view
				// GradientView * myView = [[[GradientView alloc] initWithFrame:contentRect] autorelease];
				// if (myView == nil) {
				// printf("[ct] ERROR: Failed to create CTWindow at platform::CocoaWindow.");
				// }
				// [window setContentView:myView];

				// set window config
				[window setOpaque:YES];
				[window setHidesOnDeactivate:YES];
				[window setReleasedWhenClosed:NO];
				[window setTitle:[NSString stringWithUTF8String:props.title]];

				[window setDelegate:windowDelegate];
				[window setAcceptsMouseMovedEvents:YES];
				[window setRestorable:NO];
   				[window setIgnoresMouseEvents:NO];

				[(NSWindow*) window center];

				return new CocoaWindow(window, windowDelegate);
			}
		}
	}

}
