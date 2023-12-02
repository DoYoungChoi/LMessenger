//
//  LMessengerApp.swift
//  LMessenger
//
//  Created by dodor on 11/27/23.
//

import SwiftUI

@main
struct LMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage(AppStorageType.Appearance) var appearanceValue: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    @StateObject private var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
                .onAppear {
                    container.appearanceController.changeAppearance(AppearanceType(rawValue: appearanceValue))
                }
        }
    }
}
