//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2]
    
}
