// TODO: Fix trackpad issues. MacOS is *okay* but no detection for trackpad
//       input is done. Meaning a laptop with Windows will have issues. Pixi
//       does this naive trackpad check too
// TODO: Really gotta break this file down a bit more.

const std = @import("std");
const builtin = @import("builtin");
const pixttf = @import("root");
const dvui = @import("dvui");

const CanvasWidget = @This();

const SCALE_MIN = 0.15;
const SCALE_MAX = 15.0;
/// Cell size in logical pixels
const CELL_SIZE = 50;

init_opts: InitOpts,
origin: *dvui.Point = undefined,
scale: *f32 = undefined,
scroll_area: *dvui.ScrollAreaWidget = undefined,
scroll_container: *dvui.ScrollContainerWidget = undefined,
scaler: *dvui.ScaleWidget = undefined,
scroll_rect_scale: dvui.RectScale = .{},
screen_rect_scale: dvui.RectScale = .{},
scroll_info: *dvui.ScrollInfo = undefined,
hbox: dvui.BoxWidget = undefined,

active_draw_button: *dvui.enums.Button = undefined,
panning: *bool = undefined,

pub var defaults: dvui.Options = .{
    .name = "Canvas",
    .background = true,
    .style = .control,
};

pub const InitOpts = struct {
    allocator: std.mem.Allocator,
    strokes: *std.ArrayList(pixttf.Editor.PixelPosition),
};

pub fn init(self: *CanvasWidget, src: std.builtin.SourceLocation, init_opts: InitOpts, opts: dvui.Options) void {
    self.* = .{ .init_opts = init_opts };

    var options = defaults.override(opts);
    options.color_fill = pixttf.theme.color.grid_bg;

    self.hbox.init(src, .{ .dir = .horizontal }, options.themeOverride(opts.theme));

    self.scroll_info = dvui.dataGetPtrDefault(null, self.hbox.data().id, "scroll_info", dvui.ScrollInfo, .{ .vertical = .given, .horizontal = .given });
    self.origin = dvui.dataGetPtrDefault(null, self.hbox.data().id, "origin", dvui.Point, .{});
    self.scale = dvui.dataGetPtrDefault(null, self.hbox.data().id, "scale", f32, 1.0);
    self.active_draw_button = dvui.dataGetPtrDefault(null, self.hbox.data().id, "active_draw_button", dvui.enums.Button, .none);
    self.panning = dvui.dataGetPtrDefault(null, self.hbox.data().id, "panning", bool, false);

    self.scroll_area = dvui.scrollArea(src, .{ .scroll_info = self.scroll_info, .vertical_bar = .hide, .horizontal_bar = .hide }, options);
    self.scroll_container = &self.scroll_area.scroll.?;
    self.scaler = dvui.scale(src, .{ .scale = self.scale }, .{ .rect = .{ .x = -self.origin.x, .y = -self.origin.y } });
    self.scroll_rect_scale = self.scroll_container.screenRectScale(.{});
    self.screen_rect_scale = self.scaler.screenRectScale(.{});
}

pub fn deinit(self: *CanvasWidget) void {
    defer if (dvui.widgetIsAllocated(self)) dvui.widgetFree(self);
    defer self.* = undefined;

    self.scaler.deinit();
    self.scroll_area.deinit();
    self.hbox.deinit();
}

pub fn data(self: *CanvasWidget) *dvui.WidgetData {
    return self.hbox.data();
}

pub fn processEvents(self: *CanvasWidget) void {
    var zoom: f32 = 1.0;
    var zoom_point: dvui.Point.Physical = .{};

    const events = dvui.events();
    for (events) |*e| {
        if (!self.scroll_container.matchEvent(e)) continue;

        switch (e.evt) {
            .mouse => |mouse| {
                switch (mouse.action) {
                    .press => switch (mouse.button) {
                        .left, .right => self.handleDrawInput(e, mouse),
                        // .right => e.handle(@src(), self.scroll_container.data()), // TODO: radial toolbox
                        .middle => self.handlePanStart(e, mouse),
                        else => {},
                    },
                    .release => switch (mouse.button) {
                        .left, .right => if (dvui.captured(self.scroll_container.data().id)) {
                            e.handle(@src(), self.scroll_container.data());
                            dvui.captureMouse(null, e.num);
                            dvui.dragEnd();
                            self.active_draw_button.* = .none;
                        },
                        .middle => self.handlePanEnd(e),
                        else => {},
                    },
                    .motion => {
                        self.handlePanMotion(e, mouse);
                        self.handleDrawMotion(e, mouse);
                    },
                    .wheel_x => self.handleWheelX(e, mouse),
                    .wheel_y => self.handleWheelY(e, mouse, &zoom, &zoom_point),
                    else => {},
                }
            },
            else => {},
        }
    }

    if (zoom != 1.0 and self.scale.* * zoom > SCALE_MIN and self.scale.* * zoom < SCALE_MAX) {
        self.applyZoom(zoom, zoom_point);
    }

    self.adjustViewport();
}

pub fn draw(self: *CanvasWidget) void {
    if (self.scale.* * CELL_SIZE < 2.0) return;
    self.drawGrid();
    self.drawStrokes();
}

fn handleDrawInput(self: *CanvasWidget, e: *dvui.Event, mouse: dvui.Event.Mouse) void {
    e.handle(@src(), self.scroll_container.data());
    dvui.captureMouse(self.scroll_container.data(), e.num);
    dvui.dragPreStart(mouse.p, .{});
    self.active_draw_button.* = mouse.button;

    switch (mouse.button) {
        .left => self.drawPixel(mouse.p),
        .right => self.erasePixel(mouse.p),
        else => {},
    }
}

fn handlePanStart(self: *CanvasWidget, e: *dvui.Event, mouse: dvui.Event.Mouse) void {
    e.handle(@src(), self.scroll_container.data());
    dvui.captureMouse(self.scroll_container.data(), e.num);
    dvui.dragPreStart(mouse.p, .{});
    self.panning.* = true;
}

fn handlePanEnd(self: *CanvasWidget, e: *dvui.Event) void {
    if (!dvui.captured(self.scroll_container.data().id)) return;
    e.handle(@src(), self.scroll_container.data());
    dvui.captureMouse(null, e.num);
    dvui.dragEnd();
    self.panning.* = false;
}
fn handlePanMotion(self: *CanvasWidget, e: *dvui.Event, mouse: dvui.Event.Mouse) void {
    if (!self.panning.*) return;
    if (!dvui.captured(self.scroll_container.data().id)) return;
    if (dvui.dragging(mouse.p, null)) |dps| {
        e.handle(@src(), self.scroll_container.data());
        self.scroll_info.viewport.x -= dps.x / self.scroll_rect_scale.s;
        self.scroll_info.viewport.y -= dps.y / self.scroll_rect_scale.s;
        dvui.refresh(null, @src(), self.scroll_container.data().id);
    }
}

fn handleDrawMotion(self: *CanvasWidget, e: *dvui.Event, mouse: anytype) void {
    if (!dvui.captured(self.scroll_container.data().id)) return;
    if (dvui.dragging(mouse.p, null) == null) return;
    e.handle(@src(), self.scroll_container.data());

    switch (self.active_draw_button.*) {
        .left => self.drawPixel(mouse.p),
        .right => self.erasePixel(mouse.p),
        else => {},
    }
}

fn handleWheelX(self: *CanvasWidget, e: *dvui.Event, mouse: anytype) void {
    // capture and ignore horizontal scroll on macOS when cmd is held,
    // to prevent simultaneous scroll + zoom.
    if (builtin.os.tag == .macos and mouse.mod.matchKeyBind(.{ .command = true }))
        e.handle(@src(), self.scroll_container.data());
}

fn handleWheelY(self: *CanvasWidget, e: *dvui.Event, mouse: anytype, zoom: *f32, zoom_point: *dvui.Point.Physical) void {
    const base: f32 = 1.01;

    // TODO: MacOS != Touchpad 100% of the time — would like gesture support
    //       but this seems to be a dvui limitation as of now.
    if (builtin.os.tag == .macos) {
        if (mouse.mod.matchKeyBind(.{ .command = true })) {
            const zoom_scale = @exp(@log(base) * -mouse.action.wheel_y);
            if (zoom_scale != 1.0) {
                zoom.* *= zoom_scale;
                zoom_point.* = mouse.p;
            }
        }
    } else {
        e.handle(@src(), self.scroll_container.data());
        const zoom_scale = @exp(@log(base) * mouse.action.wheel_y);
        if (zoom_scale != 1.0) {
            zoom.* *= zoom_scale;
            zoom_point.* = mouse.p;
        }
    }
}

fn applyZoom(self: *CanvasWidget, zoom: f32, zoom_point: dvui.Point.Physical) void {
    const prev_point = self.screen_rect_scale.pointFromPhysical(zoom_point);

    var pp = prev_point.scale(1.0 / self.scale.*, dvui.Point);
    self.scale.* *= zoom;
    pp = pp.scale(self.scale.*, dvui.Point);

    const new_point = self.screen_rect_scale.pointToPhysical(pp);
    const diff = self.scroll_rect_scale.pointFromPhysical(new_point).diff(self.scroll_rect_scale.pointFromPhysical(zoom_point));
    self.scroll_info.viewport.x += diff.x;
    self.scroll_info.viewport.y += diff.y;

    dvui.refresh(null, @src(), self.scroll_container.data().id);
}

fn adjustViewport(self: *CanvasWidget) void {
    if (self.scroll_info.viewport.empty()) return;

    const scroll_container_id = self.scroll_container.data().id;
    const pad = 10;
    const bbox = self.scroll_info.viewport.outsetAll(pad);

    if (bbox.y != 0) {
        const adj = -bbox.y;
        self.scroll_info.virtual_size.h += adj;
        self.scroll_info.viewport.y += adj;
        self.origin.y -= adj;
        dvui.refresh(null, @src(), scroll_container_id);
    }

    if (bbox.x != 0) {
        const adj = -bbox.x;
        self.scroll_info.virtual_size.w += adj;
        self.scroll_info.viewport.x += adj;
        self.origin.x -= adj;
        dvui.refresh(null, @src(), scroll_container_id);
    }

    if (bbox.h != self.scroll_info.virtual_size.h) {
        self.scroll_info.virtual_size.h = bbox.h;
        dvui.refresh(null, @src(), scroll_container_id);
    }

    if (bbox.w != self.scroll_info.virtual_size.w) {
        self.scroll_info.virtual_size.w = bbox.w;
        dvui.refresh(null, @src(), scroll_container_id);
    }
}

fn drawGrid(self: *CanvasWidget) void {
    const scaled_cell = self.scale.* * CELL_SIZE;
    const view_w = self.scroll_info.virtual_size.w;
    const view_h = self.scroll_info.virtual_size.h;
    const grid_color: dvui.Color = dvui.Color.gray.lighten(0.5);

    const start_x = @floor(self.origin.x / scaled_cell);
    const start_y = @floor(self.origin.y / scaled_cell);
    const end_x = @ceil((view_w + self.origin.x) / scaled_cell);
    const end_y = @ceil((view_h + self.origin.y) / scaled_cell);

    // vertical lines
    var ix = start_x;
    while (ix <= end_x) : (ix += 1) {
        const screen_x = (ix * scaled_cell) - self.origin.x;
        const is_negative = (ix < 0);
        self.drawLine(screen_x, 0, screen_x, view_h, 1, if (is_negative) .gray else grid_color);

        // TODO: improve visually, consider PixelForge style rendering
        if (is_negative and scaled_cell > 6.0) {
            var iy = start_y;
            while (iy <= end_y) : (iy += 1) {
                const screen_y = (iy * scaled_cell) - self.origin.y;
                self.drawLine(screen_x, screen_y + scaled_cell, screen_x + scaled_cell, screen_y, 1, .gray);
            }
        }
    }

    // horizontal lines
    const origin_screen_x = -self.origin.x;
    var iy = start_y;
    while (iy <= end_y) : (iy += 1) {
        const screen_y = (iy * scaled_cell) - self.origin.y;
        self.drawLine(0, screen_y, origin_screen_x, screen_y, 1, .gray);
        self.drawLine(origin_screen_x, screen_y, view_w, screen_y, 1, grid_color);
    }

    // axes
    const origin_screen_y = -self.origin.y;
    self.drawLine(origin_screen_x, 0, origin_screen_x, view_h, 3, .white);
    self.drawLine(0, origin_screen_y, origin_screen_x - 3, origin_screen_y, 3, .gray);
    self.drawLine(origin_screen_x, origin_screen_y, view_w, origin_screen_y, 3, .white);
}

fn drawStrokes(self: *CanvasWidget) void {
    const scaled_cell = self.scale.* * CELL_SIZE;

    for (self.init_opts.strokes.items) |stroke| {
        const fx: f32 = @floatFromInt(stroke.x);
        const fy: f32 = @floatFromInt(stroke.y);

        const screen_x = fx * scaled_cell - self.origin.x;
        const screen_y = -(fy + 1.0) * scaled_cell - self.origin.y;

        const tl = self.scroll_rect_scale.pointToPhysical(.{ .x = screen_x, .y = screen_y });
        const tr = self.scroll_rect_scale.pointToPhysical(.{ .x = screen_x + scaled_cell, .y = screen_y });
        const br = self.scroll_rect_scale.pointToPhysical(.{ .x = screen_x + scaled_cell, .y = screen_y + scaled_cell });
        const bl = self.scroll_rect_scale.pointToPhysical(.{ .x = screen_x, .y = screen_y + scaled_cell });

        dvui.Path.fillConvex(.{ .points = &.{ tl, tr, br, bl } }, .{ .color = .white });
    }
}

fn drawPixel(self: *CanvasWidget, p: dvui.Point.Physical) void {
    const canvas_point = self.screen_rect_scale.pointFromPhysical(p);
    const pixel_x: i16 = @intFromFloat(@floor(canvas_point.x / CELL_SIZE));
    const pixel_y: i16 = @intFromFloat(@floor(-canvas_point.y / CELL_SIZE));

    // don't append duplicates
    for (self.init_opts.strokes.items) |stroke| {
        if (stroke.x == pixel_x and stroke.y == pixel_y) return;
    }
    self.init_opts.strokes.append(self.init_opts.allocator, .{
        .x = pixel_x,
        .y = pixel_y,
    }) catch unreachable;
}

fn erasePixel(self: *CanvasWidget, p: dvui.Point.Physical) void {
    const canvas_point = self.screen_rect_scale.pointFromPhysical(p);
    const pixel_x: i16 = @intFromFloat(@floor(canvas_point.x / CELL_SIZE));
    const pixel_y: i16 = @intFromFloat(@floor(-canvas_point.y / CELL_SIZE));

    const existing = for (self.init_opts.strokes.items, 0..) |stroke, i| {
        if (stroke.x == pixel_x and stroke.y == pixel_y) break i;
    } else null;

    if (existing) |i| {
        _ = self.init_opts.strokes.orderedRemove(i);
    }
}

fn drawLine(self: *CanvasWidget, x1: f32, y1: f32, x2: f32, y2: f32, thickness: f32, color: dvui.Color) void {
    dvui.Path.stroke(.{ .points = &.{
        self.scroll_rect_scale.pointToPhysical(.{ .x = x1, .y = y1 }),
        self.scroll_rect_scale.pointToPhysical(.{ .x = x2, .y = y2 }),
    } }, .{ .thickness = thickness, .color = color });
}
