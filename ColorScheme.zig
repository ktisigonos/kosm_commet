//! A theme's `colorScheme`: Material 3's color roles, in Zig casing, and Commet's own link and
//! code colors. Every color left null keeps the `base` theme's.

const ColorScheme = @This();

const kosm = @import("kosm");
const Color = kosm.Color;

/// Generates every role left null from this one color, in the `base` theme's brightness. null
/// (default): no generated roles.
seed: ?Color = null,
/// How `seed` generates the roles. null: Commet's default (`tonal_spot`).
dynamic_scheme_variant: ?DynamicSchemeVariant = null,

/// Buttons, toggles, selected items and focus. `from`: the accent role.
primary: ?Color = null,
/// Text and icons on `primary`. `from`: the accent's `contrast.on`.
on_primary: ?Color = null,
/// Fills in the primary color, such as a selected chip. `from`: the accent role, as in
/// Commet's Dark.
primary_container: ?Color = null,
/// Text and icons on `primary_container`. `from`: the accent's `contrast.on`.
on_primary_container: ?Color = null,
/// `primaryFixed`. null: the base's.
primary_fixed: ?Color = null,
/// `primaryFixedDim`. null: the base's.
primary_fixed_dim: ?Color = null,
/// `onPrimaryFixed`. null: the base's.
on_primary_fixed: ?Color = null,
/// `onPrimaryFixedVariant`. null: the base's.
on_primary_fixed_variant: ?Color = null,

/// Commet's quiet text and icons: room and space names, timestamps, icon buttons. `from`: the
/// foreground, `emphasis.muted`, as Commet's Dark uses a gray.
secondary: ?Color = null,
/// Text and icons on `secondary`. `from`: the background role.
on_secondary: ?Color = null,
/// Quieter fills, such as a hovered item. `from`: the background, `surface.overlay`.
secondary_container: ?Color = null,
/// Text and icons on `secondary_container`. `from`: the foreground role.
on_secondary_container: ?Color = null,
/// `secondaryFixed`. null: the base's.
secondary_fixed: ?Color = null,
/// `secondaryFixedDim`. null: the base's.
secondary_fixed_dim: ?Color = null,
/// `onSecondaryFixed`. null: the base's.
on_secondary_fixed: ?Color = null,
/// `onSecondaryFixedVariant`. null: the base's.
on_secondary_fixed_variant: ?Color = null,

/// A highlight beside `primary`, such as mentions. `from`: the tertiary role.
tertiary: ?Color = null,
/// Text and icons on `tertiary`. `from`: the tertiary's `contrast.on`.
on_tertiary: ?Color = null,
/// A faint wash of the tertiary color. `from`: the tertiary role at alpha 20/255, as in
/// Commet's Dark.
tertiary_container: ?Color = null,
/// Text and icons on `tertiary_container`. `from`: the foreground role.
on_tertiary_container: ?Color = null,
/// `tertiaryFixed`. null: the base's.
tertiary_fixed: ?Color = null,
/// `tertiaryFixedDim`. null: the base's.
tertiary_fixed_dim: ?Color = null,
/// `onTertiaryFixed`. null: the base's.
on_tertiary_fixed: ?Color = null,
/// `onTertiaryFixedVariant`. null: the base's.
on_tertiary_fixed_variant: ?Color = null,

/// Errors and destructive actions. `from`: the error role.
@"error": ?Color = null,
/// Text and icons on `error`. `from`: the error's `contrast.on`.
on_error: ?Color = null,
/// Fills in the error color. `from`: the error role.
error_container: ?Color = null,
/// Text and icons on `error_container`. `from`: the error's `contrast.on`.
on_error_container: ?Color = null,

/// Borders of fields, buttons and panels. `from`: the background, `surface.overlay`, as Commet's
/// Dark matches it to `surface_container_high`.
outline: ?Color = null,
/// Dividers and quieter borders. `from`: the background, `surface.raised`.
outline_variant: ?Color = null,

/// The main area beside the room list. `from`: the background role.
surface: ?Color = null,
/// Text and icons on every surface. `from`: the foreground role.
on_surface: ?Color = null,
/// Quieter text and icons on surfaces. `from`: the foreground, `emphasis.muted`.
on_surface_variant: ?Color = null,
/// A surface darker than `surface` in dark mode. `from`: the background role.
surface_dim: ?Color = null,
/// A surface brighter than `surface` in dark mode. `from`: the background, `surface.overlay`.
surface_bright: ?Color = null,
/// The space rail. `from`: the background role.
surface_container_lowest: ?Color = null,
/// Most of Commet's panels. `from`: the background role.
surface_container_low: ?Color = null,
/// The room list and the room's side panel. `from`: the background role.
surface_container: ?Color = null,
/// `from`: the background, `surface.overlay`.
surface_container_high: ?Color = null,
/// The highest container. `from`: the background, `surface.overlay`.
surface_container_highest: ?Color = null,

/// A surface in the foreground's color, such as a snackbar. `from`: the foreground role.
inverse_surface: ?Color = null,
/// Text and icons on `inverse_surface`. `from`: the background role.
on_inverse_surface: ?Color = null,
/// The primary color on `inverse_surface`. null: the base's.
inverse_primary: ?Color = null,
/// Shadows. null: the base's.
shadow: ?Color = null,
/// The dimming behind dialogs. null: the base's.
scrim: ?Color = null,
/// The tint Material lays over raised surfaces. null: the base's.
surface_tint: ?Color = null,

/// Links in messages. `from`: the link role.
links: ?Color = null,
/// Inline code in messages. `from`: the theme's keyword code color, which Commet's own themes
/// match.
code_highlight: ?Color = null,

/// How a seed color becomes a scheme, as Flutter names it.
pub const DynamicSchemeVariant = enum { tonal_spot, fidelity, monochrome, neutral, vibrant, expressive, content, rainbow, fruit_salad };
