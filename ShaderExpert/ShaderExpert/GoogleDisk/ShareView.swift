//
//  LoginView.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 12.09.2023.
//

import SwiftUI

struct ShareView: View {
    @StateObject private var viewModel = ShareViewModel()

    var body: some View {
        ZStack {
            Button {
                viewModel.loginToGoogle()
            } label: {
                Text("Save to google disk")
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.gray)
        .cornerRadius(8)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
