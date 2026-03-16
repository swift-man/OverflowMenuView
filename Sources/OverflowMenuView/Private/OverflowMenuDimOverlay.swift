//
//  OverflowMenuDimOverlay.swift
//  OverflowMenuView
//
//  Created by SwiftMan on 3/16/26.
//

import SwiftUI

struct OverflowMenuDimOverlay: View {
  let size: CGSize
  let safeAreaInsets: EdgeInsets
  let maxDimOpacity: CGFloat
  let menuProgress: CGFloat
  let onTap: () -> Void
  
  var body: some View {
    Color.black
      .opacity(maxDimOpacity * menuProgress)
      .frame(width: size.width, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
      .offset(y: -safeAreaInsets.top)
      .allowsHitTesting(menuProgress > 0.001)
      .onTapGesture {
        onTap()
      }
  }
}
