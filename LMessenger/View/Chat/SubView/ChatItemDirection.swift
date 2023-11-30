//
//  ChatItemDirection.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

enum ChatItemDirection {
    case left
    case right
    
    var backgroundColor: Color {
        switch self {
        case .left:
            return .chatColorOhter
        case .right:
            return .chatColorMe
        }
    }
    
    var overlayAlignment: Alignment {
        switch self {
        case .left:
            return .topLeading
        case .right:
            return .topTrailing
        }
    }
    
    var overlayImage: Image {
        switch self {
        case .left:
            return Image("bubble_tail-left")
        case .right:
            return Image("bubble_tail-right")
        }
    }
}
