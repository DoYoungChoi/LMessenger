//
//  AuthenticatedView.swift
//  LMessenger
//
//  Created by dodor on 11/27/23.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var navigationRouter: NavigationRouter
    @StateObject var searchDataController: SearchDataController
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext, searchDataController.persistantConainer.viewContext)
                    .environmentObject(authViewModel)
                    .environmentObject(navigationRouter)
                    .onAppear {
                        authViewModel.send(action: .requestPushNotification)
                    }
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())), navigationRouter: .init(), searchDataController: .init())
}
