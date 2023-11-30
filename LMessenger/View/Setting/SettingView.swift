//
//  SettingView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appearanceController: AppearanceController
    @StateObject var settingViewModel: SettingViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(settingViewModel.sectionItems) { section in
                    Section {
                        ForEach(section.settings) { setting in
                            Button{
                                if let appr = setting.item as? AppearanceType {
                                    appearanceController.changeAppearance(appr)
                                    appearance = appr.rawValue
                                }
                            } label: {
                                Text(setting.item.label)
                                    .foregroundStyle(.bkText)
                            }
                        }
                    } header: {
                        Text(section.label)
                    }
                }
            }
            .navigationTitle("설정")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image("close_search")
                }
            }
        }
        .preferredColorScheme(appearanceController.appearance.colorScheme)
    }
}

#Preview {
    SettingView(settingViewModel: .init())
        .environmentObject(AppearanceController(0))
}
