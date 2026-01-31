// TODO: I'd really like all the tabs to be replaced with just a box with text
const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("../pixttf.zig");
const dvui = @import("dvui");

const CharacterSetPanel = @This();

pub fn init() !CharacterSetPanel {
    return .{};
}

pub fn deinit(character_set_panel: *CharacterSetPanel) void {
    _ = character_set_panel;
}

pub fn tick(character_set_panel: *CharacterSetPanel) !void {
    _ = character_set_panel;

    {
        var tabs = dvui.tabs(@src(), .{ .draw_focus = false }, .{ .expand = .horizontal });
        defer tabs.deinit();

        //_ = tabs.addTabLabel(true, "Glyph");
        var tab = tabs.addTab(true, .{
            .color_fill_press = dvui.themeGet().window.fill,
            .color_fill_hover = dvui.themeGet().window.fill,
        });
        defer tab.deinit();

        dvui.labelNoFmt(@src(), "Character Set", .{}, .{});
    }

    var border = dvui.Rect.all(1);
    border.y = 0;
    var vbox = dvui.box(@src(), .{}, .{ .expand = .both, .background = true, .style = .window, .border = border, .role = .tab_panel });
    defer vbox.deinit();

    dvui.labelNoFmt(@src(), "Well we set our characters... no?", .{}, .{ .expand = .both, .gravity_x = 0.5, .gravity_y = 0.5 });
}
