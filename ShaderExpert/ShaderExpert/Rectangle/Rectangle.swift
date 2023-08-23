//
//  Rectangle.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 21.08.2023.
//

import Foundation
import MetalKit

class Rectangle {
    var vBuffer: MTLBuffer!
    var iBuffer: MTLBuffer!

    var vertices: [Vertex] {
        [.init(position: .init(x: -1, y: -1, z: 0.5)),
         .init(position: .init(x: -1, y: 1, z: 0.5)),
         .init(position: .init(x: 1, y: 1, z: 0.5)),
         .init(position: .init(x: 1, y: -1, z: 0.5))]
    }

    var indices: [UInt16] {
        [0, 1, 2,
        0, 2, 3]
    }

    static var layout: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        var stride = MemoryLayout<float3>.stride

        vertexDescriptor.layouts[0].stride = stride
        return vertexDescriptor
    }

    init(device: MTLDevice) {
        var vertices = self.vertices
        guard let vertexBuffer = device.makeBuffer(bytes: &vertices,
                                                   length: MemoryLayout<Vertex>.stride * vertices.count,
                                                   options: [])
        else {
            fatalError("Unable to create quad vertex buffer")
        }
        self.vBuffer = vertexBuffer

        var indices = self.indices
        guard let indexBuffer = device.makeBuffer(bytes: &indices,
                                                  length: MemoryLayout<UInt16>.stride * indices.count)
        else {
            fatalError("Unable to create quad index buffer")
        }

        self.iBuffer = indexBuffer
    }
}
