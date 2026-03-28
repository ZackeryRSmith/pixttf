const std = @import("std");
const dvui = @import("dvui");
const pixttf = @import("pixttf.zig");

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
        dvuiThemeFromJson(dvui.Theme, &theme, t_value.object);
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

pub fn apply(self: *Theme) void {
    dvui.themeSet(self.data);
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

fn dvuiThemeFromJson(comptime T: type, value: *T, object: std.json.ObjectMap) void {
    inline for (std.meta.fields(T)) |field| {
        if (object.get(field.name)) |json_val| {
            if (field.type == dvui.Color) {
                if (json_val == .string) {
                    @field(value, field.name) = dvui.Color.tryFromHex(json_val.string) catch @field(value, field.name);
                }
            } else if (@typeInfo(field.type) == .@"struct") {
                if (json_val == .object) {
                    dvuiThemeFromJson(field.type, &@field(value, field.name), json_val.object);
                }
            }
        }
    }
}
