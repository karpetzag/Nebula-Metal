//
//  Device.swift
//  Nebula
//
//  Created by Andrey Karpets on 10.06.2022.
//
import UIKit
import Metal

enum ShaderName: String {

	case vertexShader
	case fragmentShader
	case starFragmentShader
	case nebulaFragmentShader
}

final class Device {

	lazy var commandQueue: MTLCommandQueue = {
		guard let queue = self.metalDevice.makeCommandQueue() else {
			fatalError("Failed to create command queue")
		}
		return queue
	}()

	lazy var metalDevice: MTLDevice = {
		guard let deivce = MTLCreateSystemDefaultDevice() else {
			fatalError("Failed to create device")
		}
		return deivce
	}()

	func makeRenderPipelineState(
		vertexFunctionName: String,
		fragmentFunctionName: String,
		pixelFormat: MTLPixelFormat = .bgra8Unorm
	) -> MTLRenderPipelineState {
		let descrpiptor = MTLRenderPipelineDescriptor()
		let libary = metalDevice.makeDefaultLibrary()
		descrpiptor.vertexFunction = libary?.makeFunction(name: vertexFunctionName)
		descrpiptor.fragmentFunction = libary?.makeFunction(name: fragmentFunctionName)
		descrpiptor.colorAttachments[0].pixelFormat = pixelFormat
		return self.makeRenderPipelineState(descriptor: descrpiptor)
	}

	func makeRenderPipelineState(descriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState {
		do {
			return try self.metalDevice.makeRenderPipelineState(descriptor: descriptor)
		} catch {
			fatalError("Failed to make render pipeline state \(error)")
		}
	}

	func makeRenderTargetTexture(size: CGSize) -> MTLTexture {
		let descriptor = MTLTextureDescriptor()
		descriptor.width = Int(size.width)
		descriptor.height = Int(size.height)
		descriptor.usage = [.renderTarget, .shaderRead]
		descriptor.pixelFormat = .bgra8Unorm
		guard let texture = self.metalDevice.makeTexture(descriptor: descriptor) else {
			fatalError("Failed to make texture")
		}

		return texture
	}

	func makeTexture(with data: NSData, width: Int, height: Int, isRenderTarget: Bool) -> MTLTexture {
		let descriptor = MTLTextureDescriptor()
		descriptor.width = width
		descriptor.height = height
		descriptor.pixelFormat = .bgra8Unorm
		descriptor.usage = isRenderTarget ? [.shaderRead, .renderTarget] : [.shaderRead]

		guard let texture = self.metalDevice.makeTexture(descriptor: descriptor) else {
			fatalError("Failed to create texture")
		}

		let region = MTLRegion(
			origin: MTLOrigin(x: 0, y: 0, z: 0),
			size: MTLSize(width: descriptor.width, height: descriptor.height, depth: 1)
		)

		texture.replace(region: region, mipmapLevel: 0, withBytes: data.bytes, bytesPerRow: descriptor.width * 4)
		return texture
	}

	func makeEmptyTexture(width: Int, height: Int) -> MTLTexture {
		self.makeRenderTargetTexture(size: CGSize(width: width, height: height))
	}
}
