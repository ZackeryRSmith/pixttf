const std = @import("std");
const builtin = @import("builtin");

const pixttf = @import("pixttf.zig");
const dvui = @import("dvui");

const App = pixttf.App;
const Editor = @This();
const MenuBar = @import("MenuBar.zig");
const StatusBar = @import("StatusBar.zig");

const GlyphMenu = @import("menus/GlyphMenu.zig");
const CharacterSetMenu = @import("menus/CharacterSetMenu.zig");
const TextPreviewMenu = @import("menus/TextPreviewMenu.zig");

menu_bar: *MenuBar,
status_bar: *StatusBar,

glyph_menu: *GlyphMenu,
character_set_menu: *CharacterSetMenu,
text_preview_menu: *TextPreviewMenu,

pub fn init(allocator: std.mem.Allocator) !Editor {
    std.log.info("creating pixtf.app.editor.menu_bar", .{});
    const menu_bar: *MenuBar = try allocator.create(MenuBar);
    menu_bar.* = MenuBar.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.status_bar", .{});
    const status_bar: *StatusBar = try allocator.create(StatusBar);
    status_bar.* = StatusBar.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.menus.glyph_panel", .{});
    const glyph_menu: *GlyphMenu = try allocator.create(GlyphMenu);
    glyph_menu.* = GlyphMenu.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.menus.character_set_panel", .{});
    const character_set_menu: *CharacterSetMenu = try allocator.create(CharacterSetMenu);
    character_set_menu.* = CharacterSetMenu.init() catch unreachable;

    std.log.info("creating pixtf.app.editor.menus.text_preview_panel", .{});
    const text_preview_menu: *TextPreviewMenu = try allocator.create(TextPreviewMenu);
    text_preview_menu.* = TextPreviewMenu.init() catch unreachable;

    return .{
        .menu_bar = menu_bar,
        .status_bar = status_bar,
        // .canvas_panel = canvas_panel,
        .glyph_menu = glyph_menu,
        .character_set_menu = character_set_menu,
        .text_preview_menu = text_preview_menu,
    };
}

pub fn deinit(editor: *Editor) void {
    editor.menu_bar.deinit();
    editor.glyph_menu.deinit();
    editor.character_set_menu.deinit();
    editor.text_preview_menu.deinit();
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

                try editor.glyph_menu.tick();
                try editor.character_set_menu.tick();
                try editor.text_preview_menu.tick();
            }

            var canvas = pixttf.canvasWidget(@src(), .{}, .{ .expand = .both, .style = .window });
            defer canvas.deinit();
        }
        try editor.status_bar.tick();
    }
    return .ok;
}
