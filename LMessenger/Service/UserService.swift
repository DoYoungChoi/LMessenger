//
//  UserService.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError>
}

class UserService: UserServiceType {
    
    private var dbRepository: UserDBRepositoryType
    
    init(
        dbRepository: UserDBRepositoryType
    ) {
        self.dbRepository = dbRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map { user }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != myId }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}

class StubUserService: UserServiceType {
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Just(.stub1)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}


