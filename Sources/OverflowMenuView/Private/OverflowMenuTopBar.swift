//
//  OverflowMenuTopBar.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuTopBar: View {
  private static let sideContentMinimumWidth: CGFloat = 92

  let title: AnyView
  let leadingContent: AnyView
  let trailingContent: AnyView
  let openCloseButton: AnyView
  let backgroundColor: Color
  let strokeColor: Color

  var body: some View {
    HStack(spacing: 12) {
      HStack(spacing: 12) {
        openCloseButton
        leadingContent
      }
      .frame(minWidth: Self.sideContentMinimumWidth, alignment: .leading)
      .layoutPriority(1)

      title
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .frame(maxWidth: .infinity, alignment: .center)
        .layoutPriority(2)

      trailingContent
        .frame(minWidth: Self.sideContentMinimumWidth, alignment: .trailing)
        .layoutPriority(1)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(backgroundColor)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(strokeColor, lineWidth: 1)
    }
  }
}
