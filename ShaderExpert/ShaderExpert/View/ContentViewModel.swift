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

    init() {
        filesList = FileManagerService.shared.getFilesList().map { .init(name: $0) }

        NotificationCenter.default.publisher(for: .error)
            .sink { [weak self] object in
                guard let self else { return }
                showingAlert = true
                alertText = object.userInfo?["error"] as? String ?? ""
            }
            .store(in: &subscriptions)
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
        do {
            try FileManagerService.shared.saveFile(name: fileName, text: shaderText)
            showingAlert = true
            alertText = "File saved"

            filesList = FileManagerService.shared.getFilesList().map { .init(name: $0) }
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }

    func deleteFile(_ name: String) {
        do {
            try FileManagerService.shared.deleteFile(name)
            shaderText = ""
            filesList = FileManagerService.shared.getFilesList().map { .init(name: $0) }
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }

    func openFileName(_ name: String) {
        do {
            shaderText = try FileManagerService.shared.openTextFileName(name)
            fileName = name
        } catch {
            showingAlert = true
            alertText = error.localizedDescription
        }
    }
}
