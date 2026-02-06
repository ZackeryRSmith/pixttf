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

data: dvui.Theme,

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

    var theme = dvui.themeGet();
    if (root.get("theme")) |t_value| {
        const t = t_value.object;
        theme.fill = try colorFromObject(t, "fill", theme.fill);
    }

    return .{
        .allocator = allocator,
        .name = try dupeStringOrDefault(allocator, root, "name", "unknown"),
        .author = try dupeStringOrDefault(allocator, root, "author", "unknown"),
        .version = try dupeStringOrDefault(allocator, root, "version", "1.0"),
        .license = try dupeStringOrDefault(allocator, root, "license", "unknown"),
        .source = try dupeStringOrDefault(allocator, root, "source", "unknown"),
        .data = theme,
    };
}

pub fn deinit(self: *Theme) void {
    self.allocator.free(self.name);
    self.allocator.free(self.author);
    self.allocator.free(self.version);
    self.allocator.free(self.license);
    self.allocator.free(self.source);
}

fn dupeStringOrDefault(allocator: std.mem.Allocator, object: std.json.ObjectMap, key: []const u8, default: []const u8) ![]const u8 {
    const val = object.get(key);
    const str = if (val != null and val.? == .string) val.?.string else default;
    return try allocator.dupe(u8, str);
}

fn colorFromObject(object: std.json.ObjectMap, key: []const u8, fallback: dvui.Color) !dvui.Color {
    const val = object.get(key) orelse return fallback;
    if (val != .string) return fallback;
    return dvui.Color.tryFromHex(val.string) catch fallback;
}
