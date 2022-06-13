//
//  Shaders.metal
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

#include <metal_stdlib>
#include "SharedTypes.h"

using namespace metal;

struct RasterizerData
{
	float4 position [[position]];
	float2 textureCoordinate;
};

/// Perlin noise implementation from https://gpfault.net/posts/perlin-noise.txt.html

float fade(float t) {
  return t*t*t*(t*(t*6.0 - 15.0) + 10.0);
}

float2 grad(float2 p, texture2d<float> t) {
	const float texture_width = RandomTextureSize;
	constexpr sampler textureSampler (
									  address::repeat,
									  filter::nearest
									  );
	float4 v = t.sample(textureSampler, p / texture_width);
	return normalize(v.xy * 2 - float2(1.0));
}

float noise(float2 p, texture2d<float> text) {
  /* Calculate lattice points. */
	float2 p0 = floor(p);
	float2 p1 = p0 + float2(1.0, 0.0);
	float2 p2 = p0 + float2(0.0, 1.0);
	float2 p3 = p0 + float2(1.0, 1.0);

	/* Look up gradients at lattice points. */
	float2 g0 = grad(p0, text);
	float2 g1 = grad(p1, text);
	float2 g2 = grad(p2, text);
	float2 g3 = grad(p3, text);

	float t0 = p.x - p0.x;
	float fade_t0 = fade(t0); /* Used for interpolation in horizontal direction */

	float t1 = p.y - p0.y;
	float fade_t1 = fade(t1); /* Used for interpolation in vertical direction. */

	/* Calculate dot products and interpolate.*/
	float p0p1 = (1.0 - fade_t0) * dot(g0, (p - p0)) + fade_t0 * dot(g1, (p - p1)); /* between upper two lattice points */
	float p2p3 = (1.0 - fade_t0) * dot(g2, (p - p2)) + fade_t0 * dot(g3, (p - p3)); /* between lower two lattice points */

	/* Calculate final result */
	return (1.0 - fade_t1) * p0p1 + fade_t1 * p2p3;
}

float normalNoise(float2 p, texture2d<float> texture) {
	return (noise(p, texture) + 1) * 0.5;
}

float nebulaNoise(float2 point, texture2d<float> texture) {
	const int steps = 5;
	float scale = pow(2.0, float(steps));
	float displace = 0.0;
	for (int i = 0; i < steps; i++) {
		displace = normalNoise(point * scale + displace, texture);
		scale *= 0.5;
	}
	return normalNoise(point + displace, texture);
}

vertex RasterizerData
vertexShader(uint vertexID [[ vertex_id ]],
			 constant Vertex *vertexArray [[ buffer(VertexInputIndexVertices) ]])

{

	RasterizerData out;
	float2 pixelSpacePosition = vertexArray[vertexID].position.xy;
	out.position = vector_float4(pixelSpacePosition.x, pixelSpacePosition.y, 0.0, 1.0);
	out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
	return out;
}

// Fragment shaders

fragment float4
nebulaFragmentShader(RasterizerData in [[stage_in]],
					 texture2d<float> randomTexture [[ texture(NebulaInputIndexRandomTexture) ]],
					 texture2d<float> backgroundTexture [[ texture(NebulaInputIndexBackground) ]],
					 constant NebulaFragmentData &data [[ buffer(NebulaInputIndexData) ]]
			   )
{
	sampler textureSampler;

	float4 starsColor = backgroundTexture.sample(textureSampler, in.textureCoordinate);
	float2 fragCoord = in.position.xy + data.time;
	float n = nebulaNoise(fragCoord * data.scale + data.offset, randomTexture);
	n = pow(n + data.density, data.falloff);
	float4 color = float4(data.color , 1);
	return float4(mix(starsColor, color, n));
}


fragment float4
starFragmentShader(RasterizerData in [[stage_in]],
				   texture2d<float> backgroundTexture [[ texture(0) ]],
				   constant StarsFragmentData &data [[ buffer(0) ]]
				   )
{

	constexpr sampler textureSampler;
	float4 sourceColor = backgroundTexture.sample(textureSampler, in.textureCoordinate);
	float haloFalloffCoef = 0.05;
	float3 coreColor = data.color;
	float coreRadius = data.radius;
	float3 haloColor = data.haloColor;
	
	float distanceVal = distance(in.position.xy, data.center);
	
	float e = 1.0 - exp(-(distanceVal - coreRadius) * haloFalloffCoef * data.haloFalloff);
	float3 result = mix(coreColor, haloColor, e);
	result = mix(result, float3(0,0,0), e);
	
	return float4(result, 1.0) + sourceColor;
}


fragment float4
fragmentShader(RasterizerData in [[stage_in]], texture2d<float> texture [[texture(0)]]) {
	constexpr sampler s;
	return texture.sample(s, in.textureCoordinate);
}
