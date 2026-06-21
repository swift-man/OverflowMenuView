# ``OverflowMenuUI``

Build a SwiftUI slide-out overflow menu with a left drawer, dimmed overlay, and configurable top bar.

## Overview

`OverflowMenuUI` provides a reusable container for apps that need a main content surface and a left-side menu in one coordinated interaction. The container owns the drag gesture, open and close transitions, dim overlay, and top bar shell while your app supplies the visible content through SwiftUI view builders.

Use ``OverflowMenuView`` when you want a menu that can be controlled either by user gestures or by a parent `Binding<Bool>`. Each content closure receives an ``OverflowMenuContext`` so custom title, drawer, and main content can open, close, or react to the menu's progress.

## Topics

### Menu Container

- ``OverflowMenuView``
- ``OverflowMenuContext``
- ``OverflowMenuOpenCloseButton``
- ``OverflowMenuEvent``
