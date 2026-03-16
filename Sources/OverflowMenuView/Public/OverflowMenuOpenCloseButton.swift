//
//  OverflowMenuOpenCloseButton.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

/// The default open-close button used by ``OverflowMenuView``.
///
/// You can use this view directly when you want to keep the package's default
/// interaction and appearance while providing your own `openCloseButton`
/// closure.
public struct OverflowMenuOpenCloseButton: View {
  private let isMenuPresented: Bool
  private let action: () -> Void
  
  @State private var isPressActive = false
  
  /// Creates the package's default open-close button.
  ///
  /// - Parameters:
  ///   - isMenuPresented: A Boolean value that indicates whether the menu is
  ///     currently shown.
  ///   - action: The action to perform when the control is pressed.
  public init(isMenuPresented: Bool, action: @escaping () -> Void) {
    self.isMenuPresented = isMenuPresented
    self.action = action
  }
  
  public var body: some View {
    OverflowMenuButtonLabel()
      .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
      .onLongPressGesture(
        minimumDuration: 0,
        maximumDistance: 24,
        pressing: { isPressing in
          guard isPressing else {
            isPressActive = false
            return
          }
          
          guard !isPressActive else {
            return
          }
          
          isPressActive = true
          action()
        },
        perform: {}
      )
      .accessibilityElement(children: .ignore)
      .accessibilityAddTraits(.isButton)
      .accessibilityLabel(isMenuPresented ? "Close menu" : "Open menu")
      .accessibilityAction {
        action()
      }
  }
}
