//! other potential names
//!   - PixelTTF (pttf)
//!   - Pixif
//!   - PixelFontManager (pfm) [good for cli usage]

const std = @import("std");
const dvui = @import("dvui");

// TODO: Should this just take the version from .zig.zon?
//       iirc theres no way to specify a pre field
pub const version: std.SemanticVersion = .{
    .major = 0,
    .minor = 0,
    .patch = 1,
    .pre = "alpha",
};
const title = std.fmt.comptimePrint("Pixtf {d}.{d}.{d}{s}", .{
    version.major, version.minor, version.patch, blk: {
        if (version.pre) |stage| {
            break :blk std.fmt.comptimePrint("-{s}", .{stage});
        }
        break :blk "";
    },
});

// modules
pub const App = @import("App.zig");
pub const Editor = @import("Editor.zig");

// widgets
pub const CanvasWidget = @import("widgets/CanvasWidget.zig");
pub fn canvasWidget(src: std.builtin.SourceLocation, init_opts: CanvasWidget.InitOpts, opts: dvui.Options) *CanvasWidget {
    var ret = dvui.widgetAlloc(CanvasWidget);
    ret.init(src, init_opts, opts);
    ret.data().was_allocated_on_widget_stack = true;
    ret.processEvents();
    ret.draw();
    return ret;
}

// global pointers
pub var app: *App = undefined;
pub var editor: *Editor = undefined;

pub const dvui_app: dvui.App = .{
    .config = .{
        .options = .{
            .size = .{ .w = 1200.0, .h = 650.0 },
            .min_size = .{ .w = 640.0, .h = 480.0 },
            .title = title,
            .window_init_options = .{},
        },
    },
    .frameFn = App.frame,
    .initFn = App.init,
    .deinitFn = App.deinit,
};
pub const main = dvui.App.main;
pub const panic = dvui.App.panic;
pub const std_options: std.Options = .{
    .logFn = dvui.App.logFn,
};
