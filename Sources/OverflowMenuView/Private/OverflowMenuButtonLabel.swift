//
//  OverflowMenuButtonLabel.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuButtonLabel: View {
  var body: some View {
    Image(systemName: "line.3.horizontal")
      .font(.system(size: 16, weight: .semibold))
      .foregroundStyle(.black.opacity(0.82))
      .frame(width: 40, height: 40)
      .background(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .fill(Color.white)
      )
      .overlay {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .stroke(Color.black.opacity(0.05), lineWidth: 1)
      }
  }
}
