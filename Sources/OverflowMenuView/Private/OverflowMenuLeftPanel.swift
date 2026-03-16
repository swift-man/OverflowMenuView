//
//  OverflowMenuLeftPanel.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuLeftPanel: View {
  let content: AnyView
  let sidePadding: CGFloat
  
  var body: some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .safeAreaPadding(.top, sidePadding)
      .safeAreaPadding(.bottom, sidePadding)
      .safeAreaPadding(.leading, sidePadding)
      .safeAreaPadding(.trailing, sidePadding)
  }
}
