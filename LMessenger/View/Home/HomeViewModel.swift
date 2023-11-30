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
        case requestContacts
        case presentMyProfile
        case presentOtherProfile(String)
        case goToChat(User)
    }
    
    @Published var myUser: User?
    @Published var users: [User]
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    var userId: String
    
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        navigationRouter: NavigationRouter,
        myUser: User? = nil,
        users: [User] = [],
        userId: String,
        modalDestination: HomeModalDestination? = nil
    ) {
        self.container = container
        self.navigationRouter = navigationRouter
        self.myUser = myUser
        self.users = users
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
        case .requestContacts:
            container.services.contactService.fetchContacts()
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                }
                .flatMap { _ in
                    self.container.services.userService.loadUsers(myId: self.userId)
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
        case let .goToChat(user):
            container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: user.id, otherUserName: user.name)
                .sink { completion in
                    // TODO:
                } receiveValue: { [weak self] chatRoom in
                    guard let `self` = self else { return }
                    self.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: self.userId,
                                                         otherUserId: user.id))
                }
                .store(in: &subscriptions)
        }
    }
}
