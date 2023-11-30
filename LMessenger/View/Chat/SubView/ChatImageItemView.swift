//
//  ChatImageItemView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct ChatImageItemView: View {
    let urlString: String
    let direction: ChatItemDirection
    
    var body: some View {
        HStack {
            if direction == .right { Spacer() }
            
            URLImageView(urlString: urlString)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left { Spacer() }
        }
        .padding(.horizontal, 35)
    }
}

#Preview {
    VStack {
        ChatImageItemView(urlString: "",
                          direction: .right)
        
        ChatImageItemView(urlString: "",
                          direction: .left)
    }
}
