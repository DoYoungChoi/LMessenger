//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    private var container: DIContainer
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
}
