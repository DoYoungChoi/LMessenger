//
//  AppearanceController.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

class AppearanceController: ObservableObject {
    @Published var appearance: AppearanceType
    
    init(_ appearanceValue: Int) {
        self.appearance = AppearanceType(rawValue: appearanceValue) ?? .automatic
    }
    
    func changeAppearance(_ willBeAppearance: AppearanceType) {
        appearance = willBeAppearance
    }
}
