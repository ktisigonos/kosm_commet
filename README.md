# kosm_commet

Commet (the Matrix client) for kosm: a custom theme of its own, selected in Commet's preferences.

The app writes the theme whole to
`~/.var/app/chat.commet.commetapp/data/commet/theme/custom/kosm/theme.json` (the Flatpak's
data folder; a native Commet reads `~/.local/share/chat.commet.commetapp/theme/custom/`), with
only the colors that are set; Commet takes the rest from the theme's `base`. Colors are written
alpha first (`#aarrggbb`), as Commet reads them. Commet names a custom theme by its folder, so
the app then sets `flutter.app_theme` in Commet's `shared_preferences.json` to that folder's
name, adding the key when missing. Set `preferences = null` to leave the preferences alone and
pick the theme in Commet's appearance settings yourself.

Commet reads its theme and preferences only when it starts: after an apply, restart Commet to
see the new colors. A running Commet writes its preferences back whenever a setting changes,
which can undo the selection on the first apply; quit Commet before it, or pick the theme once
in its settings.

Commet's fonts are built in and its window is opaque, so the app has no font or opacity fields.

With the theme's `files = .per_kosmos` the theme's folder is named after the kosmos instead
(`krystallos.dark`), so each kosmos applied keeps its own.

`from(theme)` lays the colors out like Commet's own Dark and Light themes, which are built on
the same Material slots: most panels (`surface_container_low`) on the background role, one
shade below it (`surface.sunken`, also the foundation behind every panel) and a few above
(`surface.raised`, `surface.overlay`, `line.border`); quiet text and icons, which Commet takes
from `secondary`, the foreground made muted; the accent only as `primary`; `tertiary` from the
warning role, as Dark uses yellow; errors, links and inline code from the error, link and keyword
code colors; and, in dark mode, Dark's 1 px round borders between panels.

## Fields

| Field | Default |
|---|---|
| `file` | `~/.var/app/chat.commet.commetapp/data/commet/theme/custom/{name}/theme.json`; `{name}` is `kosm`, or the kosmos' name with `files = .per_kosmos`; the theme is selected by the folder's name |
| `files` | the theme's `files`: `.shared` or `.per_kosmos` |
| `preferences` | `~/.var/app/chat.commet.commetapp/data/commet/shared_preferences.json`, whose `flutter.app_theme` selects the theme; null leaves it alone |
| `base` | `.dark`; `.light`, `.you_dark` or `.you_light` (the desktop's accent color); the theme the colors left null come from |
| `color_scheme` | every key of Commet's `colorScheme` in Zig casing: `seed` and `dynamic_scheme_variant`, Material 3's roles (`primary`, `on_primary`, `primary_container`, ..., `surface_container_highest`, `inverse_surface`, `shadow`, `scrim`, `surface_tint`), `links` and `code_highlight`; null leaves each color to the base |
| `foundation_color` | null: the base's; `from`: the background, `surface.sunken` |
| `settings` | `caulk_borders`, `caulk_stroke_thickness`, `caulk_border_radius`, `caulk_padding`, `shadow_blur_radius`; Commet replaces the base's with these, so null is off or 0; `from`: borders 1 px round in dark mode, as Commet's Dark |
