//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    
    var id: Int { hashValue }
}
