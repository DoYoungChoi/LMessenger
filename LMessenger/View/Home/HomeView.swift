//
//  HomeView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            contentView
                .fullScreenCover(item: $homeViewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView(profileViewModel: .init(container: container, userId: homeViewModel.userId))
                    case let .otherProfile(userId):
                        OtherProfileView()
                    }
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
                        // TODO:
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
            
            searchButton
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
                            homeViewModel.send(action: .presentOtherProfile(user.id))
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
            homeViewModel.send(action: .presentMyProfile)
        }
    }
    
    var searchButton: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(height: 36)
                .background(Color.greyCool)
                .cornerRadius(5)
            
            HStack {
                Text("검색")
                    .font(.system(size: 12))
                    .foregroundStyle(.greyLightVer2)
                
                Spacer()
            }
            .padding(.leading, 22)
        }
        .padding(.horizontal, 30)
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
    HomeView(homeViewModel: .init(container: .init(services: StubService()), userId: "user"))
}
