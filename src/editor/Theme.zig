//! Essentially a dvui.Theme with JSON serialization and custom styling properties
const std = @import("std");
const pixttf = @import("root");
const dvui = @import("dvui");

const Theme = @This();

allocator: std.mem.Allocator,

// meta
name: []const u8,
author: []const u8,
version: []const u8,
license: []const u8,
source: []const u8,

color: Palette,

// TODO: fill these with decent defaults
pub const Palette = struct {
    /// outermost application background
    bg_app: dvui.Color = dvui.Color.white,
    /// draggable canvas background
    bg_canvas: dvui.Color = dvui.Color.white,
    /// elevated panels, sidebars, dialogs
    bg_panel: dvui.Color = dvui.Color.white,
    /// elevated panels, sidebars, dialogs
    bg_panel_alt: dvui.Color = dvui.Color.white,
    /// modal/popup overlay tint
    bg_overlay: dvui.Color = dvui.Color.white,

    /// general fill behind grid content
    grid_bg: dvui.Color = dvui.Color.white,
    /// lines between cells/rows
    grid_line: dvui.Color = dvui.Color.white,
    /// background of non-editable/locked regions
    grid_locked: dvui.Color = dvui.Color.white,

    /// primary brand/action color
    accent: dvui.Color = dvui.Color.white,
    accent_hover: dvui.Color = dvui.Color.white,
    /// positive feedback (saved, online, valid)
    success: dvui.Color = dvui.Color.white,
    /// non-critical feedback (unsaved, slow)
    warning: dvui.Color = dvui.Color.white,
    /// destructive actions or errors
    danger: dvui.Color = dvui.Color.white,
    /// neutral informational highlights
    info: dvui.Color = dvui.Color.white,

    /// default border
    border: dvui.Color = dvui.Color.white,
    /// focused input border
    border_focus: dvui.Color = dvui.Color.white,
    /// subtle dividers between sections
    border_subtle: dvui.Color = dvui.Color.white,

    /// primary text
    text: dvui.Color = dvui.Color.white,
    /// secondary/dimmed text
    text_muted: dvui.Color = dvui.Color.white,
    /// greyed out text
    text_disabled: dvui.Color = dvui.Color.white,
    /// text on dark/inverted backgrounds
    text_inverse: dvui.Color = dvui.Color.white,
};

pub fn fromJson(allocator: std.mem.Allocator, path: []const u8) !Theme {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    // TODO: Doing some smarter reading can reduce memory requirements.
    //       Themes really aren't THAT large so it may just not be needed.
    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    var parsed = try std.json.parseFromSlice(std.json.Value, allocator, content, .{});
    defer parsed.deinit();
    const root = parsed.value.object;

    return .{
        .allocator = allocator,
        .name = try dupeString(allocator, root, "name", "unknown"),
        .author = try dupeString(allocator, root, "author", "unknown"),
        .version = try dupeString(allocator, root, "version", "1.0"),
        .license = try dupeString(allocator, root, "license", "unknown"),
        .source = try dupeString(allocator, root, "source", "unknown"),
        .color = paletteFromJson(if (root.get("pallet")) |p| p.object else null),
    };
}

pub fn deinit(self: *Theme) void {
    self.allocator.free(self.name);
    self.allocator.free(self.author);
    self.allocator.free(self.version);
    self.allocator.free(self.license);
    self.allocator.free(self.source);
}

fn dupeString(allocator: std.mem.Allocator, object: std.json.ObjectMap, key: []const u8, default: []const u8) ![]const u8 {
    const val = object.get(key);
    const str = if (val != null and val.? == .string) val.?.string else default;
    return try allocator.dupe(u8, str);
}

fn paletteFromJson(object: ?std.json.ObjectMap) Palette {
    var palette: Palette = .{};
    if (object == null) return palette;
    inline for (std.meta.fields(Palette)) |field| {
        if (object.?.get(field.name)) |val| {
            if (val == .string) {
                @field(palette, field.name) = dvui.Color.tryFromHex(val.string) catch @field(palette, field.name);
            }
        }
    }
    return palette;
}
