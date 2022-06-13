//
//  RendererParameters.swift
//  Nebula
//
//  Created by Andrey Karpets on 10.06.2022.
//

import Foundation

struct RendererParameters {
	var animateNebula = false
	var nebulasParameters = NebulaParameters.random()
	var pointStarsEnabled = false
	var starsEnabled = false

	var smallStarsCount = 10
	var bigStarsCount = 1
}

struct NebulaParameters: Equatable {

	enum RangeParameters {
		static let density = 1...10
		static let falloff = 1...8
		static let count = 0...5
	}

	let density: Int
	let falloff: Int
	let count: Int

	static func random() -> Self {
		NebulaParameters(
			density: Int.random(in: RangeParameters.density),
			falloff: Int.random(in: RangeParameters.falloff),
			count: Int.random(in: RangeParameters.count)
		)
	}
}
