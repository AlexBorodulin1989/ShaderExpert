//
//  ContentViewModel.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 24.08.2023.
//

import Foundation
import Combine

struct FileItem: Identifiable {
    let id: String = UUID().uuidString
    let name: String
}

final class ContentViewModel: ObservableObject {
    @Published var shaderText = Shader.fragmentShaderText
    @Published var fileName = ""

    @Published var showingAlert = false
    @Published var alertText = ""

    @Published var filesList = [FileItem]()

    private var subscriptions = Set<AnyCancellable>()

    private let savesDirectory = "shader_saves/"

    private let fileManager = FileManager.default

    init() {
        updateFilesList()

        NotificationCenter.default.publisher(for: .error)
            .sink { [weak self] object in
                guard let self else { return }
                showingAlert = true
                alertText = object.userInfo?["error"] as? String ?? ""
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Update
extension ContentViewModel {
    func updateFilesList() {
        do {
            let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory)

            let files = (try fileManager.contentsOfDirectory(atPath: url.path())).map { $0.replacingOccurrences(of: ".txt", with: "") }

            filesList = files.map { FileItem(name: $0) }
        } catch {
            assert(false, "Failed to read directory")
        }
    }
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

            updateFilesList()
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }

    func openFileName(_ name: String) {
        let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory + "/" + name + ".txt")

        do {
            let data = try Data(contentsOf: url);
            shaderText = String(decoding: data, as: UTF8.self)
            fileName = name
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }
}
