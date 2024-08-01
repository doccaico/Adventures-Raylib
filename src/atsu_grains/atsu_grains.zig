const std = @import("std");
const print = std.debug.print;

const rl = @cImport({
    @cInclude("raylib.h");
});


const screenTitle = "Atsu Grains";
const screenWidth = 480;
const screenHeight = 640;
const fps = 30;
const particleCount = 100_000;


var rand: std.Random = undefined;

const Particle = struct {
    const Self = @This();

    position: rl.Vector2,
    velocity: rl.Vector2,
    color: rl.Color,

    fn init() Self {
        return .{
            .position = .{
                .x = @floatFromInt(rand.uintLessThan(usize, screenWidth)),
                .y = @floatFromInt(rand.uintLessThan(usize, screenHeight)), 
            },
            .velocity = .{
                .x = @as(f32, @floatFromInt(rand.intRangeLessThan(i32, -100, 100))) / 100.0,
                .y = @as(f32, @floatFromInt(rand.intRangeLessThan(i32, -100, 100))) / 100.0,
            },
            .color = rl.BLACK,
            // .color = .{
            //     .r = rand.uintLessThan(u8, 255),
            //     .g = rand.uintLessThan(u8, 255),
            //     .b = rand.uintLessThan(u8, 255),
            //     .a = 255,
            // },
        };
    }

    fn getDist(self: Self, otherPos: rl.Vector2) f32 {
        const dx =self.position.x - otherPos.x;
        const dy =self.position.y - otherPos.y;
        return std.math.sqrt((dx*dx) + (dy*dy));
    }

    fn getNormal(self: Self, otherPos: rl.Vector2) rl.Vector2 {
        var dist = self.getDist(otherPos);
        if (dist == 0.0) dist = 1;
        const dx = self.position.x - otherPos.x;
        const dy = self.position.y - otherPos.y;
        const normal = .{.x = dx*(1/dist), .y = dy*(1/dist)};
        return normal;
    }

    // :TODO: why didn't use "multiplier" (: :?)
    // https://github.com/codemaker4/raylib-particle-toy/blob/master/particle.h#L58
    fn attract(self: *Self, posToAttract: rl.Vector2) void {
        const dist = @max(self.getDist(posToAttract), 0.5);
        const normal = self.getNormal(posToAttract);
        self.velocity.x -= normal.x / dist;
        self.velocity.y -= normal.y / dist;
    }

    fn doFriction(self: *Self, amount: f32) void {
        self.velocity.x *= amount;
        self.velocity.y *= amount;
    }

    fn move(self: *Self) void {
        self.position.x += self.velocity.x;
        self.position.y += self.velocity.y;
        if (self.position.x < 0)
            self.position.x += screenWidth;
        if (self.position.x >= screenWidth)
            self.position.x -= screenWidth;
        if (self.position.y < 0)
            self.position.y += screenHeight;
        if (self.position.y >= screenHeight)
            self.position.y -= screenHeight;
    }

    fn drawPixel(self: Self) void {
        rl.DrawPixelV(self.position, self.color);
    }
};

// This is a port of https://github.com/codemaker4/raylib-particle-toy

pub fn run() !void {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    rand = prng.random();

    var particles = try std.BoundedArray(Particle, particleCount).init(0);
    for (0..particleCount) |_| {
        try particles.append(Particle.init());
    }
    var slice = particles.slice();

    rl.InitWindow(screenWidth, screenHeight, screenTitle);
    defer rl.CloseWindow();

    rl.SetTargetFPS(fps);

    while (!rl.WindowShouldClose()) {
        const cursor_pos = rl.GetMousePosition();
        for (0..particleCount) |i| {
            slice[i].attract(cursor_pos);
            slice[i].doFriction(0.99);
            slice[i].move();
        }

        {
            rl.BeginDrawing();
            defer rl.EndDrawing();

            rl.ClearBackground(rl.WHITE);

            for (0..particleCount) |i| {
                slice[i].drawPixel();
            }
        }
    }
}
