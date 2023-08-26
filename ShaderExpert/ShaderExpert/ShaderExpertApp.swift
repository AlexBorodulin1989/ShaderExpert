//
//  ShaderExpertApp.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 21.08.2023.
//

import SwiftUI

@main
struct ShaderExpertApp: App {
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            ContentView_Mac()
#elseif os(iOS)
            ContentView_iOS()
#endif
        }
    }
}
