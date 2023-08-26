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

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - Actions
extension ContentViewModel {
    func update() {
        Shader.fragmentShaderText = shaderText
        NotificationCenter.default.post(name: .updateShader,
                                        object: nil,
                                        userInfo: nil)
    }
}
