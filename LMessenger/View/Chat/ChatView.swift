//
//  ChatView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI
import PhotosUI

struct ChatView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var chatViewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if chatViewModel.chatDataList.isEmpty {
                    Color.chatBg
                } else {
                    contentView
                }
            }
            .onChange(of: chatViewModel.chatDataList.last?.chats) { newValue in
                proxy.scrollTo(newValue?.last?.id, anchor: .bottom)
            }
        }
        .background(Color.chatBg)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    container.navigationRouter.pop()
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
                
                PhotosPicker(selection: $chatViewModel.imageSelection,
                             matching: .images) {
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
                    chatViewModel.send(action: .addChat(chatViewModel.message))
                    isFocused = false
                } label: {
                    Image("send")
                }
                .disabled(chatViewModel.message.isEmpty)
            }
            .padding(.horizontal, 27)
        }
        .onAppear {
            chatViewModel.send(action: .load)
        }
    }
    
    var contentView: some View {
        ForEach(chatViewModel.chatDataList) { chatData in
            Section {
                ForEach(chatData.chats) { chat in
                    if let message = chat.message {
                        ChatItemView(message: message,
                                     direction: chatViewModel.getDirection(id: chat.userId),
                                     date: chat.date)
                        .id(chat.chatId)
                    } else if let photoURL = chat.photoURL {
                        ChatImageItemView(urlString: photoURL,
                                          direction: chatViewModel.getDirection(id: chat.userId))
                        .id(chat.chatId)
                    }
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
