const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const StatusBar = @This();

pub fn init() !StatusBar {
    return .{};
}

pub fn deinit(status_bar: *StatusBar) void {
    _ = status_bar;
}

pub fn tick(status_bar: *StatusBar) !void {
    _ = status_bar;

    var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{ .style = .window, .background = true, .expand = .horizontal, .gravity_y = 1 });
    defer hbox.deinit();

    dvui.label(@src(), "no glyphs", .{}, .{});
    dvui.label(@src(), "0,0", .{}, .{ .gravity_x = 0.9 });
    dvui.label(@src(), "50.0x", .{}, .{ .gravity_x = 1 });
}
