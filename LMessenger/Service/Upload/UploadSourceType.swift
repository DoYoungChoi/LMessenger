//
//  UploadSourceType.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation

enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    var path: String {
        switch self {
        case .chat(let chatRoomId): // Chats/chatRoomId/
            return "\(DBKey.chats)/\(chatRoomId)"
        case .profile(let userId): // Users/userId/
            return "\(DBKey.users)/\(userId)"
        }
    }
}
