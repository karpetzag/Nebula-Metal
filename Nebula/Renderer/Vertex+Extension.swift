//
//  Vertex+Extension.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Foundation

typealias Vector2 = SIMD2<Float>
typealias Vector3 = SIMD3<Float>
typealias Vector4 = SIMD4<Float>
typealias Color3 = Vector3

struct Quad {

	static let vertexArray: [Vertex] = [
		Vertex(x: -1, y: 1, textureX: 0, textureY: 0),
		Vertex(x: 1, y: 1, textureX: 1, textureY: 0),
		Vertex(x: -1, y: -1, textureX: 0, textureY: 1),

		Vertex(x: -1, y: -1, textureX: 0, textureY: 1),
		Vertex(x: 1, y: -1, textureX: 1, textureY: 1),
		Vertex(x: 1, y: 1, textureX: 1, textureY: 0)
	]
}

extension Vertex {

	init(x: Float, y: Float, textureX: Float, textureY: Float) {
		self.init(position: Vector2(x, y), textureCoordinate: Vector2(textureX, textureY))
	}
}

extension Color3 {

	static func random() -> Self {
		return Color3(Float.random(in: 0...1), Float.random(in: 0...1), Float.random(in: 0...1))
	}
}
