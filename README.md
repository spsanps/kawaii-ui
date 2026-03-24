# Kawaii UI

A glossy, tactile, kawaii-skeuomorphic Flutter UI library where every element has physical mass, volume, and surface response — like candy, polished toys, or macarons.

## Features

### Core Primitives
- **KawaiiSurface** — glossy shine treatment for any widget (full/medium/subtle gloss)
- **KawaiiPressable** — instant press + bouncy spring release animation
- **KawaiiEntrance** — staggered fade + slide entrance animations

### Theming
- **KawaiiTheme** — InheritedWidget with `KawaiiTheme.of(context)`
- 5 built-in palettes: Sakura, Ocean, Forest, Lavender, Sunset
- Design tokens: spacing, border radii, shadows, opacity, curves

### Widgets
| Widget | Description |
|--------|-------------|
| `KawaiiButton` | Glossy button with 5 color presets, hero/small variants |
| `KawaiiCard` | Glass panel with inner bevel + optional corner sparkles |
| `KawaiiBadge` | Glossy circle icon container |
| `KawaiiTag` | Label chip with subtle shine |
| `KawaiiAvatar` | Circle avatar with status indicator |
| `KawaiiStat` | Animated counter pill |
| `KawaiiProgress` | Animated fill bar with gloss |
| `KawaiiCircularProgress` | Animated circular progress ring |
| `KawaiiToggle` | Switch with glossy knob |
| `KawaiiInput` | Text field with embedded action button |
| `KawaiiTextField` | Simple glass text input (no button) |
| `KawaiiCheckbox` | Rounded square with animated check |
| `KawaiiRadio<T>` | Circular radio with spring-animated dot |
| `KawaiiSlider` | Glossy track + draggable thumb |
| `KawaiiChip` | Selectable/deletable chip with avatar |
| `KawaiiNotification` | Pressable notification row |
| `KawaiiListTile` | Leading/title/subtitle/trailing list item |
| `KawaiiDivider` | Soft gradient divider |
| `KawaiiSparkleField` | Ambient animated background sparkles |

### App Shell
- `KawaiiScaffold` — gradient background + sparkle field + safe area
- `KawaiiAppBar` — frosted glass app bar
- `KawaiiBottomNavBar` — glossy bottom nav with animated pill indicator
- `KawaiiTabBar` — sliding glossy pill tab selector

### Overlays
- `showKawaiiDialog()` — centered modal with scale+fade entrance
- `showKawaiiBottomSheet()` — slide-up glass panel with drag handle
- `showKawaiiSnackbar()` — floating toast (success/error/info/warning)

### Sound & Haptics
- 8 synthesized UI sounds (boop, pop, tick, toggle, chime, send, notif, reward)
- Single-syllable sound design — clean, minimal haptic clicks
- All widgets support `playSound: false` to prevent stacking

### Icons
- 13 hand-drawn CustomPainter icons (Heart, Dress, Dumbbell, Moon, Pen, MusicNote, Search, ChatBubble, Bell, Send, Check, Arrow, PlayTriangle, Star4)
- `SparkleWidget` — animated pulsing sparkle

## Quick Start

```dart
import 'package:kawaii_ui/kawaii_ui.dart';

// Basic button
KawaiiButton.pink('Hello', onTap: () {});

// Glossy card
KawaiiCard(child: Text('Content'));

// Circular progress
KawaiiCircularProgress(progress: 0.75, color: Color(0xFFF06292));

// Dialog
showKawaiiDialog(
  context: context,
  title: 'Hello!',
  content: Text('Kawaii dialog'),
  actions: [KawaiiButton.pink('OK', onTap: () => Navigator.pop(context))],
);
```

## Example App

The `lib/app/` directory contains **Kawaii Life** — a fully functional todo, mood journal, and goals tracker app that showcases every widget in the library.

Run it:
```bash
flutter run
```

## Design Principles

1. **Every surface has gloss** — top-lit shine gradient on all interactive elements
2. **Everything is pressable** — instant press (0ms) + bouncy spring release (200ms)
3. **Single-syllable feedback** — one clean haptic click per action, never multi-buzz
4. **Tokens over magic numbers** — spacing, radii, shadows, opacity all from the token system
5. **Sound is opt-in** — all widgets accept `playSound: false` to prevent stacking
6. **Decorative elements are behind content** — sparkles and bevel borders never interfere with interactions

## License

MIT
