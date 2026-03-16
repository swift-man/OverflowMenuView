//
//  OverflowMenuBackgroundTrack.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuBackgroundTrack: View {
  let drawerWidth: CGFloat
  let fullWidth: CGFloat
  let fullHeight: CGFloat
  let leftBackground: AnyView
  let mainBackground: AnyView
  
  var body: some View {
    HStack(spacing: 0) {
      leftBackground
        .frame(width: drawerWidth, height: fullHeight)
      
      mainBackground
        .frame(width: fullWidth, height: fullHeight)
    }
    .frame(width: drawerWidth + fullWidth, height: fullHeight, alignment: .leading)
    .ignoresSafeArea()
  }
}
