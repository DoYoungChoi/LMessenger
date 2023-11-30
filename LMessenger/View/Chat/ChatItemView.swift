//
//  ChatItemView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct ChatItemView: View {
    let message: String
    let direction: ChatItemDirection
    let date: Date
    
    var body: some View {
        HStack(alignment: .bottom) {
            if direction == .right {
                Spacer()
                dateView
            }
            
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.blackFix)
                .padding(.vertical, 9)
                .padding(.horizontal, 20)
                .background(direction.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .overlay(alignment: direction.overlayAlignment) {
                    direction.overlayImage
                }
            
            if direction == .left {
                dateView
                Spacer()
            }
        }
        .padding(.horizontal, 35)
    }
    
    var dateView: some View {
        Text(date.toChatTime)
            .font(.system(size: 10))
            .foregroundStyle(.greyDeep)
    }
}

#Preview {
    VStack {
        ChatItemView(message: "안녕하세여",
                     direction: .right,
                     date: Date())
        
        ChatItemView(message: "안녕하세여",
                     direction: .left,
                     date: Date())
    }
}
