//
//  ChatDate.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var id: String { dateStr }
    var dateStr: String
    var chats: [Chat]
}
