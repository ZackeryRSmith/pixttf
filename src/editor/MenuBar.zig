const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const App = pixttf.App;
const MenuBar = @This();

pub fn init() !MenuBar {
    return .{};
}

pub fn deinit(menubar: *MenuBar) void {
    _ = menubar;
}

pub fn tick(menubar: *MenuBar) !dvui.App.Result {
    _ = menubar;

    {
        var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{ .style = .window, .background = true, .expand = .horizontal });
        defer hbox.deinit();

        var m = dvui.menu(@src(), .horizontal, .{});
        defer m.deinit();

        if (dvui.menuItemLabel(@src(), "File", .{ .submenu = true }, .{ .tag = "first-focusable" })) |r| {
            var animator = dvui.animate(@src(), .{
                .kind = .alpha,
                .duration = 250_000,
            }, .{
                .expand = .both,
            });
            defer animator.deinit();

            var fw = dvui.floatingMenu(@src(), .{ .from = r }, .{});
            defer fw.deinit();

            if (dvui.menuItemLabel(@src(), "Close Menu", .{}, .{ .expand = .horizontal }) != null) {
                m.close();
            }

            if (dvui.backend.kind != .web) {
                if (dvui.menuItemLabel(@src(), "Exit", .{}, .{ .expand = .horizontal }) != null) {
                    return .close;
                }
            }
        }

        if (dvui.menuItemLabel(@src(), "Edit", .{ .submenu = true }, .{})) |r| {
            var animator = dvui.animate(@src(), .{
                .kind = .alpha,
                .duration = 250_000,
            }, .{
                .expand = .both,
            });
            defer animator.deinit();

            var fw = dvui.floatingMenu(@src(), .{ .from = r }, .{});
            defer fw.deinit();

            if (dvui.menuItemLabel(@src(), "Undo", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Redo", .{}, .{ .expand = .horizontal }) != null) {}
            labeledSeparator(@src(), "Meta");
            if (dvui.menuItemLabel(@src(), "Font Properties", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Settings", .{}, .{ .expand = .horizontal }) != null) {}
        }

        if (dvui.menuItemLabel(@src(), "View", .{ .submenu = true }, .{})) |r| {
            var animator = dvui.animate(@src(), .{
                .kind = .alpha,
                .duration = 250_000,
            }, .{
                .expand = .both,
            });
            defer animator.deinit();

            var fw = dvui.floatingMenu(@src(), .{ .from = r }, .{});
            defer fw.deinit();

            labeledSeparator(@src(), "Editor");
            if (dvui.menuItemLabel(@src(), "Return HOME", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Zoom IN", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Zoom OUT", .{}, .{ .expand = .horizontal }) != null) {}

            labeledSeparator(@src(), "Misc");
            if (dvui.menuItemLabel(@src(), "Debug Window", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Demo Window", .{}, .{ .expand = .horizontal }) != null) {}
        }

        if (dvui.menuItemLabel(@src(), "Help", .{ .submenu = true }, .{})) |r| {
            var animator = dvui.animate(@src(), .{
                .kind = .alpha,
                .duration = 250_000,
            }, .{
                .expand = .both,
            });
            defer animator.deinit();

            var fw = dvui.floatingMenu(@src(), .{ .from = r }, .{});
            defer fw.deinit();

            if (dvui.menuItemLabel(@src(), "Manual", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "Release Notes", .{}, .{ .expand = .horizontal }) != null) {}
            labeledSeparator(@src(), "Misc");
            if (dvui.menuItemLabel(@src(), "Tutorial", .{}, .{ .expand = .horizontal }) != null) {}
            if (dvui.menuItemLabel(@src(), "About", .{}, .{ .expand = .horizontal }) != null) {}
        }
    }

    return .ok;
}
fn labeledSeparator(src: std.builtin.SourceLocation, str: []const u8) void {
    var hbox = dvui.box(src, .{ .dir = .horizontal }, .{ .expand = .horizontal });
    defer hbox.deinit();

    dvui.labelNoFmt(@src(), str, .{}, .{ .color_text = dvui.themeGet().border });
    _ = dvui.separator(@src(), .{ .expand = .horizontal, .gravity_y = 0.5 });
}
