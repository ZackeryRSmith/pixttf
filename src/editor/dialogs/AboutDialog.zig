const std = @import("std");
const pixttf = @import("root");
const dvui = @import("dvui");

const AboutDialog = @This();

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

    var heading_font: dvui.Font = .theme(.heading);
    heading_font.size = 24;

    var content = dvui.box(@src(), .{}, .{ .margin = .all(20) });
    defer content.deinit();

    {
        var hbox = dvui.box(@src(), .{ .dir = .horizontal, .equal_space = true }, .{ .expand = .both });
        defer hbox.deinit();

        {
            var vbox = dvui.box(@src(), .{}, .{ .expand = .both });
            defer vbox.deinit();

            dvui.label(@src(), "About", .{}, .{ .font = heading_font, .color_text = pixttf.theme.color.accent });

            var tl = dvui.textLayout(@src(), .{}, .{ .background = false, .expand = .horizontal });
            defer tl.deinit();

            tl.addText("An app to create and edit pixel fonts powered by ", .{});
            tl.addLink(.{ .text = "Zig", .url = "https://github.com/ziglang/zig" }, .{});
            tl.addText(" and ", .{});
            tl.addLink(.{ .text = "DVUI", .url = "https://github.com/david-vanderson/dvui" }, .{});
            tl.addTextDone(.{});
        }
        {
            var vbox = dvui.box(@src(), .{}, .{});
            defer vbox.deinit();

            dvui.label(@src(), "Resources", .{}, .{ .font = heading_font, .color_text = pixttf.theme.color.accent });
            dvui.label(@src(), "Github", .{}, .{});
        }
    }

    {
        var vbox = dvui.box(@src(), .{}, .{});
        defer vbox.deinit();

        dvui.label(@src(), "With Huge Thanks To", .{}, .{ .font = heading_font, .color_text = pixttf.theme.color.accent });

        var tl = dvui.textLayout(@src(), .{}, .{ .background = false, .expand = .horizontal });
        defer tl.deinit();

        tl.addLink(.{ .text = "Sergi Lázaro", .url = "https://sergilazaro.com/" }, .{});
        tl.addText(" for creating ", .{});
        tl.addLink(.{ .text = "PixelForge", .url = "https://pixel-forge.com/" }, .{});
        tl.addText(" the inspiration for this project.\n", .{});

        tl.addLink(.{ .text = "David Vanderson", .url = "https://github.com/david-vanderson" }, .{});
        tl.addText(" for ", .{});
        tl.addLink(.{ .text = "DVUI", .url = "https://github.com/david-vanderson/dvui" }, .{});
        tl.addText(" and all the help!\n", .{});

        tl.addLink(.{ .text = "Foxnne", .url = "https://github.com/foxnne" }, .{});
        tl.addText(" for creating ", .{});
        tl.addLink(.{ .text = "Pixi", .url = "https://github.com/foxnne/pixi" }, .{});
        tl.addText(" which much of PixTTF is based on.", .{});
        tl.addTextDone(.{});
    }

    for (dvui.events()) |*e| {
        if (!dvui.eventMatchSimple(e, dialog_win.data())) {
            switch (e.evt) {
                .mouse => |me| {
                    if (me.action == .press and !back.data().rect.contains(dialog_win.screenRectScale(.{}).pointFromPhysical(me.p))) {
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
