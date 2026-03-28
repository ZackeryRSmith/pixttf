const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
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
        var tabs = dvui.tabs(@src(), .{ .draw_focus = false }, .{
            .expand = .horizontal,
            .color_fill = pixttf.theme.color.bg_app,
            .background = true,
        });
        defer tabs.deinit();

        var tab = tabs.addTab(true, .{
            .color_fill = pixttf.theme.color.bg_app,
            .color_fill_press = pixttf.theme.color.bg_app,
            .color_fill_hover = pixttf.theme.color.bg_app,
        });
        defer tab.deinit();

        dvui.labelNoFmt(@src(), "Glyph", .{}, .{});
    }

    var border = dvui.Rect.all(1);
    border.y = 0;
    var vbox = dvui.box(@src(), .{}, .{
        .expand = .both,
        .style = .window,
        .border = border,
        .role = .tab_panel,
        .color_fill = pixttf.theme.color.bg_app,
        .background = true,
    });
    defer vbox.deinit();

    dvui.labelNoFmt(@src(), "This is so flippin glyph", .{}, .{ .expand = .both, .gravity_x = 0.5, .gravity_y = 0.5 });
}
