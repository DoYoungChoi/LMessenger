//
//  Date+Extension.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

extension Date {
    
    var toChatDataKey: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd E"
        
        return formatter.string(from: self)
    }
    
    var toChatTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:m"
        
        return formatter.string(from: self)
    }
}
