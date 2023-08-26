//
//  ContentView.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 21.08.2023.
//

import SwiftUI

struct ContentView_Mac: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            ShaderView()
            HStack {
                Button {
                    viewModel.update()
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 30))
                }
                .buttonStyle(.borderless)

                Spacer()
            }
            TextEditor(text: $viewModel.shaderText)
        }
        .padding()
    }
}

#if os(macOS)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_Mac()
    }
}
#endif
