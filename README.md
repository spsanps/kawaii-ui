# Kawaii UI

A glossy, tactile, kawaii-skeuomorphic Flutter UI library where every element has physical mass, volume, and surface response — like candy, polished toys, or macarons.

## Install

```yaml
dependencies:
  kawaii_ui:
    git:
      url: https://github.com/spsanps/kawaii-ui.git
```

## Quick Start

```dart
import 'package:kawaii_ui/kawaii_ui.dart';

// Multi-page app with bottom nav (instant tab switching, pages kept alive)
KawaiiScaffold(
  pages: [HomePage(), TasksPage(), MoodPage()],
  navItems: [
    KawaiiNavItem(icon: myIcon, label: 'Home'),
    KawaiiNavItem(icon: myIcon, label: 'Tasks', badge: 3),
    KawaiiNavItem(icon: myIcon, label: 'Mood'),
  ],
)

// Glossy button
KawaiiButton.pink('Hello', onTap: () {});

// Card with glass panel
KawaiiCard(child: Text('Content'));

// Always-lazy list (prevents eager build perf issues)
KawaiiListView(
  itemCount: items.length,
  itemBuilder: (ctx, i) => KawaiiListTile(title: items[i].name),
  header: [SectionLabel('My Items')],
  staggerEntrance: true,
);

// Instant inline form (no modal sheet delay)
KawaiiExpandableForm(
  buttonLabel: 'Add Item',
  formBuilder: (context, collapse) => Column(children: [
    KawaiiTextField(placeholder: 'Name'),
    KawaiiButton.pink('Save', onTap: () { save(); collapse(); }),
  ]),
);
```

## Widgets

### Core Primitives
| Widget | Description |
|--------|-------------|
| `KawaiiSurface` | Glossy shine treatment — the atom of the design system |
| `KawaiiPressable` | Instant press + bouncy spring release |
| `KawaiiEntrance` | Staggered fade + slide entrance |

### App Shell
| Widget | Description |
|--------|-------------|
| `KawaiiScaffold` | Gradient bg + sparkles + multi-page nav (IndexedStack) |
| `KawaiiAppBar` | Frosted glass app bar |
| `KawaiiBottomNavBar` | Glossy bottom nav with animated pill indicator |
| `KawaiiTabBar` | Sliding glossy pill tab selector |

### Content
| Widget | Description |
|--------|-------------|
| `KawaiiButton` | 5 color presets, hero/small variants |
| `KawaiiCard` | Glass panel with inner bevel + optional sparkles |
| `KawaiiBadge` | Glossy circle icon container |
| `KawaiiTag` | Label chip with subtle shine |
| `KawaiiAvatar` | Circle avatar with status indicator |
| `KawaiiStat` | Animated counter pill |
| `KawaiiProgress` | Animated fill bar with gloss |
| `KawaiiCircularProgress` | Animated circular ring |
| `KawaiiListTile` | Leading/title/subtitle/trailing list item |
| `KawaiiDivider` | Soft gradient divider |
| `KawaiiListView` | Always-lazy list with optional stagger entrance |
| `KawaiiNotification` | Pressable notification row |
| `KawaiiSparkleField` | Ambient animated background sparkles |

### Form Controls
| Widget | Description |
|--------|-------------|
| `KawaiiToggle` | Switch with glossy knob |
| `KawaiiInput` | Text field with embedded action button |
| `KawaiiTextField` | Simple glass text input (no button) |
| `KawaiiCheckbox` | Rounded square with animated check |
| `KawaiiRadio<T>` | Circular with spring-animated dot |
| `KawaiiSlider` | Glossy track + draggable thumb |
| `KawaiiChip` | Selectable/deletable chip |
| `KawaiiExpandableForm` | Instant inline form (replaces modal sheets) |

### Overlays
| Widget | Description |
|--------|-------------|
| `showKawaiiDialog()` | Centered modal (use for confirmations) |
| `showKawaiiBottomSheet()` | Slide-up panel (use for complex multi-step flows) |
| `showKawaiiSnackbar()` | Floating toast (success/error/info/warning) |

## Design Principles

1. **Every surface has gloss** — top-lit shine gradient on all interactive elements
2. **Everything is pressable** — instant press (0ms) + bouncy spring release (200ms)
3. **Single-syllable feedback** — one clean haptic click per action, never multi-buzz
4. **Tokens over magic numbers** — spacing, radii, shadows, opacity from the token system
5. **Sound is opt-in** — `playSound: false` on all widgets prevents stacking

## Performance Principles (enforced by the library)

| Principle | How the library enforces it |
|-----------|---------------------------|
| **Lazy lists** | `KawaiiListView` — always uses `ListView.builder`, impossible to build eagerly |
| **No tab rebuild lag** | `KawaiiScaffold(pages:)` — uses IndexedStack, pages kept alive |
| **No modal delay** | `KawaiiExpandableForm` — inline form, no 250ms sheet animation |
| **No keyboard lag** | `showKawaiiBottomSheet` handles insets natively — don't add `MediaQuery.viewInsets` in your builder |
| **Isolated animations** | All continuous-animation widgets self-wrap in `RepaintBoundary` |
| **Cached text styles** | `kHeading()`/`kBody()` use pre-cached base styles, not `GoogleFonts` per build |
| **Circular clipping** | `KawaiiSurface` auto-detects `BoxShape.circle` → uses `ClipOval` |
| **No decorator conflicts** | `KawaiiCard` sparkles/bevel sit behind content with `IgnorePointer` |

### Anti-patterns to avoid

```dart
// BAD: eager list
ListView(children: items.map((i) => Widget(i)).toList())

// GOOD: lazy list
KawaiiListView(itemCount: items.length, itemBuilder: (ctx, i) => Widget(items[i]))

// BAD: modal sheet for simple input (250ms delay)
showKawaiiBottomSheet(builder: (_) => TextField())

// GOOD: inline form (instant)
KawaiiExpandableForm(formBuilder: (ctx, collapse) => TextField())

// BAD: MediaQuery.of(ctx).viewInsets in sheet builder (rebuilds ~30x)
Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom))

// GOOD: let the library handle keyboard insets (already built-in)
showKawaiiBottomSheet(builder: (_) => MyContent())

// BAD: AnimatedSwitcher for page tabs (destroys/rebuilds pages)
AnimatedSwitcher(child: pages[index])

// GOOD: library handles it
KawaiiScaffold(pages: [...], navItems: [...])

// BAD: stagger entrance on every list item (feels sluggish)
KawaiiEntrance(delay: Duration(milliseconds: 40 * i), child: TaskCard())

// GOOD: items are just there — instant, like the real world
TaskCard()  // no entrance animation on list items

// BAD: listener inside StatefulBuilder.builder (adds N listeners on N rebuilds)
StatefulBuilder(builder: (ctx, setState) {
  controller.addListener(() => setState(() {})); // LEAK!
})

// GOOD: register listener once, outside the builder
controller.addListener(() { ... });
showKawaiiBottomSheet(builder: (_) => StatefulBuilder(...))
```

## Animation Speed Principles

| Element | Duration | Why |
|---------|----------|-----|
| Button press | 0ms down, 200ms spring release | Instant response, bouncy feel |
| Dialog appear | 150ms fade+scale | Fast enough to feel instant |
| Bottom sheet slide | 250ms (Flutter default) | Use `KawaiiExpandableForm` for simple inputs instead |
| Inline form expand | 200ms AnimatedSize | No route transition = instant feel |
| Tab switch | 0ms (IndexedStack) | Pages already built, just swap visibility |
| List item entrance | None | Items should just *be there* — stagger animations on list items feel sluggish |
| Checkbox check | 200ms spring | Quick but visible confirmation |
| Progress bar fill | 800ms ease-out | Slow enough to read, fast enough to not wait |

**Rule: if the user is waiting for it, it's too slow.** Animations should confirm an action, not delay it.

## Haptic Principles (enforced by the library)

| Principle | How |
|-----------|-----|
| **Tiered by weight** | tick→lightest, click→standard, heavy_click→hero/reward |
| **Throttled** | <40ms between haptics = skip (prevents spam buzz) |
| **Native Android API** | Uses `VibrationEffect.createPredefined()` — manufacturer-tuned hardware waveforms, not Flutter's weak `HapticFeedback` |
| **Single syllable** | One hit per tap, never multi-pulse patterns |
| **Opt-in** | `playSound: false` silences both audio and haptics |

### Haptic mapping

```
tick      → EFFECT_TICK        (filter pills, selections)
toggle    → EFFECT_CLICK       (switches)
boop      → EFFECT_CLICK       (standard buttons)
pop       → EFFECT_HEAVY_CLICK (hero buttons)
send      → EFFECT_CLICK       (messages)
chime     → EFFECT_CLICK       (arrivals)
notif     → EFFECT_HEAVY_CLICK (notifications)
reward    → EFFECT_HEAVY_CLICK (achievements)
```

## Theming

5 built-in palettes: `sakura` (pink), `ocean` (blue), `forest` (green), `lavender` (purple), `sunset` (orange).

```dart
KawaiiTheme(
  data: KawaiiThemeData.ocean(),
  child: MyApp(),
)
```

## Example App

`lib/app/` contains **Kawaii Life** — a todo, mood journal, and goals tracker showcasing every widget.

```bash
flutter run
```

## License

MIT
