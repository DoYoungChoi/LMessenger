//
//  KeyboardToolbar.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    private let height: CGFloat
    private let toolbarView: ToolbarView
    
    init(height: CGFloat, toolbarView: () -> ToolbarView) {
        self.height = height
        self.toolbarView = toolbarView()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                content
                    .frame(width: proxy.size.width, height: proxy.size.height - height)
            }
            
            toolbarView
                .frame(height: height)
        }
    }
}

extension View {
    func keyboardToolbar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(height: height, toolbarView: view))
    }
}
