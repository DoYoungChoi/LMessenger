//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class MyProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }
    
    private let userId: String
    private var container: DIContainer
    
    init(
        container: DIContainer,
        userInfo: User? = nil,
        userId: String,
        isPresentedDescEditView: Bool = false,
        imageSelection: PhotosPickerItem? = nil
    ) {
        self.userInfo = userInfo
        self.userId = userId
        self.container = container
        self.isPresentedDescEditView = isPresentedDescEditView
        self.imageSelection = imageSelection
    }
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.description = description
        } catch {
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            // TODO: storage upload
            // TODO: db update
        } catch {
            
        }
    }
}
