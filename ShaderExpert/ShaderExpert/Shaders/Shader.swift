//
//  Shader.swift
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 24.08.2023.
//

import Foundation

class Shader {
    static var vertexShaderText = """
    #include <metal_stdlib>
    using namespace metal;

    typedef struct {
        vector_float3 position;
    } Vertex;

    typedef enum {
        InputIndex = 10
    } ShaderIndices;

    typedef struct {
        vector_float2 screenSize;
    } Inputs;

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
    
    """

    static var fragmentShaderText = """
    #define SCALE 10
    #define UNDEFINED_VALUE 10000

    float sqrt2Function(float x) {
        float undefined = 1 - step(0, x);
        return undefined * UNDEFINED_VALUE + (1 - undefined) * sqrt(x)*2;
    }

    float quadFunction(float x) {
        return x * x;
    }

    float sin10Function(float x) {
        return sin(x) * 10;
    }

    float3 calcGraph(float (*func)(float),
                     const float3 pixel,
                     const float2 uv,
                     const float3 color,
                     const float2 screenSize) {
        const float delta = 0.00001;
        float3 resPixel = pixel;

        const float graphLineWidth = 4 * SCALE;

        float y = func(uv.x);

        float k = (func(uv.x + delta) - y) / delta;

        float dy = uv.y - y;
        float dx = dy / k;

        float horisontalWidth = graphLineWidth / screenSize.x;
        float verticalWidth = graphLineWidth / screenSize.y;
                float colored = min(step(horisontalWidth, abs(dx)),
                                        step(verticalWidth, abs(y - uv.y)));
        resPixel = mix(color, resPixel, colored);

        return resPixel;
    }

    fragment float4 fragment_main(constant Inputs &inputs [[ buffer(InputIndex) ]],
                                  VertexOut in [[stage_in]]) {
        const float lineWidth = 1 * SCALE;
        const float axisLineWidth = 3 * SCALE;

        float2 uv = float2(in.pos.xy / inputs.screenSize);
        uv.y = 1.0 - uv.y;
        uv = uv * 2 - 1;
        uv *= SCALE;
        float3 backgroundColor = float3(1.0);
        float3 axesColor = float3(0.3);
        float3 gridColor = float3(0.5);

        float3 pixel = backgroundColor;

        pixel = calcGraph(&sqrt2Function, pixel, uv, float3(1.0, 0.0, 0.0), inputs.screenSize);
        pixel = calcGraph(&quadFunction, pixel, uv, float3(0.0, 1.0, 0.0), inputs.screenSize);
        pixel = calcGraph(&sin10Function, pixel, uv, float3(0.0, 0.0, 1.0), inputs.screenSize);

        float horisontalWidth = lineWidth / inputs.screenSize.x;
        float verticalWidth = lineWidth / inputs.screenSize.y;
        float greedSize = 0.1 * SCALE;

        // Greed
        float x = fabs(uv.x - greedSize * floor(uv.x / greedSize));
        float y = fabs(uv.y - greedSize * floor(uv.y / greedSize));

        float colored = min(step(horisontalWidth * 2, x),
                                step(verticalWidth * 2, abs(y)));
        pixel = mix(axesColor, pixel, colored);

        float horisontalAxisWidth = axisLineWidth / inputs.screenSize.x;
        float verticalAxisWidth = axisLineWidth / inputs.screenSize.y;
        colored = min(step(horisontalAxisWidth, abs(uv.x)),
                            step(verticalAxisWidth, abs(uv.y)));
        pixel = mix(axesColor, pixel, colored);

        return float4(pixel, 1.0);
    }
    """
}
