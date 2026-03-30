const std = @import("std");
const pixttf = @import("root");
const dvui = @import("dvui");

const GreeterDialog = @This();

pub fn show() bool {
    var dialog_win = dvui.floatingWindow(@src(), .{
        .modal = true,
        .stay_above_parent_window = true,
        .resize = .none,
    }, .{
        .max_size_content = .width(600),
        .background = false,
        .border = .all(0),
        .gravity_x = 0.5,
        .gravity_y = 0.5,
    });
    defer dialog_win.deinit();
    dialog_win.drag_area = .{};

    // const extra_stuff: *bool = dvui.dataGetPtrDefault(null, dialog_win.data().id, "extra_stuff", bool, false);
    // const render_offscreen: *bool = dvui.dataGetPtrDefault(null, dialog_win.data().id, "render_offscreen", bool, true);
    // const alpha: *f32 = dvui.dataGetPtrDefault(null, dialog_win.data().id, "alpha", f32, 1.0);

    // background for dialog_win (since it has background false)
    var back = dvui.box(@src(), .{}, .{
        .expand = .both,
        .style = .window,
        .background = true,
        .border = .all(2),
        .min_size_content = .width(600),
        .color_fill = pixttf.theme.color.bg_panel_dark,
        .color_border = pixttf.theme.color.border_focus,
    });
    defer back.deinit();

    {
        const header = dvui.box(@src(), .{}, .{
            .expand = .horizontal,
            .background = true,
            .color_fill = pixttf.theme.color.bg_app,
        });
        defer header.deinit();

        const banner = dvui.image(@src(), .{
            .source = dvui.ImageSource{
                .imageFile = .{
                    .bytes = pixttf.assets.files.@"banner.png",
                },
            },
            .shrink = .both,
        }, .{
            .background = true,
            .color_fill = pixttf.theme.color.bg_app,
            .max_size_content = .{ .w = 760 * 0.5, .h = 290 * 0.5 },
            .gravity_x = 0.5,
        });
        _ = banner;
    }

    var hbox = dvui.box(@src(), .{ .dir = .horizontal, .equal_space = true }, .{ .expand = .horizontal, .margin = .all(20) });
    defer hbox.deinit();

    var title_font: dvui.Font = .theme(.title);
    title_font.size = 32;

    var button_font: dvui.Font = .theme(.body);
    button_font.size = 12;

    {
        var vbox = dvui.box(@src(), .{ .dir = .vertical }, .{ .expand = .vertical });
        defer vbox.deinit();

        dvui.label(@src(), "Start", .{}, .{ .font = title_font, .color_text = pixttf.theme.color.accent });
        _ = dvui.button(@src(), "New File (Ctrl+N)", .{}, .{ .background = false, .font = button_font });
        _ = dvui.button(@src(), "Open File (Ctrl+O)", .{}, .{ .background = false, .font = button_font });
        _ = dvui.button(@src(), "Import TTF (Ctrl+T)", .{}, .{ .background = false, .font = button_font });
    }

    {
        var vbox = dvui.box(@src(), .{ .dir = .vertical }, .{ .expand = .vertical });
        defer vbox.deinit();

        dvui.label(@src(), "Read", .{}, .{ .font = title_font, .color_text = pixttf.theme.color.accent });
        _ = dvui.button(@src(), "Manual", .{}, .{ .background = false, .font = button_font });
        _ = dvui.button(@src(), "Release Notes", .{}, .{ .background = false, .font = button_font });
        _ = dvui.button(@src(), "About", .{}, .{ .background = false, .font = button_font });
    }

    for (dvui.events()) |*e| {
        if (!dvui.eventMatchSimple(e, dialog_win.data())) {
            switch (e.evt) {
                .mouse => |me| {
                    if (me.action == .press) {
                        e.handle(@src(), dialog_win.data());
                        return false;
                    }
                },
                else => continue,
            }
        }
    }
    return true;
}
