//
//  OverflowMenuView.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

/// A reusable slide-out container that presents a left-side overflow menu and a
/// main content surface in a single composable SwiftUI view.
///
/// ``OverflowMenuView`` owns the drag gesture, overlay, top bar shell, and
/// presentation transitions. You supply the visual pieces through closures for
/// the title, menu content, backgrounds, and main content.
///
/// The menu can be controlled in two ways:
/// - Internally, through the ``OverflowMenuContext`` passed to all injected
///   view builders.
/// - Externally, by passing a binding to `isMenuPresented`.
public struct OverflowMenuView: View {
  @State private var menuOffset: CGFloat = 0
  @State private var dragStartOffset: CGFloat?
  @State private var lastDragTranslation: CGFloat = 0
  @State private var lastDragDirection: OverflowMenuDragDirection = .none
  @State private var pendingTransition: OverflowMenuPresentationState?
  @State private var lastSettledState: OverflowMenuPresentationState = .closed
  
  private let externalIsMenuPresented: Binding<Bool>?
  private let drawerWidth: CGFloat
  private let maxDimOpacity: CGFloat
  private let verticalSpacing: CGFloat
  private let mainPadding: CGFloat
  private let sidePadding: CGFloat
  private let settleAnimation: Animation
  private let onEvent: (OverflowMenuEvent) -> Void
  private let title: (OverflowMenuContext) -> AnyView
  private let leadingContent: (OverflowMenuContext) -> AnyView
  private let trailingContent: (OverflowMenuContext) -> AnyView
  private let openCloseButton: (OverflowMenuContext) -> AnyView
  private let leftBackground: () -> AnyView
  private let mainBackground: () -> AnyView
  private let leftView: (OverflowMenuContext) -> AnyView
  private let mainView: (OverflowMenuContext) -> AnyView
  
  /// Creates an overflow menu container that uses the built-in open-close button in
  /// the top bar.
  ///
  /// The default open-close button is a tappable hamburger-style control that toggles
  /// the drawer state. Use this initializer when you want the standard button
  /// appearance and only need to customize the surrounding content.
  ///
  /// - Parameters:
  ///   - isMenuPresented: An optional binding used to control the menu from a
  ///     parent view. When provided, changes made by the parent update the
  ///     drawer, and user interactions inside the drawer update the binding.
  ///   - drawerWidth: The fixed width of the side menu drawer.
  ///   - maxDimOpacity: The maximum opacity applied to the dimmed overlay behind
  ///     the main content when the menu is fully open.
  ///   - verticalSpacing: The vertical spacing between the top bar and the main
  ///     content.
  ///   - mainPadding: The safe-area-aware padding applied around the main panel.
  ///   - sidePadding: The safe-area-aware padding applied around the left drawer
  ///     content.
  ///   - settleAnimation: The animation used when the menu settles into the
  ///     fully open or fully closed state.
  ///   - onEvent: A closure that receives lifecycle events as the menu opens and
  ///     closes.
  ///   - title: Builds the centered title content shown in the top bar.
  ///   - leadingContent: Builds content displayed next to the open-close button on the
  ///     leading side of the top bar.
  ///   - trailingContent: Builds content displayed on the trailing side of the
  ///     top bar.
  ///   - leftBackground: Builds the background view that appears behind the side
  ///     menu.
  ///   - mainBackground: Builds the background view that appears behind the main
  ///     content.
  ///   - leftView: Builds the content shown inside the side menu drawer.
  ///   - mainView: Builds the main content area that slides with the drawer.
  public init<
    Title: View,
    LeadingContent: View,
    TrailingContent: View,
    LeftBackground: View,
    MainBackground: View,
    LeftView: View,
    MainView: View
  >(
    isMenuPresented: Binding<Bool>? = nil,
    drawerWidth: CGFloat = 304,
    maxDimOpacity: CGFloat = 0.12,
    verticalSpacing: CGFloat = 18,
    mainPadding: CGFloat = 16,
    sidePadding: CGFloat = 20,
    settleAnimation: Animation = .easeOut(duration: 0.2),
    onEvent: @escaping (OverflowMenuEvent) -> Void = { _ in },
    @ViewBuilder title: @escaping (OverflowMenuContext) -> Title,
    @ViewBuilder leadingContent: @escaping (OverflowMenuContext) -> LeadingContent,
    @ViewBuilder trailingContent: @escaping (OverflowMenuContext) -> TrailingContent,
    @ViewBuilder leftBackground: @escaping () -> LeftBackground,
    @ViewBuilder mainBackground: @escaping () -> MainBackground,
    @ViewBuilder leftView: @escaping (OverflowMenuContext) -> LeftView,
    @ViewBuilder mainView: @escaping (OverflowMenuContext) -> MainView
  ) {
    let initialPresentationState = Self.initialPresentationState(
      isMenuPresented: isMenuPresented
    )
    
    _menuOffset = State(
      initialValue: Self.initialMenuOffset(
        drawerWidth: drawerWidth,
        presentationState: initialPresentationState
      )
    )
    _lastSettledState = State(initialValue: initialPresentationState)
    
    self.externalIsMenuPresented = isMenuPresented
    self.drawerWidth = drawerWidth
    self.maxDimOpacity = maxDimOpacity
    self.verticalSpacing = verticalSpacing
    self.mainPadding = mainPadding
    self.sidePadding = sidePadding
    self.settleAnimation = settleAnimation
    self.onEvent = onEvent
    self.title = { AnyView(title($0)) }
    self.leadingContent = { AnyView(leadingContent($0)) }
    self.trailingContent = { AnyView(trailingContent($0)) }
    self.openCloseButton = { context in
      AnyView(
        OverflowMenuOpenCloseButton(
          isMenuPresented: context.isMenuPresented,
          action: context.toggleMenu
        )
      )
    }
    self.leftBackground = { AnyView(leftBackground()) }
    self.mainBackground = { AnyView(mainBackground()) }
    self.leftView = { AnyView(leftView($0)) }
    self.mainView = { AnyView(mainView($0)) }
  }
  
  /// Creates an overflow menu container with a fully custom open-close button.
  ///
  /// Use this initializer when you want to replace the built-in open-close button with
  /// your own control while keeping the rest of the container behavior the same.
  ///
  /// - Parameters:
  ///   - isMenuPresented: An optional binding used to control the menu from a
  ///     parent view. When provided, changes made by the parent update the
  ///     drawer, and user interactions inside the drawer update the binding.
  ///   - drawerWidth: The fixed width of the side menu drawer.
  ///   - maxDimOpacity: The maximum opacity applied to the dimmed overlay behind
  ///     the main content when the menu is fully open.
  ///   - verticalSpacing: The vertical spacing between the top bar and the main
  ///     content.
  ///   - mainPadding: The safe-area-aware padding applied around the main panel.
  ///   - sidePadding: The safe-area-aware padding applied around the left drawer
  ///     content.
  ///   - settleAnimation: The animation used when the menu settles into the
  ///     fully open or fully closed state.
  ///   - onEvent: A closure that receives lifecycle events as the menu opens and
  ///     closes.
  ///   - title: Builds the centered title content shown in the top bar.
  ///   - leadingContent: Builds content displayed next to the custom open-close button
  ///     on the leading side of the top bar.
  ///   - trailingContent: Builds content displayed on the trailing side of the
  ///     top bar.
  ///   - openCloseButton: Builds the custom control used to open and close the menu.
  ///   - leftBackground: Builds the background view that appears behind the side
  ///     menu.
  ///   - mainBackground: Builds the background view that appears behind the main
  ///     content.
  ///   - leftView: Builds the content shown inside the side menu drawer.
  ///   - mainView: Builds the main content area that slides with the drawer.
  public init<
    Title: View,
    LeadingContent: View,
    TrailingContent: View,
    MenuButton: View,
    LeftBackground: View,
    MainBackground: View,
    LeftView: View,
    MainView: View
  >(
    isMenuPresented: Binding<Bool>? = nil,
    drawerWidth: CGFloat = 304,
    maxDimOpacity: CGFloat = 0.12,
    verticalSpacing: CGFloat = 18,
    mainPadding: CGFloat = 16,
    sidePadding: CGFloat = 20,
    settleAnimation: Animation = .easeOut(duration: 0.2),
    onEvent: @escaping (OverflowMenuEvent) -> Void = { _ in },
    @ViewBuilder title: @escaping (OverflowMenuContext) -> Title,
    @ViewBuilder leadingContent: @escaping (OverflowMenuContext) -> LeadingContent,
    @ViewBuilder trailingContent: @escaping (OverflowMenuContext) -> TrailingContent,
    @ViewBuilder openCloseButton: @escaping (OverflowMenuContext) -> MenuButton,
    @ViewBuilder leftBackground: @escaping () -> LeftBackground,
    @ViewBuilder mainBackground: @escaping () -> MainBackground,
    @ViewBuilder leftView: @escaping (OverflowMenuContext) -> LeftView,
    @ViewBuilder mainView: @escaping (OverflowMenuContext) -> MainView
  ) {
    let initialPresentationState = Self.initialPresentationState(
      isMenuPresented: isMenuPresented
    )
    
    _menuOffset = State(
      initialValue: Self.initialMenuOffset(
        drawerWidth: drawerWidth,
        presentationState: initialPresentationState
      )
    )
    _lastSettledState = State(initialValue: initialPresentationState)
    
    self.externalIsMenuPresented = isMenuPresented
    self.drawerWidth = drawerWidth
    self.maxDimOpacity = maxDimOpacity
    self.verticalSpacing = verticalSpacing
    self.mainPadding = mainPadding
    self.sidePadding = sidePadding
    self.settleAnimation = settleAnimation
    self.onEvent = onEvent
    self.title = { AnyView(title($0)) }
    self.leadingContent = { AnyView(leadingContent($0)) }
    self.trailingContent = { AnyView(trailingContent($0)) }
    self.openCloseButton = { AnyView(openCloseButton($0)) }
    self.leftBackground = { AnyView(leftBackground()) }
    self.mainBackground = { AnyView(mainBackground()) }
    self.leftView = { AnyView(leftView($0)) }
    self.mainView = { AnyView(mainView($0)) }
  }
  
  /// Creates an overflow menu container with a custom control for opening and
  /// closing the menu.
  ///
  /// This overload is kept for source compatibility. Prefer the initializer
  /// that uses the `openCloseButton` label.
  @available(*, deprecated, message: "Use the initializer that takes openCloseButton instead.")
  public init<
    Title: View,
    LeadingContent: View,
    TrailingContent: View,
    MenuButton: View,
    LeftBackground: View,
    MainBackground: View,
    LeftView: View,
    MainView: View
  >(
    isMenuPresented: Binding<Bool>? = nil,
    drawerWidth: CGFloat = 304,
    maxDimOpacity: CGFloat = 0.12,
    verticalSpacing: CGFloat = 18,
    mainPadding: CGFloat = 16,
    sidePadding: CGFloat = 20,
    settleAnimation: Animation = .easeOut(duration: 0.2),
    onEvent: @escaping (OverflowMenuEvent) -> Void = { _ in },
    @ViewBuilder title: @escaping (OverflowMenuContext) -> Title,
    @ViewBuilder leadingContent: @escaping (OverflowMenuContext) -> LeadingContent,
    @ViewBuilder trailingContent: @escaping (OverflowMenuContext) -> TrailingContent,
    @ViewBuilder menuButton: @escaping (OverflowMenuContext) -> MenuButton,
    @ViewBuilder leftBackground: @escaping () -> LeftBackground,
    @ViewBuilder mainBackground: @escaping () -> MainBackground,
    @ViewBuilder leftView: @escaping (OverflowMenuContext) -> LeftView,
    @ViewBuilder mainView: @escaping (OverflowMenuContext) -> MainView
  ) {
    self.init(
      isMenuPresented: isMenuPresented,
      drawerWidth: drawerWidth,
      maxDimOpacity: maxDimOpacity,
      verticalSpacing: verticalSpacing,
      mainPadding: mainPadding,
      sidePadding: sidePadding,
      settleAnimation: settleAnimation,
      onEvent: onEvent,
      title: title,
      leadingContent: leadingContent,
      trailingContent: trailingContent,
      openCloseButton: menuButton,
      leftBackground: leftBackground,
      mainBackground: mainBackground,
      leftView: leftView,
      mainView: mainView
    )
  }
  
  private var openOffset: CGFloat {
    drawerWidth
  }
  
  private var isMenuPresented: Bool {
    menuOffset > 1
  }
  
  private var currentPresentationState: OverflowMenuPresentationState {
    pendingTransition ?? lastSettledState
  }
  
  private var externalPresentationState: Bool? {
    externalIsMenuPresented?.wrappedValue
  }
  
  private var menuProgress: CGFloat {
    guard openOffset > 0 else {
      return 0
    }
    
    return menuOffset / openOffset
  }
  
  private func context(safeAreaInsets: EdgeInsets) -> OverflowMenuContext {
    OverflowMenuContext(
      safeAreaInsets: safeAreaInsets,
      isMenuPresented: isMenuPresented,
      menuProgress: menuProgress,
      openAction: openMenu,
      closeAction: closeMenu,
      toggleAction: toggleMenu
    )
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let safeAreaInsets = proxy.safeAreaInsets
      let currentContext = context(safeAreaInsets: safeAreaInsets)
      let fullHeight = proxy.size.height + safeAreaInsets.top + safeAreaInsets.bottom
      let fullWidth = proxy.size.width + safeAreaInsets.leading + safeAreaInsets.trailing
      let backgroundTrack = OverflowMenuBackgroundTrack(
        drawerWidth: drawerWidth,
        fullWidth: fullWidth,
        fullHeight: fullHeight,
        leftBackground: leftBackground(),
        mainBackground: mainBackground()
      )
      let leftPanel = OverflowMenuLeftPanel(
        content: leftView(currentContext),
        sidePadding: sidePadding
      )
      let topBar = OverflowMenuTopBar(
        title: title(currentContext),
        leadingContent: leadingContent(currentContext),
        trailingContent: trailingContent(currentContext),
        openCloseButton: openCloseButton(currentContext)
      )
      let mainPanel = OverflowMenuMainPanel(
        verticalSpacing: verticalSpacing,
        mainPadding: mainPadding,
        topBar: AnyView(topBar),
        content: mainView(currentContext)
      )
      let dimOverlay = OverflowMenuDimOverlay(
        size: proxy.size,
        safeAreaInsets: safeAreaInsets,
        maxDimOpacity: maxDimOpacity,
        menuProgress: menuProgress,
        onTap: closeMenu
      )
      let contentTrack = OverflowMenuContentTrack(
        drawerWidth: drawerWidth,
        size: proxy.size,
        leftPanel: AnyView(leftPanel),
        mainPanel: AnyView(mainPanel),
        dimOverlay: AnyView(dimOverlay)
      )
      
      ZStack(alignment: .topLeading) {
        backgroundTrack
          .offset(
            x: -drawerWidth + menuOffset - safeAreaInsets.leading,
            y: -safeAreaInsets.top
          )
          .allowsHitTesting(false)
        
        contentTrack
          .offset(x: -drawerWidth + menuOffset)
          .allowsHitTesting(true)
      }
      .contentShape(Rectangle())
      .highPriorityGesture(menuDragGesture)
      .onAppear {
        syncMenuStateFromExternalBinding()
      }
      .onChange(of: externalPresentationState) { _, _ in
        syncMenuStateFromExternalBinding()
      }
    }
  }
  
  private static func initialPresentationState(
    isMenuPresented: Binding<Bool>?
  ) -> OverflowMenuPresentationState {
    isMenuPresented?.wrappedValue == true ? .open : .closed
  }
  
  private static func initialMenuOffset(
    drawerWidth: CGFloat,
    presentationState: OverflowMenuPresentationState
  ) -> CGFloat {
    presentationState == .open ? drawerWidth : 0
  }
  
  private var menuDragGesture: some Gesture {
    DragGesture(minimumDistance: 3, coordinateSpace: .global)
      .onChanged { value in
        guard shouldHandleMenuDrag(value) else {
          return
        }
        
        if dragStartOffset == nil {
          dragStartOffset = menuOffset
          lastDragTranslation = value.translation.width
          lastDragDirection = dragDirection(for: value.translation.width)
        } else {
          updateLastDragDirection(with: value.translation.width)
        }
        
        let startOffset = dragStartOffset ?? menuOffset
        menuOffset = clampedMenuOffset(startOffset + value.translation.width)
      }
      .onEnded { value in
        guard shouldHandleMenuDrag(value) else {
          resetMenuDragState()
          return
        }
        
        let startOffset = dragStartOffset ?? menuOffset
        let currentOffset = clampedMenuOffset(startOffset + value.translation.width)
        let projectedOffset = clampedMenuOffset(startOffset + value.predictedEndTranslation.width)
        let shouldOpen = resolveMenuOpenState(
          currentOffset: currentOffset,
          projectedOffset: projectedOffset,
          lastDirection: lastDragDirection
        )
        
        settleMenu(
          to: shouldOpen ? .open : .closed,
          from: currentOffset
        )
      }
  }
  
  private func shouldHandleMenuDrag(_ value: DragGesture.Value) -> Bool {
    abs(value.translation.width) > abs(value.translation.height)
  }
  
  private func clampedMenuOffset(_ value: CGFloat) -> CGFloat {
    min(max(value, 0), openOffset)
  }
  
  private func updateLastDragDirection(with translation: CGFloat) {
    let delta = translation - lastDragTranslation
    lastDragDirection = dragDirection(for: delta, fallback: lastDragDirection)
    lastDragTranslation = translation
  }
  
  private func dragDirection(
    for delta: CGFloat,
    fallback: OverflowMenuDragDirection = .none
  ) -> OverflowMenuDragDirection {
    if delta > 0.5 {
      return .opening
    }
    
    if delta < -0.5 {
      return .closing
    }
    
    return fallback
  }
  
  // Bias the end state toward the user's last drag direction instead of only the final position.
  private func resolveMenuOpenState(
    currentOffset: CGFloat,
    projectedOffset: CGFloat,
    lastDirection: OverflowMenuDragDirection
  ) -> Bool {
    switch lastDirection {
    case .opening:
      return currentOffset > 10 || projectedOffset > openOffset * 0.06
    case .closing:
      return currentOffset > openOffset * 0.94 && projectedOffset > openOffset * 0.8
    case .none:
      return projectedOffset > openOffset * 0.5
    }
  }
  
  private func resetMenuDragState() {
    dragStartOffset = nil
    lastDragTranslation = 0
    lastDragDirection = .none
  }
  
  private func toggleMenu() {
    currentPresentationState == .open ? closeMenu() : openMenu()
  }
  
  private func openMenu() {
    settleMenu(to: .open)
  }
  
  private func closeMenu() {
    settleMenu(to: .closed)
  }
  
  private func syncMenuStateFromExternalBinding() {
    guard let externalPresentationState else {
      return
    }
    
    let requestedState: OverflowMenuPresentationState = externalPresentationState ? .open : .closed
    
    guard requestedState != currentPresentationState else {
      syncExternalPresentationState(with: requestedState)
      return
    }
    
    settleMenu(to: requestedState)
  }
  
  private func settleMenu(
    to requestedState: OverflowMenuPresentationState,
    from sourceOffset: CGFloat? = nil
  ) {
    guard requestedState != currentPresentationState else {
      syncExternalPresentationState(with: requestedState)
      resetMenuDragState()
      return
    }
    
    let targetOffset = targetOffset(for: requestedState)
    let referenceOffset = sourceOffset ?? menuOffset
    
    onEvent(willEvent(for: requestedState))
    
    if abs(referenceOffset - targetOffset) <= 0.5 {
      menuOffset = targetOffset
      lastSettledState = requestedState
      pendingTransition = nil
      syncExternalPresentationState(with: requestedState)
      onEvent(didEvent(for: requestedState))
    } else {
      pendingTransition = requestedState
      syncExternalPresentationState(with: requestedState)
      withAnimation(settleAnimation, completionCriteria: .logicallyComplete) {
        menuOffset = targetOffset
      } completion: {
        lastSettledState = requestedState
        pendingTransition = nil
        onEvent(didEvent(for: requestedState))
      }
    }
    
    resetMenuDragState()
  }
  
  private func targetOffset(for state: OverflowMenuPresentationState) -> CGFloat {
    state == .open ? openOffset : 0
  }
  
  private func willEvent(for state: OverflowMenuPresentationState) -> OverflowMenuEvent {
    state == .open ? .willOpen : .willClose
  }
  
  private func didEvent(for state: OverflowMenuPresentationState) -> OverflowMenuEvent {
    state == .open ? .didOpen : .didClose
  }
  
  private func syncExternalPresentationState(
    with state: OverflowMenuPresentationState
  ) {
    let isMenuPresented = state == .open
    
    guard externalIsMenuPresented?.wrappedValue != isMenuPresented else {
      return
    }
    
    externalIsMenuPresented?.wrappedValue = isMenuPresented
  }
}
