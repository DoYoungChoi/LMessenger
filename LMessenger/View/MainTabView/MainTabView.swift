//
//  MainTabView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var selectedTab: MainTabType = .home
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id:\.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(homeViewModel: .init(container: container, 
                                                      userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView(chatListViewModel: .init(container: container,
                                                              userId: authViewModel.userId ?? ""))
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
    }
}

#Preview {
    let container = DIContainer(services: StubService())
    
    return MainTabView()
        .environmentObject(container)
        .environmentObject(AuthenticationViewModel(container: container))
}
