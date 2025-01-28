const std = @import("std");

fn define_macros(raylib_module: *std.Build.Module) void {

    //------------------------------------------------------------------------------------
    // Don't use the built in config.h
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("EXTERNAL_CONFIG_FLAGS", "1");

    //------------------------------------------------------------------------------------
    // Module selection - Some modules could be avoided
    // Mandatory modules: rcore, rlgl, utils
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_MODULE_RSHAPES", "1");
    raylib_module.addCMacro("SUPPORT_MODULE_RTEXTURES", "1");
    raylib_module.addCMacro("SUPPORT_MODULE_RTEXT", "1");
    // raylib_module.addCMacro("SUPPORT_MODULE_RMODELS", "1");
    // raylib_module.addCMacro("SUPPORT_MODULE_RAUDIO", "1");

    //------------------------------------------------------------------------------------
    // Module: rcore
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_CAMERA_SYSTEM", "1");
    raylib_module.addCMacro("SUPPORT_GESTURES_SYSTEM", "1");
    raylib_module.addCMacro("SUPPORT_RPRAND_GENERATOR", "1");
    raylib_module.addCMacro("SUPPORT_MOUSE_GESTURES", "1");
    raylib_module.addCMacro("SUPPORT_SSH_KEYBOARD_RPI", "1");
    raylib_module.addCMacro("SUPPORT_WINMM_HIGHRES_TIMER", "1");
    raylib_module.addCMacro("SUPPORT_PARTIALBUSY_WAIT_LOOP", "1");
    raylib_module.addCMacro("SUPPORT_SCREEN_CAPTURE", "1");
    raylib_module.addCMacro("SUPPORT_GIF_RECORDING", "1");
    raylib_module.addCMacro("SUPPORT_COMPRESSION_API", "1");
    raylib_module.addCMacro("SUPPORT_AUTOMATION_EVENTS", "1");
    // raylib_module.addCMacro("SUPPORT_CUSTOM_FRAME_CONTROL", "1");

    raylib_module.addCMacro("MAX_FILEPATH_CAPACITY", "8192");
    raylib_module.addCMacro("MAX_FILEPATH_LENGTH", "4096");

    raylib_module.addCMacro("MAX_KEYBOARD_KEYS", "512");
    raylib_module.addCMacro("MAX_MOUSE_BUTTONS", "8");
    raylib_module.addCMacro("MAX_GAMEPADS", "4");
    raylib_module.addCMacro("MAX_GAMEPAD_AXIS", "8");
    raylib_module.addCMacro("MAX_GAMEPAD_BUTTONS", "32");
    raylib_module.addCMacro("MAX_GAMEPAD_VIBRATION_TIME", "2.0f");
    raylib_module.addCMacro("MAX_TOUCH_POINTS", "8");
    raylib_module.addCMacro("MAX_KEY_PRESSED_QUEUE", "16");
    raylib_module.addCMacro("MAX_CHAR_PRESSED_QUEUE", "16");

    raylib_module.addCMacro("MAX_DECOMPRESSION_SIZE", "64");

    raylib_module.addCMacro("MAX_AUTOMATION_EVENTS", "16384");

    //------------------------------------------------------------------------------------
    // Module: rlgl
    //------------------------------------------------------------------------------------

    // raylib_module.addCMacro("RLGL_ENABLE_OPENGL_DEBUG_CONTEXT", "1");

    // raylib_module.addCMacro("RLGL_SHOW_GL_DETAILS_INFO", "1");

    // raylib_module.addCMacro("RL_DEFAULT_BATCH_BUFFER_ELEMENTS", "4096");
    raylib_module.addCMacro("RL_DEFAULT_BATCH_BUFFERS", "1");
    raylib_module.addCMacro("RL_DEFAULT_BATCH_DRAWCALLS", "256");
    raylib_module.addCMacro("RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS", "4");

    raylib_module.addCMacro("RL_MAX_MATRIX_STACK_SIZE", "32");

    raylib_module.addCMacro("RL_MAX_SHADER_LOCATIONS", "32");

    raylib_module.addCMacro("RL_CULL_DISTANCE_NEAR", "0.01");
    raylib_module.addCMacro("RL_CULL_DISTANCE_FAR", "1000.0");

    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_POSITION", "0");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_TEXCOORD", "1");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_NORMAL", "2");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_COLOR", "3");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_TANGENT", "4");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_LOCATION_TEXCOORD2", "5");

    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_POSITION", "\"vertexPosition\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD", "\"vertexTexCoord\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_NORMAL", "\"vertexNormal\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_COLOR", "\"vertexColor\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_TANGENT", "\"vertexTangent\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD2", "\"vertexTexCoord2\"");

    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_MVP", "\"mvp\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_VIEW", "\"matView\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_PROJECTION", "\"matProjection\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_MODEL", "\"matModel\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_NORMAL", "\"matNormal\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_UNIFORM_NAME_COLOR", "\"colDiffuse\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE0", "\"texture0\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE1", "\"texture1\"");
    raylib_module.addCMacro("RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE2", "\"texture2\"");

    //------------------------------------------------------------------------------------
    // Module: rshapes
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_QUADS_DRAW_MODE", "1");

    raylib_module.addCMacro("SPLINE_SEGMENT_DIVISIONS", "24");

    //------------------------------------------------------------------------------------
    // Module: rtextures
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_FILEFORMAT_PNG", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_BMP", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_TGA", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_JPG", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_GIF", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_QOI", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_PSD", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_DDS", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_HDR", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_PIC", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_KTX", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_ASTC", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_PKM", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_PVR", "1");
    // raylib_module.addCMacro("SUPPORT_FILEFORMAT_SVG", "1");

    raylib_module.addCMacro("SUPPORT_IMAGE_EXPORT", "1");
    raylib_module.addCMacro("SUPPORT_IMAGE_GENERATION", "1");
    raylib_module.addCMacro("SUPPORT_IMAGE_MANIPULATION", "1");

    //------------------------------------------------------------------------------------
    // Module: rtext
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_DEFAULT_FONT", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_TTF", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_FNT", "1");
    //raylib_module.addCMacro("SUPPORT_FILEFORMAT_BDF", "1");

    raylib_module.addCMacro("SUPPORT_TEXT_MANIPULATION", "1");
    raylib_module.addCMacro("SUPPORT_FONT_ATLAS_WHITE_REC", "1");

    raylib_module.addCMacro("MAX_TEXT_BUFFER_LENGTH", "1024");
    raylib_module.addCMacro("MAX_TEXTSPLIT_COUNT", "128");

    //------------------------------------------------------------------------------------
    // Module: rmodels
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_FILEFORMAT_OBJ", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_MTL", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_IQM", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_GLTF", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_VOX", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_M3D", "1");

    raylib_module.addCMacro("SUPPORT_MESH_GENERATION", "1");

    raylib_module.addCMacro("MAX_MATERIAL_MAPS", "12");
    raylib_module.addCMacro("MAX_MESH_VERTEX_BUFFERS", "7");

    //------------------------------------------------------------------------------------
    // Module: raudio
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_FILEFORMAT_WAV", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_OGG", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_MP3", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_QOA", "1");
    //raylib_module.addCMacro("SUPPORT_FILEFORMAT_FLAC","1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_XM", "1");
    raylib_module.addCMacro("SUPPORT_FILEFORMAT_MOD", "1");

    raylib_module.addCMacro("AUDIO_DEVICE_FORMAT", "ma_format_f32");
    raylib_module.addCMacro("AUDIO_DEVICE_CHANNELS", "2");
    raylib_module.addCMacro("AUDIO_DEVICE_SAMPLE_RATE", "0");

    raylib_module.addCMacro("MAX_AUDIO_BUFFER_POOL_CHANNELS", "16");

    //------------------------------------------------------------------------------------
    // Module: utils
    //------------------------------------------------------------------------------------

    raylib_module.addCMacro("SUPPORT_STANDARD_FILEIO", "1");
    raylib_module.addCMacro("SUPPORT_TRACELOG", "1");
    // raylib_module.addCMacro("SUPPORT_TRACELOG_DEBUG", "1");
    raylib_module.addCMacro("MAX_TRACELOG_MSG_LENGTH", "256");
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "Adventures with Raylib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        .rmodels = false,
        .raudio = false,
    });

    exe.addIncludePath(raylib_dep.path("src"));

    const raylib = raylib_dep.artifact("raylib");
    define_macros(raylib.root_module);
    exe.linkLibrary(raylib);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
