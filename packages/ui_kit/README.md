# UI Kit

A comprehensive set of reusable, high-quality UI components for the desktop application, built with Flutter.

## Features

This package provides a unified design system with consistent theming and behaviors.

### Theming
- **AppTheme**: Inherited widget providing access to all theme tokens.
- **Colors**: Semantic color palette (background, foreground, accent, destructive, etc.) supporting light and dark modes.
- **Typography**: Standardized text styles (h1-h3, p, small, large, muted, mono).

### Layout
- **ResizableSplit**: Flexible split-pane layouts (horizontal/vertical) with draggable handles.
- **Panel**: Structured containers with optional headers, footers, and scrollable bodies.
- **Tabs**: Custom tab bar navigation with closable tabs.

### Overlays
- **CommandPalette**: Keyboard-driven modal for searching and executing commands (Ctrl/Cmd+K style).
- **ToastOverlay**: Non-intrusive, stackable notifications with auto-dismissal.

### Data Display
- **SuperListView**: High-performance list wrapper using `super_sliver_list`.
- **ListItem**: Standardized list rows with leading/trailing widgets.
- **Avatar**: Circular images with fallback initials.
- **Badge**: Status indicators and counters.

### Input
- **Button**: Primary, secondary, ghost, and destructive variants.
- **TextInput**: Styled single-line input fields.
- **ComposerInput**: Auto-expanding multi-line input for messaging.

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  ui_kit:
    path: packages/ui_kit
```

Wrap your application root with `AppThemeProvider` and `ToastOverlay`:

```dart
import 'package:ui_kit/ui_kit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      isDark: true, // or false
      child: ToastOverlay(
        child: MaterialApp(
          // ...
        ),
      ),
    );
  }
}
```

## Usage

### Accessing Theme

```dart
final theme = AppTheme.of(context);
return Container(
  color: theme.colors.background,
  child: Text(
    'Hello World',
    style: theme.typography.h1,
  ),
);
```

### Using Components

```dart
// Button
Button(
  variant: ButtonVariant.primary,
  onPressed: () {},
  child: Text('Click Me'),
);

// Panel
Panel(
  header: PanelHeader(title: Text('My Panel')),
  body: PanelBody(child: Text('Content')),
  footer: PanelFooter(child: Text('Status: Ready')),
);
```
