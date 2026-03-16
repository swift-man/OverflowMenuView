//
//  OverflowMenuContext.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

/// Shared presentation information and menu actions that are passed to every
/// public view-building closure used by ``OverflowMenuView``.
///
/// Use this value when you need to react to the menu's current state from one
/// of the injected views, or when you want to open and close the menu from
/// inside the title area, side menu, or main content.
public struct OverflowMenuContext {
  /// The safe-area insets reported by the hosting geometry reader.
  ///
  /// This is useful when custom content needs to align itself with the same
  /// insets that the container uses for the drawer and main panel.
  public let safeAreaInsets: EdgeInsets
  
  /// A Boolean value that indicates whether the menu is currently presented.
  ///
  /// This value reflects the current visual state of the menu and updates while
  /// the container animates between open and closed states.
  public let isMenuPresented: Bool
  
  /// A normalized progress value between `0` and `1` representing how far the
  /// drawer is open.
  ///
  /// A value of `0` means the menu is fully closed, while `1` means it is fully
  /// open. Intermediate values are useful for driving custom transitions in
  /// injected content.
  public let menuProgress: CGFloat
  
  private let openAction: () -> Void
  private let closeAction: () -> Void
  private let toggleAction: () -> Void
  
  init(
    safeAreaInsets: EdgeInsets,
    isMenuPresented: Bool,
    menuProgress: CGFloat,
    openAction: @escaping () -> Void,
    closeAction: @escaping () -> Void,
    toggleAction: @escaping () -> Void
  ) {
    self.safeAreaInsets = safeAreaInsets
    self.isMenuPresented = isMenuPresented
    self.menuProgress = menuProgress
    self.openAction = openAction
    self.closeAction = closeAction
    self.toggleAction = toggleAction
  }
  
  /// Opens the menu using the same animation and state handling as the built-in
  /// open-close button and drag gesture.
  public func openMenu() {
    openAction()
  }
  
  /// Closes the menu using the same animation and state handling as tapping the
  /// dimmed overlay.
  public func closeMenu() {
    closeAction()
  }
  
  /// Toggles the menu between the open and closed states.
  public func toggleMenu() {
    toggleAction()
  }
}
