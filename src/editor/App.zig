const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const App = @This();
const Editor = pixttf.Editor;
const Theme = @import("Theme.zig");

allocator: std.mem.Allocator = undefined,
window: *dvui.Window = undefined,

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
var should_show_greeter: bool = true;

// runs before the first frame, after backend and dvui.Window.init()
pub fn init(window: *dvui.Window) !void {
    const allocator = gpa.allocator();

    std.log.info("creating pixtf.app", .{});
    pixttf.app = try allocator.create(App);
    pixttf.app.* = .{
        .allocator = allocator,
        .window = window,
    };

    std.log.info("creating pixtf.editor", .{});
    pixttf.editor = try allocator.create(Editor);
    pixttf.editor.* = try Editor.init(allocator);

    std.log.info("adding typecast font family:", .{});
    std.log.info("\t- pixelcode.ttf", .{});
    try dvui.addFont("pixelcode", pixttf.assets.files.fonts.@"pixelcode.ttf", null);
    std.log.info("\t- pixelcode-italic.ttf", .{});
    try dvui.addFont("pixelcode-italic", pixttf.assets.files.fonts.@"pixelcode-italic.ttf", null);
    std.log.info("\t- pixelcode-bold.ttf", .{});
    try dvui.addFont("pixelcode-bold", pixttf.assets.files.fonts.@"pixelcode-bold.ttf", null);
    std.log.info("\t- pixelcode-bold-italic.ttf", .{});
    try dvui.addFont("pixelcode-bold-italic", pixttf.assets.files.fonts.@"pixelcode-bold-italic.ttf", null);
    std.log.info("\t- pixelcode-extrabold.ttf", .{});
    try dvui.addFont("pixelcode-extrabold", pixttf.assets.files.fonts.@"pixelcode-extrabold.ttf", null);
    std.log.info("\t- pixelcode-extrabold-italic.ttf", .{});
    try dvui.addFont("pixelcode-extrabold-italic", pixttf.assets.files.fonts.@"pixelcode-extrabold-italic.ttf", null);
    std.log.info("\t- pixelcode-medium.ttf", .{});
    try dvui.addFont("pixelcode-medium", pixttf.assets.files.fonts.@"pixelcode-medium.ttf", null);
    std.log.info("\t- pixelcode-medium-italic.ttf", .{});
    try dvui.addFont("pixelcode-medium-italic", pixttf.assets.files.fonts.@"pixelcode-medium-italic.ttf", null);
    std.log.info("\t- pixelcode-thin.ttf", .{});
    try dvui.addFont("pixelcode-thin", pixttf.assets.files.fonts.@"pixelcode-thin.ttf", null);
    std.log.info("\t- pixelcode-thin-italic.ttf", .{});
    try dvui.addFont("pixelcode-thin-italic", pixttf.assets.files.fonts.@"pixelcode-thin-italic.ttf", null);

    std.log.info("loading theme classic_dark.json", .{});
    pixttf.theme = try Theme.fromJson(allocator, "assets/themes/classic_dark.json");

    // TODO: Theme should probably do this
    var default_font = dvui.Font.find(.{ .family = "pixelcode" });
    default_font.size = 8;
    var bold_font = dvui.Font.find(.{ .family = "pixelcode-bold" });
    bold_font.size = 28;

    var dvui_theme = dvui.themeGet();
    dvui_theme.font_body = default_font;
    dvui_theme.font_heading = bold_font;
    dvui_theme.font_title = bold_font;
    dvui.themeSet(dvui_theme);
}

// run as app is shutting down before dvui.Window.deinit()
pub fn deinit() void {
    pixttf.editor.deinit();
}

// run each frame to do normal UI
pub fn frame() !dvui.App.Result {
    if (should_show_greeter)
        should_show_greeter = pixttf.GreeterDialog.show();
    return try pixttf.editor.tick();
}
