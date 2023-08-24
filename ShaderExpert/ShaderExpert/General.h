//
//  General.h
//  ShaderExpert
//
//  Created by Aleksandr Borodulin on 04.08.2023.
//

#ifndef General_h
#define General_h

#import <simd/simd.h>

typedef struct {
    vector_float3 position;
} Vertex;

typedef enum {
    InputIndex = 10
} ShaderIndices;

typedef struct {
    vector_float2 screenSize;
} Inputs;

#endif /* General_h */
