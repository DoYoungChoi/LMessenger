//
//  HomeView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destination) {
            contentView
                .fullScreenCover(item: $homeViewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView(profileViewModel: .init(container: container, userId: homeViewModel.userId))
                    case let .otherProfile(userId):
                        OtherProfileView(profileViewModel: .init(container: container, userId: userId)) { otherUser in
                            homeViewModel.send(action: .goToChat(otherUser))
                        }
                    case .setting:
                        SettingView(settingViewModel: .init())
                    }
                }
                .navigationDestination(for: NavigationDestination.self) {
                    NavigationRoutingView(destination: $0)
                }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch homeViewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear {
                    homeViewModel.send(action: .fetch)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
                .toolbar {
                    Image("bookmark")
                    Image("notifications")
                    Image("person_add")
                    Button{
                        homeViewModel.send(action: .presentView(.setting))
                    } label: {
                        Image("settings")
                    }
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView {
            profileView
                .padding(.bottom, 30)
            
            NavigationLink(value: NavigationDestination.search(userId: homeViewModel.userId)) {
                SearchButton()
            }
            .padding(.bottom, 24)
            
            HStack {
                Text("친구")
                    .font(.system(size: 14))
                    .foregroundStyle(.bkText)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            
            // TODO: 친구 목록
            if homeViewModel.users.isEmpty {
                Spacer(minLength: 89)
                emptyView
            } else {
                LazyVStack {
                    ForEach(homeViewModel.users, id:\.id) { user in
                        Button {
                            homeViewModel.send(action: .presentView(.otherProfile(user.id)))
                        } label: {
                            HStack(spacing: 8) {
                                Image("person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                Text(user.name)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.bkText)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
            }
        }
    }
    
    var profileView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text(homeViewModel.myUser?.name ?? "이름")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.bkText)
                Text(homeViewModel.myUser?.description ?? "상태 메시지 입력")
                    .font(.system(size: 12))
                    .foregroundStyle(.greyDeep)
            }
            
            Spacer()
            
            Image("person")
                .resizable()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            homeViewModel.send(action: .presentView(.myProfile))
        }
    }
    
    var emptyView: some View {
        VStack {
            VStack(spacing: 3) {
                Text("친구를 추가해보세요.")
                    .foregroundStyle(.bkText)
                Text("큐알코드나 검색을 이용해서 친구를 추가해보세요.")
                    .foregroundStyle(.greyDeep)
            }
            .font(.system(size: 14))
            .padding(.bottom, 30)
            
            Button {
                homeViewModel.send(action: .requestContacts)
            } label: {
                Text("친구추가")
                    .font(.system(size: 14))
                    .foregroundStyle(.bkText)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 24)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.greyLight)
            }
        }
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let navigationRouter = NavigationRouter()
    
    return HomeView(homeViewModel: .init(container: container, navigationRouter: navigationRouter, userId: "user"))
        .environmentObject(container)
        .environmentObject(navigationRouter)
}
