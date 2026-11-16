//! Commet: a custom theme of its own, selected in Commet's preferences.

const std = @import("std");

/// The Commet theme; build one with `from`.
pub const App = @import("App.zig");
/// Colors from the theme.
pub const from = App.from;
/// The adapter the app writes the theme and edits the preferences with, so a config needs only
/// this package.
pub const json_adapter = @import("kosm_json").adapter;

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(App);
    std.testing.refAllDecls(App.ColorScheme);
}
