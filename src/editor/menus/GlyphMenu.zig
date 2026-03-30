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

    var box = dvui.box(@src(), .{}, .{ .margin = .all(5) });
    defer box.deinit();

    {
        var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{ .expand = .both });
        defer hbox.deinit();

        {
            var container = dvui.box(@src(), .{}, .{
                .background = true,
                .color_fill = pixttf.theme.color.bg_panel,
                .min_size_content = .all(60),
            });
            defer container.deinit();

            // encode the codepoint to UTF-8
            var buf: [5]u8 = .{0} ** 5;
            const byte_len = std.unicode.utf8Encode(pixttf.editor.active_codepoint, buf[0..4]) catch unreachable;
            const label: [:0]const u8 = buf[0..byte_len :0];
            if (dvui.labelClick(@src(), "{s}", .{label}, .{}, .{
                .font = dvui.Font.find(.{ .family = "fallback" }).larger(12),
                .gravity_x = 0.5,
                .gravity_y = 0.5,
            })) {
                const url = try std.fmt.allocPrint(pixttf.app.allocator, "https://codepoints.net/U+{X:0>4}", .{pixttf.editor.active_codepoint});
                defer pixttf.app.allocator.free(url);

                _ = dvui.openURL(.{ .url = url });
            }
        }
    }
}
