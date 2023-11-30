//
//  NavigationRoutingView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct NavigationRoutingView: View {
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .chat:
            ChatView()
        case .search:
            SearchView()
        }
    }
}
