//
//  GlobusView.swift
//  Globus
//
//  Created by Aleksandr Borodulin on 11.06.2023.
//

import SwiftUI
import MetalKit

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
typealias UniversalView = NSView
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
typealias UniversalView = UIView
#endif

struct ShaderView: ViewRepresentable {
    @State private var metalView = MTKView()

#if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        makeView()
    }
    func updateNSView(_ uiView: NSViewType, context: Context) {
    }
#elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        makeView() as! MTKView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}
#endif

    func makeView() -> UniversalView {
        return metalView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: ShaderView

        private var renderer: RenderEngine!

        init(_ parent: ShaderView) {
            self.parent = parent

            super.init()

            renderer = RenderEngine(mtkView: parent.metalView)
        }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ShaderView()
        }
    }
}
