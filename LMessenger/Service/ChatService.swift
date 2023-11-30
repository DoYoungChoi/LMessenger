//
//  ChatService.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine

protocol ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError>
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never>
}

class ChatService: ChatServiceType {
    
    private let dbRepository: ChatDBRepository
    
    init(dbRepository: ChatDBRepository) {
        self.dbRepository = dbRepository
    }
    
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        var chat = chat
        chat.chatId = dbRepository.childByAutoId(chatRoomId: chatRoomId)
        
        return dbRepository.addChat(chat.toObject(), to: chatRoomId)
            .map { chat }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        dbRepository.observeChat(chatRoomId: chatRoomId)
            .map { $0?.toModel() }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

class StubChatService: ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
