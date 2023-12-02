//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation
import Combine

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func getUser(userId: String) async throws -> UserObject
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    func updateUser(userId: String, key: String, value: Any) async throws
    func updateUser(userId: String, key: String, value: Any) -> AnyPublisher<Void, DBError>
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
    
    private let reference: DBReferenceType
    
    init(reference: DBReferenceType) {
        self.reference = reference
    }
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object > data > dic
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed) }
            .flatMap { value in
                self.reference.setValue(key: DBKey.users, path: object.id, value: value)
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        reference.getValue(key: DBKey.users, path: userId)
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: UserObject.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .emptyValue)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await self.reference.getValue(key: DBKey.users, path: userId) else {
            throw DBError.emptyValue
        }
        
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        return userObject
    }
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        reference.getValue(key: DBKey.users, path: nil)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([])
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        /*
            Users/
                user_id: [String: Any]
                user_id: [String: Any]
                user_id: [String: Any]
         */
        
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .compactMap { origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .flatMap { origin, converted in
                self.reference.setValue(key: DBKey.users, path: origin.id, value: converted)
            }
            .last()
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        try await reference.setValue(key: DBKey.users, path: "\(userId)/\(key)", value: value)
    }
    
    func updateUser(userId: String, key: String, value: Any) -> AnyPublisher<Void, DBError> {
        reference.setValue(key: DBKey.users, path: "\(userId)/\(key)", value: value)
    }
    
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError> {
        reference.filter(key: DBKey.users, path: nil, orderedValue: "name", queryString: queryString)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([])
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
