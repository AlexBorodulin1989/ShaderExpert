//
//  GeneralShader.metal
//  Globus
//
//  Created by Aleksandr Borodulin on 11.06.2023.
//

#include <metal_stdlib>
#import "../General.h"
using namespace metal;

struct VertexOut {
    float4 pos [[position]];
};

vertex VertexOut vertex_main(constant Vertex *vertices [[buffer(0)]],
                             uint id [[vertex_id]]) {
    auto vert = vertices[id];
    VertexOut result {
        .pos = float4(vert.position, 1)
    };
    return result;
}

fragment float4 fragment_main(constant Inputs &inputs [[ buffer(InputIndex) ]],
                              VertexOut in [[stage_in]]) {
    float2 uv = float2(in.pos.xy / inputs.screenSize);
    uv.y = 1.0 - uv.y;
    float3 backgroundColor = float3(1.0);
    float3 axesColor = float3(0.0, 0.0, 1.0);
    float3 gridColor = float3(0.5);

    float3 pixel = backgroundColor;

    const float tickWidth = 0.1;
    for(float i = 0.0; i<1.0; i += tickWidth) {
        if (abs(uv.x - i) < 0.002) pixel = gridColor;
        if (abs(uv.y - i) < 0.002) pixel = gridColor;
    }

    if(abs(uv.x)<0.005) pixel = axesColor;
    if(abs(uv.y)<0.005) pixel = axesColor;
    return float4(pixel, 1.0);
}
