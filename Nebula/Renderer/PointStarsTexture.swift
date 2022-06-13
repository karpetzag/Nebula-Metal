//
//  StarsTexture.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import MetalKit

struct PointStarsTextureData {

	private enum Constants {
		static let brightness: Float = 0.125
		static let density: Float = 0.06
	}

	static func generate(width: Int, height: Int) -> NSData {
		let count = Int(Float(width * height) * Constants.density)
		let dataSize = width * height * 4
		guard let data = NSMutableData(length: dataSize) else {
			fatalError("Failed to create data")
		}
		let bytes = data.mutableBytes.bindMemory(to: UInt8.self, capacity: dataSize)
		for _ in 0..<count {
			let random = Int.random(in: 0..<width * height) * 4
			let val = Int(min(255 * log(1 - Float.random(in: 0..<1)) * -Constants.brightness, 255))
			let color = UInt8(val)
			bytes[random + 0] = color
			bytes[random + 1] = color
			bytes[random + 2] = color
			bytes[random + 3] = 255
		}

		return data
	}
}
