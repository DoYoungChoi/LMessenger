//
//  AuthenticatedView.swift
//  LMessenger
//
//  Created by dodor on 11/27/23.
//

import SwiftUI

struct AuthenticatedView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext, container.searchDataController.persistantConainer.viewContext)
                    .environmentObject(authViewModel)
                    .onAppear {
                        authViewModel.send(action: .requestPushNotification)
                    }
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
        .preferredColorScheme(container.appearanceController.appearance.colorScheme)
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))
}
