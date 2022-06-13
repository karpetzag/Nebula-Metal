//
//  PingPongEncoder.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Metal

protocol IPingPongEncoder {
	func encode(source: MTLTexture, destination: MTLTexture, commandBuffer: MTLCommandBuffer, iteration: Int)
}

extension IPingPongEncoder {
	func run(
		commandBuffer: MTLCommandBuffer,
		count: Int,
		pool: PingPongTexturePool
	) {
		for index in 0..<count {
			encode(source: pool.currentSource,
				   destination: pool.currentDestination,
				   commandBuffer: commandBuffer,
				   iteration: index)
			pool.swap()
		}
	}
}
