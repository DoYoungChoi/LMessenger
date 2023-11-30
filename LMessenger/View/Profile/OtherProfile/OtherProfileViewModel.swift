//
//  OtherProfileViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation

@MainActor
class OtherProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    
    private let userId: String
    private var container: DIContainer
    
    init(
        container: DIContainer,
        userInfo: User? = nil,
        userId: String
    ) {
        self.container = container
        self.userInfo = userInfo
        self.userId = userId
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
}
