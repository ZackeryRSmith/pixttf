const std = @import("std");
const dvui = @import("dvui");
const pixttf = @import("../pixttf.zig");

const CanvasWidget = @This();

/// cell size in pixels
const CELL_SIZE = 50;

// wd: dvui.WidgetData,
init_opts: InitOpts,
origin: *dvui.Point = undefined,
scale: *f32 = undefined,
scroll_area: *dvui.ScrollAreaWidget = undefined,
scroll_container: *dvui.ScrollContainerWidget = undefined,
scaler: *dvui.ScaleWidget = undefined,
scroll_rect_scale: dvui.RectScale = .{},
screen_rect_scale: dvui.RectScale = .{},
scroll_info: *dvui.ScrollInfo = undefined,

hbox: dvui.BoxWidget,

pub var defaults: dvui.Options = .{
    .name = "Canvas",
    .background = true,
    .style = .window,
};
pub const InitOpts = struct {
    was_allocated_on_widget_stack: bool = false,
};

pub fn init(self: *CanvasWidget, src: std.builtin.SourceLocation, init_opts: InitOpts, opts: dvui.Options) void {
    self.* = .{
        .init_opts = init_opts,
        .hbox = undefined, // set below
    };
    const options = defaults.override(opts);

    self.hbox.init(src, .{ .dir = .horizontal }, options.themeOverride(opts.theme));

    self.scroll_info = dvui.dataGetPtrDefault(null, self.hbox.data().id, "scroll_info", dvui.ScrollInfo, .{ .vertical = .given, .horizontal = .given });
    self.origin = dvui.dataGetPtrDefault(null, self.hbox.data().id, "origin", dvui.Point, .{});
    self.scale = dvui.dataGetPtrDefault(null, self.hbox.data().id, "scale", f32, 1.0);

    self.scroll_area = dvui.scrollArea(src, .{ .scroll_info = self.scroll_info, .vertical_bar = .hide, .horizontal_bar = .hide }, options);
    self.scroll_container = &self.scroll_area.scroll.?;
    self.scaler = dvui.scale(src, .{ .scale = self.scale }, .{ .rect = .{ .x = -self.origin.x, .y = -self.origin.y } });
    self.scroll_rect_scale = self.scroll_container.screenRectScale(.{});
    self.screen_rect_scale = self.scaler.screenRectScale(.{});
}

pub fn deinit(self: *CanvasWidget) void {
    const should_free = self.data().was_allocated_on_widget_stack;
    defer if (should_free) dvui.widgetFree(self);
    defer self.* = undefined;

    self.scaler.deinit();
    self.scroll_area.deinit();
    self.hbox.deinit();
}

pub fn data(self: *CanvasWidget) *dvui.WidgetData {
    return self.hbox.data();
}

pub fn processEvents(self: *CanvasWidget) void {
    var zoom: f32 = 1;
    var zoom_point: dvui.Point.Physical = .{};

    const events = dvui.events();
    for (events) |*e| {
        if (!self.scroll_container.matchEvent(e))
            continue;

        switch (e.evt) {
            .mouse => |mouse| {
                if (mouse.action == .press and mouse.button == .middle) {
                    e.handle(@src(), self.scroll_container.data());
                    dvui.captureMouse(self.scroll_container.data(), e.num);
                    dvui.dragPreStart(mouse.p, .{});
                } else if (mouse.action == .release and mouse.button == .middle) {
                    if (dvui.captured(self.scroll_container.data().id)) {
                        e.handle(@src(), self.scroll_container.data());
                        dvui.captureMouse(null, e.num);
                        dvui.dragEnd();
                    }
                } else if (mouse.action == .motion) {
                    if (mouse.button.touch()) {
                        // eat touch motion events so they don't scroll
                        e.handle(@src(), self.scroll_container.data());
                    }
                    if (dvui.captured(self.scroll_container.data().id)) {
                        if (dvui.dragging(mouse.p, null)) |dps| {
                            e.handle(@src(), self.scroll_container.data());
                            self.scroll_info.viewport.x -= dps.x / self.scroll_rect_scale.s;
                            self.scroll_info.viewport.y -= dps.y / self.scroll_rect_scale.s;
                            dvui.refresh(null, @src(), self.scroll_container.data().id);
                        }
                    }
                } else if (mouse.action == .wheel_y) {
                    e.handle(@src(), self.scroll_container.data());
                    const base: f32 = 1.01;
                    const zoom_scale = @exp(@log(base) * mouse.action.wheel_y);
                    if (zoom_scale != 1.0) {
                        zoom *= zoom_scale;
                        zoom_point = mouse.p;
                    }
                }
            },
            else => {},
        }
    }

    if (zoom != 1.0) {
        // scale around mouse point
        // first get data point of mouse
        const prev_point = self.screen_rect_scale.pointFromPhysical(zoom_point);

        // scale
        var pp = prev_point.scale(1 / self.scale.*, dvui.Point);
        self.scale.* *= zoom;
        pp = pp.scale(self.scale.*, dvui.Point);

        // get where the mouse would be now
        const new_point = self.screen_rect_scale.pointToPhysical(pp);

        // convert both to viewport
        const diff = self.scroll_rect_scale.pointFromPhysical(new_point).diff(self.scroll_rect_scale.pointFromPhysical(zoom_point));
        self.scroll_info.viewport.x += diff.x;
        self.scroll_info.viewport.y += diff.y;

        dvui.refresh(null, @src(), self.scroll_container.data().id);
    }

    // don't mess with scrolling if there is nothing to scroll anyway
    if (!self.scroll_info.viewport.empty()) {
        const scroll_container_id = self.scroll_container.data().id;

        // add current viewport plus padding
        const pad = 10;
        const bbox = self.scroll_info.viewport.outsetAll(pad);

        // adjust top if needed
        if (bbox.y != 0) {
            const adj = -bbox.y;
            self.scroll_info.virtual_size.h += adj;
            self.scroll_info.viewport.y += adj;
            self.origin.y -= adj;
            dvui.refresh(null, @src(), scroll_container_id);
        }

        // adjust left if needed
        if (bbox.x != 0) {
            const adj = -bbox.x;
            self.scroll_info.virtual_size.w += adj;
            self.scroll_info.viewport.x += adj;
            self.origin.x -= adj;
            dvui.refresh(null, @src(), scroll_container_id);
        }

        // adjust bottom if needed
        if (bbox.h != self.scroll_info.virtual_size.h) {
            self.scroll_info.virtual_size.h = bbox.h;
            dvui.refresh(null, @src(), scroll_container_id);
        }

        // adjust right if needed
        if (bbox.w != self.scroll_info.virtual_size.w) {
            self.scroll_info.virtual_size.w = bbox.w;
            dvui.refresh(null, @src(), scroll_container_id);
        }
    }
}

pub fn draw(self: *CanvasWidget) void {
    const scaled_cell = self.scale.* * CELL_SIZE;
    const view_w = self.scroll_info.virtual_size.w;
    const view_h = self.scroll_info.virtual_size.h;
    const text_color: dvui.Color = dvui.Color.gray.lighten(0.5);

    // only iterate over visible cell indices
    const start_x = @floor(self.origin.x / scaled_cell);
    const start_y = @floor(self.origin.y / scaled_cell);
    const end_x = @ceil((view_w + self.origin.x) / scaled_cell);
    const end_y = @ceil((view_h + self.origin.y) / scaled_cell);

    // skip drawing if zoomed out too far
    if (scaled_cell < 2.0) return;

    // Vertical Lines & Special Zone Diagonals
    var ix = start_x;
    while (ix <= end_x) : (ix += 1) {
        const screen_x = (ix * scaled_cell) - self.origin.x;
        const is_special = (ix < 0);

        // Vertical grid line
        self.drawStroke(screen_x, 0, screen_x, view_h, 1, if (is_special) .gray else text_color);

        // diagonals (skip if zoomed out for performance)
        // TODO: Diagonals can be improved visually by a ton
        //       Plus it seems silly to just stop rendering them,
        //       we should use a style akin to PixelForge.
        if (is_special and scaled_cell > 6.0) {
            var iy = start_y;
            while (iy <= end_y) : (iy += 1) {
                const screen_y = (iy * scaled_cell) - self.origin.y;
                self.drawStroke(screen_x, screen_y + scaled_cell, screen_x + scaled_cell, screen_y, 1, .gray);
            }
        }
    }

    // Horizontal Lines (Split at X=0)
    const origin_screen_x = -self.origin.x; // Simplified since 0 * anything = 0
    var iy = start_y;
    while (iy <= end_y) : (iy += 1) {
        const screen_y = (iy * scaled_cell) - self.origin.y;

        // Left side (Special)
        self.drawStroke(0, screen_y, origin_screen_x, screen_y, 1, .gray);
        // Right side (Normal)
        self.drawStroke(origin_screen_x, screen_y, view_w, screen_y, 1, text_color);
    }

    // Origin Axes
    const origin_screen_y = -self.origin.y;
    // Vertical Axis
    self.drawStroke(origin_screen_x, 0, origin_screen_x, view_h, 3, .white);
    // Horizontal Axis (Split)
    self.drawStroke(0, origin_screen_y, origin_screen_x - 3, origin_screen_y, 3, .gray);
    self.drawStroke(origin_screen_x, origin_screen_y, view_w, origin_screen_y, 3, .white);
}

// Helper to keep the loop readable
fn drawStroke(self: *CanvasWidget, x1: f32, y1: f32, x2: f32, y2: f32, thickness: f32, color: dvui.Color) void {
    dvui.Path.stroke(.{ .points = &.{
        self.scroll_rect_scale.pointToPhysical(.{ .x = x1, .y = y1 }),
        self.scroll_rect_scale.pointToPhysical(.{ .x = x2, .y = y2 }),
    } }, .{ .thickness = thickness, .color = color });
}
