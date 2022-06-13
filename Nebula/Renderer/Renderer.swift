//
//  Renderer.swift
//  Nebula
//
//  Created by Andrey Karpets on 20.05.2022.
//

import Foundation
import MetalKit

final class Renderer: NSObject {

	private enum Constants {
		static let animationSpeed: Float = 0.5
	}

	var parameters = RendererParameters() {
		didSet {
			self.nebulaFragmentDataProvider.animationEnabled = self.parameters.animateNebula
			self.nebulaFragmentDataProvider.update(parameters: self.parameters.nebulasParameters)
			if oldValue.pointStarsEnabled != self.parameters.pointStarsEnabled {
				self.updatePointStars(size: self.view?.drawableSize ?? .zero)
				if let pointStarsTexture = self.pointStarsTexture {
					self.texturePool?.updateInitialTexture(pointStarsTexture)
				}
			}
		}
	}

	private var view: MTKView?

	private lazy var device = Device()

	private var pipelineState: MTLRenderPipelineState?
	private var nebulaEncoder: NebulaEncoder?
	private var starsEncoder: StarEncoder?

	private var pointStarsTexture: MTLTexture?
	private var texturePool: PingPongTexturePool?

	private var nebulaFragmentDataProvider = NebulaFragmentDataProvider()
	private var smallStarsFragmentDataProvider = StarFragmentDataProvider(size: .small)
	private var bigStarsFragmentDataProvider = StarFragmentDataProvider(size: .big)

	func setup(view: MTKView) {
		self.view = view
		view.device = self.device.metalDevice
		self.pipelineState = self.device.makeRenderPipelineState(
			vertexFunctionName: ShaderName.vertexShader.rawValue,
			fragmentFunctionName: ShaderName.fragmentShader.rawValue
		)

		let size = Int(RandomTextureSize)
		let randomNoiseTexture = self.device.makeTexture(
			with: RandomNoiseTextureData.generate(width: size, height: size),
			width: size,
			height: size,
			isRenderTarget: true
		)

		self.nebulaEncoder = NebulaEncoder(
			device: self.device,
			randomSourceTexture: randomNoiseTexture
		) { [unowned self] index in
			self.nebulaFragmentDataProvider.data(nebulaIndex: Int(index))
		}

		self.starsEncoder = StarEncoder(
			device: self.device,
			parametersProvider: { [unowned self] index in
			if index < self.parameters.smallStarsCount {
				return self.smallStarsFragmentDataProvider.data(index: index)
			} else {
				return self.bigStarsFragmentDataProvider.data(index: index - self.parameters.smallStarsCount)
			}
		})
	}

	func generate() {
		if let size = self.view?.drawableSize {
			self.updatePointStars(size: size)
		}
		self.nebulaFragmentDataProvider.reset()
		self.smallStarsFragmentDataProvider.reset()
		self.bigStarsFragmentDataProvider.reset()
	}

	private func reloadTexturePool(size: CGSize) {
		self.updatePointStars(size: size)

		if let pointStarsTexture = self.pointStarsTexture {
			self.texturePool = PingPongTexturePool(
				initial: pointStarsTexture,
				texture1: device.makeRenderTargetTexture(size: size),
				texture2: device.makeRenderTargetTexture(size: size)
			)
		}
	}

	private func updatePointStars(size: CGSize) {
		if !self.parameters.pointStarsEnabled {
			self.pointStarsTexture = self.device.makeEmptyTexture(
				width: Int(size.width),
				height: Int(size.height)
			)
		} else if !size.width.isZero && !size.height.isZero {
			self.pointStarsTexture = self.device.makeTexture(
				with: PointStarsTextureData.generate(width: Int(size.width), height: Int(size.height)),
				width: Int(size.width),
				height: Int(size.height),
				isRenderTarget: true
			)
		}
	}
}

extension Renderer: MTKViewDelegate {

	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		guard !size.width.isZero && !size.height.isZero else {
			return
		}
		self.smallStarsFragmentDataProvider.screenSize = size
		self.bigStarsFragmentDataProvider.screenSize = size
		self.reloadTexturePool(size: size)
	}

	func draw(in view: MTKView) {
		guard let commandBuffer = self.device.commandQueue.makeCommandBuffer(),
			  let currentDrawable = view.currentDrawable,
			  let rpd = view.currentRenderPassDescriptor else {
				  return
		}

		guard let pool = self.texturePool else {
			return
		}

		self.nebulaFragmentDataProvider.update(time: Constants.animationSpeed)

		self.texturePool?.reset()

		self.nebulaEncoder?.run(commandBuffer: commandBuffer, count: parameters.nebulasParameters.count, pool: pool)

		if self.parameters.starsEnabled {
			let count = parameters.smallStarsCount + parameters.bigStarsCount
			self.starsEncoder?.run(commandBuffer: commandBuffer, count: count, pool: pool)
		}

		guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd) else {
			return
		}

		guard let pipelineState = self.pipelineState else {
			return
		}

		encoder.setRenderPipelineState(pipelineState)
		encoder.setFragmentTexture(texturePool?.lastResult, index: 0)
		encoder.encodeAndDrawQuad()
		encoder.endEncoding()

		commandBuffer.present(currentDrawable)
		commandBuffer.commit()
		commandBuffer.waitUntilCompleted()
	}
}
