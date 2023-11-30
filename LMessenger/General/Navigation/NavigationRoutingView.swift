//
//  NavigationRoutingView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject private var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(chatRoomId, myUserId, otherUserId):
            ChatView(chatViewModel: .init(container: container,
                                          chatRoomId: chatRoomId,
                                          myUserId: myUserId,
                                          otherUserId: otherUserId))
        case .search:
            SearchView()
        }
    }
}
