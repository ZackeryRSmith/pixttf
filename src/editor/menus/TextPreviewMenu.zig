const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const TextPreviewMenu = @This();

pub fn init() !TextPreviewMenu {
    return .{};
}

pub fn deinit(text_preview_menu: *TextPreviewMenu) void {
    _ = text_preview_menu;
}

pub fn tick(text_preview_menu: *TextPreviewMenu) !void {
    _ = text_preview_menu;

    {
        var tabs = dvui.tabs(@src(), .{ .draw_focus = false }, .{ .expand = .horizontal });
        defer tabs.deinit();

        var tab = tabs.addTab(true, .{
            .color_fill_press = dvui.themeGet().window.fill,
            .color_fill_hover = dvui.themeGet().window.fill,
        });
        defer tab.deinit();

        dvui.labelNoFmt(@src(), "Text Preview", .{}, .{});
    }

    var border = dvui.Rect.all(1);
    border.y = 0;
    var vbox = dvui.box(@src(), .{}, .{ .expand = .both, .background = true, .style = .window, .border = border, .role = .tab_panel });
    defer vbox.deinit();

    dvui.labelNoFmt(@src(), "You'd better be looking at text", .{}, .{ .expand = .both, .gravity_x = 0.5, .gravity_y = 0.5 });
}
