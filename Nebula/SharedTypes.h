//
//  SharedTypes.h
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

#ifndef SharedTypes_h
#define SharedTypes_h
#include <simd/simd.h>

#define RandomTextureSize 256

typedef enum VertexInputIndex
{
	VertexInputIndexVertices = 0
} VertexInputIndex;

typedef enum NebulaInputIndex
{
	NebulaInputIndexRandomTexture = 0,
	NebulaInputIndexBackground = 1,
	NebulaInputIndexData = 0
} NebulaInputIndex;

typedef enum StarInputIndex
{
	StarInputIndexBackground = 0,
	StarInputIndexData = 0
} StarInputIndex;

typedef struct
{
	vector_float2 position;
	vector_float2 textureCoordinate;
} Vertex;

typedef struct
{
	float time;
	simd_float3 color;
	simd_float2 offset;
	float density;
	float falloff;
	float scale;
} NebulaFragmentData;

typedef struct
{
	float time;
	simd_float3 color;
	simd_float3 haloColor;
	simd_float2 center;
	float haloFalloff;
	float radius;
} StarsFragmentData;


#endif /* SharedTypes_h */
