const std = @import("std");

// c https://github.com/epsilon-phase/raylib-experiments/blob/canon/src/utility/circular_buffer.c
// odin https://github.com/JustinRyanH/Breakit/blob/main/src/game/ring_buffer.odin
// cpp https://www.geeksforgeeks.org/implement-circular-buffer-using-std-vector-in-cpp/

// memo(gist) https://gist.github.com/doccaico/96246588c5de08e3b24bf526c87dac97

pub fn CircularBuffer(comptime T: type, comptime N: usize) type {
    return struct {
        const Self = @This();

        push_index: u64,
        len: u64,
        data: []T,
        isolated: ?T,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) !Self {
            return Self{
                .push_index = 0,
                .len = 0,
                .data = try allocator.alloc(T, N),
                .isolated = null,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: Self) void {
            self.allocator.free(self.data);
        }

        pub fn append(self: *Self, item: T) void {
            if (self.len < N) {
                const new_index = (self.push_index + 1) % N;
                self.data[self.push_index] = item;
                self.push_index = new_index;
                self.len += 1;
            } else {
                const new_index = (self.push_index + 1) % N;
                const isolated_index = self.push_index;
                self.isolated = self.data[isolated_index];
                self.data[self.push_index] = item;
                self.push_index = new_index;
            }
        }

        pub fn popValue(self: *Self) void {
            const new_index = (self.push_index + 1) % N;
            self.push_index = new_index;
        }

        pub fn lastValue(self: Self) T {
            return self.data[(self.push_index - 1) % N];
        }

        pub fn isFull(self: Self) bool {
            return self.len == N;
        }
    };
}

test "CircularBuffer isFull" {
    var cb = try CircularBuffer(i32, 3).init(std.testing.allocator);
    defer cb.deinit();

    cb.append(1);
    try std.testing.expect(!cb.isFull());
    cb.append(2);
    try std.testing.expect(!cb.isFull());
    cb.append(3);
    try std.testing.expect(cb.isFull());
    cb.append(4);
    try std.testing.expect(cb.isFull());
}

test "CircularBuffer isolated" {
    var cb = try CircularBuffer(i32, 3).init(std.testing.allocator);
    defer cb.deinit();

    cb.append(1);
    try std.testing.expect(cb.isolated == null);
    cb.append(2);
    try std.testing.expect(cb.isolated == null);
    cb.append(3);
    try std.testing.expect(cb.isolated == null);
    cb.append(4);
    try std.testing.expect(cb.isolated != null);
}
