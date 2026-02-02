const std = @import("std");
const builtin = @import("builtin");
const dvui = @import("dvui");
const pixttf = @import("../pixttf.zig");

const RadialMenuWidget = @This();

// NOTE: inspo
//   - https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSAkp5k__Fbiq2fgNmTsg7MCmvtqYl_Aj8dg&s
//   - https://store-images.s-microsoft.com/image/apps.45823.14012971694252945.f7e9c633-4b51-4d3c-8b79-847f4e9df724.848fe86c-db17-4a50-8b92-d4056d880808
//   - https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVqCgriDDunHGkIoC5IBVAQivRudUrbx5wiTZLwyG5Bg&s
//   - https://cdn2.f-cdn.com/contestentries/2086645/61856662/626fc2b96db8a_thumb900.jpg

fw: dvui.FloatingWidget = undefined,
init_opts: InitOpts,

pub const InitOpts = struct {
    was_allocated_on_widget_stack: bool = false,
};

pub fn init(self: *RadialMenuWidget, src: std.builtin.SourceLocation, init_opts: InitOpts, opts: dvui.Options) void {
    self.* = .{
        .init_opts = init_opts,
    };
    _ = opts;
    self.fw.init(src, .{}, .{ .min_size_content = .all(500) });
}

pub fn deinit(self: *RadialMenuWidget) void {
    self.fw.deinit();
}

pub fn data(self: *RadialMenuWidget) *dvui.WidgetData {
    return self.fw.data();
}

const RADIUS: f32 = 200;
const CIRCLE_THICKNESS: f32 = 4;
const CUTS = 6;

pub fn draw(self: *RadialMenuWidget) void {
    const screen_rect_scale = self.fw.screenRectScale(.{});

    var path: dvui.Path.Builder = .init(dvui.currentWindow().lifo());
    defer path.deinit();
    const center_point: dvui.Point.Physical = screen_rect_scale.pointToPhysical(.{
        .x = @ceil(RADIUS / 2) + @ceil(CIRCLE_THICKNESS / 2),
        .y = @ceil(RADIUS / 2) + @ceil(CIRCLE_THICKNESS / 2),
    });
    path.addArc(
        center_point,
        RADIUS,
        dvui.math.degreesToRadians(360),
        dvui.math.degreesToRadians(0),
        false,
    );
    path.build().fillConvex(.{ .color = .gray });

    const angle: f32 = 360 / CUTS;
    for (0..CUTS) |i| {
        dvui.Path.stroke(
            .{ .points = &.{
                .{
                    .x = center_point.x + RADIUS * @cos(dvui.math.degreesToRadians(angle * @as(f32, @floatFromInt(i)))),
                    .y = center_point.y + RADIUS * @sin(dvui.math.degreesToRadians(angle * @as(f32, @floatFromInt(i)))),
                },
                center_point,
            } },
            .{ .thickness = CIRCLE_THICKNESS, .color = .white },
        );
    }
    path.build().stroke(.{ .thickness = CIRCLE_THICKNESS, .color = .white });

    path.points.items.len = 0; // clear out points
    path.addArc(
        center_point,
        RADIUS / 2,
        dvui.math.degreesToRadians(360),
        dvui.math.degreesToRadians(0),
        false,
    );
    path.build().fillConvex(.{ .color = .gray });
    path.build().stroke(.{ .thickness = CIRCLE_THICKNESS, .color = .white });

    // dvui.Path.stroke(.{ .points = &.{
    //     screen_rect_scale.pointToPhysical(.{ .x = 0, .y = 0 }),
    //     screen_rect_scale.pointToPhysical(.{ .x = 300, .y = 300 }),
    // } }, .{ .thickness = 10, .color = .red });
}
