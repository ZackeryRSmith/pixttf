const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("pixttf.zig");
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

    std.log.info("loading classic_dark theme", .{});
    var theme = try Theme.fromJson(allocator, "/Users/zackerysmith/Projects/Zig/pixttf/src/themes/classic_dark.json");
    defer theme.deinit();

    // std.log.debug("\t\tname: {s}", .{theme.name});
    // std.log.debug("\t\tauthor: {s}", .{theme.author});
    // std.log.debug("\t\tversion: {s}", .{theme.version});
    // std.log.debug("\t\tlicense: {s}", .{theme.license});
    // std.log.debug("\t\tsource: {s}", .{theme.source});
    // std.log.debug("\t\tdata: {any}", .{theme.data});
}

// Run as app is shutting down before dvui.Window.deinit()
pub fn deinit() void {
    pixttf.editor.deinit();
}

// Run each frame to do normal UI
pub fn frame() !dvui.App.Result {
    return try pixttf.editor.tick();
}
