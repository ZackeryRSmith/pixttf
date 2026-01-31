const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("pixttf.zig");
const dvui = @import("dvui");

const App = @This();
const Editor = pixttf.Editor;

allocator: std.mem.Allocator = undefined,
window: *dvui.Window = undefined,

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;

// runs before the first frame, after backend and dvui.Window.init()
pub fn init(window: *dvui.Window) !void {
    const allocator = gpa.allocator();

    std.log.info("creating pixtf.app", .{});
    pixtf.app = try allocator.create(App);
    pixtf.app.* = .{
        .allocator = allocator,
        .window = window,
    };

    std.log.info("creating pixtf.editor", .{});
    pixtf.editor = try allocator.create(Editor);
    pixtf.editor.* = try Editor.init(allocator);
}

// Run as app is shutting down before dvui.Window.deinit()
pub fn deinit() void {
    pixtf.editor.deinit();
}

// Run each frame to do normal UI
pub fn frame() !dvui.App.Result {
    return try pixtf.editor.tick();
}
