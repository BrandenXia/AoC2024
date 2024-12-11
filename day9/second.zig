const std = @import("std");

const Disk = union(enum) {
    file: struct { id: usize },
    free,

    fn parse(buffer: []const u8) !std.ArrayList(Disk) {
        var disk = std.ArrayList(Disk).init(std.heap.page_allocator);
        errdefer disk.deinit();

        var fileId: usize = 0;
        var isFile = true;

        for (buffer) |c| {
            if (c < '0' or c > '9') continue;
            const length = c - '0';
            var count: usize = 0;
            while (count < length) : (count += 1) {
                if (isFile)
                    try disk.append(Disk{ .file = .{ .id = fileId } })
                else
                    try disk.append(Disk.free);
            }
            if (isFile) fileId += 1;
            isFile = !isFile;
        }

        return disk;
    }

    fn same_file_id(a: Disk, id: usize) bool {
        return switch (a) {
            .file => |f| f.id == id,
            .free => false,
        };
    }
};

fn defrag(disk: []Disk) []Disk {
    const File = struct { id: usize, start: usize, end: usize };

    var files = std.ArrayList(File).init(std.heap.page_allocator);
    errdefer files.deinit();

    var i: usize = 0;
    while (i < disk.len) {
        if (disk[i] != Disk.free) {
            const start = i;
            const fileId = disk[i].file.id;
            while (i < disk.len and Disk.same_file_id(disk[i], fileId)) : (i += 1) {}
            files.append(.{ .id = fileId, .start = start, .end = i - 1 }) catch unreachable;
        } else i += 1;
    }

    std.mem.sort(File, files.items, {}, struct {
        fn lessThan(context: void, a: File, b: File) bool {
            _ = context;
            return a.id > b.id;
        }
    }.lessThan);

    for (files.items) |file| {
        const length = file.end - file.start + 1;
        var free_start: ?usize = null;

        for (0..@max(0, @as(i32, @intCast(file.start)) - @as(i32, @intCast(length)) + 1)) |j| {
            var is_free = true;
            var k: usize = 0;
            while (k < length and j + k < disk.len) : (k += 1)
                if (disk[j + k] != Disk.free) {
                    is_free = false;
                    break;
                };
            if (is_free and k == length) {
                free_start = j;
                break;
            }
        }

        if (free_start) |fs| {
            for (0..length) |k|
                disk[fs + k] = Disk{ .file = .{ .id = file.id } };
            for (file.start..file.end + 1) |k|
                disk[k] = Disk.free;
        }
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

pub fn main() !void {
    var disk = Disk.parse(@embedFile("input.txt")) catch unreachable;
    errdefer disk.deinit();

    const result = checksum(defrag(disk.items));

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{}\n", .{result});
}
