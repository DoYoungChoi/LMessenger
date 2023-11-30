//
//  ChatObject.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

struct ChatObject: Codable {
    var id: String { chatId }
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
}

extension ChatObject {
    func toModel() -> Chat {
        .init(
            chatId: chatId,
            userId: userId,
            message: message,
            photoURL: photoURL,
            date: date
        )
    }
}
