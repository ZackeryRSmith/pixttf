const std = @import("std");
const pixttf = @import("root");
const dvui = @import("dvui");

const SettingsDialog = @This();

pub fn show() void {
    var id_mutex = dvui.dialogAdd(null, @src(), 0, render);
    defer id_mutex.mutex.unlock();
}

pub fn render(id: dvui.Id) !void {
    const showing = dvui.dataGetPtrDefault(null, id, "showing", bool, true);

    var dialog_win = dvui.floatingWindow(@src(), .{
        .modal = false,
        .stay_above_parent_window = true,
        .resize = .all,
        .open_flag = showing,
    }, .{
        .max_size_content = .width(600),
        .background = false,
        .border = .all(0),
        .gravity_x = 0.5,
        .gravity_y = 0.5,
    });
    defer dialog_win.deinit();

    var titlebar = dvui.box(@src(), .{}, .{
        .expand = .both,
        .style = .window,
        .background = true,
        .border = .all(2),
        .min_size_content = .width(600),
        .color_fill = pixttf.theme.color.bg_panel_alt,
        .color_border = pixttf.theme.color.border_focus,
    });
    defer titlebar.deinit();

    dialog_win.dragAreaSet(dvui.windowHeader("Settings", "", showing));

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

    dvui.label(@src(), "There's an unsaved document. Are you sure you want to exit?", .{}, .{});
    dvui.label(@src(), "Unsaved changes will be lost!", .{}, .{});

    _ = dvui.separator(@src(), .{});

    var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{});
    defer hbox.deinit();

    _ = dvui.button(@src(), "Exit", .{}, .{});
    _ = dvui.button(@src(), "Cancel", .{}, .{});

    if (!showing.*) {
        dvui.dialogRemove(id);
    }
}
