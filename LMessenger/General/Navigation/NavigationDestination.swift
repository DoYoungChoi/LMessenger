//
//  NavigationDestination.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search
}
