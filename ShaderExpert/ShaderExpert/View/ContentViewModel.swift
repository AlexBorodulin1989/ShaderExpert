//
//  ContentViewModel.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 24.08.2023.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var shaderText = Shader.fragmentShaderText
    @Published var fileName = ""

    @Published var showingAlert = false
    @Published var alertText = ""

    private var subscriptions = Set<AnyCancellable>()

    private let savesDirectory = "shader_saves/"
}

// MARK: - Actions
extension ContentViewModel {
    func update() {
        Shader.fragmentShaderText = shaderText
        NotificationCenter.default.post(name: .updateShader,
                                        object: nil,
                                        userInfo: nil)
    }

    func saveFile() {
        let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory)

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                showingAlert = true
                alertText = error.localizedDescription
            }
        }

        let fileUrl = url.appendingPathComponent(fileName + ".txt")

        do {
            try shaderText.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)

            showingAlert = true
            alertText = "Saved to: \(url.absoluteString)"
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }
}
