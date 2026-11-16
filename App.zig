//! A Commet theme of its own, generated whole, and Commet's preferences selecting it. Field
//! names are Commet's, in Zig casing.

const App = @This();

const std = @import("std");
const kosm = @import("kosm");

/// The theme file kosm owns; `{name}` is filled as `files` says. Commet names a custom theme by
/// its folder, which must hold the file as `theme.json`. Default: the Flatpak's
/// `~/.var/app/chat.commet.commetapp/data/commet/theme/custom/{name}/theme.json`; a native
/// Commet reads `~/.local/share/chat.commet.commetapp/theme/custom/`.
file: []const u8 = "~/.var/app/chat.commet.commetapp/data/commet/theme/custom/{name}/theme.json",
/// How `{name}` in `file` is filled: `kosm`, or the kosmos' name. Default: the theme's `files`.
files: kosm.Theme.Files = .shared,
/// Commet's preferences, whose `flutter.app_theme` the app sets to the theme's folder name,
/// adding the key when missing. Commet reads it at start. null: not touched; pick the theme in
/// Commet's appearance settings yourself. Default: the Flatpak's
/// `~/.var/app/chat.commet.commetapp/data/commet/shared_preferences.json`.
preferences: ?[]const u8 = "~/.var/app/chat.commet.commetapp/data/commet/shared_preferences.json",
/// `base`: Commet's theme the colors left null come from. `from`: the theme's mode. Default:
/// `.dark`.
base: Base = .dark,
/// `colorScheme`.
color_scheme: ColorScheme = .{},
/// `foundation.color`: the backdrop behind every panel. `from`: the background role. null:
/// the base's.
foundation_color: ?kosm.Color = null,

/// A theme's `colorScheme`.
pub const ColorScheme = @import("ColorScheme.zig");

/// Commet's built-in themes a custom theme starts from; the `you_` ones take the desktop's
/// accent color.
pub const Base = enum { dark, light, you_dark, you_light };

/// The base from the theme's mode, and colors from the theme: Material's roles from the
/// accent, secondary and error roles and the palette's purple, surfaces from the background and
/// the theme's surface variations, text from the foreground, links from the link role and inline
/// code from the keyword code color.
pub fn from(theme: kosm.Theme) App {
    const roles = theme.roles;
    const variations = theme.variations;
    const background = roles.background;
    const foreground = roles.foreground;
    const on = variations.contrast.on;
    const container = variations.alpha.highlight;
    const tertiary = theme.palette.purple;
    return .{
        .files = theme.files,
        .base = if (theme.mode == .dark) .dark else .light,
        .foundation_color = background,
        .color_scheme = .{
            .primary = roles.accent,
            .on_primary = on.apply(roles.accent),
            .primary_container = container.apply(roles.accent),
            .on_primary_container = foreground,
            .secondary = roles.secondary,
            .on_secondary = on.apply(roles.secondary),
            .secondary_container = container.apply(roles.secondary),
            .on_secondary_container = foreground,
            .tertiary = tertiary,
            .on_tertiary = on.apply(tertiary),
            .tertiary_container = container.apply(tertiary),
            .on_tertiary_container = foreground,
            .@"error" = roles.@"error",
            .on_error = on.apply(roles.@"error"),
            .error_container = container.apply(roles.@"error"),
            .on_error_container = foreground,
            .outline = variations.line.border.apply(background),
            .outline_variant = variations.line.separator.apply(background),
            .surface = background,
            .on_surface = foreground,
            .on_surface_variant = variations.emphasis.muted.apply(foreground),
            .surface_dim = variations.surface.sunken.apply(background),
            .surface_bright = variations.surface.raised.apply(background),
            .surface_container_lowest = variations.surface.sunken.apply(background),
            .surface_container_low = background,
            .surface_container = variations.surface.raised.apply(background),
            .surface_container_high = variations.surface.overlay.apply(background),
            .surface_container_highest = variations.surface.overlay.then(variations.surface.raised).apply(background),
            .inverse_surface = foreground,
            .on_inverse_surface = background,
            .links = roles.link,
            .code_highlight = theme.code.keyword,
        },
    };
}

/// Writes the theme whole, then sets the preferences to select it.
pub fn apply(self: App, output: *kosm.Output) !void {
    const file = try output.namedFile(self.file, self.files);
    const folder = std.Io.Dir.path.dirname(file) orelse "";
    const theme_name = std.Io.Dir.path.basename(folder);
    if (!std.mem.eql(u8, std.Io.Dir.path.basename(file), "theme.json") or theme_name.len == 0)
        return output.fail(file, "Commet reads a custom theme only from 'theme.json' in a folder named after it", .{});
    try output.generate(.{ .file = file, .lang = "json", .format = .{ .color = .hex8_argb } }, try self.themeValue(output.allocator));

    const preferences_file = self.preferences orelse return;
    var preferences = try output.edit(.{ .files = preferences_file, .lang = "json" });
    const key = "flutter.app_theme";
    if ((try preferences.nodes(.{key})).len == 0)
        return preferences.insert((try preferences.nodes(""))[0], key, theme_name);
    try preferences.set(.{key}, theme_name);
}

/// What `theme.json` holds: the base, the colors that are set and the foundation's color.
fn themeValue(self: App, allocator: std.mem.Allocator) std.mem.Allocator.Error!kosm.Value {
    var sections: std.ArrayList(kosm.Value.Entry) = .empty;
    try sections.append(allocator, .{ .key = "base", .value = .{ .string = @tagName(self.base) } });
    if (try colorSchemeValue(allocator, self.color_scheme)) |scheme| try sections.append(allocator, .{ .key = "colorScheme", .value = scheme });
    if (self.foundation_color) |color| {
        const foundation = try allocator.dupe(kosm.Value.Entry, &.{.{ .key = "color", .value = .{ .color = color } }});
        try sections.append(allocator, .{ .key = "foundation", .value = .{ .table = foundation } });
    }
    return .{ .table = sections.items };
}

/// The set fields of `scheme` under Commet's camelCase names; null when none is set.
fn colorSchemeValue(allocator: std.mem.Allocator, scheme: ColorScheme) std.mem.Allocator.Error!?kosm.Value {
    var entries: std.ArrayList(kosm.Value.Entry) = .empty;
    inline for (@typeInfo(ColorScheme).@"struct".field_names) |name| {
        const value: ?kosm.Value = switch (@TypeOf(@field(scheme, name))) {
            ?kosm.Color => if (@field(scheme, name)) |color| .{ .color = color } else null,
            ?ColorScheme.DynamicSchemeVariant => if (@field(scheme, name)) |variant| .{ .string = switch (variant) {
                inline else => |tag| comptime camelCase(@tagName(tag)),
            } } else null,
            else => @compileError("ColorScheme." ++ name ++ " has a type colorSchemeValue does not write"),
        };
        if (value) |present| try entries.append(allocator, .{ .key = comptime camelCase(name), .value = present });
    }
    return if (entries.items.len == 0) null else .{ .table = entries.items };
}

/// `snake_case` as `camelCase`, as Commet and Flutter name keys and enum values.
fn camelCase(comptime name: []const u8) []const u8 {
    comptime {
        @setEvalBranchQuota(100 * name.len);
        var result: []const u8 = "";
        var upper_next = false;
        for (name) |character| {
            if (character == '_') {
                upper_next = true;
                continue;
            }
            result = result ++ .{if (upper_next) std.ascii.toUpper(character) else character};
            upper_next = false;
        }
        return result;
    }
}

const testing = std.testing;
const root = @import("root.zig");

const Fixture = struct {
    tmp: testing.TmpDir,
    arena: std.heap.ArenaAllocator,
    plan: kosm.Plan,
    diagnostics: kosm.Diagnostics = .{},
    warnings: kosm.Warnings = undefined,
    home_buffer: [std.Io.Dir.max_path_bytes]u8 = undefined,
    output: kosm.Output = undefined,

    fn init(fixture: *Fixture, preferences: ?[]const u8) !void {
        fixture.* = .{ .tmp = testing.tmpDir(.{}), .arena = .init(testing.allocator), .plan = .init(testing.allocator, testing.io) };
        if (preferences) |text| {
            try fixture.tmp.dir.createDirPath(testing.io, ".var/app/chat.commet.commetapp/data/commet");
            try fixture.tmp.dir.writeFile(testing.io, .{ .sub_path = ".var/app/chat.commet.commetapp/data/commet/shared_preferences.json", .data = text });
        }
        fixture.warnings = .init(fixture.arena.allocator());
        const length = try fixture.tmp.dir.realPath(testing.io, &fixture.home_buffer);
        fixture.output = .{
            .allocator = fixture.arena.allocator(),
            .home = fixture.home_buffer[0..length],
            .adapters = &.{root.json_adapter},
            .plan = &fixture.plan,
            .diagnostics = &fixture.diagnostics,
            .warnings = &fixture.warnings,
            .app = "commet",
            .kosmos = "krystallos.dark",
        };
    }

    fn deinit(fixture: *Fixture) void {
        fixture.plan.deinit();
        fixture.arena.deinit();
        fixture.tmp.cleanup();
    }

    fn planned(fixture: *Fixture, display_path: []const u8) []const u8 {
        for (fixture.plan.files.items) |file| {
            if (std.mem.eql(u8, file.display_path, display_path)) return file.new;
        }
        return "(not planned)";
    }
};

/// Preferences as Commet writes them: one line, keys with dots.
const preferences_json = "{\"flutter.check_for_updates\":false,\"flutter.app_theme\":\"dark\",\"flutter.player_volume\":37.17}";

const theme_path = "~/.var/app/chat.commet.commetapp/data/commet/theme/custom/kosm/theme.json";
const preferences_path = "~/.var/app/chat.commet.commetapp/data/commet/shared_preferences.json";

const test_theme = kosm.Theme.from(.{ .palette = .{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .cyan = kosm.hex("2d8699") }, .mode = .dark });

test "the theme is written whole with alpha-first colors under camelCase keys, and the preferences select it" {
    var fixture: Fixture = undefined;
    try fixture.init(preferences_json);
    defer fixture.deinit();
    try from(test_theme).apply(&fixture.output);

    const written = fixture.planned(theme_path);
    try testing.expect(std.mem.startsWith(u8, written,
        \\{
        \\  "base": "dark",
        \\  "colorScheme": {
        \\    "primary": "#ff2d8699",
        \\    "onPrimary": "#ff041c26",
        \\    "primaryContainer": "#402d8699",
        \\    "onPrimaryContainer": "#ffa3c5cc",
        \\    "secondary": "#ff
    ));
    try testing.expect(std.mem.indexOf(u8, written, "\"surface\": \"#ff041c26\",\n    \"onSurface\": \"#ffa3c5cc\",\n") != null);
    try testing.expect(std.mem.indexOf(u8, written, "\"surfaceContainerHighest\": ") != null);
    try testing.expect(std.mem.indexOf(u8, written, "\"codeHighlight\": ") != null);
    try testing.expect(std.mem.indexOf(u8, written, "seed") == null);
    try testing.expect(std.mem.indexOf(u8, written, "primaryFixed") == null);
    try testing.expect(std.mem.endsWith(u8, written, "  \"foundation\": {\n    \"color\": \"#ff041c26\"\n  }\n}\n"));

    try testing.expectEqualStrings("{\"flutter.check_for_updates\":false,\"flutter.app_theme\":\"kosm\",\"flutter.player_volume\":37.17}", fixture.planned(preferences_path));
}

test "preferences without a theme gain the key, and null preferences are left alone" {
    var fixture: Fixture = undefined;
    try fixture.init("{\"flutter.player_volume\":37.17}");
    defer fixture.deinit();
    try from(test_theme).apply(&fixture.output);
    const preferences = fixture.planned(preferences_path);
    try testing.expect(std.mem.indexOf(u8, preferences, "\"flutter.app_theme\"") != null);
    try testing.expect(std.mem.indexOf(u8, preferences, "\"kosm\"") != null);

    var untouched: Fixture = undefined;
    try untouched.init(null);
    defer untouched.deinit();
    var app = from(test_theme);
    app.preferences = null;
    try app.apply(&untouched.output);
    try testing.expectEqual(1, untouched.plan.files.items.len);
}

test "a seed's variant is written as Flutter names it, and App{} writes only the base" {
    var fixture: Fixture = undefined;
    try fixture.init(preferences_json);
    defer fixture.deinit();
    const seeded: App = .{ .base = .you_light, .color_scheme = .{ .seed = kosm.hex("2d8699"), .dynamic_scheme_variant = .fruit_salad } };
    try seeded.apply(&fixture.output);
    try testing.expectEqualStrings(
        \\{
        \\  "base": "you_light",
        \\  "colorScheme": {
        \\    "seed": "#ff2d8699",
        \\    "dynamicSchemeVariant": "fruitSalad"
        \\  }
        \\}
        \\
    , fixture.planned(theme_path));

    var empty_fixture: Fixture = undefined;
    try empty_fixture.init(null);
    defer empty_fixture.deinit();
    const empty: App = .{ .preferences = null };
    try empty.apply(&empty_fixture.output);
    try testing.expectEqualStrings("{\n  \"base\": \"dark\"\n}\n", empty_fixture.planned(theme_path));
}

test "a file not named theme.json fails, and so do missing preferences" {
    var fixture: Fixture = undefined;
    try fixture.init(null);
    defer fixture.deinit();
    const wrong: App = .{ .file = "~/.local/share/chat.commet.commetapp/theme/custom/kosm.json" };
    try testing.expectError(error.AppFailed, wrong.apply(&fixture.output));
    try testing.expectEqualStrings("Commet reads a custom theme only from 'theme.json' in a folder named after it", fixture.diagnostics.message());

    try testing.expectError(error.NoFile, from(test_theme).apply(&fixture.output));
}

test "per kosmos, the theme gets a folder of the kosmos' own, which the preferences select" {
    var fixture: Fixture = undefined;
    try fixture.init(preferences_json);
    defer fixture.deinit();
    var theme = test_theme;
    theme.files = .per_kosmos;
    try from(theme).apply(&fixture.output);
    try testing.expect(std.mem.startsWith(u8, fixture.planned("~/.var/app/chat.commet.commetapp/data/commet/theme/custom/krystallos.dark/theme.json"), "{\n  \"base\": \"dark\""));
    try testing.expect(std.mem.indexOf(u8, fixture.planned(preferences_path), "\"flutter.app_theme\":\"krystallos.dark\"") != null);
}
