const std = @import("std");
const dvui = @import("dvui");
pub const assets = @import("assets");

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
pub const App = @import("editor/App.zig");
pub const Theme = @import("editor/Theme.zig");
pub const Editor = @import("editor/Editor.zig");

pub const charsets: []const @import("charsets/CharacterSet.zig") = &.{
    @import("charsets/ascii.zig").ascii,
    @import("charsets/adobe_latin.zig").adobe_latin_1,
    @import("charsets/adobe_latin.zig").adobe_latin_2,
    @import("charsets/adobe_latin.zig").adobe_latin_3,
    @import("charsets/adobe_latin.zig").adobe_latin_4,
};

// dialogs
pub const GreeterDialog = @import("editor/dialogs/GreeterDialog.zig");
pub const AboutDialog = @import("editor/dialogs/AboutDialog.zig");
pub const EditWarningDialog = @import("editor/dialogs/ExitWarningDialog.zig");
pub const SettingsDialog = @import("editor/dialogs/SettingsDialog.zig");

// TODO: might make more sense for this to be a file under editor/widgets
// widgets
pub const CanvasWidget = @import("editor/widgets/CanvasWidget.zig");
pub fn canvas(src: std.builtin.SourceLocation, init_opts: CanvasWidget.InitOpts, opts: dvui.Options) *CanvasWidget {
    var ret = dvui.widgetAlloc(CanvasWidget);
    ret.init(src, init_opts, opts);
    ret.processEvents();
    ret.draw();
    return ret;
}

pub const RadialMenuWidget = @import("editor/widgets/RadialMenuWidget.zig");
pub fn radialMenu(src: std.builtin.SourceLocation, init_opts: RadialMenuWidget.InitOpts, opts: dvui.Options) *RadialMenuWidget {
    var ret = dvui.widgetAlloc(RadialMenuWidget);
    ret.init(src, init_opts, opts);
    // ret.processEvents();
    ret.draw();
    return ret;
}

// global pointers
pub var app: *App = undefined;
pub var editor: *Editor = undefined;
pub var theme: Theme = undefined;

pub const dvui_app: dvui.App = .{
    .config = .{
        .options = .{
            .size = .{ .w = 1200.0, .h = 650.0 },
            .min_size = .{ .w = 640.0, .h = 480.0 },
            .title = title,
            .icon = assets.files.@"icon.png",
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
