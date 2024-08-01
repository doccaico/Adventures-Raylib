const std = @import("std");
const print = std.debug.print;

const rl = @cImport({
    @cInclude("raylib.h");
});


const screenTitle = "Sim Sim";
const screenWidth = 480;
const screenHeight = 640;
const fps = 30;
const cellSide  = 4;
const typeShort = 50;
const typeLong = 40;
const gridWidth = screenWidth / cellSide;
const gridHeight = screenHeight / cellSide - 15;

const skyColor =    rl.Color{ .r = 102, .g = 191, .b = 255, .a = 210 };
const gravelColor = rl.Color{ .r = 130, .g = 130, .b = 130, .a = 150 };
const waterColor=   rl.Color{ .r = 20,  .g = 82,  .b = 200, .a = 150 };
const sandColor =   rl.Color{ .r = 211, .g = 169, .b = 108, .a = 215 };
const smokeColor =  rl.Color{ .r = 200, .g = 200, .b = 200, .a = 245 };
const acidColor =   rl.Color{ .r = 0,   .g = 208, .b = 65,  .a = 200 };
const rockColor =   rl.Color{ .r = 40,  .g = 40,  .b = 40,  .a = 230 };


var rand: std.Random = undefined;

const CellType = enum {
    air,
    gravel,
    water,
    sand,
    smoke,
    acid,
    rock,
};

const ParticleHandler = struct {
    const Self = @This();

    grid: [gridWidth][gridHeight]CellType,

    fn init() Self {
        var grid: [gridWidth][gridHeight]CellType = undefined;
        for (0..gridWidth) |i| {
            for (0..gridHeight) |j| {
                grid[i][j] = .air;
            }
        }
        return .{ .grid = grid, };
    }

    fn drawParticles(self: Self) void {
        for (0..gridWidth) |i| {
            for (0..gridHeight) |j| {
                const color = switch (self.grid[i][j]) {
                    .air => skyColor,
                    .gravel => gravelColor,
                    .water => waterColor,
                    .sand => sandColor,
                    .smoke => smokeColor,
                    .acid => acidColor,
                    .rock => rockColor,
                };
                rl.DrawRectangle(
                    @intCast(i * cellSide),
                    @intCast(j * cellSide),
                    cellSide,
                    cellSide,
                    color);
            }
        }
        rl.DrawRectangle(10,  585, typeLong, typeShort, skyColor);
        rl.DrawRectangle(55,  585, typeLong, typeShort, gravelColor);
        rl.DrawRectangle(100, 585, typeLong, typeShort, waterColor);
        rl.DrawRectangle(145, 585, typeLong, typeShort, sandColor);
        rl.DrawRectangle(190, 585, typeLong, typeShort, smokeColor);
        rl.DrawRectangle(235, 585, typeLong, typeShort, acidColor);
        rl.DrawRectangle(280, 585, typeLong, typeShort, rockColor);
    }

    fn putParticles(self: *Self, x: usize, y: usize, brush_size: usize, selected_brush: CellType) void {
        const xn: i32 = @intCast(@divTrunc(x, cellSide));
        const yn: i32 = @intCast(@divTrunc(y, cellSide));
        var i: i32 = 0;
        while (i < brush_size) : (i += 1) {
            var j: i32 = 0;
            while (j < brush_size) : (j += 1) {
                const ix = xn - @as(i32, @intCast(brush_size / 2)) + i;
                const iy = yn - @as(i32, @intCast(brush_size / 2)) + j;
                if (ix >= 0
                    and ix < gridWidth
                    and iy >= 0
                    and iy < gridHeight)
                {
                    self.grid[@intCast(ix)][@intCast(iy)] = selected_brush;
                }
            }
        }
    }

    fn simulate(self: *Self) void {
        self.simulateHorizontal();
        self.simulateVertical();
    }

    fn simulateVertical(self: *Self) void {
        var moved: [gridWidth][gridHeight]bool = .{.{false} ** gridHeight} ** gridWidth;
        var smoke_count: usize = 0;
        var sum_smoke: usize = 0;
        var j: usize = gridHeight - 1;

        while (j != std.math.maxInt(usize)) : (j -%= 1) {
            sum_smoke += smoke_count;
            smoke_count = 0;
            for (0..gridWidth) |i| {
                if (moved[i][j]) continue;

                switch (self.grid[i][j]) {
                    .gravel => {
                        if (j + 1 < gridHeight
                            and self.grid[i][j + 1] == .acid)
                        {
                            self.grid[i][j] = .smoke;
                            self.grid[i][j + 1] = .smoke;
                        }
                        else if (j + 1 < gridHeight
                            and (self.grid[i][j + 1] == .air or self.grid[i][j + 1] == .water))
                        {
                            self.grid[i][j] = self.grid[i][j + 1];
                            self.grid[i][j + 1] = .gravel;
                        }
                    },
                    .water => {
                        if (j + 1 < gridHeight
                            and self.grid[i][j + 1] == .acid)
                        {
                            self.grid[i][j] = .smoke;
                            self.grid[i][j + 1] = .smoke;
                        }
                        else if (j + 1 < gridHeight
                            and self.grid[i][j + 1] == .air)
                        {
                            self.grid[i][j] = .air;
                            self.grid[i][j + 1] = .water;
                        }
                    },
                    .sand => {
                        if (j + 1 < gridHeight
                            and self.grid[i][j + 1] == .acid)
                        {
                            self.grid[i][j] = .smoke;
                            self.grid[i][j + 1] = .smoke;
                        }
                        else if (j + 1 < gridHeight
                            and (self.grid[i][j + 1] == .air or self.grid[i][j + 1] == .water))
                        {
                            self.grid[i][j] = self.grid[i][j + 1];
                            self.grid[i][j + 1] = .sand;
                        }
                    },
                    .smoke => {
                        if (sum_smoke < 1400) {
                            smoke_count += 1;
                        }
                        if (@rem(rand.int(i32), @as(i32, @intCast((95 - sum_smoke / 20)))) == 0) {
                            self.grid[i][j] = .air;
                        } else {
                            var x: usize = j;
                            while (x > 0) : (x -= 1) {
                                if (self.grid[i][x] == .smoke) {
                                    moved[i][x] = true;
                                }
                                else if(self.grid[i][x] == .rock){
                                    x += 1;
                                    break;
                                }
                                else {
                                    break;
                                }
                            }
                            self.grid[i][j] = self.grid[i][x];
                            self.grid[i][x] = .smoke;
                            moved[i][x] = true;
                        }
                    },
                    .acid => {
                        if (j + 1 < gridHeight
                            and (self.grid[i][j + 1] == .acid or self.grid[i][j + 1] == .rock))
                        {
                            continue;
                        }
                        else if (j + 1 < gridHeight
                            and self.grid[i][j + 1] != .air
                            and self.grid[i][j + 1] != .smoke)
                        {
                            self.grid[i][j] = .smoke;
                            self.grid[i][j + 1] = .smoke;
                        }
                        else if (j + 1 < gridHeight) {
                            self.grid[i][j] = .air;
                            self.grid[i][j + 1] = .acid;
                        }
                    },
                    else => {},
                }
            }
        }
    }

    fn simulateHorizontal(self: *Self) void {
        var moved: [gridWidth][gridHeight]bool = .{.{false} ** gridHeight} ** gridWidth;

        for (0..gridWidth) |i| {
            var j: usize = gridHeight - 1;
            while (j != std.math.maxInt(usize)) : (j -%= 1) {
                if (moved[i][j]) continue;

                switch (self.grid[i][j]) {
                    .water => {
                        if (@rem(rand.int(i32), 2) == 0) {
                            if (i != 0) {
                                if (i - 1 >= 0
                                    and self.grid[i - 1][j] == .air)
                                {
                                    self.grid[i - 1][j] = .water;
                                    self.grid[i][j] = .air;
                                }
                            }
                        }
                        else {
                            if (i + 1 < gridWidth
                                and self.grid[i + 1][j] == .air)
                            {
                                self.grid[i + 1][j] = .water;
                                self.grid[i][j] = .air;
                            }
                        }
                    },
                    .sand => {
                        if (@rem(rand.int(i32), 2) == 0) {
                            if (i != 0) {
                                if (i - 1 >= 0
                                    and j + 1 < gridHeight
                                    and (self.grid[i - 1][j + 1] == .air or self.grid[i - 1][j + 1] == .water)
                                    and self.grid[i - 1][j] != .sand
                                    and self.grid[i - 1][j] != .gravel
                                    and self.grid[i - 1][j] != .rock
                                    and self.grid[i][j + 1] != .air)
                                {
                                    self.grid[i][j] = self.grid[i - 1][j];
                                    moved[i][j] = true;
                                    self.grid[i - 1][j] = .sand;
                                    moved[i - 1][j] = true;
                                }
                            }
                        }
                        else if (i + 1 < gridWidth
                            and j + 1 < gridHeight
                            and (self.grid[i + 1][j + 1] == .air or self.grid[i + 1][j + 1] == .water)
                            and self.grid[i + 1][j] != .sand
                            and self.grid[i + 1][j] != .gravel
                            and self.grid[i + 1][j] != .rock
                            and self.grid[i][j + 1] != .air)
                        {
                            self.grid[i][j] = self.grid[i + 1][j];
                            moved[i][j] = true;
                            self.grid[i + 1][j] = .sand;
                            moved[i + 1][j] = true;
                        }
                    },
                    .smoke => {
                        if (@rem(rand.int(i32), 2) == 0) {
                            if (i != 0) {
                                if (i - 1 >= 0
                                    and self.grid[i - 1][j] == .air)
                                {
                                    self.grid[i - 1][j] = .smoke;
                                    self.grid[i][j] = .air;
                                }
                            }
                        }
                        else if (i + 1 < gridWidth
                            and self.grid[i + 1][j] == .air)
                        {
                                self.grid[i + 1][j] = .smoke;
                                self.grid[i][j] = .air;
                        }
                    },
                    .acid => {
                        if (@rem(rand.int(i32), 2) == 0) {
                            if (i != 0) {
                                if (j + 1 < gridHeight
                                    and i - 1 >= 0
                                    and self.grid[i][j + 1] == .acid
                                    and self.grid[i - 1][j] != .air
                                    and self.grid[i - 1][j] != .acid
                                    and self.grid[i - 1][j] != .rock)
                                {
                                    self.grid[i - 1][j] = .smoke;
                                    self.grid[i][j] = .smoke;
                                }
                                else if (i - 1 >= 0
                                    and self.grid[i - 1][j] == .air)
                                {
                                    self.grid[i][j] = self.grid[i - 1][j];
                                    self.grid[i - 1][j] = .acid;
                                }
                            }
                        }
                        else {
                            if (j + 1 < gridHeight
                                and i + 1 < gridWidth
                                and self.grid[i][j + 1] == .acid
                                and self.grid[i + 1][j] != .air
                                and self.grid[i + 1][j] != .acid
                                and self.grid[i + 1][j] != .rock)
                            {
                                self.grid[i + 1][j] = .smoke;
                                self.grid[i][j] = .smoke;
                            }
                            else if (i + 1 < gridWidth
                                and self.grid[i + 1][j] == .air)
                            {
                                self.grid[i][j] = self.grid[i + 1][j];
                                self.grid[i + 1][j] = .acid;
                            }
                        }
                    },
                    else => {},
                }
            }
        }
    }
};

const Simulator = struct {
    const Self = @This();

    handler: ParticleHandler,
    selected_brush: CellType,
    brush_size: usize,

    fn init() Self {
        rl.InitWindow(screenWidth, screenHeight, screenTitle);
        rl.SetTargetFPS(fps);
        return .{
            .handler = ParticleHandler.init(),
            .selected_brush = .air,
            .brush_size = 1,
        };
    }

    fn deinit(self: Self) void {
        _ = self;
        rl.CloseWindow();
    }

    fn run(self: *Self) void {
        while (!rl.WindowShouldClose()) {
            self.drawingFunction();
            self.handler.simulate();
            self.mouseInteraction();
        }
    }

    fn drawingFunction(self: Self) void {
        rl.BeginDrawing();
            rl.ClearBackground(rl.BLACK);
            self.handler.drawParticles();
            rl.DrawText(rl.TextFormat("%d", self.brush_size), 355, 590, 40, rl.WHITE);
            rl.DrawRectangle(400, 603, 30, 10, rl.WHITE);
            rl.DrawRectangle(410, 593, 10, 30, rl.WHITE);
            rl.DrawRectangle(440, 603, 30, 10, rl.WHITE);
        rl.EndDrawing();
    }

    fn mouseInteraction(self: *Self) void {
        const x = rl.GetMouseX();
        const y = rl.GetMouseY();
        if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT)) {
            if (y >= 585) {
                if (x > 10 and x < 10 + typeLong) {
                    self.selected_brush = .air;
                }
                else if (x > 55 and x < 55 + typeLong) {
                    self.selected_brush = .gravel;
                }
                else if (x > 100 and x < 100 + typeLong) {
                    self.selected_brush = .water;
                }
                else if (x > 145 and x < 145 + typeLong) {
                    self.selected_brush = .sand;
                }
                else if (x > 190 and x < 190 + typeLong) {
                    self.selected_brush = .smoke;
                }
                else if (x > 235 and x < 235 + typeLong) {
                    self.selected_brush = .acid;
                }
                else if (x > 280 and x < 280 + typeLong) {
                    self.selected_brush = .rock;
                }
                else if (self.brush_size < 15 and x > 400 and x < 430 and rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT)) {
                    self.brush_size += 1;
                }
                else if (self.brush_size > 1 and x > 440 and x < 470 and rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT)) {
                    self.brush_size -= 1;
                }
            } else {
                if (x >= 0 and y >= 0) {
                    self.handler.putParticles(@intCast(x), @intCast(y), self.brush_size, self.selected_brush);
                }
            }
        }
    }
};

//
// This is a port of https://github.com/SzyZub/ParticleSimulator
//

pub fn run() !void {

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    rand = prng.random();

    var sim = Simulator.init();
    defer sim.deinit();
    sim.run();
}
