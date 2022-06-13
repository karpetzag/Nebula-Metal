//
//  NebulaEncoder.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Metal

class NebulaEncoder: IPingPongEncoder {

	var parametersProvider: (_ index: Int) -> NebulaFragmentData

	private let pipelineState: MTLRenderPipelineState
	private let renderPassDescriptor: MTLRenderPassDescriptor
	private let randomSourceTexture: MTLTexture

	init(
		device: Device,
		randomSourceTexture: MTLTexture,
		parametersProvider: @escaping (_ index: Int) -> NebulaFragmentData
	) {
		self.randomSourceTexture = randomSourceTexture
		self.parametersProvider = parametersProvider

		self.pipelineState = device.makeRenderPipelineState(
			vertexFunctionName: ShaderName.vertexShader.rawValue,
			fragmentFunctionName: ShaderName.nebulaFragmentShader.rawValue
		)

		self.renderPassDescriptor = MTLRenderPassDescriptor()
		self.renderPassDescriptor.colorAttachments[0].loadAction = .clear
		self.renderPassDescriptor.colorAttachments[0].storeAction = .store
	}

	func encode(source: MTLTexture, destination: MTLTexture, commandBuffer: MTLCommandBuffer, iteration: Int) {
		var parameters = parametersProvider(iteration)

		renderPassDescriptor.colorAttachments[0].texture = destination
		let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
		encoder?.setRenderPipelineState(pipelineState)
		encoder?.setFragmentBytes(
			&parameters,
			length: MemoryLayout<NebulaFragmentData>.stride,
			index: Int(NebulaInputIndexData.rawValue)
		)
		encoder?.setFragmentTexture(randomSourceTexture, index: Int(NebulaInputIndexRandomTexture.rawValue))
		encoder?.setFragmentTexture(source, index: Int(NebulaInputIndexBackground.rawValue))
		encoder?.encodeAndDrawQuad()
		encoder?.endEncoding()
	}
}
