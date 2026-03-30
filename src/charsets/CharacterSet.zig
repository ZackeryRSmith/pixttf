const CharacterSet = @This();

name: [:0]const u8,
codepoints: []const u21,

pub fn fromRanges(
    comptime name: [:0]const u8,
    comptime ranges: []const [2]u21,
) CharacterSet {
    const codepoints = comptime blk: {
        var total: usize = 0;
        for (ranges) |r| total += r[1] - r[0] + 1;

        var arr: [total]u21 = undefined;
        var idx: usize = 0;
        for (ranges) |r| {
            var cp = r[0];
            while (cp <= r[1]) : (cp += 1) {
                arr[idx] = cp;
                idx += 1;
            }
        }
        const frozen = arr; // copy into a const to freeze it
        break :blk frozen;
    };

    return .{
        .name = name,
        .codepoints = &codepoints,
    };
}

/// Build from an explicit list of codepoints at comptime
pub fn fromCodepoints(comptime name: [:0]const u8, comptime cps: []const u21) CharacterSet {
    return .{ .name = name, .codepoints = cps };
}
