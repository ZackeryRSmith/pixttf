const std = @import("std");
const dvui = @import("dvui");
const pixttf = @import("../pixttf.zig");

const GreeterDialog = @This();

window: dvui.FloatingWindowWidget = undefined,

pub fn show() bool {
    return true;
}

// from dvui/Examples.zig
// NOTE: this should be removed and is only here for refrence
// pub fn dialogDirect() void {
//     const uniqueId = dvui.parentGet().extendId(@src(), 0);
//     const allow_resize = dvui.dataGetPtrDefault(null, uniqueId, "allow_resize", bool, true);

//     var dialog_win = dvui.floatingWindow(@src(), .{ .modal = false, .open_flag = &show_dialog, .resize = if (allow_resize.*) .all else .none }, .{ .max_size_content = .width(500), .background = false, .border = .all(0) });
//     defer dialog_win.deinit();

//     const extra_stuff: *bool = dvui.dataGetPtrDefault(null, dialog_win.data().id, "extra_stuff", bool, false);
//     const render_offscreen: *bool = dvui.dataGetPtrDefault(null, dialog_win.data().id, "render_offscreen", bool, true);
//     const alpha: *f32 = dvui.dataGetPtrDefault(null, dialog_win.data().id, "alpha", f32, 1.0);

//     var pic: ?dvui.Picture = null;
//     if (render_offscreen.*) {
//         // Render contents to buffer so the alpha is applied a single time to the
//         // whole thing
//         pic = dvui.Picture.start(dialog_win.data().rectScale().r);
//     } else {
//         dvui.alphaSet(alpha.*);
//     }

//     // background for dialog_win (since it has background false)
//     var back = dvui.box(@src(), .{}, .{ .expand = .both, .style = .window, .background = true, .border = .all(1), .corner_radius = .all(5) });
//     defer back.deinit();

//     dialog_win.dragAreaSet(dvui.windowHeader("Dialog", "", &show_dialog));
//     dvui.label(@src(), "Asking a Question", .{}, .{ .font = .theme(.title), .gravity_x = 0.5 });
//     dvui.label(@src(), "This dialog is directly called by user code.", .{}, .{ .gravity_x = 0.5 });

//     _ = dvui.checkbox(@src(), allow_resize, "Allow Resizing", .{});

//     {
//         var box = dvui.box(@src(), .{ .dir = .horizontal }, .{});
//         defer box.deinit();
//         _ = dvui.checkbox(@src(), render_offscreen, "Render Offscreen", .{});
//         _ = dvui.sliderEntry(@src(), "alpha: {d:0.2}", .{ .value = alpha, .min = 0, .max = 1, .interval = 0.01 }, .{});
//     }

//     {
//         var box = dvui.box(@src(), .{}, .{ .min_size_content = .all(100), .background = true, .color_fill = .green });
//         defer box.deinit();

//         var box2 = dvui.box(@src(), .{}, .{ .min_size_content = .all(80), .background = true, .color_fill = .blue });
//         defer box2.deinit();

//         var box3 = dvui.box(@src(), .{}, .{ .min_size_content = .all(60), .background = true, .color_fill = .red });
//         defer box3.deinit();
//     }

//     if (dvui.button(@src(), "Toggle extra stuff and fit window", .{}, .{ .tab_index = 1 })) {
//         extra_stuff.* = !extra_stuff.*;
//         dialog_win.autoSize();
//     }

//     if (extra_stuff.*) {
//         dvui.label(@src(), "This is some extra stuff\nwith a multi-line label\nthat has 3 lines", .{}, .{ .margin = .{ .x = 4 } });

//         var tl = dvui.textLayout(@src(), .{}, .{});
//         tl.addText("Here is a textLayout with a bunch of text in it that would overflow the right edge but the dialog has a max_size_content", .{});
//         tl.deinit();
//     }

//     {
//         _ = dvui.spacer(@src(), .{ .expand = .vertical });
//         var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{ .gravity_x = 1.0 });
//         defer hbox.deinit();

//         const gravx: f32, const tindex: u16 = switch (dvui.currentWindow().button_order) {
//             .cancel_ok => .{ 1.0, 4 },
//             .ok_cancel => .{ 0.0, 2 },
//         };

//         if (dvui.button(@src(), "Yes", .{}, .{ .gravity_x = gravx, .tab_index = tindex })) {
//             dialog_win.close(); // can close the dialog this way
//         }

//         if (dvui.button(@src(), "No", .{}, .{ .tab_index = 3 })) {
//             show_dialog = false; // can close by not running this code anymore
//         }
//     }

//     if (pic) |*p| {
//         p.stop();
//         dvui.alphaSet(alpha.*);

//         // here is where the picture is rendered to the screen
//         p.deinit();
//     }

//     dvui.alphaSet(1.0);
// }
