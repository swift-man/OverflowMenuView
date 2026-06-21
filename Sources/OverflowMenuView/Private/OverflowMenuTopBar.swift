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
      title
      
      HStack(spacing: 12) {
        HStack(spacing: 12) {
          openCloseButton
          leadingContent
        }
        
        Spacer(minLength: 0)
        
        trailingContent
      }
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
