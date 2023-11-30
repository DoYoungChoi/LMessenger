//
//  OtherProfileView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var profileViewModel: OtherProfileViewModel
    
    var goToChat: (User) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                }
            }
            .task {
                // OnAppear가 불리기 직전에 실행
                await profileViewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        URLImageView(urlString: profileViewModel.userInfo?.profileURL)
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }
    
    var nameView: some View {
        Text(profileViewModel.userInfo?.name ?? "이름")
            .font((.system(size: 24, weight: .bold)))
            .foregroundStyle(.bgWh)
    }
    
    var descriptionView: some View {
        Text(profileViewModel.userInfo?.description ?? "")
            .font(.system(size: 14))
            .foregroundStyle(.bgWh)
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            ForEach(OtherProfileMenuType.allCases, id:\.self) { menu in
                Button {
                    if menu == .chat,
                       let userInfo = profileViewModel.userInfo {
                        dismiss()
                        goToChat(userInfo)
                    }
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundStyle(.bgWh)
                    }
                }
            }
        }
    }
}

#Preview {
    OtherProfileView(profileViewModel: .init(container: DIContainer(services: StubService()), userId: "user")) { _ in }
}
