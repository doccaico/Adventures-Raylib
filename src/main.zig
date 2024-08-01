// const std = @import("std");
const mugen_eyes = @import("mugen_eyes/mugen_eyes.zig");
const atsu_grains = @import("atsu_grains/atsu_grains.zig");
const sim_sim = @import("sim_sim/sim_sim.zig");

pub fn main() !void {
    // try mugen_eyes.run();
    // try atsu_grains.run();
    try sim_sim.run();
}
