//
//  ChatDBRepository.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatDBRepositoryType {
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError>
    func childByAutoId(chatRoomId: String) -> String
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func removeObservedHandler() -> Void
}

class ChatDBRepository: ChatDBRepositoryType {
    var db: DatabaseReference = Database.database(url: "https://lmessenger-81a2e-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    var observedHandlers: [UInt] = []
    
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.chats).child(chatRoomId).child(object.chatId).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func childByAutoId(chatRoomId: String) -> String {
        let ref = db.child(DBKey.chats).child(chatRoomId).childByAutoId()
        return ref.key ?? ""
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
        
        let handler = db.child(DBKey.chats).child(chatRoomId).observe(.childAdded) { snapshot in
            subject.send(snapshot.value)
        }
        
        observedHandlers.append(handler)
        
        return subject
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatObject?.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil)
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func removeObservedHandler() {
        observedHandlers.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}
