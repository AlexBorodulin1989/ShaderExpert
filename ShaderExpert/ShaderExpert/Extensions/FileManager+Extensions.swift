//
//  FileManager+Extensions.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 27.08.2023.
//

import Foundation

extension FileManager {
    static func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
