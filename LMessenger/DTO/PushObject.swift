//
//  PushObject.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

struct PushObject: Encodable {
    var to: String
    var notification: NotificationOjbect
    
    struct NotificationOjbect: Encodable {
        var title: String
        var body: String
    }
}
