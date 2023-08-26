//
//  RenderEngine.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 11.06.2023.
//

import MetalKit
import Combine

class RenderEngine: NSObject {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue!

    private var library: MTLLibrary!

    private var mesh: Rectangle!
    private var pipelineState: MTLRenderPipelineState!

    var timer: Float = 0

    private(set) var aspectRatio: Float = 1

    private var depthState: MTLDepthStencilState!

    var inputs = Inputs()

    private var subscriptions = Set<AnyCancellable>()

    private let pixelFormat: MTLPixelFormat

    init(mtkView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice()
        else {
            fatalError("Fatal error: cannot create Device")
        }

        self.device = device

        mesh = Rectangle(device: device)

        pixelFormat = mtkView.colorPixelFormat

        super.init()

        guard
            let depthState = createDepthState()
        else {
            fatalError("Fatal error: cannot create depth state")
        }
        self.depthState = depthState

        guard
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("Fatal error: cannot create Queue")
        }
        self.commandQueue = commandQueue

        mtkView.device = device

        createPipeline()

        mtkView.clearColor = MTLClearColor(red: 0.5,
                                             green: 0.5,
                                             blue: 0.5,
                                             alpha: 1.0)

        mtkView.depthStencilPixelFormat = .depth32Float

        mtkView.delegate = self

        NotificationCenter.default.publisher(for: .updateShader)
            .sink { [weak self] _ in
                guard let self else { return }
                createPipeline()
            }
            .store(in: &subscriptions)
    }

    func createPipeline() {
        do {
            library = try device.makeLibrary(source: Shader.vertexShaderText + Shader.fragmentShaderText, options: nil)
        } catch {
            print(error.localizedDescription)
        }

        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineDescriptor.vertexDescriptor = Rectangle.layout
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension RenderEngine {
    func createDepthState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension RenderEngine: MTKViewDelegate {
    func mtkView(_ view: MTKView,
                 drawableSizeWillChange size: CGSize
    ) {
        inputs.screenSize = float2(x: Float(size.width),
                                   y: Float(size.height))
    }

    func draw(in view: MTKView) {
        guard
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }

        renderEncoder.setDepthStencilState(depthState)

        renderEncoder.setFragmentBytes(&inputs,
                                       length: MemoryLayout<Inputs>.stride,
                                       index: InputIndex.value)

        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(mesh.vBuffer,
                                      offset: 0,
                                      index: 0)

        renderEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: mesh.indices.count,
                                            indexType: .uint16,
                                            indexBuffer: mesh.iBuffer,
                                            indexBufferOffset: 0)

        renderEncoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            return
        }

        commandBuffer.present(drawable)

        commandBuffer.commit()
    }
}
