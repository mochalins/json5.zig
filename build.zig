const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("json5", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mod_unit_tests = b.addTest(.{ .root_module = mod });
    const run_mod_unit_tests = b.addRunArtifact(mod_unit_tests);

    const test_suite = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("test/suite.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "json5", .module = mod },
            },
        }),
    });
    const run_test_suite = b.addRunArtifact(test_suite);

    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_mod_unit_tests.step);
    test_step.dependOn(&run_test_suite.step);
}
