//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case fetch
        case presentMyProfile
        case presentOtherProfile(String)
    }
    
    @Published var myUser: User?
    @Published var users: [User]
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    private var container: DIContainer
    private var userId: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        myUser: User? = nil,
        users: [User] = [],
        container: DIContainer,
        userId: String,
        modalDestination: HomeModalDestination? = nil
    ) {
        self.myUser = myUser
        self.users = users
        self.container = container
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .fetch:
            phase = .loading
            
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    // stream 이벤트 중간에 작업을 하고 싶은 경우 사용
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(myId: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.users = users
                    self?.phase = .success
                }
                .store(in: &subscriptions)
        case .presentMyProfile:
            modalDestination = .myProfile
        case let .presentOtherProfile(userId):
            modalDestination = .otherProfile(userId)
        }
    }
}
