//
//  ChatListView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var chatListViewModel: ChatListViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            ScrollView {
                NavigationLink(value: NavigationDestination.search(userId: chatListViewModel.userId)) {
                    SearchButton()
                }
                .padding(.top, 14)
                .padding(.bottom, 14)
                
                ForEach(chatListViewModel.chatRooms, id:\.self) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, userId: chatListViewModel.userId)
                }
            }
            .navigationTitle("대화")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
        .onAppear {
            chatListViewModel.send(action: .load)
        }
    }
}

fileprivate struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let userId: String
    
    var body: some View {
        NavigationLink(value: NavigationDestination.chat(chatRoomId: chatRoom.chatRoomId,
                                                         myUserId: userId,
                                                         otherUserId: chatRoom.otherUserId)) {
            HStack(spacing: 8) {
                Image("person")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(chatRoom.otherUserName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.bkText)
                    
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(.greyDeep)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    let container = DIContainer(services: StubService())
    
    return ChatListView(chatListViewModel: .init(container: container, userId: "user"))
}
