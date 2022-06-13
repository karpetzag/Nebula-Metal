//
//  StarEncoder.swift
//  Nebula
//
//  Created by Andrey Karpets on 24.05.2022.
//

import MetalKit

final class StarEncoder: IPingPongEncoder {

	var parametersProvider: (_ index: Int) -> StarsFragmentData

	private let pipelineState: MTLRenderPipelineState
	private let renderPassDescriptor: MTLRenderPassDescriptor

	init(
		device: Device,
		parametersProvider: @escaping (_ index: Int) -> StarsFragmentData) {
		self.parametersProvider = parametersProvider

		pipelineState = device.makeRenderPipelineState(
			vertexFunctionName: ShaderName.vertexShader.rawValue,
			fragmentFunctionName: ShaderName.starFragmentShader.rawValue
		)

		renderPassDescriptor = MTLRenderPassDescriptor()
		renderPassDescriptor.colorAttachments[0].loadAction = .clear
		renderPassDescriptor.colorAttachments[0].storeAction = .store
	}

	func encode(source: MTLTexture, destination: MTLTexture, commandBuffer: MTLCommandBuffer, iteration: Int) {
		var parameters = parametersProvider(iteration)
		renderPassDescriptor.colorAttachments[0].texture = destination
		let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
		encoder?.setRenderPipelineState(pipelineState)
		encoder?.setFragmentBytes(
			&parameters, length: MemoryLayout<StarsFragmentData>.stride,
			index: Int(StarInputIndexData.rawValue)
		)
		encoder?.setFragmentTexture(source, index: Int(StarInputIndexBackground.rawValue))
		encoder?.encodeAndDrawQuad()
		encoder?.endEncoding()
	}
}
