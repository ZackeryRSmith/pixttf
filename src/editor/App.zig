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
}

// Run as app is shutting down before dvui.Window.deinit()
pub fn deinit() void {
    pixttf.editor.deinit();
}

// Run each frame to do normal UI
pub fn frame() !dvui.App.Result {
    return try pixttf.editor.tick();
}
