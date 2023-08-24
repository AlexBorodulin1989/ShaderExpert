//
//  ContentView.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 21.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var shaderText = "Enter shader"

    var body: some View {
        VStack {
            ShaderView()
            TextEditor(text: $shaderText)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
