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

                TextField("File name", text: $viewModel.fileName)

                Button {
                    if viewModel.fileName.isEmpty {
                        viewModel.showingAlert = true
                        viewModel.alertText = "File name cannot be empty"
                        return
                    }

                    do {
                        let range = NSRange(location: 0,
                                            length: viewModel.fileName.utf16.count)

                        let digits = /[a-zA-Z]+/

                        if try digits.wholeMatch(in: viewModel.fileName) != nil {
                            viewModel.saveFile()
                        } else {
                            viewModel.showingAlert = true
                            viewModel.alertText = "File name can contains chars from a to z"
                        }
                    } catch {
                        viewModel.showingAlert = true
                        viewModel.alertText = "File name can contains chars from a to z"
                    }


                } label: {
                    Image(systemName: "opticaldisc.fill")
                        .font(.system(size: 30))
                }
                .buttonStyle(.borderless)

                Spacer()
            }
            TextEditor(text: $viewModel.shaderText)
        }
        .padding()
        .alert(viewModel.alertText, isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#if os(macOS)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_Mac()
    }
}
#endif
