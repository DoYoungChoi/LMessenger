//
//  Chat.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

struct Chat: Hashable, Identifiable{
    var id: String { chatId }
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
}
