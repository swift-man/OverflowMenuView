# OverflowMenuUI

![Badge](https://img.shields.io/badge/Swift-6.0-FA7343.svg?style=flat-square&logo=Swift&logoColor=white)
![Badge](https://img.shields.io/badge/SwiftUI-001b87.svg?style=flat-square&logo=Swift&logoColor=white)
![Badge - Version](https://img.shields.io/badge/Version-0.6.0-1177AA?style=flat-square)
![Badge - Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange?style=flat-square)
![Badge - Platform](https://img.shields.io/badge/iOS-v17.0-yellow?style=flat-square)
![Badge - License](https://img.shields.io/badge/license-MIT-black?style=flat-square)

`OverflowMenuUI` is a SwiftUI slide-out menu container for iOS.

It provides:
- A left-side drawer and a main content surface in one container
- A built-in top bar with a default open-close button, or support for a custom one
- Drag-to-open and drag-to-close interactions
- A dimmed overlay that closes the menu when tapped
- Optional external control through `Binding<Bool>`
- Context-driven actions inside injected content via `OverflowMenuContext`
- Lifecycle callbacks through `OverflowMenuEvent`

## Requirements

- iOS 17.0+
- Swift 6.0 toolchain
- SwiftUI

## API Documentation

Swift DocC API documentation for `OverflowMenuUI` is available at
https://docs.gorani.me/OverflowMenuView/documentation/overflowmenuui/.

## Package

The library product and Swift module name are both `OverflowMenuUI`.

```swift
import OverflowMenuUI
```

## Basic Usage

```swift
import OverflowMenuUI
import SwiftUI

struct DemoView: View {
  @State private var isMenuPresented = false

  var body: some View {
    OverflowMenuView(
      isMenuPresented: $isMenuPresented,
      onEvent: { event in
        print("menu event:", event)
      },
      title: { _ in
        Text("Inbox")
          .font(.headline)
      },
      leadingContent: { _ in
        EmptyView()
      },
      trailingContent: { context in
        Button(context.isMenuPresented ? "Close" : "Open") {
          context.toggleMenu()
        }
      },
      leftBackground: {
        Color(uiColor: .systemGroupedBackground)
      },
      mainBackground: {
        Color(uiColor: .systemBackground)
      },
      leftView: { context in
        VStack(alignment: .leading, spacing: 16) {
          Text("Menu")
            .font(.title2.weight(.semibold))

          Button("Close menu") {
            context.closeMenu()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      },
      mainView: { context in
        VStack(spacing: 16) {
          Button("Open from context") {
            context.openMenu()
          }

          Button(isMenuPresented ? "Close from parent state" : "Open from parent state") {
            isMenuPresented.toggle()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    )
  }
}
```

## Using the Default Open-Close Button

The default initializer gives you a built-in hamburger button. You only need to
provide the surrounding title, leading content, trailing content, backgrounds,
left drawer content, and main content.

```swift
OverflowMenuView(
  title: { _ in Text("Home") },
  leadingContent: { _ in EmptyView() },
  trailingContent: { _ in EmptyView() },
  leftBackground: { Color.gray.opacity(0.15) },
  mainBackground: { Color.white },
  leftView: { _ in Text("Drawer") },
  mainView: { _ in Text("Main") }
)
```

## Using a Custom Open-Close Button

If you want a custom button, use the initializer that includes the `openCloseButton`
closure.

```swift
OverflowMenuView(
  isMenuPresented: $isMenuPresented,
  title: { _ in Text("Custom Button") },
  leadingContent: { _ in EmptyView() },
  trailingContent: { _ in EmptyView() },
  openCloseButton: { context in
    Button {
      context.toggleMenu()
    } label: {
      Image(systemName: context.isMenuPresented ? "xmark" : "line.3.horizontal")
        .font(.headline)
        .frame(width: 40, height: 40)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
  },
  leftBackground: { Color.black.opacity(0.06) },
  mainBackground: { Color.white },
  leftView: { _ in Text("Drawer") },
  mainView: { _ in Text("Main") }
)
```

If you want the package's default control inside the custom slot, you can also
use `OverflowMenuOpenCloseButton` directly.

```swift
OverflowMenuView(
  isMenuPresented: $isMenuPresented,
  title: { _ in Text("Reusable Default Control") },
  leadingContent: { _ in EmptyView() },
  trailingContent: { _ in EmptyView() },
  openCloseButton: { context in
    OverflowMenuOpenCloseButton(
      isMenuPresented: context.isMenuPresented,
      action: context.toggleMenu
    )
  },
  leftBackground: { Color.gray.opacity(0.1) },
  mainBackground: { Color.white },
  leftView: { _ in Text("Drawer") },
  mainView: { _ in Text("Main") }
)
```

## External State Control

Pass a binding to `isMenuPresented` when the parent view should control the menu.

```swift
@State private var isMenuPresented = false

Button("Open Menu") {
  isMenuPresented = true
}
```

The binding stays in sync in both directions:
- Setting the binding from the parent opens or closes the menu
- Tapping the built-in open-close button updates the binding
- Drag gestures update the binding after the drawer settles
- Tapping the dimmed overlay updates the binding

## OverflowMenuContext

Every public content closure receives an `OverflowMenuContext`.

It exposes:
- `safeAreaInsets`
- `isMenuPresented`
- `menuProgress`
- `openMenu()`
- `closeMenu()`
- `toggleMenu()`

`menuProgress` is especially useful for custom animations that should react to
how far the drawer is currently opened.

## OverflowMenuEvent

You can observe presentation changes with the `onEvent` closure.

Available events:
- `willOpen`
- `didOpen`
- `willClose`
- `didClose`

## Customization Notes

- `drawerWidth` controls the width of the menu drawer
- `maxDimOpacity` controls how dark the overlay becomes
- `verticalSpacing` controls the gap between the top bar and the main content
- `mainPadding` controls safe-area-aware padding around the main panel
- `sidePadding` controls safe-area-aware padding around the drawer content
- `topBarBackgroundColor` defaults to the system background color and adapts to
  light and dark appearance
- `topBarStrokeColor` defaults to the system separator color
- Horizontal-dominant drags control the drawer while vertical-dominant gestures
  are left to the content views
- `settleAnimation` controls the final open and close animation

## Folder Structure

- `Sources/OverflowMenuView/Public`: public API surface
- `Sources/OverflowMenuView/Private`: internal building blocks used by the public container
