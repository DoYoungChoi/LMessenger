//
//  MyProfileDescEditView.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import SwiftUI

struct MyProfileDescEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var description: String
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("상태메시지를 입력해주세요", text: $description)
                    .multilineTextAlignment(.center)
            }
            .toolbar {
                Button("완료") {
                    dismiss()
                    onCompleted(description)
                }
                .disabled(description.isEmpty)
            }
        }
    }
}

#Preview {
    MyProfileDescEditView(description: "") { _ in }
}
