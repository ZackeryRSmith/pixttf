const std = @import("std");
const pixttf = @import("root");
const dvui = @import("dvui");

const ExitWarningDialog = @This();

pub fn show() bool {
    var dialog_win = dvui.floatingWindow(@src(), .{
        .modal = false,
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

    dialog_win.dragAreaSet(dvui.windowHeader("Exit", "", null));

    dvui.label(@src(), "There's an unsaved document. Are you sure you want to exit?", .{}, .{});
    dvui.label(@src(), "Unsaved changes will be lost!", .{}, .{});

    _ = dvui.separator(@src(), .{});

    var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{});
    defer hbox.deinit();

    _ = dvui.button(@src(), "Exit", .{}, .{});
    _ = dvui.button(@src(), "Cancel", .{}, .{});

    return true;
}
