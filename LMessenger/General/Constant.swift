//
//  Constant.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

typealias DBKey = Constant.DBKey
typealias AppStorageType = Constant.AppStorage

enum Constant { }

extension Constant {
    struct DBKey {
        static let users = "Users"
        static let chatRooms = "ChatRooms"
        static let chats = "Chats"
    }
}

extension Constant {
    struct AppStorage {
        static let Appearance = "AppStorage_Appearance"
    }
}
