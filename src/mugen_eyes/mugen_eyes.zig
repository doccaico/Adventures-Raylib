const std = @import("std");
const builtin = @import("builtin");
const print = std.debug.print;

const lib = @import("lib.zig");

const rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});


pub const screenTitle = "Mugen Eyes";
pub const screenWidth = 480;
pub const screenHeight = 640;
pub const fps = 30;
pub const circularBufferSize = 150;
pub const particleMaxSize = 20;
pub const particleMaxSpeed = 4.0;


var rand: std.Random = undefined;

const colors = [_]rl.Color{
    .{ .r = 255, .g = 0,   .b = 0,   .a = 255 }, // Red
    .{ .r = 0,   .g = 255, .b = 0,   .a = 255 }, // Green
    .{ .r = 0,   .g = 0,   .b = 255, .a = 255 }, // Blue
    .{ .r = 55,  .g = 55,  .b = 55,  .a = 255 }, // Darkish gray
};

const Particle = struct {
    position: rl.Vector2,
    lifetime_remaining: usize,
    size: f32,
    color: rl.Color,
};

const ParticleEmitter = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    position: rl.Vector2,
    lifetime_max: usize,
    particle_count: usize,
    wheel_house: []Particle,

    fn init(allocator: std.mem.Allocator, pos: rl.Vector2, particle_count: usize, lifetime_max: usize) !Self {
        const wh = try allocator.alloc(Particle, particle_count);
        for (wh) |*item| {
            item.lifetime_remaining = 0;
        }
        return .{
            .position = pos,
            .particle_count = particle_count,
            .lifetime_max = lifetime_max,
            .wheel_house = wh,
            .allocator = allocator,
        };
    }

    fn draw(self: Self) void {
        rl.DrawCircle(
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            3.0,
            rl.BLACK);

        for (0..self.particle_count) |i| {
            rl.DrawCircle(
                @intFromFloat(self.wheel_house[i].position.x),
                @intFromFloat(self.wheel_house[i].position.y),
                self.wheel_house[i].size,
                self.wheel_house[i].color);
        }
    }

    fn step(self: Self) void {
        for (0..self.particle_count) |i| {
            particle_step(self, &self.wheel_house[i]);
        }
    }

    fn particle_step(self: Self, particle: *Particle) void {
        particle.position = self.position;

        if (particle.lifetime_remaining <= 0) {
            particle.color = colors[rand.uintLessThan(usize, colors.len)];
            particle.lifetime_remaining = rand.uintLessThan(usize, self.lifetime_max);
            // :TODO: https://github.com/doccaico/raylib-examples-odin/blob/main/particle.odin#L67
            particle.size = @floatFromInt(rand.intRangeLessThan(usize, 1, particleMaxSize));
            return;
        }
        particle.lifetime_remaining -= 1;
        particle.size = rl.Clamp(
            @as(f32, @floatFromInt(particleMaxSize * particle.lifetime_remaining / self.lifetime_max)),
            1.0,
            particleMaxSize);
    }

};

// Reference: https://github.com/doccaico/raylib-examples-odin/blob/main/particle.odin
// Original: https://github.com/epsilon-phase/raylib-experiments/blob/canon/src/particle/main.c

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = if (builtin.mode == .Debug) gpa.allocator() else std.heap.c_allocator;
    defer if (builtin.mode == .Debug) std.debug.assert(gpa.deinit() == .ok);

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    rand = prng.random();

    var emitters = try lib.CircularBuffer(ParticleEmitter, circularBufferSize).init(allocator);
    defer {
        for (0..emitters.len) |i| {
            allocator.free(emitters.data[i].wheel_house);
        }
        emitters.deinit();
    }

    rl.InitWindow(screenWidth, screenHeight, screenTitle);
    defer rl.CloseWindow();

    rl.SetTargetFPS(fps);

    while (!rl.WindowShouldClose()) {
        if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT)) {
            const cursor_pos = rl.GetMousePosition();
            emitters.append(try ParticleEmitter.init(allocator, cursor_pos, 50, 100));
            if (emitters.isolated) |isolated| {
                allocator.free(isolated.wheel_house);
            }
        }

        {
            rl.BeginDrawing();
            defer rl.EndDrawing();

            rl.ClearBackground(rl.WHITE);

            for (0..emitters.len) |i| {
                emitters.data[i].draw();
            }
        }

        for (0..emitters.len) |i| {
            emitters.data[i].step();
        }
    }
}
