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
        HStack {
            VStack {
                ShaderView()
                ToolView_Mac(viewModel: viewModel)
                TextEditor(text: $viewModel.shaderText)
            }
            .padding()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.filesList) { item in
                        Button {
                            viewModel.openFileName(item.name)
                        } label: {
                            Text(item.name)
                        }
                        .buttonStyle(.borderless)
                        .frame(height: 45)
                    }
                }
            }
            .frame(width: 150)
            .padding(.leading, 4)
            .padding(.trailing, 16)
        }
        .alert(viewModel.alertText, isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct ToolView_Mac: View {
    @ObservedObject var viewModel: ContentViewModel

    @State private var showingDeleteAlert = false

    var body: some View {
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
                    let chars = /[a-zA-Z0-9._-]+/

                    if try chars.wholeMatch(in: viewModel.fileName) != nil {
                        viewModel.saveFile()
                    } else {
                        viewModel.showingAlert = true
                        viewModel.alertText = "File name can contains chars from a to z, numbers, dot, _, -"
                    }
                } catch {
                    viewModel.showingAlert = true
                    viewModel.alertText = "File name can contains chars from a to z, numbers, dot, _, -"
                }


            } label: {
                Image(systemName: "opticaldisc.fill")
                    .font(.system(size: 30))
            }
            .buttonStyle(.borderless)

            Button {
                if viewModel.fileName.isEmpty {
                    viewModel.showingAlert = true
                    viewModel.alertText = "Cannot delete default shader"
                } else {
                    showingDeleteAlert = true
                }
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 30))
            }
            .buttonStyle(.borderless)


            Spacer()
        }
        .alert(isPresented:$showingDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete shader?"),
                message: Text("There is no undo"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteFile(viewModel.fileName)
                },
                secondaryButton: .cancel()
            )
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
