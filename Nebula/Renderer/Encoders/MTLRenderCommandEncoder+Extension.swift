//
//  MTLRenderCommandEncoder+Extension.swift
//  Nebula
//
//  Created by Andrey Karpets on 10.06.2022.
//

import Metal

extension MTLRenderCommandEncoder {

	func encodeAndDrawQuad(indexOfVertexArray: Int = 0) {
		self.setVertexBytes(
			Quad.vertexArray,
			length: MemoryLayout<Vertex>.stride * Quad.vertexArray.count,
			index: indexOfVertexArray
		)
		self.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: Quad.vertexArray.count)
	}
}
