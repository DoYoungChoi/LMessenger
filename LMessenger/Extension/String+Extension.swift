//
//  String+Extension.swift
//  LMessenger
//
//  Created by dodor on 12/2/23.
//

import Foundation

extension String {
    var toChatDate: Date? {
        let formmater = DateFormatter()
        formmater.locale = Locale(identifier: "ko_KR")
        formmater.dateFormat = "yyyy.MM.dd E"
        return formmater.date(from: self)
    }
}
