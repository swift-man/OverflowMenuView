//
//  OverflowMenuEvent.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

/// Lifecycle events emitted while the overflow menu transitions between closed
/// and open states.
public enum OverflowMenuEvent: Equatable, Sendable {
  /// Emitted immediately before the menu begins opening.
  case willOpen
  
  /// Emitted after the menu has fully completed its opening transition.
  case didOpen
  
  /// Emitted immediately before the menu begins closing.
  case willClose
  
  /// Emitted after the menu has fully completed its closing transition.
  case didClose
}
