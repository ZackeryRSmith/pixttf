const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const App = @This();
const Editor = pixttf.Editor;
const Theme = @import("Theme.zig");

allocator: std.mem.Allocator = undefined,
window: *dvui.Window = undefined,

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
var should_show_greeter: bool = true;

// runs before the first frame, after backend and dvui.Window.init()
pub fn init(window: *dvui.Window) !void {
    const allocator = gpa.allocator();

    std.log.info("creating pixtf.app", .{});
    pixttf.app = try allocator.create(App);
    pixttf.app.* = .{
        .allocator = allocator,
        .window = window,
    };

    std.log.info("creating pixtf.editor", .{});
    pixttf.editor = try allocator.create(Editor);
    pixttf.editor.* = try Editor.init(allocator);

    pixttf.theme = try Theme.fromJson(allocator, "assets/themes/classic_dark.json");

    // TODO: Theme should probably do this
    var default_font = dvui.Font.find(.{ .family = "pixelcode" });
    default_font.size = 17;
    var bold_font = dvui.Font.find(.{ .family = "pixelcode-bold" });
    bold_font.size = 28;

    var dvui_theme = dvui.themeGet();
    dvui_theme.font_body = default_font;
    dvui_theme.font_heading = bold_font;
    dvui_theme.font_title = bold_font;
    dvui.themeSet(dvui_theme);
}

// run as app is shutting down before dvui.Window.deinit()
pub fn deinit() void {
    pixttf.editor.deinit();
}

// run each frame to do normal UI
pub fn frame() !dvui.App.Result {
    if (should_show_greeter)
        should_show_greeter = pixttf.GreeterDialog.show();
    return try pixttf.editor.tick();
}
