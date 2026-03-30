// TODO: I'd really like all the tabs to be replaced with just a box with text.
//       Unless I find a reason for tabs they're overkill here.
const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const CharacterSetMenu = @This();

// State now holds an index rather than an enum
selected_idx: usize = 0,

const names: [pixttf.charsets.len][:0]const u8 = blk: {
    var arr: [pixttf.charsets.len][:0]const u8 = undefined;
    for (pixttf.charsets, 0..) |cs, i| arr[i] = cs.name;
    break :blk arr;
};

pub fn init() !CharacterSetMenu {
    return .{};
}

pub fn deinit(character_set_menu: *CharacterSetMenu) void {
    _ = character_set_menu;
}

pub fn tick(self: *CharacterSetMenu) !void {
    var box = dvui.box(@src(), .{}, .{
        .expand = .both,
        .max_size_content = .{ .h = 100, .w = 100 },
    });
    defer box.deinit();

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

        dvui.labelNoFmt(@src(), "Character Set", .{}, .{});
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

    _ = dvui.dropdown(
        @src(),
        &names,
        .{ .choice = &self.selected_idx },
        .{},
        .{ .expand = .horizontal },
    );

    var scroll_area = dvui.scrollArea(@src(), .{}, .{ .expand = .horizontal });
    defer scroll_area.deinit();

    const active = pixttf.charsets[self.selected_idx];

    for (active.codepoints, 0..) |cp, i| {
        // encode the codepoint to UTF-8
        var buf: [5]u8 = .{0} ** 5;
        const byte_len = std.unicode.utf8Encode(cp, buf[0..4]) catch continue;
        const label: [:0]const u8 = buf[0..byte_len :0];

        if (dvui.button(@src(), label, .{}, .{
            .id_extra = i,
            .min_size_content = .{ .w = 28, .h = 28 },
        })) {
            // TODO: handle selected codepoint
            std.log.debug("selected codepoint U+{X:0>4}", .{cp});
        }
    }
}
