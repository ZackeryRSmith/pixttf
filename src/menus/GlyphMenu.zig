const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("../pixttf.zig");
const dvui = @import("dvui");

const GlyphMenu = @This();

pub fn init() !GlyphMenu {
    return .{};
}

pub fn deinit(glyph_menu: *GlyphMenu) void {
    _ = glyph_menu;
}

pub fn tick(glyph_menu: *GlyphMenu) !void {
    _ = glyph_menu;

    {
        var tabs = dvui.tabs(@src(), .{ .draw_focus = false }, .{ .expand = .horizontal });
        defer tabs.deinit();

        var tab = tabs.addTab(true, .{
            .color_fill_press = dvui.themeGet().window.fill,
            .color_fill_hover = dvui.themeGet().window.fill,
        });
        defer tab.deinit();

        dvui.labelNoFmt(@src(), "Glyph", .{}, .{});
    }

    var border = dvui.Rect.all(1);
    border.y = 0;
    var vbox = dvui.box(@src(), .{}, .{ .expand = .both, .background = true, .style = .window, .border = border, .role = .tab_panel });
    defer vbox.deinit();

    dvui.labelNoFmt(@src(), "This is so flippin glyph", .{}, .{ .expand = .both, .gravity_x = 0.5, .gravity_y = 0.5 });
}
