//
//  OverflowMenuContentTrack.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuContentTrack: View {
  let drawerWidth: CGFloat
  let size: CGSize
  let leftPanel: AnyView
  let mainPanel: AnyView
  let dimOverlay: AnyView
  
  var body: some View {
    HStack(spacing: 0) {
      leftPanel
        .frame(width: drawerWidth, height: size.height)
      
      mainPanel
        .frame(width: size.width, height: size.height)
        .overlay(alignment: .topLeading) {
          dimOverlay
        }
    }
    .frame(width: drawerWidth + size.width, height: size.height, alignment: .leading)
  }
}
