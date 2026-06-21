//
//  OverflowMenuTopBar.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuTopBar: View {
  let title: AnyView
  let leadingContent: AnyView
  let trailingContent: AnyView
  let openCloseButton: AnyView
  let backgroundColor: Color
  let strokeColor: Color

  var body: some View {
    ZStack {
      HStack(spacing: 12) {
        openCloseButton
        leadingContent
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      HStack(spacing: 0) {
        Spacer(minLength: 92)

        title
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(maxWidth: .infinity, alignment: .center)

        Spacer(minLength: 92)
      }

      trailingContent
        .frame(maxWidth: .infinity, alignment: .trailing)
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
