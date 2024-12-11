const std = @import("std");

const Disk = union(enum) {
    file: struct { id: usize },
    free,

    fn parse(comptime buffer: []const u8) []Disk {
        var disk: [2000000]Disk = undefined;
        var diskIndex: usize = 0;
        var fileId: usize = 0;
        var isFile = true;

        inline for (buffer) |c| {
            if (c < '0' or c > '9') continue;
            const length = c - '0';
            var count: usize = 0;
            while (count < length) : (count += 1) {
                if (isFile)
                    disk[diskIndex] = Disk{ .file = .{ .id = fileId } }
                else
                    disk[diskIndex] = Disk.free;

                diskIndex += 1;
            }
            if (isFile) fileId += 1;
            isFile = !isFile;
        }

        return disk[0..diskIndex];
    }

    fn compact(disk: []Disk) []Disk {
        var freeIndex: usize = 0;
        var rightIndex = disk.len;

        while (true) {
            while (freeIndex < disk.len and disk[freeIndex] != Disk.free)
                freeIndex += 1;

            if (freeIndex >= disk.len) break;

            while (rightIndex > freeIndex and disk[rightIndex - 1] == Disk.free)
                rightIndex -= 1;

            if (rightIndex <= freeIndex) break;

            disk[freeIndex] = disk[rightIndex - 1];
            disk[rightIndex - 1] = Disk.free;
        }

        return disk;
    }

    fn checksum(disk: []Disk) usize {
        var sum: usize = 0;
        for (disk, 0..) |d, i|
            switch (d) {
                .file => |f| sum += i * f.id,
                .free => {},
            };

        return sum;
    }
};

pub fn main() !void {
    @setEvalBranchQuota(1000000);
    @setRuntimeSafety(false);

    const result = comptime Disk.checksum(Disk.compact(Disk.parse(@embedFile("input.txt"))));

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{}\n", .{result});
}
