//
//  FileManagerService.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 24.09.2023.
//

import Foundation
import os

class FileManagerService {
    private static var lock = OSAllocatedUnfairLock()
    private static var _shared = FileManagerService()

    static var shared: FileManagerService {
        get { lock.withLock { _shared } }
    }

    private let fileManager = FileManager.default

    private let savesDirectory = "shader_saves/"

    private init() {}
}

// MARK: - Files list
extension FileManagerService {
    func getFilesList() -> [String] {
        do {
            let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory)

            let files = (try fileManager.contentsOfDirectory(atPath: url.path())).map { $0.replacingOccurrences(of: ".txt", with: "") }

            return files
        } catch {
            assert(false, "Failed to read directory")
            return []
        }
    }

    func saveFile(name: String, text: String) throws {
        let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory)

        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }

        let fileUrl = url.appendingPathComponent(name + ".txt")

        try text.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)

        print("Saved to: \(url.absoluteString)")
    }

    func deleteFile(_ name: String) throws {
        let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory + name + ".txt")
        try fileManager.removeItem(at: url)
    }

    func openTextFileName(_ name: String) throws -> String {
        let url = FileManager.documentDirectory().appendingPathComponent(savesDirectory + name + ".txt")
        let data = try Data(contentsOf: url)

        return String(decoding: data, as: UTF8.self)
    }
}
