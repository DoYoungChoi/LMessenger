//
//  ChatViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    enum Action {
        
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var otherUser: User?
    @Published var message: String = ""
    
    private let chatRoomId: String
    private let myUserId: String
    private let otherUserId: String
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        chatRoomId: String,
        myUserId: String,
        otherUserId: String
    ) {
        self.chatRoomId = chatRoomId
        self.myUserId = myUserId
        self.otherUserId = otherUserId
        self.container = container
        
        updateChatDataList(.init(chatId: "chat1_id", userId: "myUserId", message: "안녕하세요", date: Date()))
        updateChatDataList(.init(chatId: "chat2_id", userId: "otherUserId", message: "Hi", date: Date()))
        updateChatDataList(.init(chatId: "chat3_id", userId: "otherUserId", message: "뭐해?", date: Date()))
        updateChatDataList(.init(chatId: "chat4_id", userId: "myUserId", message: "공부", date: Date()))
    }
    
    func updateChatDataList(_ chat: Chat) {
        let keyDate = chat.date.toChatDataKey
        if let index = chatDataList.firstIndex(where: { $0.dateStr == keyDate }) {
            chatDataList[index].chats.append(chat)
        } else {
            chatDataList.append(ChatData(dateStr: keyDate, chats: [chat]))
        }
    }
    
    func getDirection(id: String) -> ChatItemDirection {
        myUserId == id ? .right : .left
    }
    
    func send(action: Action) {
        
    }
}
