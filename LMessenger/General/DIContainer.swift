//
//  DIContainer.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(
        services: ServiceType
    ) {
        self.services = services
    }
}
