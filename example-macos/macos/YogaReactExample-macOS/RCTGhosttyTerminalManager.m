#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <AppKit/AppKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#include "ghostty.h"

// ---------------------------------------------------------------------------
// GhosttyAppManager — singleton that owns the ghostty_app_t
// ---------------------------------------------------------------------------

@interface GhosttyAppManager : NSObject
@property (nonatomic, assign) ghostty_app_t app;
+ (instancetype)shared;
@end

// Forward-declare the view so callbacks can reach it
@interface RCTGhosttyTerminalView : NSView <NSTextInputClient>
@property (nonatomic, assign) ghostty_surface_t surface;
@property (nonatomic, copy) RCTBubblingEventBlock onTitle;
@property (nonatomic, copy) RCTBubblingEventBlock onBell;
@property (nonatomic, copy) RCTBubblingEventBlock onExit;
@property (nonatomic, copy) NSString *cwd;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, copy) NSString *fontFamily;
@end

// ---------------------------------------------------------------------------
// Runtime callbacks (C functions)
// ---------------------------------------------------------------------------

static void rt_wakeup(void *ud) {
  dispatch_async(dispatch_get_main_queue(), ^{
    ghostty_app_t app = [GhosttyAppManager shared].app;
    if (app) ghostty_app_tick(app);
  });
}

static bool rt_action(ghostty_app_t app, ghostty_target_s target,
                      ghostty_action_s action) {
  if (target.tag != GHOSTTY_TARGET_SURFACE) return false;
  ghostty_surface_t surface = target.target.surface;
  if (!surface) return false;

  RCTGhosttyTerminalView *view =
      (__bridge RCTGhosttyTerminalView *)ghostty_surface_userdata(surface);
  if (!view) return false;

  switch (action.tag) {
    case GHOSTTY_ACTION_SET_TITLE: {
      NSString *title = action.action.set_title.title
        ? [NSString stringWithUTF8String:action.action.set_title.title]
        : @"";
      if (view.onTitle) {
        view.onTitle(@{@"title": title});
      }
      return true;
    }
    case GHOSTTY_ACTION_RING_BELL: {
      NSBeep();
      if (view.onBell) {
        view.onBell(@{});
      }
      return true;
    }
    case GHOSTTY_ACTION_SHOW_CHILD_EXITED: {
      if (view.onExit) {
        view.onExit(@{@"exitCode": @(action.action.child_exited.exit_code)});
      }
      return true;
    }
    case GHOSTTY_ACTION_CLOSE_WINDOW:
      return true;
    default:
      return false;
  }
}

static void rt_read_clipboard(void *ud, ghostty_clipboard_e clipboard,
                              void *state) {
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  NSString *str = [pb stringForType:NSPasteboardTypeString];
  ghostty_surface_t surface = ud;
  if (str) {
    ghostty_surface_complete_clipboard_request(surface,
                                               str.UTF8String,
                                               state, false);
  }
}

static void rt_confirm_read_clipboard(void *ud, const char *text,
                                      void *state,
                                      ghostty_clipboard_request_e req) {
  ghostty_surface_t surface = ud;
  ghostty_surface_complete_clipboard_request(surface, text, state, true);
}

static void rt_write_clipboard(void *ud, ghostty_clipboard_e clipboard,
                               const ghostty_clipboard_content_s *content,
                               size_t content_len, bool confirm) {
  if (content_len == 0) return;
  NSPasteboard *pb = [NSPasteboard generalPasteboard];
  [pb clearContents];
  NSString *str = [NSString stringWithUTF8String:content[0].data];
  if (str) [pb setString:str forType:NSPasteboardTypeString];
}

static void rt_close_surface(void *ud, bool processAlive) {
  // no-op — surface lifecycle managed by React
}

// ---------------------------------------------------------------------------
// GhosttyAppManager implementation
// ---------------------------------------------------------------------------

@implementation GhosttyAppManager

+ (instancetype)shared {
  static GhosttyAppManager *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[GhosttyAppManager alloc] init];
  });
  return instance;
}

- (instancetype)init {
  if (self = [super init]) {
    _app = NULL;
    ghostty_init(0, NULL);

    ghostty_config_t cfg = ghostty_config_new();
    ghostty_config_finalize(cfg);

    ghostty_runtime_config_s rt = {
      .userdata            = (__bridge void *)self,
      .supports_selection_clipboard = false,
      .wakeup_cb           = rt_wakeup,
      .action_cb           = rt_action,
      .read_clipboard_cb   = rt_read_clipboard,
      .confirm_read_clipboard_cb = rt_confirm_read_clipboard,
      .write_clipboard_cb  = rt_write_clipboard,
      .close_surface_cb    = rt_close_surface,
    };

    _app = ghostty_app_new(&rt, cfg);
    ghostty_config_free(cfg);

    if (!_app) {
      NSLog(@"[Ghostty] Failed to create ghostty_app_t");
    }
  }
  return self;
}

@end

// ---------------------------------------------------------------------------
// macOS keyCode → ghostty_input_key_e translation
// ---------------------------------------------------------------------------

static ghostty_input_key_e keyCodeToGhostty(unsigned short keyCode) {
  switch (keyCode) {
    // Writing System Keys
    case 0x32: return GHOSTTY_KEY_BACKQUOTE;
    case 0x2A: return GHOSTTY_KEY_BACKSLASH;
    case 0x21: return GHOSTTY_KEY_BRACKET_LEFT;
    case 0x1E: return GHOSTTY_KEY_BRACKET_RIGHT;
    case 0x2B: return GHOSTTY_KEY_COMMA;
    case 0x1D: return GHOSTTY_KEY_DIGIT_0;
    case 0x12: return GHOSTTY_KEY_DIGIT_1;
    case 0x13: return GHOSTTY_KEY_DIGIT_2;
    case 0x14: return GHOSTTY_KEY_DIGIT_3;
    case 0x15: return GHOSTTY_KEY_DIGIT_4;
    case 0x17: return GHOSTTY_KEY_DIGIT_5;
    case 0x16: return GHOSTTY_KEY_DIGIT_6;
    case 0x1A: return GHOSTTY_KEY_DIGIT_7;
    case 0x1C: return GHOSTTY_KEY_DIGIT_8;
    case 0x19: return GHOSTTY_KEY_DIGIT_9;
    case 0x18: return GHOSTTY_KEY_EQUAL;
    case 0x0A: return GHOSTTY_KEY_INTL_BACKSLASH;
    case 0x5E: return GHOSTTY_KEY_INTL_RO;
    case 0x5D: return GHOSTTY_KEY_INTL_YEN;
    case 0x00: return GHOSTTY_KEY_A;
    case 0x0B: return GHOSTTY_KEY_B;
    case 0x08: return GHOSTTY_KEY_C;
    case 0x02: return GHOSTTY_KEY_D;
    case 0x0E: return GHOSTTY_KEY_E;
    case 0x03: return GHOSTTY_KEY_F;
    case 0x05: return GHOSTTY_KEY_G;
    case 0x04: return GHOSTTY_KEY_H;
    case 0x22: return GHOSTTY_KEY_I;
    case 0x26: return GHOSTTY_KEY_J;
    case 0x28: return GHOSTTY_KEY_K;
    case 0x25: return GHOSTTY_KEY_L;
    case 0x2E: return GHOSTTY_KEY_M;
    case 0x2D: return GHOSTTY_KEY_N;
    case 0x1F: return GHOSTTY_KEY_O;
    case 0x23: return GHOSTTY_KEY_P;
    case 0x0C: return GHOSTTY_KEY_Q;
    case 0x0F: return GHOSTTY_KEY_R;
    case 0x01: return GHOSTTY_KEY_S;
    case 0x11: return GHOSTTY_KEY_T;
    case 0x20: return GHOSTTY_KEY_U;
    case 0x09: return GHOSTTY_KEY_V;
    case 0x0D: return GHOSTTY_KEY_W;
    case 0x07: return GHOSTTY_KEY_X;
    case 0x10: return GHOSTTY_KEY_Y;
    case 0x06: return GHOSTTY_KEY_Z;
    case 0x1B: return GHOSTTY_KEY_MINUS;
    case 0x2F: return GHOSTTY_KEY_PERIOD;
    case 0x27: return GHOSTTY_KEY_QUOTE;
    case 0x29: return GHOSTTY_KEY_SEMICOLON;
    case 0x2C: return GHOSTTY_KEY_SLASH;

    // Functional Keys
    case 0x3A: return GHOSTTY_KEY_ALT_LEFT;
    case 0x3D: return GHOSTTY_KEY_ALT_RIGHT;
    case 0x33: return GHOSTTY_KEY_BACKSPACE;
    case 0x39: return GHOSTTY_KEY_CAPS_LOCK;
    case 0x6E: return GHOSTTY_KEY_CONTEXT_MENU;
    case 0x3B: return GHOSTTY_KEY_CONTROL_LEFT;
    case 0x3E: return GHOSTTY_KEY_CONTROL_RIGHT;
    case 0x24: return GHOSTTY_KEY_ENTER;
    case 0x37: return GHOSTTY_KEY_META_LEFT;
    case 0x36: return GHOSTTY_KEY_META_RIGHT;
    case 0x38: return GHOSTTY_KEY_SHIFT_LEFT;
    case 0x3C: return GHOSTTY_KEY_SHIFT_RIGHT;
    case 0x31: return GHOSTTY_KEY_SPACE;
    case 0x30: return GHOSTTY_KEY_TAB;

    // Control Pad Section
    case 0x75: return GHOSTTY_KEY_DELETE;
    case 0x77: return GHOSTTY_KEY_END;
    case 0x73: return GHOSTTY_KEY_HOME;
    case 0x72: return GHOSTTY_KEY_INSERT;
    case 0x79: return GHOSTTY_KEY_PAGE_DOWN;
    case 0x74: return GHOSTTY_KEY_PAGE_UP;

    // Arrow Pad Section
    case 0x7D: return GHOSTTY_KEY_ARROW_DOWN;
    case 0x7B: return GHOSTTY_KEY_ARROW_LEFT;
    case 0x7C: return GHOSTTY_KEY_ARROW_RIGHT;
    case 0x7E: return GHOSTTY_KEY_ARROW_UP;

    // Numpad Section
    case 0x47: return GHOSTTY_KEY_NUM_LOCK;
    case 0x52: return GHOSTTY_KEY_NUMPAD_0;
    case 0x53: return GHOSTTY_KEY_NUMPAD_1;
    case 0x54: return GHOSTTY_KEY_NUMPAD_2;
    case 0x55: return GHOSTTY_KEY_NUMPAD_3;
    case 0x56: return GHOSTTY_KEY_NUMPAD_4;
    case 0x57: return GHOSTTY_KEY_NUMPAD_5;
    case 0x58: return GHOSTTY_KEY_NUMPAD_6;
    case 0x59: return GHOSTTY_KEY_NUMPAD_7;
    case 0x5B: return GHOSTTY_KEY_NUMPAD_8;
    case 0x5C: return GHOSTTY_KEY_NUMPAD_9;
    case 0x45: return GHOSTTY_KEY_NUMPAD_ADD;
    case 0x5F: return GHOSTTY_KEY_NUMPAD_COMMA;
    case 0x41: return GHOSTTY_KEY_NUMPAD_DECIMAL;
    case 0x4B: return GHOSTTY_KEY_NUMPAD_DIVIDE;
    case 0x4C: return GHOSTTY_KEY_NUMPAD_ENTER;
    case 0x51: return GHOSTTY_KEY_NUMPAD_EQUAL;
    case 0x43: return GHOSTTY_KEY_NUMPAD_MULTIPLY;
    case 0x4E: return GHOSTTY_KEY_NUMPAD_SUBTRACT;

    // Function Section
    case 0x35: return GHOSTTY_KEY_ESCAPE;
    case 0x7A: return GHOSTTY_KEY_F1;
    case 0x78: return GHOSTTY_KEY_F2;
    case 0x63: return GHOSTTY_KEY_F3;
    case 0x76: return GHOSTTY_KEY_F4;
    case 0x60: return GHOSTTY_KEY_F5;
    case 0x61: return GHOSTTY_KEY_F6;
    case 0x62: return GHOSTTY_KEY_F7;
    case 0x64: return GHOSTTY_KEY_F8;
    case 0x65: return GHOSTTY_KEY_F9;
    case 0x6D: return GHOSTTY_KEY_F10;
    case 0x67: return GHOSTTY_KEY_F11;
    case 0x6F: return GHOSTTY_KEY_F12;
    case 0x69: return GHOSTTY_KEY_F13;
    case 0x6B: return GHOSTTY_KEY_F14;
    case 0x71: return GHOSTTY_KEY_F15;
    case 0x6A: return GHOSTTY_KEY_F16;
    case 0x40: return GHOSTTY_KEY_F17;
    case 0x4F: return GHOSTTY_KEY_F18;
    case 0x50: return GHOSTTY_KEY_F19;
    case 0x5A: return GHOSTTY_KEY_F20;

    // Media Keys
    case 0x49: return GHOSTTY_KEY_AUDIO_VOLUME_DOWN;
    case 0x4A: return GHOSTTY_KEY_AUDIO_VOLUME_MUTE;
    case 0x48: return GHOSTTY_KEY_AUDIO_VOLUME_UP;

    default: return GHOSTTY_KEY_UNIDENTIFIED;
  }
}

// ---------------------------------------------------------------------------
// NSEvent modifier flags → ghostty_input_mods_e
// ---------------------------------------------------------------------------

static ghostty_input_mods_e modsFromFlags(NSEventModifierFlags flags) {
  uint32_t mods = GHOSTTY_MODS_NONE;
  if (flags & NSEventModifierFlagShift)   mods |= GHOSTTY_MODS_SHIFT;
  if (flags & NSEventModifierFlagControl) mods |= GHOSTTY_MODS_CTRL;
  if (flags & NSEventModifierFlagOption)  mods |= GHOSTTY_MODS_ALT;
  if (flags & NSEventModifierFlagCommand) mods |= GHOSTTY_MODS_SUPER;
  if (flags & NSEventModifierFlagCapsLock) mods |= GHOSTTY_MODS_CAPS;

  // Sided modifiers via device-dependent bits
  NSUInteger raw = flags;
  if (raw & 0x00000004) mods |= GHOSTTY_MODS_SHIFT_RIGHT;  // NX_DEVICERSHIFTKEYMASK
  if (raw & 0x00002000) mods |= GHOSTTY_MODS_CTRL_RIGHT;   // NX_DEVICERCTLKEYMASK
  if (raw & 0x00000040) mods |= GHOSTTY_MODS_ALT_RIGHT;    // NX_DEVICERALTKEYMASK
  if (raw & 0x00000010) mods |= GHOSTTY_MODS_SUPER_RIGHT;  // NX_DEVICERCMDKEYMASK

  return (ghostty_input_mods_e)mods;
}

// consumed_mods: everything except control and command (Ghostty convention)
static ghostty_input_mods_e consumedModsFromFlags(NSEventModifierFlags flags) {
  NSEventModifierFlags cleaned = flags & ~(NSEventModifierFlagControl | NSEventModifierFlagCommand);
  return modsFromFlags(cleaned);
}

// ---------------------------------------------------------------------------
// RCTGhosttyTerminalView
// ---------------------------------------------------------------------------

@implementation RCTGhosttyTerminalView {
  BOOL _surfaceCreated;
  NSTrackingArea *_trackingArea;
}

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.wantsLayer = YES;
    _surfaceCreated = NO;
    _fontSize = 0; // 0 means use default
  }
  return self;
}

- (CALayer *)makeBackingLayer {
  CAMetalLayer *layer = [CAMetalLayer layer];
  layer.device = MTLCreateSystemDefaultDevice();
  layer.contentsScale = self.window.backingScaleFactor ?: 2.0;
  layer.opaque = YES;
  return layer;
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  if (self.window && !_surfaceCreated) {
    [self createSurface];
  }
}

- (void)createSurface {
  ghostty_app_t app = [GhosttyAppManager shared].app;
  if (!app) return;

  ghostty_surface_config_s cfg = ghostty_surface_config_new();
  cfg.platform_tag = GHOSTTY_PLATFORM_MACOS;
  cfg.platform.macos.nsview = (__bridge void *)self;
  cfg.userdata = (__bridge void *)self;
  cfg.scale_factor = self.window.backingScaleFactor;
  cfg.font_size = _fontSize;

  if (_cwd) cfg.working_directory = _cwd.UTF8String;
  if (_command) cfg.command = _command.UTF8String;

  _surface = ghostty_surface_new(app, &cfg);
  if (_surface) {
    _surfaceCreated = YES;
    uint32_t w = (uint32_t)self.bounds.size.width;
    uint32_t h = (uint32_t)self.bounds.size.height;
    if (w > 0 && h > 0) {
      ghostty_surface_set_size(_surface, w, h);
    }
  } else {
    NSLog(@"[Ghostty] Failed to create surface");
  }
}

- (void)removeFromSuperview {
  if (_surface) {
    ghostty_surface_free(_surface);
    _surface = NULL;
    _surfaceCreated = NO;
  }
  [super removeFromSuperview];
}

- (void)dealloc {
  if (_surface) {
    ghostty_surface_free(_surface);
    _surface = NULL;
  }
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

- (void)setFrameSize:(NSSize)newSize {
  [super setFrameSize:newSize];
  if (_surface) {
    uint32_t w = (uint32_t)newSize.width;
    uint32_t h = (uint32_t)newSize.height;
    if (w > 0 && h > 0) {
      ghostty_surface_set_size(_surface, w, h);
    }
  }
}

- (void)viewDidChangeBackingProperties {
  [super viewDidChangeBackingProperties];
  if (_surface && self.window) {
    double scale = self.window.backingScaleFactor;
    ghostty_surface_set_content_scale(_surface, scale, scale);

    CAMetalLayer *metalLayer = (CAMetalLayer *)self.layer;
    if ([metalLayer isKindOfClass:[CAMetalLayer class]]) {
      metalLayer.contentsScale = scale;
    }
  }
}

// ---------------------------------------------------------------------------
// First responder
// ---------------------------------------------------------------------------

- (BOOL)acceptsFirstResponder { return YES; }

- (BOOL)becomeFirstResponder {
  if (_surface) ghostty_surface_set_focus(_surface, true);
  return YES;
}

- (BOOL)resignFirstResponder {
  if (_surface) ghostty_surface_set_focus(_surface, false);
  return YES;
}

// ---------------------------------------------------------------------------
// Mouse tracking
// ---------------------------------------------------------------------------

- (void)updateTrackingAreas {
  [super updateTrackingAreas];
  if (_trackingArea) [self removeTrackingArea:_trackingArea];
  _trackingArea = [[NSTrackingArea alloc]
    initWithRect:self.bounds
         options:(NSTrackingMouseEnteredAndExited |
                  NSTrackingMouseMoved |
                  NSTrackingActiveInKeyWindow |
                  NSTrackingInVisibleRect)
           owner:self
        userInfo:nil];
  [self addTrackingArea:_trackingArea];
}

- (NSPoint)surfacePoint:(NSEvent *)event {
  NSPoint p = [self convertPoint:event.locationInWindow fromView:nil];
  // Flip Y for ghostty (top-left origin)
  p.y = self.bounds.size.height - p.y;
  return p;
}

- (void)mouseDown:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
  ghostty_surface_mouse_button(_surface, GHOSTTY_MOUSE_PRESS, GHOSTTY_MOUSE_LEFT,
                               modsFromFlags(event.modifierFlags));
}

- (void)mouseUp:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
  ghostty_surface_mouse_button(_surface, GHOSTTY_MOUSE_RELEASE, GHOSTTY_MOUSE_LEFT,
                               modsFromFlags(event.modifierFlags));
}

- (void)rightMouseDown:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
  ghostty_surface_mouse_button(_surface, GHOSTTY_MOUSE_PRESS, GHOSTTY_MOUSE_RIGHT,
                               modsFromFlags(event.modifierFlags));
}

- (void)rightMouseUp:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
  ghostty_surface_mouse_button(_surface, GHOSTTY_MOUSE_RELEASE, GHOSTTY_MOUSE_RIGHT,
                               modsFromFlags(event.modifierFlags));
}

- (void)mouseMoved:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
}

- (void)mouseDragged:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
}

- (void)rightMouseDragged:(NSEvent *)event {
  if (!_surface) return;
  NSPoint p = [self surfacePoint:event];
  ghostty_surface_mouse_pos(_surface, p.x, p.y, modsFromFlags(event.modifierFlags));
}

- (void)scrollWheel:(NSEvent *)event {
  if (!_surface) return;
  double dx = event.scrollingDeltaX;
  double dy = event.scrollingDeltaY;
  ghostty_input_scroll_mods_t smods = 0;
  if (event.hasPreciseScrollingDeltas) smods |= 1;
  ghostty_surface_mouse_scroll(_surface, dx, dy, smods);
}

// ---------------------------------------------------------------------------
// Keyboard input
// ---------------------------------------------------------------------------

- (void)keyDown:(NSEvent *)event {
  if (!_surface) return;

  ghostty_input_key_s key_ev = {0};
  key_ev.action = GHOSTTY_ACTION_PRESS;
  if (event.isARepeat) key_ev.action = GHOSTTY_ACTION_REPEAT;
  key_ev.keycode = event.keyCode;
  key_ev.mods = modsFromFlags(event.modifierFlags);
  key_ev.consumed_mods = consumedModsFromFlags(event.modifierFlags);

  // unshifted codepoint
  NSString *unshifted = [event charactersByApplyingModifiers:0];
  if (unshifted.length > 0) {
    key_ev.unshifted_codepoint = [unshifted characterAtIndex:0];
  }

  // text for character input
  NSString *chars = event.characters;
  if (chars.length == 1) {
    unichar ch = [chars characterAtIndex:0];
    // Skip control characters (handled by Ghostty) and PUA (function keys)
    if (ch < 0x20) {
      NSString *noCtrl = [event charactersByApplyingModifiers:
        event.modifierFlags & ~NSEventModifierFlagControl];
      if (noCtrl.length > 0) chars = noCtrl;
      else chars = nil;
    } else if (ch >= 0xF700 && ch <= 0xF8FF) {
      chars = nil;
    }
  }

  key_ev.text = chars ? chars.UTF8String : NULL;
  key_ev.composing = false;

  bool handled = ghostty_surface_key(_surface, key_ev);
  if (!handled) {
    [self interpretKeyEvents:@[event]];
  }
}

- (void)keyUp:(NSEvent *)event {
  if (!_surface) return;

  ghostty_input_key_s key_ev = {0};
  key_ev.action = GHOSTTY_ACTION_RELEASE;
  key_ev.keycode = event.keyCode;
  key_ev.mods = modsFromFlags(event.modifierFlags);
  key_ev.consumed_mods = consumedModsFromFlags(event.modifierFlags);
  key_ev.unshifted_codepoint = 0;
  key_ev.text = NULL;
  key_ev.composing = false;

  ghostty_surface_key(_surface, key_ev);
}

- (void)flagsChanged:(NSEvent *)event {
  if (!_surface) return;

  ghostty_input_key_e key = keyCodeToGhostty(event.keyCode);
  if (key == GHOSTTY_KEY_UNIDENTIFIED) return;

  // Determine press/release by checking if the modifier bit is set
  BOOL pressed = NO;
  switch (event.keyCode) {
    case 0x38: case 0x3C: pressed = !!(event.modifierFlags & NSEventModifierFlagShift); break;
    case 0x3B: case 0x3E: pressed = !!(event.modifierFlags & NSEventModifierFlagControl); break;
    case 0x3A: case 0x3D: pressed = !!(event.modifierFlags & NSEventModifierFlagOption); break;
    case 0x37: case 0x36: pressed = !!(event.modifierFlags & NSEventModifierFlagCommand); break;
    case 0x39: pressed = !!(event.modifierFlags & NSEventModifierFlagCapsLock); break;
    default: return;
  }

  ghostty_input_key_s key_ev = {0};
  key_ev.action = pressed ? GHOSTTY_ACTION_PRESS : GHOSTTY_ACTION_RELEASE;
  key_ev.keycode = event.keyCode;
  key_ev.mods = modsFromFlags(event.modifierFlags);
  key_ev.consumed_mods = (ghostty_input_mods_e)GHOSTTY_MODS_NONE;
  key_ev.text = NULL;
  key_ev.composing = false;

  ghostty_surface_key(_surface, key_ev);
}

// ---------------------------------------------------------------------------
// NSTextInputClient (IME)
// ---------------------------------------------------------------------------

- (void)insertText:(id)string replacementRange:(NSRange)replacementRange {
  if (!_surface) return;
  NSString *str = [string isKindOfClass:[NSAttributedString class]]
    ? [string string] : string;
  if (str.length > 0) {
    ghostty_surface_text(_surface, str.UTF8String, strlen(str.UTF8String));
  }
}

- (void)setMarkedText:(id)string selectedRange:(NSRange)selectedRange
     replacementRange:(NSRange)replacementRange {
  if (!_surface) return;
  NSString *str = [string isKindOfClass:[NSAttributedString class]]
    ? [string string] : string;
  if (str.length > 0) {
    ghostty_surface_preedit(_surface, str.UTF8String, strlen(str.UTF8String));
  }
}

- (void)unmarkText {
  if (_surface) ghostty_surface_preedit(_surface, NULL, 0);
}

- (NSRange)selectedRange { return NSMakeRange(NSNotFound, 0); }
- (NSRange)markedRange { return NSMakeRange(NSNotFound, 0); }
- (BOOL)hasMarkedText { return NO; }
- (NSAttributedString *)attributedSubstringForProposedRange:(NSRange)range
                                                actualRange:(NSRangePointer)actualRange {
  return nil;
}
- (NSArray<NSAttributedStringKey> *)validAttributesForMarkedText { return @[]; }
- (NSRect)firstRectForCharacterRange:(NSRange)range
                         actualRange:(NSRangePointer)actualRange {
  if (_surface) {
    double x = 0, y = 0, w = 0, h = 0;
    ghostty_surface_ime_point(_surface, &x, &y, &w, &h);
    NSRect r = NSMakeRect(x, self.bounds.size.height - y - h, w, h);
    return [self.window convertRectToScreen:[self convertRect:r toView:nil]];
  }
  return NSZeroRect;
}
- (NSUInteger)characterIndexForPoint:(NSPoint)point { return NSNotFound; }

// ---------------------------------------------------------------------------
// React props
// ---------------------------------------------------------------------------

- (void)setCwd:(NSString *)cwd {
  _cwd = [cwd copy];
  // Prop can only be set before surface creation
}

- (void)setCommand:(NSString *)command {
  _command = [command copy];
}

- (void)setFontSize:(float)fontSize {
  _fontSize = fontSize;
}

- (void)setFontFamily:(NSString *)fontFamily {
  _fontFamily = [fontFamily copy];
}

@end

// ---------------------------------------------------------------------------
// RCTGhosttyTerminalManager (RCTViewManager)
// ---------------------------------------------------------------------------

@interface RCTGhosttyTerminalManager : RCTViewManager
@end

@implementation RCTGhosttyTerminalManager

RCT_EXPORT_MODULE(GhosttyTerminal)

- (NSView *)view {
  return [[RCTGhosttyTerminalView alloc] initWithFrame:CGRectZero];
}

RCT_EXPORT_VIEW_PROPERTY(onTitle, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onBell, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onExit, RCTBubblingEventBlock)
RCT_CUSTOM_VIEW_PROPERTY(cwd, NSString, RCTGhosttyTerminalView) {
  if (json) view.cwd = [json description];
}
RCT_CUSTOM_VIEW_PROPERTY(command, NSString, RCTGhosttyTerminalView) {
  if (json) view.command = [json description];
}
RCT_CUSTOM_VIEW_PROPERTY(fontSize, float, RCTGhosttyTerminalView) {
  if (json) view.fontSize = [json floatValue];
}
RCT_CUSTOM_VIEW_PROPERTY(fontFamily, NSString, RCTGhosttyTerminalView) {
  if (json) view.fontFamily = [json description];
}

@end
