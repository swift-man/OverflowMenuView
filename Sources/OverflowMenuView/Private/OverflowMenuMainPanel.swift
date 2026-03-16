//
//  OverflowMenuMainPanel.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuMainPanel: View {
  let verticalSpacing: CGFloat
  let mainPadding: CGFloat
  let topBar: AnyView
  let content: AnyView
  
  var body: some View {
    VStack(spacing: verticalSpacing) {
      topBar
      content
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    .safeAreaPadding(.top, mainPadding)
    .safeAreaPadding(.bottom, mainPadding)
    .safeAreaPadding(.leading, mainPadding)
    .safeAreaPadding(.trailing, mainPadding)
  }
}
