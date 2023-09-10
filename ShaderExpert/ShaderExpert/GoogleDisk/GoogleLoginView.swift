//
//  GoogleLoginView.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 10.09.2023.
//

import SwiftUI
import GoogleSignIn
#if os(iOS)
import UIKit
#endif

struct GoogleLoginView: ViewRepresentable {

#if os(macOS)
    @State private var view = NSView()

    func makeNSView(context: Context) -> some NSView {
        makeView()
    }
    func updateNSView(_ uiView: NSViewType, context: Context) {}
#elseif os(iOS)
    @State private var view = UIView()

    func makeUIView(context: Context) -> MTKView {
        makeView() as! MTKView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}
#endif

    func makeView() -> UniversalView {
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: GoogleLoginView

        private var renderer: RenderEngine!

        init(_ parent: GoogleLoginView) {
            self.parent = parent

            super.init()

            DispatchQueue.main.async {
                if let window = parent.view.window {
                    let signInConfig = GIDConfiguration.init(clientID: "212033144017-vkh2oj61rfgj9mgkmbau8aro03uo1gh8.apps.googleusercontent.com")
                    GIDSignIn.sharedInstance.configuration = signInConfig
                    print(GIDSignIn.sharedInstance.currentUser)
                    GIDSignIn.sharedInstance.signIn(withPresenting: window) { result, error in
                        if let error = error {
                            assert(false, error.localizedDescription)
                        } else {
                            print(result)
                        }
                    }
                }
            }
        }
    }
}

struct GoogleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GoogleLoginView()
        }
    }
}
