//
//  Chat.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var id: String { chatId }
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    
    var lastMessage: String {
        if let message {
            return message
        } else if let _ = photoURL {
            return "사진"
        } else {
            return "내용 없음"
        }
    }
}

extension Chat {
    func toObject() -> ChatObject {
        .init(
            chatId: chatId,
            userId: userId,
            message: message,
            photoURL: photoURL,
            date: date
        )
    }
}

