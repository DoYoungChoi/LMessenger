//
//  SettingItem.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

protocol SettingItemable {
    var label: String { get }
}

struct SectionItem: Identifiable {
    let id = UUID()
    let label: String
    let settings: [SettingItem]
}

struct SettingItem: Identifiable {
    let id = UUID()
    let item: SettingItemable
}
