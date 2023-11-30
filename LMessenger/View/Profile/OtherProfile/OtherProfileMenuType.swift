//
//  OtherProfileMenuType.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation

enum OtherProfileMenuType: Hashable, CaseIterable {
    case chat
    case call
    case facetime
    
    var description: String {
        switch self {
        case .chat:
            return "대화"
        case .call:
            return "음성통화"
        case .facetime:
            return "영상통화"
        }
    }
    
    var imageName: String {
        switch self {
        case .chat:
            return "sms"
        case .call:
            return "phone_profile"
        case .facetime:
            return "videocam"
        }
    }
}
