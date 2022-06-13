//
//  NebulaFragmentDataProvider.swift
//  Nebula
//
//  Created by Andrey Karpets on 28.05.2022.
//

import Foundation

final class NebulaFragmentDataProvider {

	private enum Constants {
		static let densityScale: Float = 0.015
		static let scale: Float = 0.001
		static let offsetLimit: Float = 20
		static let falloffStartValue: Float = 1
	}

	var animationEnabled = false

	private var parameters = NebulaParameters.random()

	private var values = [NebulaFragmentData]()

	func data(nebulaIndex: Int) -> NebulaFragmentData {
		if nebulaIndex >= values.count {
			self.values.append(generate())
			return data(nebulaIndex: nebulaIndex)
		}

		return values[nebulaIndex]
	}

	func update(time: Float) {
		guard animationEnabled else {
			return
		}
		for i in 0..<values.count {
			values[i].time += time
		}
	}

	func update(parameters: NebulaParameters) {
		self.parameters = parameters
		self.update()
	}

	func reset() {
		self.values.removeAll()
	}

	private func update() {
		for i in 0..<values.count {
			values[i].falloff = Float(parameters.falloff)
			values[i].density = Float(parameters.density) * Constants.densityScale
		}
	}

	private func generate() -> NebulaFragmentData {
		NebulaFragmentData(
			time: 0,
			color: Color3.random(),
			offset: Vector2.random(in: 0...Constants.offsetLimit),
			density: Float(parameters.density) * Constants.densityScale,
			falloff: Float(parameters.falloff) + Constants.falloffStartValue,
			scale: Constants.scale
		)
	}
}
