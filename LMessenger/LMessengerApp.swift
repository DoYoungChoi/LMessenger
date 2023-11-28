//
//  LMessengerApp.swift
//  LMessenger
//
//  Created by dodor on 11/27/23.
//

import SwiftUI

@main
struct LMessengerApp: App {
    @StateObject private var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init())
                .environmentObject(container)
        }
    }
}
