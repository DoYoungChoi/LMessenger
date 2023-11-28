//
//  LoginView.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.bkText)
                    .padding(.top, 80)
                
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundStyle(.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button {
                // TODO: google login
            } label: {
                Text("Google로 로그인")
            }
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyDeep))
            
            Button {
                // TODO: Apple login
            } label: {
                Text("Apple로 로그인")
            }
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyDeep))
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("back")
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
