const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const App = pixttf.App;
const Editor = @This();
const MenuBar = @import("MenuBar.zig");
const StatusBar = @import("StatusBar.zig");

const GlyphMenu = @import("menus/GlyphMenu.zig");
const CharacterSetMenu = @import("menus/CharacterSetMenu.zig");
const TextPreviewMenu = @import("menus/TextPreviewMenu.zig");

const Glyph = struct {
    strokes: std.ArrayList(PixelPosition),
};

// TODO: Would be useful to show in the editor the limitations of the software.
//       It's very unlikely and unpractical for a pixel font to be larger than
//       this though. Maybe clicking outside of the drawable space gives a message like:
//       "You cannot draw outside this space, this is a limitation builtin to PixTTF.
//        if you need space outside of this area please file an issue or contact me at ..."
pub const PixelPosition = struct {
    x: i16,
    y: i16,
};

allocator: std.mem.Allocator,

menu_bar: *MenuBar,
status_bar: *StatusBar,

glyph_menu: *GlyphMenu,
character_set_menu: *CharacterSetMenu,
text_preview_menu: *TextPreviewMenu,

glyphs: std.AutoHashMap(u21, Glyph),
active_codepoint: u21 = 'A',

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

    var editor = Editor{
        .allocator = allocator,
        .glyphs = std.AutoHashMap(u21, Glyph).init(allocator),
        .active_codepoint = 'A',
        .menu_bar = menu_bar,
        .status_bar = status_bar,
        .glyph_menu = glyph_menu,
        .character_set_menu = character_set_menu,
        .text_preview_menu = text_preview_menu,
    };

    try editor.switchGlyph('A');

    return editor;
}

pub fn deinit(self: *Editor) void {
    self.menu_bar.deinit();
    self.glyph_menu.deinit();
    self.character_set_menu.deinit();
    self.text_preview_menu.deinit();
    self.status_bar.deinit();

    var it = self.glyphs.valueIterator();
    while (it.next()) |glyph| {
        glyph.strokes.deinit(self.allocator);
    }
    self.glyphs.deinit();
}

pub fn tick(self: *Editor) !dvui.App.Result {
    var vbox = dvui.box(@src(), .{}, .{
        .expand = .both,
        .style = .content,
        .color_fill = pixttf.theme.color.bg_app,
        .background = true,
    });
    defer vbox.deinit();
    {
        const res = try self.menu_bar.tick();
        if (res != .ok) return res;

        {
            var hbox = dvui.box(@src(), .{ .dir = .horizontal }, .{
                .expand = .both,
                .style = .content,
                .color_fill = pixttf.theme.color.bg_app,
                .background = true,
            });
            defer hbox.deinit();
            {
                var vbox2 = dvui.box(@src(), .{ .dir = .vertical }, .{
                    .expand = .vertical,
                    .style = .content,
                    .color_fill = pixttf.theme.color.bg_app,
                    .background = true,
                    .min_size_content = .{ .w = 350 },
                });
                defer vbox2.deinit();

                try self.glyph_menu.tick();
                try self.character_set_menu.tick();
                try self.text_preview_menu.tick();
            }

            const glyph = self.activeGlyph().?;

            var canvas = pixttf.canvas(@src(), .{ .strokes = &glyph.strokes, .allocator = self.allocator }, .{ .expand = .both, .style = .content });
            defer canvas.deinit();

            // var radial_menu = pixttf.radialMenu(@src(), .{}, .{});
            // defer radial_menu.deinit();
        }
        try self.status_bar.tick();
    }
    return .ok;
}

pub fn activeGlyph(self: *Editor) ?*Glyph {
    return self.glyphs.getPtr(self.active_codepoint);
}

pub fn switchGlyph(self: *Editor, codepoint: u21) !void {
    // create entry if it doesn't exist yet (lazy init)
    const result = try self.glyphs.getOrPut(codepoint);
    if (!result.found_existing) {
        result.value_ptr.* = Glyph{
            .strokes = try std.ArrayList(PixelPosition).initCapacity(self.allocator, 0),
        };
    }
    self.active_codepoint = codepoint;
}
