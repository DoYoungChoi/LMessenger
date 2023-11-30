//
//  ChatView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @StateObject var chatViewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            if chatViewModel.chatDataList.isEmpty {
                Color.chatBg
            } else {
                contentView
            }
        }
        .background(Color.chatBg)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    navigationRouter.pop()
                } label: {
                    Image("back")
                }
                
                Text(chatViewModel.otherUser?.name ?? "대화방이름")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.bkText)
            }
                
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image("search_chat")
                Image("bookmark")
                Image("settings")
            }
        }
        .keyboardToolbar(height: 50) {
            HStack(spacing: 13) {
                Button {
                } label: {
                    Image("other_add")
                }
                Button {
                } label: {
                    Image("image_add")
                }
                Button {
                } label: {
                    Image("photo_camera")
                }
                
                TextField("", text: $chatViewModel.message)
                    .font(.system(size: 16))
                    .foregroundStyle(.bkText)
                    .focused($isFocused)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color.greyCool)
                    .cornerRadius(20)
                
                Button {
                    
                } label: {
                    Image("send")
                }
            }
            .padding(.horizontal, 27)
        }
    }
    
    var contentView: some View {
        ForEach(chatViewModel.chatDataList) { chatData in
            Section {
                ForEach(chatData.chats) { chat in
                    ChatItemView(message: chat.message ?? "",
                                 direction: chatViewModel.getDirection(id: chat.userId),
                                 date: chat.date)
                }
            } header: {
                headerView(dateStr: chatData.dateStr)
            }
        }
    }
    
    func headerView(dateStr: String) -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(width: 76, height: 20)
                .background(Color.chatNotice)
                .cornerRadius(50)
            Text(dateStr)
                .font(.system(size: 10))
                .foregroundStyle(.bgWh)
        }
        .padding(.top)
    }
}

#Preview {
    NavigationStack {
        ChatView(chatViewModel: .init(container: DIContainer(services: StubService()),
                                      chatRoomId: "chatRoomId",
                                      myUserId: "myUserId",
                                      otherUserId: "otherUserId"))
    }
}
