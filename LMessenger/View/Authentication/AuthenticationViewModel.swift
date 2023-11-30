//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case requestPushNotification
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userId: String?
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce: String?
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
        case .googleLogin:
            isLoading = true
            container.services.authService.signInWithGoogle()
                .flatMap { user in
                    self.container.services.userService.addUser(user)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] user in
                    self?.userId = user.id
                    self?.authenticationState = .authenticated
                    self?.isLoading = false
                }
                .store(in: &subscriptions)
        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request)
            currentNonce = nonce
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
                    .flatMap { user in
                        self.container.services.userService.addUser(user)
                    }
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                        self?.isLoading = false
                    }
                    .store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
                isLoading = false
            }
        case .requestPushNotification:
            container.services.pushNotificationService.requestAuthorization { granted in
                
            }
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }
                .store(in: &subscriptions)
        }
    }
}
