const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dvui_dep = b.dependency("dvui", .{
        .target = target,
        .optimize = optimize,
        .backend = .sdl3,
    });

    const exe = b.addExecutable(.{
        .name = "pixttf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/pixttf.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "dvui", .module = dvui_dep.module("dvui_sdl3") },
                .{ .name = "sdl-backend", .module = dvui_dep.module("sdl3") },
            },
        }),
    });

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_exe.step);
}
