//
//  RandomNoiseTexture.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Metal

struct RandomNoiseTextureData {

	static func generate(width: Int, height: Int) -> NSData {
		let dataSize = 4 * width * height
		guard let data = NSMutableData(length: dataSize) else {
			fatalError("Failed to create data for random texture noise")
		}

		let bytes = data.mutableBytes.bindMemory(to: UInt8.self, capacity: dataSize)
		for y in 0..<height {
			for x in 0..<width {
				let position = 4 * (y * width + x)
				bytes[position + 0] = UInt8(Int.random(in: 0..<256))
				bytes[position + 1] = UInt8(Int.random(in: 0..<256))
				bytes[position + 2] = UInt8(Int.random(in: 0..<256))
				bytes[position + 3] = UInt8(Int.random(in: 0..<256))
			}
		}
		return data
	}
}
