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
        .fill(Color(red: 0.98, green: 0.96, blue: 0.92))
    )
    .overlay {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(Color.black.opacity(0.05), lineWidth: 1)
    }
  }
}
