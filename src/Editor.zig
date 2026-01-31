const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("pixttf.zig");
const dvui = @import("dvui");

const App = pixttf.App;
const Editor = @This();
const MenuBar = @import("MenuBar.zig");
const StatusBar = @import("StatusBar.zig");

// TODO: Worth moving all the panel logic to it's own file E.g. SideView.zig
//       Might cause issues with window docking in the future though...
const GlyphPanel = @import("panels/GlyphPanel.zig");
const CharacterSetPanel = @import("panels/CharacterSetPanel.zig");
const TextPreviewPanel = @import("panels/TextPreviewPanel.zig");

menu_bar: *MenuBar,
status_bar: *StatusBar,

glyph_panel: *GlyphPanel,
character_set_panel: *CharacterSetPanel,
text_preview_panel: *TextPreviewPanel,

pub fn init(allocator: std.mem.Allocator) !Editor {
    std.log.info("creating pixtf.app.editor.menu_bar", .{});
    const menu_bar: *MenuBar = try allocator.create(MenuBar);
    menu_bar.* = MenuBar.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.status_bar", .{});
    const status_bar: *StatusBar = try allocator.create(StatusBar);
    status_bar.* = StatusBar.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.panels.glyph_panel", .{});
    const glyph_panel: *GlyphPanel = try allocator.create(GlyphPanel);
    glyph_panel.* = GlyphPanel.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.panels.character_set_panel", .{});
    const character_set_panel: *CharacterSetPanel = try allocator.create(CharacterSetPanel);
    character_set_panel.* = CharacterSetPanel.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.panels.text_preview_panel", .{});
    const text_preview_panel: *TextPreviewPanel = try allocator.create(TextPreviewPanel);
    text_preview_panel.* = TextPreviewPanel.init() catch unreachable;

    return .{
        .menu_bar = menu_bar,
        .status_bar = status_bar,
        // .canvas_panel = canvas_panel,
        .glyph_panel = glyph_panel,
        .character_set_panel = character_set_panel,
        .text_preview_panel = text_preview_panel,
    };
}

pub fn deinit(editor: *Editor) void {
    editor.menu_bar.deinit();
    editor.glyph_panel.deinit();
    editor.character_set_panel.deinit();
    editor.text_preview_panel.deinit();
    //editor.canvas_panel.deinit();
    editor.status_bar.deinit();
}

pub fn tick(editor: *Editor) !dvui.App.Result {
    var vbox = dvui.box(@src(), .{}, .{ .expand = .both, .style = .content });
    defer vbox.deinit();
    {
        const res = try editor.menu_bar.tick();
        if (res != .ok) return res;

        {
            var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{ .expand = .both, .style = .content });
            defer hbox.deinit();
            {
                var vbox2 = dvui.box(@src(), .{ .dir = .vertical }, .{ .expand = .vertical, .style = .content, .min_size_content = .{ .w = 350 } });
                defer vbox2.deinit();

                try editor.glyph_panel.tick();
                try editor.character_set_panel.tick();
                try editor.text_preview_panel.tick();
            }

            var canvas = pixttf.canvasWidget(@src(), .{}, .{ .expand = .both, .style = .window });
            defer canvas.deinit();
        }
        try editor.status_bar.tick();
    }
    return .ok;
}
